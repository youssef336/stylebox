// StyleBox AI Proxy - Simplified Version
// Deploy this to Cloudflare Workers

addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  const url = new URL(request.url)
  const path = url.pathname

  // CORS headers
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Content-Type': 'application/json'
  }

  if (request.method === 'OPTIONS') {
    return new Response(null, { headers, status: 204 })
  }

  // Health check
  if (path === '/' && request.method === 'GET') {
    return jsonResponse({ status: 'ok', service: 'stylebox-ai' }, headers)
  }

  // CHAT endpoint
  if (path === '/chat' && request.method === 'POST') {
    try {
      const { message, history } = await request.json()
      
      if (!message) {
        return jsonResponse({ error: 'missing_message' }, headers, 400)
      }

      // Get Gemini key from environment
      const GEMINI_API_KEY = GEMINI_API_KEY || null
      
      if (!GEMINI_API_KEY) {
        return jsonResponse({ error: 'missing_gemini_key', hint: 'Add GEMINI_API_KEY as encrypted variable' }, headers, 500)
      }

      const contents = []
      
      // Add history
      if (Array.isArray(history)) {
        for (const h of history) {
          contents.push({
            role: h.role === 'model' ? 'model' : 'user',
            parts: [{ text: h.text || '' }]
          })
        }
      }
      
      // Add current message
      contents.push({
        role: 'user',
        parts: [{ text: message }]
      })

      const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`
      
      const geminiRes = await fetch(geminiUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents,
          generationConfig: {
            temperature: 0.6,
            maxOutputTokens: 800
          }
        })
      })

      if (!geminiRes.ok) {
        const errorText = await geminiRes.text()
        return jsonResponse({ error: 'gemini_failed', details: errorText }, headers, 502)
      }

      const data = await geminiRes.json()
      const reply = data?.candidates?.[0]?.content?.parts?.[0]?.text || 'No response from AI'

      return jsonResponse({ reply: reply.trim() }, headers)

    } catch (err) {
      return jsonResponse({ error: 'chat_error', message: err.message }, headers, 500)
    }
  }

  // VISION endpoint
  if (path === '/vision' && request.method === 'POST') {
    try {
      const { prompt, imageBase64, mimeType } = await request.json()
      
      if (!prompt || !imageBase64) {
        return jsonResponse({ error: 'missing_prompt_or_image' }, headers, 400)
      }

      const GEMINI_API_KEY = GEMINI_API_KEY || null
      
      if (!GEMINI_API_KEY) {
        return jsonResponse({ error: 'missing_gemini_key' }, headers, 500)
      }

      const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`
      
      const geminiRes = await fetch(geminiUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{
            role: 'user',
            parts: [
              { inlineData: { data: imageBase64, mimeType: mimeType || 'image/jpeg' } },
              { text: prompt }
            ]
          }],
          generationConfig: {
            temperature: 0.4,
            maxOutputTokens: 600
          }
        })
      })

      if (!geminiRes.ok) {
        const errorText = await geminiRes.text()
        return jsonResponse({ error: 'gemini_failed', details: errorText }, headers, 502)
      }

      const data = await geminiRes.json()
      const reply = data?.candidates?.[0]?.content?.parts?.[0]?.text || 'No response from AI'

      return jsonResponse({ reply: reply.trim() }, headers)

    } catch (err) {
      return jsonResponse({ error: 'vision_error', message: err.message }, headers, 500)
    }
  }

  return jsonResponse({ error: 'not_found', path }, headers, 404)
}

function jsonResponse(data, headers, status = 200) {
  return new Response(JSON.stringify(data), { status, headers })
}
