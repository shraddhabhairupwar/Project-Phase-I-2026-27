# LingoSpark — updated learning platform

This is a separate copy of the uploaded project. The UI layout and database models are unchanged.

## Changes
- Branding shown in the website is LingoSpark.
- Adventure map stages are Level 1 through Level 7 in every chapter for Kids, Teens and Adults.
- Each stage loads its own 10 chapter-specific questions from the existing database bank, rather than sampling randomly from the entire bank. Each of the seven stages uses a distinct set; questions are stable on retries.
- Chapter lessons include additional age- and difficulty-specific study objectives, guided practice, and assessment focus.
- Stage submission sends question_ids, and handles NULL score/attempt counters in existing PostgreSQL records.

## New: Fast interactive question maker
- On the dashboard, click **AI Question Maker** (the Create Questions feature).
- Pick Beginner, Intermediate or Advanced, then select a chapter from your own age group's syllabus.
- The default **Fast mode** reads chapter-linked practice questions directly from PostgreSQL, without waiting for Ollama. No paid API key is needed.
- Answer multiple-choice questions by tapping an option. Some exercises accept typed answers or sentence word tiles.
- Use **Next question** / **Previous** and finish with **Submit quiz & see score**. You'll see your score, correct answers and explanations.
- Speaking, writing and pronunciation chapters now include curated, age-appropriate multiple-choice concept checks; written responses are flagged for self-review instead of getting a misleading automatic mark.
- Tick the optional Ollama box only if you want to try up to two new AI-written choice questions. The app limits that extra waiting time, and returns the chapter-bank quiz if Ollama does not respond.
- Quiz scores in **Question Maker** are for extra practice only. Your existing Adventure Map stage submissions, progress and level-unlocking rules are unchanged.
- The fast quiz does not write new questions to PostgreSQL; only the optional Ollama mode may add its new questions.

## New: Hindi and Marathi translation fix
- **Translator:** Choose source and target language (English, Hindi or Marathi are supported, along with the existing extra languages). Enter a sentence and click the translate button.
- **Chapter explanations:** Open a chapter and choose **Explain in Marathi** (or your chosen native language). The page now translates one short section at a time, so large chapters do not exhaust the backup provider's per-request limit. Click **Next section** to keep reading; use **Previous section** to revisit translations already completed during this visit.
- Hindi and Marathi are translated using a free online translation service instead of relying on the small local Ollama model. **No paid API key is required**, but your laptop must be connected to the internet.
- The free service is unofficial and may sometimes be blocked or rate-limited. A second, limited free provider is attempted for short messages; failures return clear errors rather than hanging indefinitely or displaying fake translations.
- **If you see HTTP 429:** The free provider is temporarily limiting your requests. Wait and try again later. The chapter page also offers **Try this section in Google Translate** to open the selected portion on the public translation website if both automatic services are unavailable. This manual fallback is not guaranteed either.
- The anonymous backup has a **5,000-character daily limit**; repeatedly translating many chapter sections may exhaust it. Already translated sections are reused until you navigate away or refresh the page.
- Hindi and Marathi results must contain Devanagari characters. A script check cannot guarantee perfect grammar, so review important learning material.
- **Privacy:** Text submitted for translation is sent to an external service. Do not enter names, passwords or personal information, especially about children.
- This change makes no edits to your database schema or stored progress.

## New: Dynamic word-pronunciation practice
- Open **Speech Practice** from the dashboard. Kids (6–12) get everyday/school words, Teens (13–17) get school and academic vocabulary, and Adults get daily-life/work vocabulary.
- Each round presents **10 words**. Click **Listen to the word**, then **Pronounce this word** and allow the microphone in Chrome or Edge.
- The browser displays what it heard and whether it recognized the target word. You can retry, move between words, finish the round, or generate **10 new words**. The next round avoids the last round's words per logged-in learner.
- Word recognition is **not a verified phoneme-level pronunciation score**. The check measures whether speech recognition understood the target word; the browser can misrecognize correct speech. Sound-level grading would require a separate validated audio model.
- The word bank and attempt feedback run in the browser. No new Python package or database table is required. Browser speech recognition may transmit microphone audio to the browser vendor's recognition service, depending on the browser. Avoid private or identifying speech.

### Reusing the working PostgreSQL configuration safely
Before starting this extracted ZIP, copy the contents of the working **old** `backend/.env` into the **new** `backend/.env`. Keep your existing `DATABASE_URL` and `SECRET_KEY` values. Do not create or reset a database. Copy any existing `frontend/.env` too. The extracted ZIP does not include or overwrite either secret file.

**Windows first-time install (in the new folder):** Run `FIRST_TIME_SETUP.bat` once, then run `START_BACKEND.bat` and `START_FRONTEND.bat` in separate windows. If you already copied `backend/.env`, setup leaves it intact. If you already installed dependencies, you may run the two START files directly.

## IMPORTANT: existing database and environment
1. Keep your current project folder and PostgreSQL database as a backup. Do not delete or recreate them.
2. Extract this ZIP to a NEW folder.
3. Copy your working backend/.env from your OLD project into the new backend folder. Never share this file publicly. Keep its DATABASE_URL pointing to your existing database.
4. If you have a custom frontend/.env, copy it as well.
5. Start the backend using START_BACKEND.bat; keep the terminal open.
6. Start the frontend using START_FRONTEND.bat; keep the terminal open.
7. Open the Vite Local URL shown in the frontend terminal (typically http://localhost:5173).
8. Visit http://127.0.0.1:8000/health to confirm database connectivity before testing.
9. **Important:** Stop the backend from every OLD LingoBloom/LingoSpark folder first. Only run the backend from THIS extracted project; an older backend on port 8000 may return incompatible quiz or translation responses.

## Notes
- This ZIP does NOT contain your local backend/.env, PostgreSQL data, Python virtual environment, or node_modules.
- Previously stored module progress and AI-generated questions are not intentionally deleted by this update. Built-in question banks may be populated on first backend startup if they are missing.
- The local Ollama model must be running for AI-powered tools. Static chapter questions do not require Ollama.
- Question content is chapter-specific but the existing static question banks still deserve teacher review before formal assessment.
- The package was checked for syntax and internal consistency, but a full Windows/PostgreSQL browser test must be done on your machine.
