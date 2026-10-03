const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const { GoogleGenerativeAI } = require('@google/generative-ai');

admin.initializeApp();

const app = express();
app.use(cors({ origin: true }));
app.use(express.json({ limit: '12mb' }));

function getGeminiKey() {
  const cfg = functions.config();
  const key = cfg && cfg.gemini && cfg.gemini.key;
  if (!key) {
    throw new Error('missing_gemini_key');
  }
  return key;
}

function buildChatHistory(history) {
  if (!Array.isArray(history)) return [];
  return history
    .map((h) => {
      const role = h && typeof h.role === 'string' ? h.role : null;
      const text = h && typeof h.text === 'string' ? h.text : null;
      if (!role || !text) return null;
      const geminiRole = role === 'model' ? 'model' : 'user';
      return { role: geminiRole, parts: [{ text }] };
    })
    .filter(Boolean);
}

app.post('/chat', async (req, res) => {
  try {
    const { message, history } = req.body || {};
    if (typeof message !== 'string' || !message.trim()) {
      return res.status(400).json({ error: 'invalid_message' });
    }

    const genAI = new GoogleGenerativeAI(getGeminiKey());
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

    const chat = model.startChat({
      history: buildChatHistory(history),
      generationConfig: {
        temperature: 0.6,
        maxOutputTokens: 800,
      },
    });

    const result = await chat.sendMessage(message);
    const reply = result && result.response ? result.response.text() : '';

    return res.json({ reply: (reply || '').trim() });
  } catch (e) {
    if (String(e && e.message) === 'missing_gemini_key') {
      return res.status(500).json({ error: 'missing_gemini_key' });
    }
    return res.status(500).json({ error: 'chat_failed' });
  }
});

app.post('/vision', async (req, res) => {
  try {
    const { prompt, imageBase64, mimeType } = req.body || {};

    if (typeof prompt !== 'string' || !prompt.trim()) {
      return res.status(400).json({ error: 'invalid_prompt' });
    }
    if (typeof imageBase64 !== 'string' || !imageBase64.trim()) {
      return res.status(400).json({ error: 'invalid_image' });
    }

    const genAI = new GoogleGenerativeAI(getGeminiKey());
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

    const result = await model.generateContent([
      {
        inlineData: {
          data: imageBase64,
          mimeType: typeof mimeType === 'string' && mimeType ? mimeType : 'image/jpeg',
        },
      },
      { text: prompt },
    ]);

    const reply = result && result.response ? result.response.text() : '';

    return res.json({ reply: (reply || '').trim() });
  } catch (e) {
    if (String(e && e.message) === 'missing_gemini_key') {
      return res.status(500).json({ error: 'missing_gemini_key' });
    }
    return res.status(500).json({ error: 'vision_failed' });
  }
});

exports.api = functions
  .region('us-central1')
  .runWith({ memory: '512MB', timeoutSeconds: 60 })
  .https.onRequest(app);
