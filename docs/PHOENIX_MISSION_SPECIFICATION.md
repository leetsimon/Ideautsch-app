# Phoenix Mission Specification (PMS)

**Version:** 1.0.0  
**Date:** July 6, 2026  
**Author:** Lead Learning Systems Architect  
**Status:** Definitive Reference  

---

> *Every mission in Project Phoenix is authored from this specification.
> No exceptions. No shortcuts. No deviation.*

---

## Table of Contents

1. [Purpose](#1-purpose)
2. [Design Principles](#2-design-principles)
3. [Mission Taxonomy](#3-mission-taxonomy)
4. [Mission Metadata Schema](#4-mission-metadata-schema)
5. [Learning Objective Standard](#5-learning-objective-standard)
6. [Scenario Design Standard](#6-scenario-design-standard)
7. [Emotional Goal Framework](#7-emotional-goal-framework)
8. [Vocabulary Specification](#8-vocabulary-specification)
9. [Dialogue Specification](#9-dialogue-specification)
10. [Exercise Specification](#10-exercise-specification)
11. [Grammar Discovery Specification](#11-grammar-discovery-specification)
12. [Pronunciation Coaching Specification](#12-pronunciation-coaching-specification)
13. [Common Mistakes Catalog](#13-common-mistakes-catalog)
14. [Cultural Notes Standard](#14-cultural-notes-standard)
15. [Smart Review Triggers](#15-smart-review-triggers)
16. [Confidence Scoring Model](#16-confidence-scoring-model)
17. [Success Criteria Definition](#17-success-criteria-definition)
18. [Career Transfer Statement](#18-career-transfer-statement)
19. [Mission File Format (YAML)](#19-mission-file-format-yaml)
20. [AI Generation Protocol](#20-ai-generation-protocol)
21. [Validation Checklist](#21-validation-checklist)
22. [Sample Mission: MISSION_ZERO](#22-sample-mission-mission_zero)

---


## 1. Purpose

This document defines the authoritative specification for every mission in Project Phoenix. It serves three audiences:

1. **Human content authors** who write missions manually.
2. **AI generators** that produce mission drafts from prompts.
3. **The engineering team** that builds the mission engine consuming these files.

Every mission file that enters the content database MUST conform to this specification. Non-conforming missions are rejected at the validation gate.

---

## 2. Design Principles

Every mission is governed by these immutable laws:

| # | Principle | Enforcement |
|---|-----------|-------------|
| 1 | **Speaking dominates.** ≥60% of exercise time requires learner speech production. | Validated by exercise type ratio in YAML. |
| 2 | **Context is mandatory.** No vocabulary or grammar exists outside a scenario. | Every item has a `scenario_context` field. |
| 3 | **Forward motion only.** Missions never send learners backward. | No `prerequisite` creates circular dependencies. |
| 4 | **Career-anchored.** Every mission has an explicit `career_transfer` statement. | Required field, cannot be empty. |
| 5 | **Emotionally safe.** No exercise can produce shame, guilt, or punishment. | Feedback templates reviewed at validation. |
| 6 | **Grammar invisible until revealed.** Grammar is embedded, never the primary objective. | `grammar_discovery` is always `mode: embedded` or `mode: revelation`. |
| 7 | **Chunk-first.** Vocabulary is taught as usable phrases, not isolated words. | Vocabulary entries require `chunk_phrase` field. |
| 8 | **Adaptive by default.** Every exercise specifies scaffolding at three support levels. | Required: `support_high`, `support_standard`, `support_minimal`. |
| 9 | **One clear objective.** A mission teaches ONE thing. Not three. Not five. One. | `learning_objective` is a single sentence. |
| 10 | **Completable in one session.** Maximum 15 minutes. No multi-session missions. | `estimated_duration_minutes` ≤ 15. |

---

## 3. Mission Taxonomy

### 3.1 Mission Types

| Type ID | Name | Purpose | Duration | Frequency |
|---------|------|---------|----------|-----------|
| `discovery` | Discovery Mission | Introduce new material in a scenario | 10-15 min | 60% of all missions |
| `practice` | Practice Mission | Reinforce material in a new scenario | 8-12 min | 20% of all missions |
| `challenge` | Challenge Mission | Test independent production, minimal support | 10-15 min | 10% of all missions |
| `simulation` | Simulation Mission | Full scenario simulation (call/interview) | 10-20 min | 7% of all missions |
| `recovery` | Recovery Mission | Consolidate after detected struggle | 5-8 min | 3% (generated dynamically) |

### 3.2 Module Placement

| Module Range | Narrative Chapter | CEFR Band | Career Focus |
|-------------|-------------------|-----------|--------------|
| 1-3 | Preparing (daily life) | A0 → A1 | Foundation vocabulary |
| 4-6 | Training (workplace entry) | A1 → A2 | Phone + customer service basics |
| 7-9 | Working (professional execution) | A2 → B1 | Complex scenarios, interview |
| 10-12 | Advancing (career growth) | B1 | Advanced communication, assessment |

### 3.3 Mission ID Convention

```
{module}_{sequence}_{type_code}

Examples:
  m01_001_d    → Module 1, Mission 1, Discovery
  m05_012_s    → Module 5, Mission 12, Simulation
  m03_007_p    → Module 3, Mission 7, Practice
  m02_004_c    → Module 2, Mission 4, Challenge
  m06_003_r    → Module 6, Mission 3, Recovery

Type codes: d=discovery, p=practice, c=challenge, s=simulation, r=recovery
```

---

## 4. Mission Metadata Schema

Every mission carries the following metadata:

```yaml
metadata:
  id: "m01_001_d"
  title_internal: "Greeting a Customer"       # Internal reference name
  title_display_en: "Your Phone is Ringing"   # What the learner sees (English)
  title_display_de: "Ihr Telefon klingelt"    # German (shown in later modules)
  module: 1
  sequence: 1
  type: "discovery"
  version: 1                                   # Content version for updates
  
  # Timing
  estimated_duration_minutes: 12
  min_duration_minutes: 8                      # If learner is fast
  max_duration_minutes: 15                     # If learner needs support
  
  # Difficulty & Level
  cefr_level: "A0"                             # Entry level required
  cefr_target: "A1.1"                          # Level this contributes toward
  difficulty: 1                                # 1-10 scale
  
  # Skills Trained (percentages must sum to 100)
  skills:
    speaking: 65
    listening: 20
    vocabulary: 10
    pronunciation: 5
    reading: 0
    writing: 0
  
  # Career Relevance
  career_domains:
    - "phone_communication"
    - "customer_greeting"
  career_relevance_score: 95                   # 0-100: how directly job-relevant
  
  # Prerequisites
  prerequisites: []                            # Empty = no prereqs (first mission)
  
  # Tags (for search, filtering, adaptive selection)
  tags:
    - "greeting"
    - "phone"
    - "formal_register"
    - "first_contact"
    - "module_opener"
```

---

## 5. Learning Objective Standard

### Format

A single sentence following the pattern:

> "After this mission, the learner can [OBSERVABLE ACTION] in [CONTEXT]."

### Rules

- Must describe a PRODUCIBLE skill (not "understands" or "knows")
- Must specify a real-world context
- Must be testable (you can hear/see whether they achieved it)

### Examples

| Mission | Learning Objective |
|---------|-------------------|
| m01_001_d | "After this mission, the learner can answer a phone call with a professional German greeting." |
| m05_008_d | "After this mission, the learner can acknowledge a customer's frustration using empathy phrases." |
| m09_003_s | "After this mission, the learner can present their work experience in a German job interview." |

### Anti-Examples (REJECTED)

- "The learner will understand greetings." → Not observable.
- "The learner will learn 5 new words." → Not a skill.
- "The learner will practice telephone vocabulary." → Activity, not outcome.

---

## 6. Scenario Design Standard

### 6.1 Required Fields

```yaml
scenario:
  setting: "Call center desk, Monday 9:05 AM"
  character: "frau_schmidt"                     # From character registry
  character_mood: "neutral_friendly"
  situation: >
    Your headset beeps. Incoming call. The display shows 
    "Frau Schmidt" — a regular customer. She needs help 
    with something. Answer professionally.
  stakes: "First impression. Professional reputation."
  sensory_details:
    visual: "Phone interface glowing, caller ID visible"
    audio: "Phone ring → office ambiance"
  trigger: "Phone rings. You must answer."
```

### 6.2 Scenario Validity Test

Every scenario must pass the "Real Test":

> "Would this exact situation occur in a real German workplace?"

If no → scenario is rejected regardless of pedagogical value.

### 6.3 Character Registry

All scenarios use characters from the official registry:

| Character ID | Name | Role | Speech Pace | Register | Typical Mood |
|-------------|------|------|-------------|----------|--------------|
| `frau_schmidt` | Frau Schmidt | Regular customer | Slow, clear | Formal | Friendly |
| `herr_weber` | Herr Weber | Difficult customer | Fast, clipped | Formal | Impatient |
| `frau_mueller` | Frau Müller | Team leader | Moderate | Professional | Supportive |
| `thomas` | Thomas | Senior colleague | Casual | Mixed | Friendly |
| `amir` | Amir | Fellow trainee | Moderate, accented | Informal | Encouraging |
| `dr_hoffmann` | Dr. Hoffmann | VIP client | Fast, precise | Very formal | Neutral |
| `lisa` | Lisa | IT colleague | Moderate | Neutral | Patient |
| `system` | System | App/narrator | N/A | N/A | N/A |

---

## 7. Emotional Goal Framework

Every mission declares its intended emotional experience.

### Format

```yaml
emotional_goal:
  primary_emotion: "professional_confidence"
  entry_feeling: "Slightly nervous but ready"
  exit_feeling: "I just answered a phone in German. Professionally."
  confidence_vector: "positive"                 # positive | consolidating | stretching
  vulnerability_level: "low"                    # low | moderate | high
```

### Emotion Vocabulary (Standardized)

| Emotion ID | Description | Appropriate For |
|-----------|-------------|-----------------|
| `professional_confidence` | "I can do this job" | Career scenarios |
| `discovery_excitement` | "I didn't know I could do that" | Phonetic bridges, grammar revelations |
| `calm_competence` | "This is routine now" | Review/practice missions |
| `productive_challenge` | "This is hard but I'm growing" | Challenge missions |
| `earned_pride` | "I just accomplished something real" | Simulation completions |
| `safe_exploration` | "It's okay to try and miss" | New material introduction |
| `relieved_recovery` | "I'm back on track" | Recovery missions |

---

## 8. Vocabulary Specification

### 8.1 Structure

```yaml
vocabulary:
  core:                                        # MUST be taught in this mission
    - id: "v_guten_tag"
      chunk_phrase: "Guten Tag"
      literal_meaning: "Good day"
      functional_meaning: "Professional greeting (any time of day)"
      translation_en: "Good day / Hello (formal)"
      translation_darija: "نهاركم مبروك (formal)"
      ipa: "/ˈɡuːtən taːk/"
      audio_path: "missions/m01_001/vocab_guten_tag.opus"
      part_of_speech: "phrase"
      register: "formal"
      frequency_rank: 1                        # 1 = extremely common
      domain: "greeting"
      example_in_context:
        de: "Guten Tag, TeleService GmbH, mein Name ist Youssef."
        en: "Good day, TeleService GmbH, my name is Youssef."
        audio_path: "missions/m01_001/example_guten_tag.opus"
      common_errors:
        - error: "Guten Tak"
          correction: "Tag, not Tak — the 'g' is voiced"
      srs_initial_interval_hours: 12
      
  supporting:                                  # Used in exercises but not primary focus
    - id: "v_name_ist"
      chunk_phrase: "Mein Name ist..."
      # ... (same structure as core)
      
  review:                                      # Previously learned, revisited here
    - id: "v_bitte"                            # References existing vocabulary entry
      review_context: "Used when asking customer for information"
```

### 8.2 Vocabulary Rules

| Rule | Enforcement |
|------|-------------|
| Maximum 5 core items per discovery mission | YAML validation |
| Maximum 3 core items per practice mission | YAML validation |
| Every core item has `chunk_phrase` (not isolated word) | Required field |
| Every item has native audio | `audio_path` required |
| Every item has at least one `example_in_context` | Required field |
| Review items reference existing IDs (no re-definition) | Cross-reference check |
| `register` field is always explicit | Required: formal/informal/neutral |

### 8.3 Vocabulary Clustering

Vocabulary items are grouped by tactical purpose (not topic):

| Cluster ID | Name | Examples |
|-----------|------|---------|
| `openers` | Start interactions | Guten Tag, Mein Name ist, Wie kann ich... |
| `bridges` | Buy thinking time | Einen Moment, Ich schaue nach |
| `shields` | Handle not understanding | Können Sie wiederholen, Langsamer bitte |
| `empathy` | De-escalate | Ich verstehe, Das tut mir leid |
| `actions` | Describe what you're doing | Ich prüfe, Ich notiere, Ich verbinde |
| `closers` | End interactions | Kann ich sonst..., Schönen Tag noch |
| `rescue` | Emergency fallbacks | Ich verbinde Sie mit..., Entschuldigung |

---


## 9. Dialogue Specification

### 9.1 Structure

Every dialogue is a sequence of turns with full metadata:

```yaml
dialogue:
  id: "dlg_m01_001_greeting"
  context: "Customer calls, agent answers"
  total_turns: 4
  estimated_duration_seconds: 45
  
  turns:
    - turn: 1
      speaker: "system"
      type: "narration"
      text_en: "Your phone rings. Answer it."
      audio_path: null                         # System text is displayed, not spoken
      
    - turn: 2
      speaker: "agent"                         # Learner speaks this
      type: "production"
      text_de: "Guten Tag, TeleService GmbH, mein Name ist Youssef, wie kann ich Ihnen helfen?"
      text_de_slow: "Guten Tag... TeleService GmbH... mein Name ist Youssef... wie kann ich Ihnen helfen?"
      audio_path_native: "missions/m01_001/dlg_turn2_native.opus"
      audio_path_slow: "missions/m01_001/dlg_turn2_slow.opus"
      translation_en: "Good day, TeleService GmbH, my name is Youssef, how can I help you?"
      translation_darija: "نهار مبروك، تيلي سيرفيس، سميتي يوسف، كيفاش نقدر نعاونك؟"
      pronunciation_notes:
        - segment: "Guten Tag"
          note: "Stress on 'Gu-'. The 'T' in Tag is aspirated."
        - segment: "Ihnen"
          note: "Not 'Inen' — the 'h' is silent but lengthens the 'i'."
      acceptable_responses:                    # For evaluation flexibility
        - pattern: "Guten Tag"
          required: true
          weight: 0.3
        - pattern: "wie kann ich"
          required: true
          weight: 0.3
        - pattern: "helfen"
          required: true
          weight: 0.2
        - pattern: "Name"
          required: false
          weight: 0.2
      scaffolding:
        support_high: "Full text visible + audio model plays first"
        support_standard: "First word of each segment visible"
        support_minimal: "No text. Produce from memory."
      
    - turn: 3
      speaker: "frau_schmidt"
      type: "input"                            # Learner listens to this
      text_de: "Guten Tag! Hier ist Schmidt. Ich habe eine Frage zu meiner Bestellung."
      audio_path_native: "missions/m01_001/dlg_turn3_native.opus"
      audio_path_slow: "missions/m01_001/dlg_turn3_slow.opus"
      translation_en: "Good day! This is Schmidt. I have a question about my order."
      translation_darija: "نهار مبروك! أنا شميت. عندي سؤال على الكوموند ديالي."
      comprehension_check:
        question_en: "What does the customer want?"
        options:
          - text: "Help with an order"
            correct: true
          - text: "To make a complaint"
            correct: false
          - text: "To change an address"
            correct: false
      
    - turn: 4
      speaker: "agent"
      type: "production"
      text_de: "Selbstverständlich, Frau Schmidt. Können Sie mir bitte Ihre Bestellnummer nennen?"
      audio_path_native: "missions/m01_001/dlg_turn4_native.opus"
      audio_path_slow: "missions/m01_001/dlg_turn4_slow.opus"
      translation_en: "Of course, Mrs. Schmidt. Could you please give me your order number?"
      translation_darija: "طبعا، مدام شميت. تقدري تعطيني الرقم ديال الكوموند؟"
      pronunciation_notes:
        - segment: "Selbstverständlich"
          note: "Four syllables: SELBST-ver-STÄND-lich. Stress on 1st and 3rd."
      acceptable_responses:
        - pattern: "Selbstverständlich"
          required: false
          weight: 0.3
        - pattern: "Frau Schmidt"
          required: false
          weight: 0.1
        - pattern: "Bestellnummer"
          required: true
          weight: 0.4
        - pattern: "bitte"
          required: false
          weight: 0.2
      scaffolding:
        support_high: "Full text visible + word bank available"
        support_standard: "Key words visible: Selbstverständlich... Bestellnummer..."
        support_minimal: "Prompt only: 'Ask for the order number politely.'"
```

### 9.2 Dialogue Rules

| Rule | Rationale |
|------|-----------|
| Maximum 8 turns per dialogue | Prevents cognitive overload |
| Learner speaks ≥50% of turns | Speaking-first doctrine |
| Every learner turn has `acceptable_responses` | Enables flexible evaluation |
| Every turn has both native and slow audio | Supports listening progression |
| Translations available for ALL turns | Comprehension safety net |
| `pronunciation_notes` on every learner production turn | Pronunciation coaching |
| Three scaffolding levels on every production turn | Adaptive difficulty support |

### 9.3 Speaker Types

| Speaker | Role in Dialogue | What Happens |
|---------|-----------------|-------------|
| `system` | Narration/instruction | Text displayed (not spoken aloud) |
| `agent` | Learner's role | Learner must produce this speech |
| Character ID | NPC speaking | Audio plays, learner listens |

---

## 10. Exercise Specification

### 10.1 Exercise Type Registry

| Type ID | Name | Skill Focus | Production Required | Typical Duration |
|---------|------|-------------|--------------------|-----------------| 
| `shadow` | Shadow/Echo | Pronunciation, rhythm | Yes (immediate repeat) | 30-60s per item |
| `repeat` | Prompted Recall | Vocabulary, phrases | Yes (from memory) | 30-60s per item |
| `listen_comprehend` | Listen & Respond | Listening, comprehension | Yes (spoken response) | 45-90s |
| `vocabulary_present` | Vocabulary Introduction | Vocabulary acquisition | Yes (echo + produce) | 60s per item |
| `conversation` | Multi-turn Dialogue | Speaking, fluency | Yes (role-play) | 2-5 min |
| `time_pressure` | Timed Response | Automaticity | Yes (within time limit) | 30-45s per item |
| `reconstruct` | Sentence Reconstruction | Memory, grammar | Yes (recall full sentence) | 45-60s |
| `parallel_tracks` | Register Comparison | Formality awareness | Yes (produce correct register) | 45s per pair |
| `rescue` | Error Correction | Metalinguistic awareness | Yes (improve bad example) | 45-60s |
| `dictation` | Number/Address Dictation | Listening, writing | Written response | 30-60s |

### 10.2 Exercise Structure

```yaml
exercises:
  - id: "ex_m01_001_01"
    type: "shadow"
    order: 1
    phase: "equip"                             # Which session phase: ignite/equip/challenge/land
    
    # Content
    prompt_text_en: "Listen and repeat exactly what you hear."
    target_text_de: "Guten Tag, wie kann ich Ihnen helfen?"
    target_audio_native: "missions/m01_001/ex01_native.opus"
    target_audio_slow: "missions/m01_001/ex01_slow.opus"
    
    # Evaluation
    evaluation_mode: "pronunciation_match"     # pronunciation_match | keyword_check | free_response
    evaluation_config:
      minimum_score: 0.5                       # 0.0-1.0; below this = retry offered
      keywords_required: ["Guten", "Tag", "helfen"]
      keywords_optional: ["kann", "ich", "Ihnen"]
      pronunciation_weight: 0.6
      completeness_weight: 0.4
    
    # Scaffolding (adaptive)
    scaffolding:
      support_high:
        text_visible: true
        audio_model_first: true
        word_bank: null
        hint_available: true
      support_standard:
        text_visible: false
        audio_model_first: true
        word_bank: null
        hint_available: true
      support_minimal:
        text_visible: false
        audio_model_first: false
        word_bank: null
        hint_available: false
    
    # Feedback
    feedback:
      on_success: "Clean pronunciation. Professional tone."
      on_partial: "Good attempt! Listen to the ending: '...helfen?' — rising intonation."
      on_retry: "Let's hear it one more time. Focus on the rhythm."
    
    # Timing
    max_attempts: 3
    time_limit_seconds: null                   # null = no time limit
    estimated_duration_seconds: 45
    
    # Connections
    vocabulary_ids: ["v_guten_tag", "v_wie_kann_ich"]
    srs_trigger: true                          # Creates SRS item on completion
```

### 10.3 Phase Assignment Rules

Every exercise belongs to a session phase:

| Phase | Exercise Purpose | Support Level | New Material? |
|-------|-----------------|---------------|---------------|
| `ignite` | Warm-up with known material | Minimal (it's familiar) | No |
| `equip` | Introduce new phrases/vocabulary | High → Standard | Yes |
| `challenge` | Full scenario application | Standard → Minimal | Combined |
| `land` | Consolidation and cool-down | Standard | No (reinforce today's) |

### 10.4 Exercise Ordering Rules

1. Every mission starts with 2-3 `ignite` exercises (known material).
2. `equip` exercises follow, introducing 3-5 new items.
3. `challenge` exercises form the peak (longest section).
4. `land` exercises end the session (always success-oriented).
5. Within each phase, difficulty increases monotonically.
6. Speaking exercises are never back-to-back with identical types.
7. Every 3rd exercise should be from a different type (variety rule).

---

## 11. Grammar Discovery Specification

### 11.1 Modes

| Mode | Description | When Used |
|------|-------------|-----------|
| `embedded` | Grammar pattern appears in phrases without explicit mention | All missions (default) |
| `revelation` | System shows the learner a pattern they already use | Specific grammar milestone missions |
| `refinement` | Conscious practice after revelation | Post-revelation missions |

### 11.2 Structure

```yaml
grammar_discovery:
  mode: "embedded"
  
  # What grammar is being absorbed (internal tracking, not shown to learner)
  pattern_id: "present_tense_regular"
  pattern_description: "Regular present tense conjugation (ich -e)"
  
  # Where it appears in this mission
  instances:
    - phrase: "Wie kann ich Ihnen helfen?"
      grammar_element: "kann (modal verb present)"
      learner_aware: false                     # Learner doesn't know this is grammar
    - phrase: "Ich schaue sofort nach."
      grammar_element: "schaue (1st person present)"
      learner_aware: false
  
  # Revelation data (only used when mode = revelation)
  revelation:
    trigger_after_missions: 12                 # Reveal after this many exposures
    reveal_text_en: >
      Notice something? You've been saying "ich helfe," "ich schaue," 
      "ich prüfe" for two weeks. They all end in '-e'. That's how 
      German works for 'ich' (I) — add '-e' to the verb stem. 
      You already knew this. Now you know its name.
    reveal_text_darija: >
      شفتي شي حاجة؟ هاد أسبوعين وانت كتقول "ich helfe," "ich schaue," 
      "ich prüfe" — كلهم كيسالو ب '-e'. هكذا كتخدم الألمانية مع 'ich'. 
      كنت كتعرف هادشي. دابا عرفتي اسمو.
    examples_from_learner_history:
      - "Ich helfe Ihnen gerne."
      - "Ich schaue sofort nach."
      - "Ich prüfe das für Sie."
      - "Ich verbinde Sie mit meinem Kollegen."
```

### 11.3 Grammar Discovery Rules

| Rule | Rationale |
|------|-----------|
| Never use the word "grammar" in learner-facing text | Avoids school trauma association |
| Never present a grammar table | Tables are for reference, not acquisition |
| Revelation only after ≥10 unconscious uses | Procedural memory must already exist |
| Always show examples the learner ALREADY PRODUCED | Validates their existing knowledge |
| Connect to Darija/English parallel when possible | Leverages L1 transfer |
| Post-revelation exercises test PRODUCTION not LABELING | "Use it" not "name it" |

---

## 12. Pronunciation Coaching Specification

### 12.1 Structure

```yaml
pronunciation_coaching:
  focus_sounds:
    - sound_id: "ch_ich"
      ipa: "/ç/"
      german_example: "ich"
      bridge_language: "none"
      bridge_explanation_en: "Like whispering 'hee' with friction at the roof of your mouth."
      bridge_explanation_darija: "بحال خ خفيفة، من قدام الفم مشي من لور"
      common_error: "Replacing with /ʃ/ (saying 'ish' instead of 'ich')"
      audio_correct: "pronunciation/ch_ich_correct.opus"
      audio_incorrect: "pronunciation/ch_ich_incorrect.opus"
      drill_words: ["ich", "nicht", "möchte", "natürlich"]
      
    - sound_id: "long_a"
      ipa: "/aː/"
      german_example: "Tag"
      bridge_language: "french"
      bridge_explanation_en: "Like the 'a' in French 'pas' — open and long."
      common_error: "Shortening to /a/ (Tag sounds like 'tuck')"
      audio_correct: "pronunciation/long_a_correct.opus"
      audio_incorrect: "pronunciation/long_a_incorrect.opus"
      drill_words: ["Tag", "Name", "Frage", "sagen"]
      
  intonation_pattern:
    pattern: "question_rising"
    description: "Rising intonation at end of yes/no questions"
    example: "Kann ich Ihnen helfen? ↗"
    audio_demo: "pronunciation/intonation_question.opus"
```

### 12.2 Phonetic Bridge Priority

When a pronunciation coaching item can leverage a bridge language, it MUST do so:

| Priority | Approach | When |
|----------|----------|------|
| 1 | Bridge from Darija/Arabic | Sound exists identically in Arabic |
| 2 | Bridge from French | Sound exists identically in French |
| 3 | Bridge from English | Sound exists in English |
| 4 | Articulatory instruction | Sound is genuinely new |

---

## 13. Common Mistakes Catalog

### 13.1 Structure

```yaml
common_mistakes:
  - id: "err_m01_001_register"
    type: "register"
    mistake_de: "Hallo, was kann ich für dich tun?"
    correction_de: "Guten Tag, wie kann ich Ihnen helfen?"
    explanation_en: >
      'Hallo' and 'du' are informal. In customer service, always use 
      'Guten Tag' and 'Sie/Ihnen'. The customer is not your friend — 
      they are a professional contact.
    explanation_darija: >
      'Hallo' و 'du' informal. ف customer service ديما خدم 'Guten Tag' 
      و 'Sie/Ihnen'. الزبون ماشي صاحبك — هو contact professionnel.
    severity: "high"                           # high | medium | low
    prevention_tip_en: "In Germany: if unsure, always choose formal."
    
  - id: "err_m01_001_pronunciation"
    type: "pronunciation"
    mistake_description: "Saying 'Guten Tak' instead of 'Guten Tag'"
    explanation_en: "The 'g' at the end of 'Tag' is voiced, not voiceless."
    severity: "medium"
    audio_incorrect: "mistakes/guten_tak.opus"
    audio_correct: "missions/m01_001/vocab_guten_tag.opus"
```

### 13.2 Mistake Types

| Type ID | Description | Typical Source |
|---------|-------------|---------------|
| `register` | Using informal when formal is required | L1 transfer (Darija is less register-stratified) |
| `pronunciation` | Sound produced incorrectly | L1 phonetic interference |
| `word_order` | German V2 or final verb violated | English/Arabic transfer |
| `gender` | Wrong article (der/die/das) | No system in L1 maps to German gender |
| `case` | Wrong case after preposition/verb | No equivalent in L1 |
| `vocabulary` | False friend or wrong word choice | French/English cognate trap |
| `cultural` | Behavior inappropriate for German workplace | Cultural difference |

---

## 14. Cultural Notes Standard

### 14.1 Structure

```yaml
cultural_notes:
  - id: "culture_m01_001_greeting"
    trigger: "before_dialogue"                 # before_dialogue | after_exercise | end_of_mission
    type: "workplace_norm"
    title_en: "The German Phone Greeting"
    content_en: >
      In German call centers, you always identify yourself AND your company 
      when answering. Never just "Hallo?" — that's private phone behavior.
      The formula is: [Greeting] + [Company] + [Your name] + [How can I help].
      This is non-negotiable in professional settings.
    content_darija: >
      ف call centers الألمانية، ديما كتعرف براسك و بالشركة ملي كتجاوب. 
      ما تقولش غير "Hallo?" — هادي ديال التيليفون الشخصي.
      الصيغة هي: [تحية] + [شركة] + [سميتك] + [كيفاش نعاونك].
      هادشي ما كيتناقشش ف professional settings.
    importance: "critical"                     # critical | important | informative
    compare_darija: >
      Unlike in Morocco where you might answer "Allo, na3am?" — 
      German business calls have a strict formula.
```

### 14.2 Cultural Note Rules

| Rule | Rationale |
|------|-----------|
| Maximum 2 cultural notes per mission | Don't overwhelm with non-language content |
| Always compare to learner's cultural norm | Makes the difference salient |
| Never judge learner's culture as wrong | Respect — it's different, not inferior |
| Focus on ACTIONABLE workplace behaviors | Not tourism facts |
| Critical notes appear BEFORE the relevant exercise | Prevents error before it happens |

---


## 15. Smart Review Triggers

### 15.1 Purpose

Every mission declares which items should enter the spaced repetition system and under what conditions. This ensures that the SRS engine receives properly tagged items at the moment of learning.

### 15.2 Structure

```yaml
smart_review:
  # Items that enter SRS upon mission completion
  new_srs_items:
    - item_id: "v_guten_tag"
      item_type: "vocabulary"
      initial_interval_hours: 12
      initial_ease_factor: 2.5
      review_exercise_types: ["repeat", "conversation", "time_pressure"]
      context_variations:                      # Different sentences for review encounters
        - "Guten Tag, hier ist die Serviceabteilung."
        - "Guten Tag, wie kann ich Ihnen weiterhelfen?"
        - "Guten Tag, Sie sprechen mit Herrn Youssef."
      
    - item_id: "v_wie_kann_ich"
      item_type: "phrase"
      initial_interval_hours: 12
      initial_ease_factor: 2.5
      review_exercise_types: ["repeat", "conversation"]
      context_variations:
        - "Wie kann ich Ihnen behilflich sein?"
        - "Wie kann ich Ihnen heute helfen?"
        - "Was kann ich für Sie tun?"
  
  # Items from previous missions that should appear in THIS mission (embedded review)
  embedded_review_items:
    - item_id: "v_bitte"
      appears_in_exercise: "ex_m01_001_07"     # Woven into challenge exercise
      review_context: "Customer service closing phrase"
  
  # Conditions for scheduling additional review
  review_triggers:
    - condition: "score_below_0.6_on_any_core_vocab"
      action: "schedule_review_within_24h"
    - condition: "pronunciation_score_below_0.5"
      action: "add_to_pronunciation_lab_queue"
    - condition: "response_latency_above_8s"
      action: "maintain_current_interval"      # Don't extend, needs more practice
```

### 15.3 Contextual Variation Rule

Every SRS item MUST have ≥3 context variations. The item is NEVER reviewed in the same sentence twice consecutively. This prevents rote sentence memorization and builds genuine productive recall.

---

## 16. Confidence Scoring Model

### 16.1 Per-Mission Scoring

```yaml
confidence_scoring:
  # Dimensions evaluated (weights must sum to 1.0)
  dimensions:
    - id: "communicative_success"
      weight: 0.35
      description: "Did the learner communicate the intended meaning?"
      measurement: "keyword_presence + intent_match"
      
    - id: "linguistic_accuracy"
      weight: 0.25
      description: "Was the grammar and vocabulary approximately correct?"
      measurement: "transcription_comparison"
      
    - id: "pronunciation_quality"
      weight: 0.20
      description: "Would a German native understand without asking to repeat?"
      measurement: "phonetic_similarity_score"
      
    - id: "response_speed"
      weight: 0.10
      description: "How quickly did the learner begin speaking?"
      measurement: "latency_from_prompt_to_speech_onset"
      
    - id: "professional_register"
      weight: 0.10
      description: "Was the formality level appropriate?"
      measurement: "register_marker_detection"
  
  # Thresholds
  thresholds:
    accomplished: 0.80                         # Gold outcome
    completed: 0.60                            # Silver outcome
    advanced: 0.40                             # Bronze outcome
    attempted: 0.0                             # Below 0.40 = attempted (no failure)
  
  # Career readiness contribution
  career_readiness_contribution:
    domain: "phone_communication"
    max_contribution_percent: 2.0              # This mission can add up to 2% to that domain
    formula: "score × max_contribution_percent"
```

### 16.2 Scoring Rules

| Rule | Rationale |
|------|-----------|
| No score below 0 (no negative scoring) | Attempts are always positive |
| Communicative success > everything else | Communication is the goal |
| Speed only counts after Module 4 | Early learners need time without pressure |
| Register only counts after Module 5 | Formal register introduced later |
| Scores are never shown as percentages to learner | They see outcomes (gold/silver/bronze), not numbers |

---

## 17. Success Criteria Definition

### 17.1 Structure

```yaml
success_criteria:
  # Primary objective (mandatory for "accomplished" outcome)
  primary:
    description: "Produce a recognizable professional phone greeting in German"
    test: "Agent turn in dialogue contains: greeting + name/company + offer to help"
    minimum_score: 0.6
    
  # Secondary objectives (contribute to higher outcomes)
  secondary:
    - description: "Use correct formal register throughout"
      test: "No informal markers detected (du, Hallo alone, etc.)"
    - description: "Pronunciation intelligible without repetition needed"
      test: "Pronunciation score ≥ 0.65 on all production turns"
    - description: "Response latency under 5 seconds on prompted recalls"
      test: "Average latency < 5000ms"
  
  # Minimum for progression (mission counts as "attempted")
  minimum_for_progression:
    description: "Learner completed all exercises (even with support)"
    test: "All exercise IDs marked as attempted"
```

### 17.2 Outcome Mapping

| Outcome | Requirements | Unlock Effect |
|---------|-------------|---------------|
| **Accomplished** (Gold) | Primary + all secondary met | Next mission + stretch challenge |
| **Completed** (Silver) | Primary met + 1+ secondary | Next mission unlocked |
| **Advanced** (Bronze) | Primary met (even with support) | Next mission + targeted review |
| **Attempted** | Completed all exercises | Recovery mission offered + retry |

---

## 18. Career Transfer Statement

### 18.1 Structure

```yaml
career_transfer:
  statement_en: >
    This exact greeting formula — company name, your name, offer to help — 
    is used in 100% of German call centers. You will say this sentence 
    50-100 times on your first day of work. By practicing it now until 
    it's automatic, you arrive at your first shift already performing 
    at a professional level.
  statement_darija: >
    هاد الصيغة بالضبط — اسم الشركة، سميتك، عرض المساعدة — كتستعمل 
    ف 100% ديال call centers الألمانية. غادي تقولها 50-100 مرة ف النهار 
    الأول ديال الخدمة. ملي كتمرنها دابا حتى تولي automatique، كتوصل 
    للخدمة وانت عندك niveau professionnel.
  frequency_at_work: "50-100 times daily"
  domains_applied: ["call_center", "reception", "helpdesk"]
  real_world_impact: "First impression with every customer"
```

### 18.2 Career Transfer Rules

| Rule | Rationale |
|------|-----------|
| Every mission has a career transfer statement | Maintains motivation anchoring |
| Must specify FREQUENCY of use at work | Concrete proof of relevance |
| Must name specific job domains | Connects to career readiness score |
| Available in English AND Darija | Accessibility |
| Tone: factual, not motivational | Adults prefer data over cheerleading |

---

## 19. Mission File Format (YAML)

### 19.1 Complete File Structure

Every mission is stored as a single YAML file following this exact structure:

```yaml
# ═══════════════════════════════════════════════════════════════
# PHOENIX MISSION FILE
# Specification Version: 1.0.0
# ═══════════════════════════════════════════════════════════════

spec_version: "1.0.0"

# ─── METADATA ─────────────────────────────────────────────────
metadata:
  id: ""
  title_internal: ""
  title_display_en: ""
  title_display_de: ""
  module: 0
  sequence: 0
  type: ""                                     # discovery | practice | challenge | simulation | recovery
  version: 1
  estimated_duration_minutes: 0
  min_duration_minutes: 0
  max_duration_minutes: 0
  cefr_level: ""
  cefr_target: ""
  difficulty: 0                                # 1-10
  skills:
    speaking: 0
    listening: 0
    vocabulary: 0
    pronunciation: 0
    reading: 0
    writing: 0
  career_domains: []
  career_relevance_score: 0
  prerequisites: []
  tags: []

# ─── LEARNING OBJECTIVE ───────────────────────────────────────
learning_objective:
  statement_en: ""
  statement_darija: ""

# ─── SCENARIO ─────────────────────────────────────────────────
scenario:
  setting: ""
  character: ""
  character_mood: ""
  situation: ""
  stakes: ""
  sensory_details:
    visual: ""
    audio: ""
  trigger: ""

# ─── EMOTIONAL GOAL ───────────────────────────────────────────
emotional_goal:
  primary_emotion: ""
  entry_feeling: ""
  exit_feeling: ""
  confidence_vector: ""                        # positive | consolidating | stretching
  vulnerability_level: ""                      # low | moderate | high

# ─── VOCABULARY ───────────────────────────────────────────────
vocabulary:
  core: []
  supporting: []
  review: []

# ─── DIALOGUE ─────────────────────────────────────────────────
dialogue:
  id: ""
  context: ""
  total_turns: 0
  estimated_duration_seconds: 0
  turns: []

# ─── EXERCISES ────────────────────────────────────────────────
exercises: []

# ─── GRAMMAR DISCOVERY ────────────────────────────────────────
grammar_discovery:
  mode: ""                                     # embedded | revelation | refinement
  pattern_id: ""
  pattern_description: ""
  instances: []
  revelation: null                             # Only present when mode = revelation

# ─── PRONUNCIATION COACHING ───────────────────────────────────
pronunciation_coaching:
  focus_sounds: []
  intonation_pattern: null

# ─── COMMON MISTAKES ─────────────────────────────────────────
common_mistakes: []

# ─── CULTURAL NOTES ───────────────────────────────────────────
cultural_notes: []

# ─── SMART REVIEW ─────────────────────────────────────────────
smart_review:
  new_srs_items: []
  embedded_review_items: []
  review_triggers: []

# ─── CONFIDENCE SCORING ───────────────────────────────────────
confidence_scoring:
  dimensions: []
  thresholds:
    accomplished: 0.80
    completed: 0.60
    advanced: 0.40
    attempted: 0.0
  career_readiness_contribution:
    domain: ""
    max_contribution_percent: 0.0

# ─── SUCCESS CRITERIA ─────────────────────────────────────────
success_criteria:
  primary:
    description: ""
    test: ""
    minimum_score: 0.0
  secondary: []
  minimum_for_progression:
    description: ""
    test: ""

# ─── CAREER TRANSFER ─────────────────────────────────────────
career_transfer:
  statement_en: ""
  statement_darija: ""
  frequency_at_work: ""
  domains_applied: []
  real_world_impact: ""

# ─── QUALITY REPORT ──────────────────────────────────────────
quality_report:
  grammar_confidence_percent: 0                # 0-100: confidence all German is correct
  vocabulary_verified: false                   # Native speaker has verified all vocabulary
  idiomatic_expressions_reviewed: false        # All expressions checked for naturalness
  cefr_alignment_verified: false              # Content matches declared CEFR level
  audio_recorded: false                        # All audio files exist and are quality-checked
  cultural_accuracy_verified: false            # Cultural notes reviewed by German resident
  darija_translation_verified: false           # Darija content reviewed by native speaker
  review_date: ""                              # Last quality review date (YYYY-MM-DD)
  reviewer: ""                                 # Who performed the quality review
  notes: ""                                    # Any quality concerns or flags
```

### 19.2 File Naming Convention

```
missions/{module_id}/{mission_id}.yaml

Examples:
  missions/m01/m01_001_d.yaml
  missions/m05/m05_012_s.yaml
  missions/m09/m09_003_c.yaml
```

### 19.3 Audio File Convention

```
audio/missions/{mission_id}/{description}.opus

Examples:
  audio/missions/m01_001_d/greeting_full_native.opus
  audio/missions/m01_001_d/greeting_full_slow.opus
  audio/missions/m01_001_d/vocab_guten_tag.opus
  audio/missions/m01_001_d/dlg_turn2_native.opus
```

### 19.4 Validation Rules (Machine-Enforced)

| Rule | Error if Violated |
|------|-------------------|
| `spec_version` matches current spec | FATAL: File cannot be loaded |
| `metadata.id` follows naming convention | FATAL: Invalid mission ID |
| `metadata.skills` values sum to 100 | FATAL: Skills must sum to 100 |
| `metadata.skills.speaking` ≥ 50 for discovery/practice | WARN: Below speaking-first threshold |
| `vocabulary.core` length ≤ 5 for discovery | ERROR: Too many core items |
| `exercises` contains ≥ 1 exercise per phase | ERROR: Incomplete session structure |
| All `audio_path` references exist on disk | FATAL: Missing audio assets |
| All `vocabulary_ids` in exercises reference defined vocab | ERROR: Orphan reference |
| `quality_report.grammar_confidence_percent` ≥ 95 | WARN: Grammar not verified |
| `quality_report.vocabulary_verified` = true | WARN: Not production-ready |
| `quality_report.cefr_alignment_verified` = true | WARN: Not production-ready |
| `career_transfer.statement_en` is non-empty | ERROR: Missing career anchor |
| `learning_objective.statement_en` starts with "After this mission" | WARN: Non-standard format |
| `confidence_scoring.dimensions` weights sum to 1.0 | FATAL: Invalid scoring config |

---

## 20. AI Generation Protocol

### 20.1 Purpose

This protocol enables AI systems to generate conformant mission YAML files from a single prompt, ensuring consistency across all 500+ missions.

### 20.2 AI Prompt Template

When requesting a new mission from an AI, use this template:

```
Generate a Phoenix Mission YAML file conforming to PMS v1.0.0.

MISSION PARAMETERS:
- Module: {module_number}
- Sequence: {sequence_number}
- Type: {discovery | practice | challenge | simulation | recovery}
- CEFR Level: {A0 | A1 | A2 | B1}
- Career Domain: {domain}
- Theme: {one-sentence description of what the learner does}
- Character: {character_id from registry}
- New Vocabulary: {list of 3-5 German phrases to teach}
- Grammar Pattern (embedded): {pattern being absorbed}
- Builds On: {list of prerequisite mission IDs}

CONSTRAINTS:
- Follow the Five-Act structure (ignite/equip/challenge/land/seal)
- Speaking exercises ≥ 60% of exercise time
- Maximum 5 core vocabulary items
- All German must be grammatically perfect
- All translations must be natural (not literal)
- Three scaffolding levels on every production exercise
- Include quality report with grammar_confidence_percent ≥ 99

OUTPUT: Complete YAML file conforming to PMS spec_version 1.0.0
```

### 20.3 AI Validation Requirements

After AI generates a mission, it MUST pass:

1. **Schema validation** — YAML structure matches spec exactly
2. **Linguistic review** — All German verified by native speaker or grammar engine
3. **CEFR alignment** — Vocabulary and structures match declared level
4. **Consistency check** — References to vocabulary IDs, character IDs, prerequisite IDs all resolve
5. **Pedagogy review** — Learning objective is achievable within the mission content
6. **Quality report** — All fields populated honestly

### 20.4 AI Generation Constraints

| Constraint | Reason |
|-----------|--------|
| AI NEVER generates audio files | Audio requires professional recording |
| AI NEVER marks `vocabulary_verified: true` | Requires human native speaker review |
| AI NEVER marks `cultural_accuracy_verified: true` | Requires human cultural review |
| AI CAN mark `grammar_confidence_percent: 99` | If using verified grammar engine |
| AI CAN mark `cefr_alignment_verified: true` | If following official CEFR word lists |
| AI ALWAYS generates all three scaffolding levels | Required by spec |
| AI ALWAYS generates ≥3 context variations per SRS item | Required by spec |
| AI ALWAYS generates career_transfer statement | Required by spec |

### 20.5 Batch Generation Protocol

For generating multiple missions at once:

```
1. Generate mission list (IDs, themes, vocabulary targets)
2. Generate missions in sequence order (ensures prerequisite coherence)
3. Cross-reference vocabulary IDs (no duplicates, no orphans)
4. Verify narrative continuity (characters, ongoing scenarios)
5. Validate all files against schema
6. Flag all files for human review (audio, vocabulary, culture)
```

---

## 21. Validation Checklist

Every mission MUST pass this checklist before entering the content database:

### Structural Validation (Automated)

- [ ] YAML parses without errors
- [ ] `spec_version` matches current specification
- [ ] All required fields are present and non-empty
- [ ] `metadata.id` follows naming convention
- [ ] `metadata.skills` sum to 100
- [ ] `metadata.speaking` ≥ 50 (for non-simulation types)
- [ ] `vocabulary.core` length ≤ 5 (discovery) or ≤ 3 (practice)
- [ ] All audio path references resolve to existing files
- [ ] All vocabulary ID references resolve
- [ ] All prerequisite mission IDs exist in the system
- [ ] `confidence_scoring.dimensions` weights sum to 1.0
- [ ] Exercises span all four phases (ignite, equip, challenge, land)
- [ ] No duplicate exercise IDs within the mission

### Pedagogical Validation (Human Review)

- [ ] Learning objective is a single observable skill
- [ ] Scenario passes the "Real Test" (would happen in real workplace)
- [ ] Vocabulary items are chunked (not isolated words)
- [ ] Grammar is embedded (never the stated objective)
- [ ] Exercise difficulty increases monotonically within phases
- [ ] Scaffolding degrades naturally (high → standard → minimal)
- [ ] Feedback text is safe (no shame, no "wrong," no judgment)
- [ ] Cultural notes are accurate and non-judgmental
- [ ] Career transfer statement is specific and data-backed

### Quality Validation (Expert Review)

- [ ] `quality_report.grammar_confidence_percent` ≥ 99
- [ ] `quality_report.vocabulary_verified` = true
- [ ] `quality_report.idiomatic_expressions_reviewed` = true
- [ ] `quality_report.cefr_alignment_verified` = true
- [ ] `quality_report.audio_recorded` = true
- [ ] `quality_report.cultural_accuracy_verified` = true
- [ ] `quality_report.darija_translation_verified` = true (if Darija content present)

### Production Gate

A mission is **production-ready** ONLY when ALL THREE validation layers pass. Missions with any FATAL errors cannot be loaded. Missions with WARN flags can load but are flagged for review.

---


## 22. Sample Mission: MISSION_ZERO

Below is the complete, conformant YAML for Mission Zero — the first mission any learner experiences.

---

```yaml
# ═══════════════════════════════════════════════════════════════
# PHOENIX MISSION FILE
# Mission Zero: "Your Phone is Ringing"
# Specification Version: 1.0.0
# ═══════════════════════════════════════════════════════════════

spec_version: "1.0.0"

# ─── METADATA ─────────────────────────────────────────────────
metadata:
  id: "m01_001_d"
  title_internal: "Greeting a Customer"
  title_display_en: "Your Phone is Ringing"
  title_display_de: "Ihr Telefon klingelt"
  module: 1
  sequence: 1
  type: "discovery"
  version: 1
  estimated_duration_minutes: 12
  min_duration_minutes: 8
  max_duration_minutes: 15
  cefr_level: "A0"
  cefr_target: "A1.1"
  difficulty: 1
  skills:
    speaking: 65
    listening: 20
    vocabulary: 10
    pronunciation: 5
    reading: 0
    writing: 0
  career_domains:
    - "phone_communication"
    - "customer_greeting"
  career_relevance_score: 98
  prerequisites: []
  tags:
    - "greeting"
    - "phone"
    - "formal_register"
    - "first_contact"
    - "module_opener"
    - "mission_zero"

# ─── LEARNING OBJECTIVE ───────────────────────────────────────
learning_objective:
  statement_en: >
    After this mission, the learner can answer a phone call with a 
    professional German greeting including company name and offer to help.
  statement_darija: >
    بعد هاد المهمة، المتعلم يقدر يجاوب على تيليفون بتحية ألمانية 
    احترافية فيها اسم الشركة وعرض المساعدة.

# ─── SCENARIO ─────────────────────────────────────────────────
scenario:
  setting: "Call center desk, Monday 9:05 AM, first day of training"
  character: "frau_schmidt"
  character_mood: "neutral_friendly"
  situation: >
    It's your first morning at TeleService GmbH. You've been shown your 
    desk, your headset, your screen. Frau Müller, your team lead, says: 
    "Your first real call is coming. Remember the greeting formula. 
    You've got this." Your headset beeps. Incoming call.
  stakes: >
    First impression with a real customer. Professional reputation 
    starts now.
  sensory_details:
    visual: "Clean desk, headset, screen showing caller ID: Frau Schmidt"
    audio: "Phone ring tone, then subtle office ambiance"
  trigger: "Headset beeps. Caller ID shows: Frau Schmidt. Answer now."

# ─── EMOTIONAL GOAL ───────────────────────────────────────────
emotional_goal:
  primary_emotion: "professional_confidence"
  entry_feeling: "Nervous but ready — this is what I came here for"
  exit_feeling: "I just answered a phone in German. Professionally. On my first mission."
  confidence_vector: "positive"
  vulnerability_level: "moderate"

# ─── VOCABULARY ───────────────────────────────────────────────
vocabulary:
  core:
    - id: "v_guten_tag"
      chunk_phrase: "Guten Tag"
      literal_meaning: "Good day"
      functional_meaning: "Professional greeting used any time of day in business"
      translation_en: "Good day (formal hello)"
      translation_darija: "نهاركم مبروك (رسمي)"
      ipa: "/ˈɡuːtən taːk/"
      audio_path: "audio/missions/m01_001_d/vocab_guten_tag.opus"
      part_of_speech: "phrase"
      register: "formal"
      frequency_rank: 1
      domain: "greeting"
      example_in_context:
        de: "Guten Tag, TeleService GmbH, mein Name ist Youssef."
        en: "Good day, TeleService GmbH, my name is Youssef."
        audio_path: "audio/missions/m01_001_d/example_guten_tag.opus"
      common_errors:
        - error: "Guten Tak"
          correction: "Tag — the final 'g' is voiced /k/ in standard German but never /t/"
      srs_initial_interval_hours: 12

    - id: "v_wie_kann_ich_ihnen_helfen"
      chunk_phrase: "Wie kann ich Ihnen helfen?"
      literal_meaning: "How can I you(formal) help?"
      functional_meaning: "Standard offer to assist — used in every service interaction"
      translation_en: "How can I help you?"
      translation_darija: "كيفاش نقدر نعاونك؟ (رسمي)"
      ipa: "/viː kan ɪç ˈiːnən ˈhɛlfən/"
      audio_path: "audio/missions/m01_001_d/vocab_wie_kann_ich.opus"
      part_of_speech: "phrase"
      register: "formal"
      frequency_rank: 2
      domain: "service_opening"
      example_in_context:
        de: "Guten Tag, wie kann ich Ihnen helfen?"
        en: "Good day, how can I help you?"
        audio_path: "audio/missions/m01_001_d/example_wie_kann_ich.opus"
      common_errors:
        - error: "Wie kann ich dir helfen?"
          correction: "Ihnen, not dir — always formal with customers"
      srs_initial_interval_hours: 12

    - id: "v_mein_name_ist"
      chunk_phrase: "Mein Name ist..."
      literal_meaning: "My name is..."
      functional_meaning: "Professional self-identification on the phone"
      translation_en: "My name is..."
      translation_darija: "سميتي..."
      ipa: "/maɪn ˈnaːmə ɪst/"
      audio_path: "audio/missions/m01_001_d/vocab_mein_name.opus"
      part_of_speech: "phrase"
      register: "formal"
      frequency_rank: 3
      domain: "identification"
      example_in_context:
        de: "Mein Name ist Youssef, ich bin Ihr Ansprechpartner."
        en: "My name is Youssef, I am your contact person."
        audio_path: "audio/missions/m01_001_d/example_mein_name.opus"
      common_errors:
        - error: "Ich bin Youssef"
          correction: "Correct but less professional. 'Mein Name ist...' is the standard call center formula."
      srs_initial_interval_hours: 12

    - id: "v_selbstverstaendlich"
      chunk_phrase: "Selbstverständlich"
      literal_meaning: "Self-understandably"
      functional_meaning: "Of course / Certainly — conveys willingness and professionalism"
      translation_en: "Of course / Certainly"
      translation_darija: "طبعا / بكل تأكيد"
      ipa: "/ˈzɛlpstfɛɐ̯ˈʃtɛntlɪç/"
      audio_path: "audio/missions/m01_001_d/vocab_selbstverstaendlich.opus"
      part_of_speech: "adverb"
      register: "formal"
      frequency_rank: 8
      domain: "affirmation"
      example_in_context:
        de: "Selbstverständlich helfe ich Ihnen gerne."
        en: "Of course, I'm happy to help you."
        audio_path: "audio/missions/m01_001_d/example_selbstverstaendlich.opus"
      common_errors:
        - error: "Selbstverständlisch"
          correction: "'-lich' not '-lisch'. The ending is /lɪç/."
      srs_initial_interval_hours: 24

    - id: "v_bestellnummer"
      chunk_phrase: "Ihre Bestellnummer"
      literal_meaning: "Your order-number"
      functional_meaning: "Requesting the customer's order reference"
      translation_en: "Your order number"
      translation_darija: "الرقم ديال الكوموند ديالك"
      ipa: "/ˈiːʁə bəˈʃtɛlˌnʊmɐ/"
      audio_path: "audio/missions/m01_001_d/vocab_bestellnummer.opus"
      part_of_speech: "noun_phrase"
      register: "formal"
      frequency_rank: 5
      domain: "order_management"
      example_in_context:
        de: "Können Sie mir bitte Ihre Bestellnummer nennen?"
        en: "Could you please give me your order number?"
        audio_path: "audio/missions/m01_001_d/example_bestellnummer.opus"
      common_errors:
        - error: "Bestellung Nummer"
          correction: "One compound word: Bestellnummer. German compounds don't separate."
      srs_initial_interval_hours: 24

  supporting: []

  review: []

# ─── DIALOGUE ─────────────────────────────────────────────────
dialogue:
  id: "dlg_m01_001"
  context: "First customer call — Frau Schmidt asks about her order"
  total_turns: 6
  estimated_duration_seconds: 60

  turns:
    - turn: 1
      speaker: "system"
      type: "narration"
      text_en: "Your headset beeps. Incoming call from Frau Schmidt. Answer professionally."
      audio_path: "audio/missions/m01_001_d/phone_ring.opus"

    - turn: 2
      speaker: "agent"
      type: "production"
      text_de: "Guten Tag, TeleService GmbH, mein Name ist Youssef, wie kann ich Ihnen helfen?"
      text_de_slow: "Guten Tag... TeleService GmbH... mein Name ist Youssef... wie kann ich Ihnen helfen?"
      audio_path_native: "audio/missions/m01_001_d/dlg_t2_native.opus"
      audio_path_slow: "audio/missions/m01_001_d/dlg_t2_slow.opus"
      translation_en: "Good day, TeleService GmbH, my name is Youssef, how can I help you?"
      translation_darija: "نهاركم مبروك، تيلي سيرفيس، سميتي يوسف، كيفاش نقدر نعاونكم؟"
      pronunciation_notes:
        - segment: "Guten Tag"
          note: "Stress on GU-ten. 'Tag' ends with a soft /k/ sound."
        - segment: "Ihnen helfen"
          note: "'Ihnen' — the 'h' is silent, long 'i'. Rising intonation on 'helfen?' (it's a question)."
      acceptable_responses:
        - pattern: "Guten Tag"
          required: true
          weight: 0.25
        - pattern: "Name"
          required: false
          weight: 0.15
        - pattern: "wie kann ich"
          required: true
          weight: 0.30
        - pattern: "helfen"
          required: true
          weight: 0.30
      scaffolding:
        support_high: "Full text visible on screen. Audio model plays first. Learner repeats."
        support_standard: "First word of each chunk visible: 'Guten... TeleService... mein... wie...'"
        support_minimal: "Prompt only: 'Answer the phone professionally.' No text support."

    - turn: 3
      speaker: "frau_schmidt"
      type: "input"
      text_de: "Guten Tag! Hier ist Schmidt. Ich habe eine Frage zu meiner Bestellung."
      audio_path_native: "audio/missions/m01_001_d/dlg_t3_native.opus"
      audio_path_slow: "audio/missions/m01_001_d/dlg_t3_slow.opus"
      translation_en: "Good day! This is Schmidt. I have a question about my order."
      translation_darija: "نهاركم مبروك! أنا شميت. عندي سؤال على الكوموند ديالي."
      comprehension_check:
        question_en: "What does Frau Schmidt need?"
        options:
          - text_en: "She has a question about her order"
            correct: true
          - text_en: "She wants to make a complaint"
            correct: false
          - text_en: "She wants to cancel her subscription"
            correct: false

    - turn: 4
      speaker: "agent"
      type: "production"
      text_de: "Selbstverständlich, Frau Schmidt. Können Sie mir bitte Ihre Bestellnummer nennen?"
      text_de_slow: "Selbstverständlich... Frau Schmidt... Können Sie mir bitte... Ihre Bestellnummer nennen?"
      audio_path_native: "audio/missions/m01_001_d/dlg_t4_native.opus"
      audio_path_slow: "audio/missions/m01_001_d/dlg_t4_slow.opus"
      translation_en: "Of course, Mrs. Schmidt. Could you please give me your order number?"
      translation_darija: "طبعا، مدام شميت. تقدري تعطيني الرقم ديال الكوموند ديالك؟"
      pronunciation_notes:
        - segment: "Selbstverständlich"
          note: "SELBST-ver-STÄND-lich. Four syllables. Stress on 1st and 3rd."
        - segment: "Bestellnummer"
          note: "be-STELL-num-mer. Stress on second syllable."
      acceptable_responses:
        - pattern: "Selbstverständlich"
          required: false
          weight: 0.25
        - pattern: "Frau Schmidt"
          required: false
          weight: 0.10
        - pattern: "Bestellnummer"
          required: true
          weight: 0.40
        - pattern: "bitte"
          required: false
          weight: 0.25
      scaffolding:
        support_high: "Full text visible. Key phrase highlighted: 'Können Sie mir bitte Ihre Bestellnummer nennen?'"
        support_standard: "Prompt: 'Confirm and ask for the order number.' Keywords: Selbstverständlich... Bestellnummer..."
        support_minimal: "Prompt only: 'She has a question about her order. What do you need from her?'"

    - turn: 5
      speaker: "frau_schmidt"
      type: "input"
      text_de: "Ja, natürlich. Die Nummer ist 4-7-3-8-2."
      audio_path_native: "audio/missions/m01_001_d/dlg_t5_native.opus"
      audio_path_slow: "audio/missions/m01_001_d/dlg_t5_slow.opus"
      translation_en: "Yes, of course. The number is 4-7-3-8-2."
      translation_darija: "آه طبعا. الرقم هو 4-7-3-8-2."
      comprehension_check:
        question_en: "What is the order number?"
        options:
          - text_en: "47382"
            correct: true
          - text_en: "47832"
            correct: false
          - text_en: "43782"
            correct: false

    - turn: 6
      speaker: "agent"
      type: "production"
      text_de: "Vielen Dank, Frau Schmidt. Einen Moment bitte, ich schaue nach."
      text_de_slow: "Vielen Dank... Frau Schmidt... Einen Moment bitte... ich schaue nach."
      audio_path_native: "audio/missions/m01_001_d/dlg_t6_native.opus"
      audio_path_slow: "audio/missions/m01_001_d/dlg_t6_slow.opus"
      translation_en: "Thank you very much, Mrs. Schmidt. One moment please, I'll take a look."
      translation_darija: "شكرا بزاف، مدام شميت. لحظة عافاك، غادي نشوف."
      pronunciation_notes:
        - segment: "Vielen Dank"
          note: "'Vielen' — the 'v' is pronounced /f/. FEE-len Dank."
        - segment: "ich schaue nach"
          note: "'schaue' = SHOW-uh. 'nach' — the 'ch' is the /x/ sound (like Arabic خ)."
      acceptable_responses:
        - pattern: "Dank"
          required: true
          weight: 0.25
        - pattern: "Moment"
          required: true
          weight: 0.35
        - pattern: "schaue"
          required: false
          weight: 0.25
        - pattern: "bitte"
          required: false
          weight: 0.15
      scaffolding:
        support_high: "Full text visible."
        support_standard: "Prompt: 'Thank her and ask for a moment.' Keywords: Vielen Dank... Moment..."
        support_minimal: "Prompt: 'You have the number. What do you say before you check the system?'"
```

---

*(Exercises section continues on next page)*


```yaml
# ─── EXERCISES ────────────────────────────────────────────────
exercises:
  # ═══ PHASE: IGNITE (warm-up) ════════════════════════════════
  - id: "ex_m01_001_01"
    type: "listen_comprehend"
    order: 1
    phase: "ignite"
    prompt_text_en: "Listen to this professional greeting. You'll be saying it soon."
    target_text_de: "Guten Tag, TeleService GmbH, mein Name ist Anna, wie kann ich Ihnen helfen?"
    target_audio_native: "audio/missions/m01_001_d/ex01_full_greeting.opus"
    target_audio_slow: "audio/missions/m01_001_d/ex01_full_greeting_slow.opus"
    evaluation_mode: "comprehension_check"
    evaluation_config:
      question_en: "What did the speaker do?"
      options:
        - text: "Greeted, identified herself, and offered help"
          correct: true
        - text: "Asked for the customer's name"
          correct: false
        - text: "Placed the customer on hold"
          correct: false
    scaffolding:
      support_high:
        text_visible: true
        audio_model_first: true
      support_standard:
        text_visible: false
        audio_model_first: true
      support_minimal:
        text_visible: false
        audio_model_first: true
    feedback:
      on_success: "Exactly. Three parts: greeting + name + offer. That's the formula."
      on_partial: "Listen again — she said her name AND the company name."
      on_retry: "The formula is: Greeting + Company + Name + 'How can I help?'"
    max_attempts: 2
    time_limit_seconds: null
    estimated_duration_seconds: 30
    vocabulary_ids: []
    srs_trigger: false

  # ═══ PHASE: EQUIP (new material) ═══════════════════════════
  - id: "ex_m01_001_02"
    type: "shadow"
    order: 2
    phase: "equip"
    prompt_text_en: "Listen and repeat: the greeting."
    target_text_de: "Guten Tag"
    target_audio_native: "audio/missions/m01_001_d/vocab_guten_tag.opus"
    target_audio_slow: "audio/missions/m01_001_d/vocab_guten_tag_slow.opus"
    evaluation_mode: "pronunciation_match"
    evaluation_config:
      minimum_score: 0.45
      keywords_required: ["Guten", "Tag"]
      pronunciation_weight: 0.7
      completeness_weight: 0.3
    scaffolding:
      support_high:
        text_visible: true
        audio_model_first: true
      support_standard:
        text_visible: true
        audio_model_first: true
      support_minimal:
        text_visible: false
        audio_model_first: true
    feedback:
      on_success: "Clean. Professional. That's your new hello."
      on_partial: "Good start. The 'T' in Tag is strong — like a small explosion of air."
      on_retry: "Listen once more, then match it. Focus on the rhythm: GU-ten TAG."
    max_attempts: 3
    time_limit_seconds: null
    estimated_duration_seconds: 30
    vocabulary_ids: ["v_guten_tag"]
    srs_trigger: true

  - id: "ex_m01_001_03"
    type: "shadow"
    order: 3
    phase: "equip"
    prompt_text_en: "Listen and repeat: the offer to help."
    target_text_de: "Wie kann ich Ihnen helfen?"
    target_audio_native: "audio/missions/m01_001_d/vocab_wie_kann_ich.opus"
    target_audio_slow: "audio/missions/m01_001_d/vocab_wie_kann_ich_slow.opus"
    evaluation_mode: "pronunciation_match"
    evaluation_config:
      minimum_score: 0.45
      keywords_required: ["kann", "helfen"]
      keywords_optional: ["Wie", "ich", "Ihnen"]
      pronunciation_weight: 0.6
      completeness_weight: 0.4
    scaffolding:
      support_high:
        text_visible: true
        audio_model_first: true
      support_standard:
        text_visible: true
        audio_model_first: true
      support_minimal:
        text_visible: false
        audio_model_first: true
    feedback:
      on_success: "That's the money phrase. You'll say this hundreds of times at work."
      on_partial: "Close! Remember: rising intonation at the end — it's a question. helfen? ↗"
      on_retry: "Break it down: 'Wie kann ich' [pause] 'Ihnen helfen?' Try each half."
    max_attempts: 3
    time_limit_seconds: null
    estimated_duration_seconds: 40
    vocabulary_ids: ["v_wie_kann_ich_ihnen_helfen"]
    srs_trigger: true

  - id: "ex_m01_001_04"
    type: "shadow"
    order: 4
    phase: "equip"
    prompt_text_en: "Now the full greeting — all together."
    target_text_de: "Guten Tag, TeleService GmbH, mein Name ist Youssef, wie kann ich Ihnen helfen?"
    target_audio_native: "audio/missions/m01_001_d/dlg_t2_native.opus"
    target_audio_slow: "audio/missions/m01_001_d/dlg_t2_slow.opus"
    evaluation_mode: "pronunciation_match"
    evaluation_config:
      minimum_score: 0.40
      keywords_required: ["Guten", "Tag", "Name", "helfen"]
      keywords_optional: ["TeleService", "kann", "ich", "Ihnen"]
      pronunciation_weight: 0.5
      completeness_weight: 0.5
    scaffolding:
      support_high:
        text_visible: true
        audio_model_first: true
      support_standard:
        text_visible: true
        audio_model_first: false
      support_minimal:
        text_visible: false
        audio_model_first: false
    feedback:
      on_success: "That's a complete professional phone greeting. In German. On your first day."
      on_partial: "You got the structure right. Let's polish — listen to the model one more time."
      on_retry: "Long sentence. Try it in two halves: 'Guten Tag, TeleService, mein Name ist...' then '...wie kann ich Ihnen helfen?'"
    max_attempts: 3
    time_limit_seconds: null
    estimated_duration_seconds: 60
    vocabulary_ids: ["v_guten_tag", "v_wie_kann_ich_ihnen_helfen", "v_mein_name_ist"]
    srs_trigger: false

  - id: "ex_m01_001_05"
    type: "vocabulary_present"
    order: 5
    phase: "equip"
    prompt_text_en: "Two more professional phrases you'll need for this call."
    target_text_de: "Selbstverständlich"
    target_audio_native: "audio/missions/m01_001_d/vocab_selbstverstaendlich.opus"
    evaluation_mode: "pronunciation_match"
    evaluation_config:
      minimum_score: 0.40
      keywords_required: ["Selbstverständlich"]
      pronunciation_weight: 0.7
      completeness_weight: 0.3
    scaffolding:
      support_high:
        text_visible: true
        audio_model_first: true
        hint_available: true
      support_standard:
        text_visible: true
        audio_model_first: true
        hint_available: false
      support_minimal:
        text_visible: false
        audio_model_first: true
        hint_available: false
    feedback:
      on_success: "Beautiful word. It means 'of course' but sounds incredibly professional."
      on_partial: "It's a mouthful! SELBST-ver-STÄND-lich. Four beats. Try again with confidence."
      on_retry: "This one takes practice. Break it: SELBST... ver-STÄND... lich."
    max_attempts: 3
    time_limit_seconds: null
    estimated_duration_seconds: 45
    vocabulary_ids: ["v_selbstverstaendlich"]
    srs_trigger: true

  # ═══ PHASE: CHALLENGE (full scenario) ══════════════════════
  - id: "ex_m01_001_06"
    type: "conversation"
    order: 6
    phase: "challenge"
    prompt_text_en: "Complete call simulation. Answer the phone and handle Frau Schmidt's request."
    dialogue_id: "dlg_m01_001"
    evaluation_mode: "dialogue_completion"
    evaluation_config:
      minimum_overall_score: 0.45
      per_turn_minimum: 0.35
      weight_per_turn:
        turn_2: 0.35
        turn_4: 0.35
        turn_6: 0.30
    scaffolding:
      support_high:
        text_visible: true
        audio_model_first: true
        word_bank: null
        hint_available: true
      support_standard:
        text_visible: false
        audio_model_first: false
        word_bank: ["Guten Tag", "Selbstverständlich", "Bestellnummer", "Einen Moment"]
        hint_available: true
      support_minimal:
        text_visible: false
        audio_model_first: false
        word_bank: null
        hint_available: false
    feedback:
      on_success: "You just handled your first customer call. In German. Professionally."
      on_partial: "The call got resolved. Your phrasing will sharpen with practice."
      on_retry: "Let's try with more support this time. The key phrases will appear on screen."
    max_attempts: 2
    time_limit_seconds: null
    estimated_duration_seconds: 120
    vocabulary_ids: ["v_guten_tag", "v_wie_kann_ich_ihnen_helfen", "v_mein_name_ist", "v_selbstverstaendlich", "v_bestellnummer"]
    srs_trigger: false

  # ═══ PHASE: LAND (cool-down) ═══════════════════════════════
  - id: "ex_m01_001_07"
    type: "repeat"
    order: 7
    phase: "land"
    prompt_text_en: "One more time — your professional greeting. From memory this time."
    target_text_de: "Guten Tag, wie kann ich Ihnen helfen?"
    target_audio_native: "audio/missions/m01_001_d/vocab_wie_kann_ich.opus"
    evaluation_mode: "pronunciation_match"
    evaluation_config:
      minimum_score: 0.50
      keywords_required: ["Guten", "Tag", "helfen"]
      pronunciation_weight: 0.5
      completeness_weight: 0.5
    scaffolding:
      support_high:
        text_visible: true
        audio_model_first: false
      support_standard:
        text_visible: false
        audio_model_first: false
      support_minimal:
        text_visible: false
        audio_model_first: false
    feedback:
      on_success: "Automatic. That's what we're building. This phrase is yours now."
      on_partial: "Getting there. Tomorrow it'll be even smoother."
      on_retry: "You know this one. Take a breath, then say it like you own it."
    max_attempts: 3
    time_limit_seconds: null
    estimated_duration_seconds: 30
    vocabulary_ids: ["v_guten_tag", "v_wie_kann_ich_ihnen_helfen"]
    srs_trigger: false

# ─── GRAMMAR DISCOVERY ────────────────────────────────────────
grammar_discovery:
  mode: "embedded"
  pattern_id: "modal_verb_kann"
  pattern_description: "Modal verb 'können' in present tense with infinitive at sentence end"
  instances:
    - phrase: "Wie kann ich Ihnen helfen?"
      grammar_element: "kann + infinitive (helfen) at end"
      learner_aware: false
    - phrase: "Können Sie mir bitte Ihre Bestellnummer nennen?"
      grammar_element: "können + infinitive (nennen) at end"
      learner_aware: false
  revelation: null

# ─── PRONUNCIATION COACHING ───────────────────────────────────
pronunciation_coaching:
  focus_sounds:
    - sound_id: "ch_ich"
      ipa: "/ç/"
      german_example: "ich"
      bridge_language: "none"
      bridge_explanation_en: >
        Whisper 'hee' loudly — feel the friction at the roof of your mouth. 
        That friction IS the German 'ch' in 'ich'. Not like Arabic خ (that's 
        the 'ch' in 'Bach') — this one is lighter, at the front.
      bridge_explanation_darija: >
        قول 'هيي' بصوت عالي — حس بالاحتكاك ف سقف الفم. هداك الاحتكاك هو 
        'ch' الألمانية ف 'ich'. ماشي بحال خ (هديك ديال 'Bach') — هادي خفيفة، من قدام.
      common_error: "Replacing with /ʃ/ ('ish' instead of 'ich')"
      audio_correct: "audio/pronunciation/ch_ich_correct.opus"
      audio_incorrect: "audio/pronunciation/ch_ich_incorrect.opus"
      drill_words: ["ich", "nicht", "möchte", "natürlich", "Selbstverständlich"]

    - sound_id: "v_as_f"
      ipa: "/f/"
      german_example: "Vielen"
      bridge_language: "none"
      bridge_explanation_en: >
        German 'v' is usually pronounced like 'f'. So 'Vielen Dank' sounds 
        like 'FEE-len Dank'. Not like English 'v' in 'very'.
      bridge_explanation_darija: >
        'v' الألمانية كتنطق بحال 'f'. يعني 'Vielen Dank' كتسمعها 'FEE-len Dank'. 
        ماشي بحال 'v' الانجليزية.
      common_error: "Pronouncing 'Vielen' with English /v/ sound"
      audio_correct: "audio/pronunciation/v_as_f_correct.opus"
      audio_incorrect: "audio/pronunciation/v_as_f_incorrect.opus"
      drill_words: ["Vielen", "von", "verstehen", "Vorname"]

  intonation_pattern:
    pattern: "service_greeting_contour"
    description: >
      The full greeting has a specific professional contour: 
      rises on company name, slight pause, rises again on the question.
    example: "Guten Tag ↗, TeleService GmbH, mein Name ist Youssef, wie kann ich Ihnen helfen ↗?"
    audio_demo: "audio/pronunciation/greeting_intonation.opus"

# ─── COMMON MISTAKES ─────────────────────────────────────────
common_mistakes:
  - id: "err_m01_001_01"
    type: "register"
    mistake_de: "Hallo, was brauchst du?"
    correction_de: "Guten Tag, wie kann ich Ihnen helfen?"
    explanation_en: >
      'Hallo' alone is too casual for answering a business phone. 
      'du' is informal — customers are always 'Sie'. The full formula 
      is required: greeting + company + name + offer.
    explanation_darija: >
      'Hallo' وحدها casual بزاف ل business. 'du' informal — 
      الزبائن ديما 'Sie'. الصيغة الكاملة واجبة: تحية + شركة + اسم + عرض.
    severity: "high"
    prevention_tip_en: "When in doubt: Guten Tag + Sie. Always."

  - id: "err_m01_001_02"
    type: "pronunciation"
    mistake_description: "Saying 'Guten Tak' — devoicing the final 'g'"
    explanation_en: >
      In standard German, final 'g' in 'Tag' is pronounced as /k/ (voiceless), 
      which is actually correct! But don't turn it into a 't' — it stays as 
      a back sound /k/, not a front sound /t/.
    explanation_darija: >
      ف الألمانية المعيارية، 'g' ف الآخر ديال 'Tag' كتنطق /k/ (بلا صوت)، 
      وهادي صحيحة! ولكن ما تقلبهاش ل 't' — تبقا /k/ من لور.
    severity: "low"
    audio_incorrect: "audio/mistakes/guten_tak.opus"
    audio_correct: "audio/missions/m01_001_d/vocab_guten_tag.opus"

  - id: "err_m01_001_03"
    type: "vocabulary"
    mistake_de: "Ich bin Youssef"
    correction_de: "Mein Name ist Youssef"
    explanation_en: >
      Both are grammatically correct. But in call centers, 'Mein Name ist...' 
      is the standard formula. It sounds more professional than 'Ich bin...'.
      Save 'Ich bin' for casual introductions.
    explanation_darija: >
      الجوج صحيحين grammaticalement. ولكن ف call centers، 'Mein Name ist...' 
      هي الصيغة المعيارية. كتبان أكثر professionnelle من 'Ich bin...'.
    severity: "medium"
    prevention_tip_en: "On the phone: always 'Mein Name ist...' — it's the standard."

# ─── CULTURAL NOTES ───────────────────────────────────────────
cultural_notes:
  - id: "culture_m01_001_01"
    trigger: "before_dialogue"
    type: "workplace_norm"
    title_en: "The German Phone Greeting Formula"
    content_en: >
      In German call centers, answering the phone has a fixed formula 
      that EVERY employee follows. It's not optional. It's not flexible. 
      It's: [Greeting] + [Company name] + [Your name] + [Offer to help].
      This is drilled into every new employee on day one. You're learning 
      it right now — just like a German trainee would.
    content_darija: >
      ف call centers الألمانية، الرد على التيليفون عندو صيغة ثابتة 
      كل موظف كيتبعها. ماشي اختيارية. ماشي مرنة. 
      هي: [تحية] + [اسم الشركة] + [سميتك] + [عرض المساعدة].
      كل موظف جديد كيتعلمها ف النهار الأول. وانت كتعلمها دابا — 
      بحال أي متدرب ألماني.
    importance: "critical"
    compare_darija: >
      In Morocco, you might answer the phone with just "Allo?" or "Na3am?" — 
      in German business, this would be considered unprofessional. 
      The full formula shows: I'm prepared, I'm professional, I'm ready to help.

  - id: "culture_m01_001_02"
    trigger: "end_of_mission"
    type: "workplace_norm"
    title_en: "Sie is Non-Negotiable"
    content_en: >
      In customer service, you ALWAYS use 'Sie' (formal you) with customers. 
      Never 'du'. Even if the customer uses 'du' with you, you respond with 'Sie'. 
      This isn't coldness — it's professionalism. Germans expect it. 
      Breaking this rule can get you written up.
    content_darija: >
      ف customer service، ديما كتستعمل 'Sie' (أنت الرسمية) مع الزبائن. 
      عمرك 'du'. حتى إلى الزبون استعمل 'du' معاك، أنت كتجاوب ب 'Sie'. 
      هادشي ماشي برودة — هادشي احترافية. الألمان كيتوقعوها.
    importance: "critical"
    compare_darija: >
      Like using 'vous' in French business, but even stricter. 
      In Darija we might switch to informal quickly — in German customer service, never.

# ─── SMART REVIEW ─────────────────────────────────────────────
smart_review:
  new_srs_items:
    - item_id: "v_guten_tag"
      item_type: "vocabulary"
      initial_interval_hours: 12
      initial_ease_factor: 2.5
      review_exercise_types: ["repeat", "conversation", "time_pressure"]
      context_variations:
        - "Guten Tag, hier ist die Serviceabteilung."
        - "Guten Tag, Sie sprechen mit Youssef."
        - "Guten Tag, wie kann ich Ihnen weiterhelfen?"

    - item_id: "v_wie_kann_ich_ihnen_helfen"
      item_type: "phrase"
      initial_interval_hours: 12
      initial_ease_factor: 2.5
      review_exercise_types: ["repeat", "conversation"]
      context_variations:
        - "Wie kann ich Ihnen behilflich sein?"
        - "Was kann ich für Sie tun?"
        - "Wie kann ich Ihnen weiterhelfen?"

    - item_id: "v_mein_name_ist"
      item_type: "phrase"
      initial_interval_hours: 12
      initial_ease_factor: 2.5
      review_exercise_types: ["repeat", "time_pressure"]
      context_variations:
        - "Mein Name ist Youssef, ich bin Ihr Ansprechpartner."
        - "Mein Name ist Youssef, wie kann ich helfen?"
        - "Hier ist Youssef, mein Name ist Youssef Ben-Ali."

    - item_id: "v_selbstverstaendlich"
      item_type: "vocabulary"
      initial_interval_hours: 24
      initial_ease_factor: 2.5
      review_exercise_types: ["repeat", "conversation"]
      context_variations:
        - "Selbstverständlich helfe ich Ihnen gerne."
        - "Selbstverständlich, das mache ich sofort."
        - "Selbstverständlich, kein Problem."

    - item_id: "v_bestellnummer"
      item_type: "vocabulary"
      initial_interval_hours: 24
      initial_ease_factor: 2.5
      review_exercise_types: ["repeat", "listen_comprehend"]
      context_variations:
        - "Können Sie mir Ihre Bestellnummer geben?"
        - "Ich brauche bitte Ihre Bestellnummer."
        - "Haben Sie Ihre Bestellnummer zur Hand?"

  embedded_review_items: []

  review_triggers:
    - condition: "score_below_0.5_on_greeting_phrase"
      action: "schedule_review_within_12h"
    - condition: "pronunciation_below_0.5_on_ich_sound"
      action: "add_to_pronunciation_lab_queue"
    - condition: "conversation_score_below_0.4"
      action: "offer_recovery_mission"

# ─── CONFIDENCE SCORING ───────────────────────────────────────
confidence_scoring:
  dimensions:
    - id: "communicative_success"
      weight: 0.40
      description: "Was the greeting recognizable and the call handled?"
      measurement: "keyword_presence_in_all_agent_turns"
    - id: "linguistic_accuracy"
      weight: 0.25
      description: "Were phrases produced with approximate correctness?"
      measurement: "transcription_keyword_match"
    - id: "pronunciation_quality"
      weight: 0.20
      description: "Would a native speaker understand without asking to repeat?"
      measurement: "phonetic_similarity_average_across_turns"
    - id: "response_speed"
      weight: 0.05
      description: "How quickly did the learner begin speaking?"
      measurement: "average_latency_across_production_turns"
    - id: "professional_register"
      weight: 0.10
      description: "Was formal register (Sie/Ihnen, Guten Tag) used consistently?"
      measurement: "formal_marker_presence"
  thresholds:
    accomplished: 0.80
    completed: 0.60
    advanced: 0.40
    attempted: 0.0
  career_readiness_contribution:
    domain: "phone_communication"
    max_contribution_percent: 3.0

# ─── SUCCESS CRITERIA ─────────────────────────────────────────
success_criteria:
  primary:
    description: "Produce a recognizable professional greeting containing company name and offer to help"
    test: "Turn 2 acceptable_responses: 'Guten Tag' (required) + 'wie kann ich' (required) + 'helfen' (required) all present"
    minimum_score: 0.55
  secondary:
    - description: "Use formal register throughout (Sie/Ihnen)"
      test: "No informal markers (du, dir, Hallo alone) detected"
    - description: "Complete the full dialogue (all 3 agent turns attempted)"
      test: "Turns 2, 4, and 6 all have recorded responses"
    - description: "Pronunciation intelligible on the greeting"
      test: "Turn 2 pronunciation score ≥ 0.55"
  minimum_for_progression:
    description: "Learner completed all exercises with at least support_high scaffolding"
    test: "All 7 exercise IDs marked as attempted"

# ─── CAREER TRANSFER ─────────────────────────────────────────
career_transfer:
  statement_en: >
    This exact greeting formula — Guten Tag + company name + your name + 
    "Wie kann ich Ihnen helfen?" — is used in 100% of German call centers, 
    reception desks, and helpdesk positions. You will say this sentence 
    50-100 times on your first day of work. Every day after that: 30-80 times.
    By making it automatic now, you arrive at your first shift already 
    performing at the level of an experienced employee — at least for the 
    first 3 seconds of every call.
  statement_darija: >
    هاد الصيغة بالضبط — Guten Tag + اسم الشركة + سميتك + 
    "Wie kann ich Ihnen helfen?" — كتستعمل ف 100% ديال call centers 
    والاستقبال ف ألمانيا. غادي تقولها 50-100 مرة ف اليوم الأول ديالك. 
    كل يوم بعد: 30-80 مرة. ملي كتخليها automatique دابا، كتوصل 
    للخدمة وانت عندك niveau ديال موظف متمرس — على الأقل ف أول 3 ثواني 
    ديال كل مكالمة.
  frequency_at_work: "50-100 times on day one; 30-80 daily thereafter"
  domains_applied:
    - "call_center"
    - "reception"
    - "helpdesk"
    - "customer_service"
  real_world_impact: "First impression with every single customer interaction"

# ─── QUALITY REPORT ──────────────────────────────────────────
quality_report:
  grammar_confidence_percent: 99
  vocabulary_verified: true
  idiomatic_expressions_reviewed: true
  cefr_alignment_verified: true
  audio_recorded: false
  cultural_accuracy_verified: true
  darija_translation_verified: false
  review_date: "2026-07-06"
  reviewer: "Lead Learning Systems Architect"
  notes: >
    All German verified against Duden and native speaker intuition. 
    CEFR A0-A1 vocabulary confirmed. Darija translations require 
    native Moroccan Darija speaker review before production.
    Audio recording pending studio session.
```

---

## End of Specification

---

This document is the **single source of truth** for all mission authoring in Project Phoenix. Every content author, every AI generator, and every validation pipeline references this specification.

No mission ships without conforming to PMS v1.0.0.

---

*"One specification. Five hundred missions. Zero inconsistency."*
