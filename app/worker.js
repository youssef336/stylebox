// Cloudflare Worker: AI Proxy for MysteryBag
// Free tier: 100,000 requests/day
// Store GEMINI_API_KEY as a Worker Secret (via Cloudflare Dashboard)

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    // CORS headers
    const corsHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
      "Content-Type": "application/json"
    };

    if (request.method === "OPTIONS") {
      return new Response(null, { headers: corsHeaders, status: 204 });
    }

    // ========== CHAT ENDPOINT ==========
    if (path === "/chat" && request.method === "POST") {
      try {
        const body = await request.json();
        const { message, history, role } = body;
        
        console.log("[CHAT] Received request:", { message: message?.substring(0, 50), historyLength: history?.length, role });
        
        if (!message || typeof message !== "string") {
          console.log("[CHAT] Error: invalid message");
          return jsonResponse({ error: "invalid_message", details: "Message must be a non-empty string" }, 400, corsHeaders);
        }

        const geminiKey = env.GEMINI_API_KEY;
        if (!geminiKey) {
          console.log("[CHAT] Error: missing GEMINI_API_KEY");
          return jsonResponse({ error: "missing_gemini_key", details: "GEMINI_API_KEY not configured in worker secrets" }, 500, corsHeaders);
        }

        // Build Gemini request
        const contents = buildGeminiHistory(history);
        contents.push({
          role: "user",
          parts: [{ text: message }]
        });

        console.log("[CHAT] Calling Gemini API...");
        
        const geminiRes = await fetch(
          `https://generativelanguage.googleapis.com/v1/models/gemini-1.0-pro:generateContent?key=${geminiKey}`,
          {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              contents,
              generationConfig: {
                temperature: 0.6,
                maxOutputTokens: 800
              }
            })
          }
        );

        if (!geminiRes.ok) {
          const errText = await geminiRes.text();
          console.log("[CHAT] Gemini API error:", geminiRes.status, errText);
          return jsonResponse({ error: "gemini_failed", status: geminiRes.status, details: errText }, 502, corsHeaders);
        }

        const geminiData = await geminiRes.json();
        const reply = geminiData?.candidates?.[0]?.content?.parts?.[0]?.text || "";
        
        console.log("[CHAT] Success, reply length:", reply.length);

        return jsonResponse({ reply: reply.trim() }, 200, corsHeaders);

      } catch (e) {
        console.log("[CHAT] Exception:", e.message, e.stack);
        return jsonResponse({ error: "chat_error", message: e.message, stack: e.stack }, 500, corsHeaders);
      }
    }

    // ========== VISION ENDPOINT ==========
    if (path === "/vision" && request.method === "POST") {
      try {
        const body = await request.json();
        const { prompt, imageBase64, mimeType } = body;
        
        console.log("[VISION] Received request:", { prompt: prompt?.substring(0, 50), hasImage: !!imageBase64, imageLength: imageBase64?.length, mimeType });
        
        if (!prompt || !imageBase64) {
          console.log("[VISION] Error: missing prompt or image");
          return jsonResponse({ 
            error: "invalid_request", 
            details: "Both 'prompt' and 'imageBase64' are required",
            received: { hasPrompt: !!prompt, hasImage: !!imageBase64 }
          }, 400, corsHeaders);
        }

        const geminiKey = env.GEMINI_API_KEY;
        if (!geminiKey) {
          console.log("[VISION] Error: missing GEMINI_API_KEY");
          return jsonResponse({ error: "missing_gemini_key", details: "GEMINI_API_KEY not configured in worker secrets" }, 500, corsHeaders);
        }

        // Validate base64
        if (!isValidBase64(imageBase64)) {
          console.log("[VISION] Error: invalid base64 image data");
          return jsonResponse({ error: "invalid_base64", details: "Image data is not valid base64" }, 400, corsHeaders);
        }

        const requestBody = {
          contents: [{
            role: "user",
            parts: [
              { inlineData: { data: imageBase64, mimeType: mimeType || "image/jpeg" } },
              { text: prompt }
            ]
          }],
          generationConfig: {
            temperature: 0.4,
            maxOutputTokens: 600
          }
        };

        console.log("[VISION] Calling Gemini API...");
        
        const geminiRes = await fetch(
          `https://generativelanguage.googleapis.com/v1/models/gemini-1.0-pro:generateContent?key=${geminiKey}`,
          {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(requestBody)
          }
        );

        if (!geminiRes.ok) {
          const errText = await geminiRes.text();
          console.log("[VISION] Gemini API error:", geminiRes.status, errText);
          return jsonResponse({ error: "gemini_failed", status: geminiRes.status, details: errText }, 502, corsHeaders);
        }

        const geminiData = await geminiRes.json();
        const reply = geminiData?.candidates?.[0]?.content?.parts?.[0]?.text || "";
        
        console.log("[VISION] Success, reply length:", reply.length);

        return jsonResponse({ reply: reply.trim() }, 200, corsHeaders);

      } catch (e) {
        console.log("[VISION] Exception:", e.message, e.stack);
        return jsonResponse({ error: "vision_error", message: e.message, stack: e.stack }, 500, corsHeaders);
      }
    }

    // Health check
    if (path === "/" && request.method === "GET") {
      const hasKey = !!env.GEMINI_API_KEY;
      console.log("[HEALTH] Status check, key configured:", hasKey);
      return jsonResponse({ 
        status: "ok", 
        service: "stylebox-ai-proxy",
        geminiKeyConfigured: hasKey,
        endpoints: ["/chat", "/vision"]
      }, 200, corsHeaders);
    }

    console.log("[404] Not found:", path);
    return jsonResponse({ error: "not_found", path }, 404, corsHeaders);
  }
};

function buildGeminiHistory(history) {
  if (!Array.isArray(history)) return [];
  return history.map(h => ({
    role: h.role === "model" ? "model" : "user",
    parts: [{ text: h.text || "" }]
  }));
}

function isValidBase64(str) {
  if (typeof str !== 'string') return false;
  if (str.length === 0) return false;
  // Basic base64 validation
  const base64Regex = /^[A-Za-z0-9+/]*={0,2}$/;
  return base64Regex.test(str);
}

function jsonResponse(data, status, corsHeaders) {
  return new Response(JSON.stringify(data), {
    status,
    headers: corsHeaders
  });
}
