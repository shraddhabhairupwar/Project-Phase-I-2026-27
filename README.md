# LingoSpark – Adventure Path Edition

A React + FastAPI + PostgreSQL language-learning application. It runs without Docker.

## What's new in this edition

- A Duolingo-inspired learning path with bright, soft colours, rounded lesson nodes, star rewards, locked stages and animated stage tiles.
- Each module has **7 stages**, each with **10 different questions** (70 unique starter questions per module).
- 10 modules × 3 levels × 3 age groups = 90 modules and 6,300 starter questions.
- The 7 stage names are Warm-up, Picture Quest, Word Builder, Sentence Safari, Listening Lab, Speak & Create and Boss Challenge.
- A stage needs at least 7/10 to unlock the next stage. A module is marked complete only after all 7 stages are passed.
- Different activity formats include multiple choice, picture choice, odd-one-out, matching, categorising, word ordering, listening, speaking, describing a picture and open-ended writing.
- Grammar learning content includes Nouns, Pronouns, Verbs, Adjectives, Articles, Tenses, Subject–verb agreement, Prepositions, Conjunctions and Punctuation, with explanations and examples.
- Topic illustrations are local SVG files in `frontend/public/images/` (no image API needed to display them).
- Translation, grammar feedback, AI question generation and Talk with Lingo use the local Ollama model by default. No paid LLM API key is required.
- Stage scores, points, streaks and module completion are stored in PostgreSQL.

## Quick setup on Windows

1. Extract the ZIP to a normal folder (not inside a protected Windows folder).
2. Double-click `FIRST_TIME_SETUP.bat` once.
3. Open `backend/.env` and enter your PostgreSQL password. Keep `DATABASE_URL` pointed at `language_learning` for the unified Kids + Teen + Adult app.
4. Double-click `START_BACKEND.bat` and keep that window open.
5. Double-click `START_FRONTEND.bat` in a second window and open the Vite address shown (normally `http://localhost:5173`).

If setup scripts are blocked, follow the manual commands below.

## 1. Requirements

- Python 3.10+
- Node.js 18+
- PostgreSQL installed locally (pgAdmin is fine)
- No Docker required

## 2. Create the PostgreSQL database

In pgAdmin, create a database named `language_learning`. Keep your existing database if you already use that name. The application creates its tables and seeds its learning content when FastAPI starts.

## 3. Start the backend (Terminal 1)

```bat
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
copy .env.example .env
```

Edit `backend/.env` and enter your actual PostgreSQL password:

```env
DATABASE_URL=postgresql+psycopg://postgres:YOUR_POSTGRES_PASSWORD@localhost:5432/language_learning
SECRET_KEY=replace-this-with-a-long-random-secret
FRONTEND_ORIGIN=http://localhost:5173
LLM_API_KEY=
LLM_BASE_URL=https://api.openai.com/v1
LLM_MODEL=gpt-4o-mini
```

Start FastAPI:

```bat
uvicorn app.main:app --reload
```

Check `http://127.0.0.1:8000/health`. It should return a connected database status. On first start, 90 modules and 6,300 starter questions are seeded. On an existing database from the earlier LingoSpark edition, the seed routine refreshes the built-in `seed_v2` questions to 70 per module and preserves AI-created questions and learner records. The new `module_stage_progress` table is created automatically.

## 4. Start the frontend (Terminal 2)

```bat
cd frontend
npm install
npm run dev
```

Open `http://localhost:5173`.

## 5. AI / NLP API setup

The backend reads the key from `backend/.env`; never put the key in React or commit `.env` to GitHub.

Ollama is the default provider. Keep these settings in `backend/.env`:

```env
OLLAMA_BASE_URL=http://127.0.0.1:11434
OLLAMA_MODEL=llama3.2:1b
LLM_API_KEY=
```

A paid compatible provider is optional; leave `LLM_API_KEY` blank to use Ollama only. Restart FastAPI after changing `.env`.

API routes:

- `POST /ai/translate` – translate lesson material to the learner's native language.
- `POST /ai/grammar` – give grammar feedback on learner text.
- `POST /ai/chat` – age-aware AI conversation (local guided fallback if no key is set).
- `POST /ai/generate-questions` – generate and save additional questions to PostgreSQL (requires a key; review AI content before classroom use).

AI provider API usage may cost money separately from a ChatGPT subscription.

## 6. How the game progression works

1. Register and select the target language.
2. Choose the Beginner path and open a module such as Basic Grammar.
3. Read the Learning Book. It includes topic explanations, definitions, types and examples.
4. Select Adventure Stages. Seven nodes are shown on the map.
5. Complete all 10 activities in Stage 1. A score of 70% or higher unlocks Stage 2.
6. Repeat until all 7 stages are cleared. The module then counts as completed.
7. Complete all 10 modules in the level and pass the final level assessment to unlock the next level.

## 7. Activity formats

- Multiple choice and picture choice
- Odd one out
- Match the pair
- Categorise the word
- Tap words to build a sentence
- Listening with slow / normal / fast playback
- Speaking using browser speech recognition
- Picture description and short writing answers
- Hints for each activity

Browser speech recognition depends on browser support and microphone permission; Chrome is recommended. The current speech feedback is transcript-based, not phoneme-level pronunciation scoring.

## 8. Useful API routes

- `POST /auth/register`, `POST /auth/login`, `GET /users/me`
- `GET /modules`, `GET /modules/{id}`
- `GET /modules/{id}/stages`
- `GET /modules/{id}/stage/{stage_no}/questions`
- `POST /modules/{id}/stage/{stage_no}/submit`
- `GET /progress`, `GET /gamification`, `GET /levels/status`
- `GET /assessment/level/{level}/questions`, `POST /assessment/level?level=beginner`
- `POST /ai/grammar`, `POST /ai/chat`, `POST /ai/translate`, `POST /ai/generate-questions`

## 9. Troubleshooting

- If the frontend shows Failed to fetch, keep the backend terminal running and open `http://127.0.0.1:8000/health`.
- If PostgreSQL connection fails, check that the PostgreSQL service is running and the database name, password and port are correct in `.env`.
- If Vite uses another port, update `FRONTEND_ORIGIN` and restart FastAPI.
- Check local AI status at `http://127.0.0.1:8000/ai/status` while the backend is running. It reports whether Ollama is reachable and whether the configured model is installed.\n- If an AI feature cannot connect, open Command Prompt and run `ollama list`. Confirm `llama3.2:1b` is listed, then run `ollama serve` only if Ollama is not already running. Open `http://127.0.0.1:11434/api/tags` to check that Ollama responds. Restart `START_BACKEND.bat`.
- If microphone access fails, use Chrome and allow microphone permission.

## Child-safety note

Before real deployment for children under 13, add parent/guardian consent, data minimisation, child-safe AI moderation, retention/deletion controls and a review of applicable child privacy requirements. The starter project is for development and classroom demonstration, not a production child service.


## Quiz navigation and adult professional English update

- Stage quizzes now display one question per screen with Previous / Next controls and a final Finish stage action.
- Each new stage attempt selects a random set of 10 questions from that module's 70-question bank. The submission includes the selected question IDs so grading uses the exact displayed questions.
- Picture-choice and picture-description activities display a related local topic illustration; no external image API is required.
- Accounts aged 18+ receive a professional English curriculum with these 10 modules: AI HR Interview Practice, Professional Email Writing, Workplace Communication, Business Vocabulary, AI Mock Interviews, Group Discussion Practice, Presentation & Public Speaking, Real-life Conversation Simulations, Fluency Improvement and Professional Writing Correction.
- The adult curriculum is seeded for Beginner, Intermediate and Advanced levels. Restart FastAPI once after updating so the seed routine refreshes module titles and learning content.
- Random selection makes question sets vary between attempts; the same question can still appear again in a later random attempt because the starter bank is finite.


## Teen Explorer upgrade (ages 13–17)

This unified build keeps the Kids (6–12), Teen (13–17) and Adult (18+) paths in one application and one PostgreSQL database. Only the Teen experience receives the new mature dashboard refinements and teen-focused lesson names/content.

- Teen curriculum: Grammar for Clear Communication; Vocabulary for School & Beyond; Sentence & Paragraph Skills; Listening for Meaning; Confident Speaking; Pronunciation & Fluency; Reading for Insight; Writing for Real Audiences; Social & Everyday Conversations; Digital Communication & Media Literacy.
- Teen lessons include explicit syllabus progression, including parts of speech and grammar development across Beginner, Intermediate and Advanced.
- Teen stage challenges and the final level assessment require at least 75%; Kids and Adult keep the existing 70% threshold.
- Teen Sentence Builder serves a shuffled set of eight prompts from a 30-sentence bank.
- Teen Speech Practice uses browser speech-to-text. Use the latest Chrome or Edge and allow microphone access. This is transcription, not phoneme-level pronunciation scoring.
- Teen AI chat uses Ollama when it is available and switches to guided practice if the local model is unavailable. No paid API key is required.

## Important database setup for the unified platform

Use the existing shared `language_learning` database for this complete Kids + Teen + Adult application. In `backend/.env`, make sure `DATABASE_URL` points to `language_learning`, not the separate `lingospark_teen` database used by the earlier standalone Teen build. The separate database is not deleted or modified by this ZIP. Back up your databases before making configuration changes. On first startup, the app seeds/updates the Teen curriculum alongside the existing Kids and Adult content. Existing learner progress is kept in the database it was originally saved to; this ZIP does not automatically merge progress from a separate database.
