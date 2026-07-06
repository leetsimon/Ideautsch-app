# Phoenix Mission Specification — Part 09: Assessment System

**Specification Version:** 1.0.0  

---

## 1. Assessment Philosophy

Assessment in Phoenix is NOT testing. It is **measurement in service of growth**. The learner never feels "graded." They feel "informed about their progress toward employment."

Key principles:
- Scores are INTERNAL (learner sees outcomes, not numbers)
- Assessment is CONTINUOUS (not end-of-unit tests)
- The ultimate metric is Job Readiness (not lesson completion)
- Assessment drives ADAPTATION (the system adjusts to results)
- There is no failure state. Only "accomplished / completed / advancing / attempted"

---

## 2. Confidence Scoring Schema

```yaml
confidence_scoring:
  dimensions:
    - id: "communicative_success"
      weight: 0.35
      description: "Did the learner communicate the intended meaning?"
      measurement: "keyword_presence + intent_match across all production turns"
      
    - id: "linguistic_accuracy"
      weight: 0.25
      description: "Were grammar, vocabulary, and word order approximately correct?"
      measurement: "transcription_keyword_match + formal_marker_detection"
      
    - id: "pronunciation_quality"
      weight: 0.20
      description: "Would a German native understand without requesting repetition?"
      measurement: "phonetic_similarity_average (MFCC comparison or Vosk confidence)"
      
    - id: "response_speed"
      weight: 0.10
      description: "How quickly did the learner begin speaking after the prompt?"
      measurement: "average_latency_ms across production exercises"
      
    - id: "professional_register"
      weight: 0.10
      description: "Was formality appropriate for the scenario (Sie, Guten Tag, full formulas)?"
      measurement: "formal_marker_count / expected_formal_marker_count"

  thresholds:
    accomplished: 0.80
    completed: 0.60
    advanced: 0.40
    attempted: 0.0

  career_readiness_contribution:
    domain: "phone_communication"
    max_contribution_percent: 3.0
```

---

## 3. Scoring Dimensions — Detailed

### 3.1 Communicative Success (35%)

The most important dimension. "Did the message get across?"

**Measurement method:**
```
For each production turn:
  1. Run speech through Vosk → transcription
  2. Check for required keywords in acceptable_responses
  3. Score = (matched_required / total_required) × weight_allocation

Overall communicative_success = average across all production turns
```

**Tolerance:** A learner who says "Guten Tag, wie kann helfen?" (dropping "ich Ihnen") STILL communicates successfully. Communicative success is lenient on grammar if meaning is clear.

### 3.2 Linguistic Accuracy (25%)

"Was the grammar and vocabulary correct enough for professional use?"

**Measurement method:**
```
For each production turn:
  1. Check all keywords (required + optional) against transcription
  2. Check for word order indicators (verb position)
  3. Check for register markers (Sie/Ihnen vs du/dir)
  4. Score = (matched_total / expected_total)
```

**Important:** This dimension is WEIGHTED LOWER than communicative success. A learner who communicates clearly but imperfectly STILL passes. This prevents perfectionism-induced silence.

### 3.3 Pronunciation Quality (20%)

"Would a native speaker understand without asking 'Wie bitte?'"

**Measurement method:**
```
For each production turn:
  1. Compare Vosk transcription confidence scores per word
  2. Higher Vosk confidence = better pronunciation
  3. Average word-level confidence across the turn
  4. Apply: if average_confidence > 0.7 → good pronunciation
```

**Fallback (if Vosk unavailable):** Duration comparison (utterance length within ±30% of native model = acceptable rhythm).

### 3.4 Response Speed (10%)

"Is recall becoming automatic?"

**Measurement method:**
```
For each production turn:
  latency = time_from_prompt_display to speech_onset

  If latency ≤ 3s: speed_score = 1.0
  If latency 3-5s: speed_score = 0.7
  If latency 5-8s: speed_score = 0.4
  If latency > 8s: speed_score = 0.1
```

**Module adjustment:** Speed scoring is DISABLED in Modules 1-3 (learners need time without pressure). Enabled from Module 4 onward.

### 3.5 Professional Register (10%)

"Is the formality level correct for customer service?"

**Measurement method:**
```
formal_markers_expected = ["Sie", "Ihnen", "Guten Tag", "bitte", "Können"]
informal_markers_detected = ["du", "dir", "Hallo" (alone), "mal", "halt"]

register_score = formal_markers_found / formal_markers_expected
penalty: -0.15 for each informal_marker_detected in customer-facing context
```

---

## 4. Outcome Model

Missions do not "pass" or "fail." They resolve with graduated outcomes:

| Outcome | Score Range | Symbol | Meaning | Effect |
|---------|------------|--------|---------|--------|
| **Accomplished** | ≥ 0.80 | Gold | All objectives met, strong performance | Next mission + stretch challenge offered |
| **Completed** | 0.60 – 0.79 | Silver | Objectives met with room for improvement | Next mission unlocked |
| **Advanced** | 0.40 – 0.59 | Bronze | Partial success, significant gaps | Next mission + targeted review scheduled |
| **Attempted** | < 0.40 | — (no symbol) | Meaningful struggle, effort recognized | Recovery mission offered + gentle retry |

### Outcome Display (What the Learner Sees)

```
[ACCOMPLISHED — Gold]
"You handled that call professionally. Frau Schmidt got what she needed. 
Every required phrase was clear and professional. Moving forward."

[COMPLETED — Silver]
"Call handled. Customer satisfied. A few phrases to polish — 
they'll come back in tomorrow's session for another round."

[ADVANCED — Bronze]  
"You got through it. The key message landed. Some parts need 
more practice — I'm scheduling targeted review."

[ATTEMPTED — no badge]
"That was challenging. You attempted every part — that counts.
Let's approach this from a different angle tomorrow."
```

The learner NEVER sees a percentage or numeric score. They see narrative outcomes.

---

## 5. Success Criteria Schema

```yaml
success_criteria:
  primary:
    description: "Produce a recognizable professional greeting with company name and offer to help"
    test: >
      Agent turn 2: 'Guten Tag' (required, matched) + 
      'wie kann ich' (required, matched) + 'helfen' (required, matched) 
      = all required patterns present
    minimum_score: 0.55
    
  secondary:
    - description: "Maintain formal register throughout (Sie/Ihnen, no du)"
      test: "Zero informal markers detected across all production turns"
    - description: "Complete all three agent turns in the dialogue"
      test: "Turns 2, 4, and 6 all have recorded responses (even if imperfect)"
    - description: "Pronunciation intelligible on greeting phrase"
      test: "Turn 2 pronunciation dimension ≥ 0.55"
      
  minimum_for_progression:
    description: "Learner completed all exercises with at least support_high scaffolding"
    test: "All exercise IDs marked as attempted (response recorded for each)"
```

### Success Criteria Rules

| Rule | Rationale |
|------|-----------|
| Primary criterion tests the learning objective directly | Alignment between objective and assessment |
| Secondary criteria add quality dimensions | Distinguish "good enough" from "excellent" |
| Minimum for progression is ALWAYS achievable | Forward motion guarantee |
| Primary minimum_score is lower than outcome thresholds | Ensures progression even at "advanced" (bronze) |
| No criterion uses grammar labeling or metalinguistic knowledge | Production-only assessment |

---

## 6. Career Readiness Score

### 6.1 Overall Architecture

```
JOB READINESS SCORE (0–100%)
═══════════════════════════════

Composed of domain scores:

  📞 Phone Communication      [25% weight]
  🤝 Customer Handling         [25% weight]
  💬 Professional Language     [20% weight]
  🗣️ Speaking Fluency          [15% weight]
  🎤 Interview Readiness       [15% weight]
```

### 6.2 Per-Mission Contribution

Each mission contributes to ONE career domain:

```yaml
career_readiness_contribution:
  domain: "phone_communication"
  max_contribution_percent: 3.0               # Max this mission can add
  formula: "mission_score × max_contribution_percent"
```

Example: If learner scores 0.75 on a mission contributing max 3.0% to phone_communication:
- Contribution = 0.75 × 3.0 = 2.25% added to phone_communication domain

### 6.3 Domain Score Calculation

```
domain_score = sum(all mission contributions in this domain) / domain_maximum
```

Where `domain_maximum` = sum of all max_contribution_percent for missions in that domain.

### 6.4 Thresholds

| Score Range | Meaning | Displayed Message |
|-------------|---------|-------------------|
| 0–25% | Beginning | "Building your foundation" |
| 25–50% | Developing | "Growing stronger every session" |
| 50–70% | Functional | "Could handle basic calls with some support" |
| 70–85% | Professional | "Job-ready for standard positions" |
| 85–100% | Expert | "Strong candidate for any customer service role" |

### 6.5 The "Ready" Milestone

When Job Readiness reaches 70%, the app delivers a meaningful milestone:

```
"Your Job Readiness Score reached 70%. 

This means: if you applied for a German customer service position today, 
you have the language skills to perform the job.

You started at 0%. You are now professionally functional in German.

This isn't a game score. This is a real assessment of real ability."
```

---

## 7. Career Transfer Statement Schema

```yaml
career_transfer:
  statement_en: >
    This greeting formula — Guten Tag + company name + your name + 
    "Wie kann ich Ihnen helfen?" — is used in 100% of German call centers.
    You will say this sentence 50–100 times on your first day of work.
    By making it automatic now, you arrive at your first shift performing
    at the level of an experienced employee — for the first 3 seconds 
    of every call.
  statement_darija: >
    هاد الصيغة — Guten Tag + اسم الشركة + سميتك + "Wie kann ich Ihnen helfen?" — 
    كتستعمل ف 100% ديال call centers الألمانية. غادي تقولها 50-100 مرة 
    ف النهار الأول. ملي كتخليها automatique دابا، كتوصل للخدمة عندك 
    niveau ديال واحد اللي خدام من زمان — على الأقل ف أول 3 ثواني.
  frequency_at_work: "50-100 times daily"
  domains_applied:
    - "call_center"
    - "reception"
    - "helpdesk"
    - "customer_service"
  real_world_impact: "First impression with every single customer"
```

### Career Transfer Rules

| Rule | Rationale |
|------|-----------|
| Every mission has a career_transfer statement | Non-negotiable career anchoring |
| Must specify FREQUENCY of real-world use | Concrete motivation ("you'll say this 50 times a day") |
| Must name specific job types where this applies | Connects to job search |
| Both English AND Darija versions required | Accessibility |
| Tone: factual, data-based, not motivational platitudes | Adults prefer evidence over cheerleading |
| Maximum 4 sentences in each language | Concise, impactful |

---

## 8. Quality Report Schema

Every mission carries a quality assurance report:

```yaml
quality_report:
  grammar_confidence_percent: 99
  vocabulary_verified: true
  idiomatic_expressions_reviewed: true
  cefr_alignment_verified: true
  audio_recorded: true
  cultural_accuracy_verified: true
  darija_translation_verified: true
  review_date: "2026-07-06"
  reviewer: "Native German speaker + Moroccan Darija speaker"
  notes: "All German verified against Duden. Darija reviewed by Casablanca native."
```

### Quality Report Fields

| Field | Type | Meaning |
|-------|------|---------|
| `grammar_confidence_percent` | 0–100 | How confident are we the German is grammatically correct? |
| `vocabulary_verified` | bool | Has a native speaker confirmed all vocab is natural? |
| `idiomatic_expressions_reviewed` | bool | Do phrases sound like what Germans actually say? |
| `cefr_alignment_verified` | bool | Is content appropriate for the declared CEFR level? |
| `audio_recorded` | bool | Do all audio files exist and pass quality check? |
| `cultural_accuracy_verified` | bool | Have cultural notes been confirmed by someone who lives/works in Germany? |
| `darija_translation_verified` | bool | Has a native Moroccan Darija speaker confirmed translations? |
| `review_date` | ISO date | When was the last quality review? |
| `reviewer` | string | Who performed the review? |
| `notes` | string | Any concerns, flags, or context |

### Production Readiness Gate

A mission is **production-ready** ONLY when:
- `grammar_confidence_percent ≥ 95`
- `vocabulary_verified = true`
- `cefr_alignment_verified = true`
- `audio_recorded = true`

Other fields (cultural, darija) are RECOMMENDED but not blocking.

---

*End of Part 09. Continue to `10_ai_generation_protocol.md` for AI mission generation.*
