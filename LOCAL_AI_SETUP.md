# LingoSpark local AI setup (free)

This project uses Ollama on your own Windows laptop. No paid LLM API key is required.

## 1. Install and download the model once

Install Ollama from https://ollama.com/download/windows, then open Command Prompt and run:

```cmd
ollama pull llama3.2:1b
```

You have already completed this step on your current laptop.

## 2. Keep Ollama available

Ollama normally runs as a background Windows application. If the backend cannot connect to it, open Command Prompt and run `ollama serve` (only if the Ollama service is not already running). Check installed models with `ollama list`.

## 3. Start LingoSpark

Start PostgreSQL, then run `START_BACKEND.bat` and `START_FRONTEND.bat` in separate windows. The backend connects to `http://127.0.0.1:11434` and uses `llama3.2:1b` by default.

Optional settings in `backend/.env`:

```env
OLLAMA_BASE_URL=http://127.0.0.1:11434
OLLAMA_MODEL=llama3.2:1b
```

No `LLM_API_KEY` is needed. If Ollama is unavailable, Talk with Lingo falls back to guided practice, and the fast Question Maker uses the built-in question bank. Grammar and chat retain their local Ollama behaviour.

**Translation is different in this update.** The Hindi and Marathi translator now tries a free online translation endpoint first, with a limited free backup service. It does not wait for the small Ollama model, which previously produced unreliable Marathi text. Translation requires an internet connection but no paid API key. The free endpoints are third-party services and may have outages or rate limits. Do not send passwords, names, or other private information to the translator.

## Performance note

The configured model is deliberately small for an 8 GB RAM laptop with an older dual-core CPU. Responses can take time. Avoid running several AI requests simultaneously. The model is a small general-purpose LLM, so review generated teaching content before using it in formal lessons.
