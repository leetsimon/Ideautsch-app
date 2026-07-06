# Phoenix Content Pipeline — Part 02: Vocabulary Master Database

**Version:** 1.0.0  
**Status:** Production Reference  

---

## 1. Purpose

The Vocabulary Master Database is the single source of truth for every German chunk taught in Project Phoenix. It is NOT a dictionary. It is a **curated arsenal of professional German communication tools**, each carrying complete metadata for:

- Teaching (when and how to introduce it)
- Review (SRS scheduling across 500+ missions)
- Evaluation (how to assess learner production)
- Multilingual support (Darija, French, English bridges)
- Error prediction (what Moroccan learners will get wrong)

---

## 2. Master Entry Schema

```yaml
# ═══════════════════════════════════════════════════════════
# VOCABULARY MASTER ENTRY
# ═══════════════════════════════════════════════════════════

entry_id: "v_wie_kann_ich_ihnen_helfen"
version: 1
created_date: "2026-07-06"
last_reviewed: "2026-07-06"
production_status: "approved"             # draft | reviewed | approved

# ─── GERMAN CONTENT ───────────────────────────────────────
german:
  chunk_phrase: "Wie kann ich Ihnen helfen?"
  literal_translation: "How can I you(formal-dative) help?"
  normalized_form: "wie kann ich ihnen helfen"
  word_count: 5
  syllable_count: 7
  
# ─── CLASSIFICATION ───────────────────────────────────────
classification:
  cefr_level: "A1"
  cefr_source: "Goethe-Institut A1 Wortliste — 'helfen', 'können'"
  frequency_general: 847                   # DWDS frequency rank
  frequency_call_center: 2                 # Phoenix internal ranking (1=most used)
  frequency_spoken: 12                     # Spoken corpus rank
  career_relevance_score: 99               # 0–100
  career_domains:
    - "phone_communication"
    - "customer_greeting"
    - "service_opening"
  tactical_cluster: "openers"
  register: "formal"
  formality_level: 5                       # 1(very informal)–5(very formal)
  
# ─── GRAMMAR ──────────────────────────────────────────────
grammar:
  part_of_speech: "interrogative_phrase"
  grammatical_structures:
    - pattern_id: "modal_verb_koennen"
      role: "Primary example of können + Infinitiv"
    - pattern_id: "v2_word_order"
      role: "Question word (Wie) triggers inversion"
    - pattern_id: "dative_case"
      role: "'Ihnen' is dative of 'Sie'"
  verb_info:
    infinitive: "helfen"
    conjugation_present: "ich helfe, Sie helfen, er/sie hilft"
    auxiliary: "haben"
    partizip_ii: "geholfen"
    separable: false
    irregular: true
  case_required: "dative"
  gender: null                             # Not applicable (phrase)
  plural: null
  
# ─── PRONUNCIATION ────────────────────────────────────────
pronunciation:
  ipa: "/viː kan ɪç ˈiːnən ˈhɛlfn̩/"
  stress_pattern: "Wie KANN ich IH-nen HEL-fen?"
  syllable_breakdown: "Wie | kann | ich | Ih-nen | hel-fen"
  audio_reference:
    native: "audio/vocab/v_wie_kann_ich_ihnen_helfen_native.opus"
    slow: "audio/vocab/v_wie_kann_ich_ihnen_helfen_slow.opus"
    shadow: "audio/vocab/v_wie_kann_ich_ihnen_helfen_shadow.opus"
  key_sounds:
    - sound_id: "w_as_v"
      position: "word-initial in 'Wie'"
      note: "German w = /v/ (like French v, NOT English w)"
    - sound_id: "ch_ich_laut"
      position: "word-final in 'ich'"
      note: "Palatal fricative /ç/ — not /ʃ/ or /x/"
    - sound_id: "long_i"
      position: "in 'Ihnen'"
      note: "Long /iː/ — the 'h' is silent, just lengthens the vowel"
  intonation: "Rising on final word 'helfen?' — question contour"
  
# ─── MULTILINGUAL BRIDGES ─────────────────────────────────
bridges:
  english:
    translation: "How can I help you? (formal)"
    cognate_connection: "kann ≈ can, helfen ≈ help"
    phonetic_bridge: null
    grammar_parallel: "Same structure: How + can + I + you + help?"
    
  french:
    translation: "Comment puis-je vous aider ?"
    cognate_connection: null
    phonetic_bridge: "'w' in 'Wie' = French 'v' in 'vous'"
    grammar_parallel: "Inversion (puis-je) mirrors German question inversion"
    cultural_note: "Same formality level as French 'vous' register"
    
  darija:
    translation: "كيفاش نقدر نعاونك؟"
    transliteration: "kifach n9der n3awnek?"
    register_note: "Darija version is naturally less formal — German version uses Sie"
    phonetic_bridge: null
    cultural_parallel: "Like saying 'كيفاش نقدر نخدمك' in a service context"
    teaching_note: "Emphasize: in German, this question is MORE formal than the Darija equivalent"

# ─── CONTEXT & USAGE ──────────────────────────────────────
usage:
  functional_meaning: >
    The standard offer of assistance in German customer service. 
    Opens every interaction for the customer to state their need. 
    Used in every single call center greeting formula.
  when_to_use:
    - "Answering any customer service phone call"
    - "Greeting a customer at a service desk"
    - "Beginning any professional assistance interaction"
  when_not_to_use:
    - "With colleagues (too formal — use 'Kann ich dir helfen?')"
    - "In written communication (use 'Wie kann ich Ihnen behilflich sein?')"
  
  example_sentences:
    - de: "Guten Tag, wie kann ich Ihnen helfen?"
      en: "Good day, how can I help you?"
      context: "Standard phone greeting"
      audio: "audio/examples/wie_kann_ich_01.opus"
    - de: "Wie kann ich Ihnen heute helfen?"
      en: "How can I help you today?"
      context: "Variant with time marker"
      audio: "audio/examples/wie_kann_ich_02.opus"
    - de: "Wie kann ich Ihnen weiterhelfen?"
      en: "How can I help you further?"
      context: "After initial assistance, offering more"
      audio: "audio/examples/wie_kann_ich_03.opus"
      
  collocations:
    - "Guten Tag, ... wie kann ich Ihnen helfen?"
    - "... wie kann ich Ihnen behilflich sein?"
    - "Wie kann ich Ihnen heute weiterhelfen?"
    
  synonyms:
    - id: "v_was_kann_ich_fuer_sie_tun"
      note: "Slightly more formal alternative"
    - id: "v_wie_kann_ich_behilflich_sein"
      note: "Very formal, often written"
      
  antonyms: []
  
  related_chunks:
    - id: "v_guten_tag"
      relationship: "precedes"
    - id: "v_mein_name_ist"
      relationship: "co-occurs_in_greeting"
    - id: "v_selbstverstaendlich"
      relationship: "typical_response_to_customer_request"

# ─── MOROCCAN LEARNER ERRORS ──────────────────────────────
errors:
  predicted_errors:
    - error_type: "register"
      error_text: "Wie kann ich dir helfen?"
      correct_text: "Wie kann ich Ihnen helfen?"
      explanation_en: "'dir' = informal. 'Ihnen' = formal. Always formal with customers."
      explanation_darija: "'dir' = informal. 'Ihnen' = formal. ديما formal مع الزبائن."
      probability: 0.7
      severity: "critical"
      source: "Darija does not stratify formality as strictly"
      
    - error_type: "pronunciation"
      error_text: "Wie kann isch Ihnen helfen?"
      correct_text: "Wie kann ich Ihnen helfen?"
      explanation_en: "'ich' uses /ç/ (palatal), not /ʃ/ (post-alveolar)"
      probability: 0.5
      severity: "medium"
      source: "No /ç/ in Arabic; nearest approximation is /ʃ/"
      
    - error_type: "word_order"
      error_text: "Wie ich kann Ihnen helfen?"
      correct_text: "Wie kann ich Ihnen helfen?"
      explanation_en: "After question word, VERB comes before SUBJECT (inversion)"
      probability: 0.3
      severity: "medium"
      source: "English/Arabic word order transfer"

# ─── SRS METADATA ─────────────────────────────────────────
srs:
  initial_interval_hours: 12
  initial_ease_factor: 2.5
  review_exercise_types:
    - "repeat"
    - "conversation"
    - "time_pressure"
  context_variations:
    - "Wie kann ich Ihnen behilflich sein?"
    - "Was kann ich für Sie tun?"
    - "Wie kann ich Ihnen weiterhelfen?"
    - "Womit kann ich Ihnen heute dienen?"
  review_contexts:
    - context: "Customer calls, you answer"
      prompt_en: "A customer is on the line. Offer to help."
    - context: "Walk-in customer at service desk"
      prompt_en: "Someone approaches your desk. Offer assistance."
    - context: "Follow-up call to customer"
      prompt_en: "You're calling back. Open by offering help."

# ─── TEACHING METADATA ────────────────────────────────────
teaching:
  first_introduced_in: "m01_001_d"
  teaching_method: "chunk_whole"           # Taught as complete unit
  prerequisite_vocabulary: []              # No prerequisites (first module)
  builds_toward:
    - "v_was_kann_ich_fuer_sie_tun"
    - "v_wie_kann_ich_weiterhelfen"
  difficulty_for_moroccan_learner: 3       # 1(easy)–5(very hard)
  difficulty_factors:
    - "'ch' sound (ich-Laut) is new for Arabic speakers"
    - "Dative 'Ihnen' is an unfamiliar concept"
    - "Word order inversion may feel unnatural"
  teaching_tip: >
    Teach as a complete chunk FIRST. Don't explain dative or inversion. 
    Let the mouth learn the shape. Grammar explanation comes in Module 3.

# ─── MEDIA REFERENCES ─────────────────────────────────────
media:
  audio:
    native_speaker: "audio/vocab/v_wie_kann_ich_ihnen_helfen_native.opus"
    slow_version: "audio/vocab/v_wie_kann_ich_ihnen_helfen_slow.opus"
    shadow_version: "audio/vocab/v_wie_kann_ich_ihnen_helfen_shadow.opus"
    pronunciation_drill: "audio/pronunciation/wie_kann_ich_drill.opus"
  image:
    scenario_illustration: "images/scenarios/phone_greeting.webp"
    generation_prompt: >
      Professional call center agent answering phone with confident 
      smile, headset on, CRM screen visible. Semi-realistic style.
  video: null                              # No video for vocabulary items
```

---

## 3. Database Statistics Targets

| Metric | Target | Coverage |
|--------|--------|----------|
| Total entries | 2,500+ | Full A1–B2 professional vocabulary |
| A1 entries | 400 | Basic survival + first professional chunks |
| A2 entries | 600 | Routine professional communication |
| B1 entries | 800 | Independent professional operation |
| B2 entries | 700 | Advanced professional communication |
| Call center specific | 800 | Core workplace vocabulary |
| Interview specific | 200 | Job application language |
| Daily life | 500 | Non-work essential German |
| Technical/IT support | 300 | Technical helpdesk scenarios |

---

## 4. Tactical Cluster Distribution

| Cluster | Target Count | Priority Modules |
|---------|-------------|-----------------|
| openers | 40 | 1–4 |
| bridges | 35 | 1–6 |
| shields | 30 | 1–4 |
| empathy | 50 | 5–9 |
| actions | 80 | 4–10 |
| confirmers | 40 | 4–8 |
| closers | 35 | 4–8 |
| rescue | 25 | 1–5 |
| affirmers | 45 | 3–8 |
| deniers | 40 | 6–10 |
| quantifiers | 60 | 4–9 |
| transitions | 50 | 7–12 |
| fillers | 20 | 5–8 |
| technical | 150 | 7–10 |
| interview | 100 | 9–11 |
| email | 80 | 6–10 |
| meeting | 70 | 9–12 |
| small_talk | 60 | 2–5, 10 |

---

## 5. Frequency Sources

| Source | Type | Use |
|--------|------|-----|
| DWDS Kernkorpus (21. Jh.) | Written + spoken | General frequency ranking |
| DWDS Gesprochenes Deutsch | Spoken only | Spoken frequency ranking |
| Goethe A1/A2/B1/B2 Wortlisten | Pedagogical | CEFR level assignment |
| Phoenix Call Center Corpus (internal) | Domain-specific | Call center frequency |
| telc Prüfungsmaterial | Exam-focused | Priority vocabulary for certification |
| PONS Großwörterbuch | Reference | Definitions, collocations |
| Duden Online | Authority | Grammar verification, spelling |
| Reverso Context | Usage | Natural context sentences |

---

## 6. Quality Criteria for Vocabulary Entries

Every entry must pass:

| Criterion | Requirement | Verified By |
|-----------|-------------|-------------|
| German spelling | Matches Duden | Automated spell-check |
| IPA accuracy | Matches standard pronunciation | Phonetics expert |
| CEFR level | Confirmed against Goethe Wortliste | Automated cross-reference |
| Darija naturalness | Confirmed by Moroccan native | Human reviewer |
| English accuracy | Natural equivalent (not literal) | Bilingual reviewer |
| French accuracy | Natural equivalent where provided | Bilingual reviewer |
| Example sentences | Grammatically perfect, context-appropriate | Native German reviewer |
| Error predictions | Based on contrastive analysis data | Linguistics expert |
| SRS variations | All grammatically correct, contextually diverse | Native reviewer |
| Career relevance | Confirmed frequency in German workplace data | Domain expert |
| Audio recorded | Professional studio quality | Audio engineer |

---

*End of Part 02. Continue to `03_mission_roadmap.md`.*
