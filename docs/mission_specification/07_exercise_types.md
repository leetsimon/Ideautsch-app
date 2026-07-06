# Phoenix Mission Specification — Part 07: Exercise Types

**Specification Version:** 1.0.0  

---

## 1. Exercise Design Philosophy

Exercises are not tests. They are **training events** that build neural pathways for German production. Every exercise must:

- Require the learner to PRODUCE language (≥60% of exercises involve speaking)
- Exist within a professional context (never abstract drills)
- Provide immediate, specific feedback
- Include three scaffolding levels for adaptive delivery
- Be completable in 30–120 seconds

---

## 2. Exercise Type Registry

| Type ID | Name | Primary Skill | Production Required | Typical Duration |
|---------|------|---------------|--------------------|-----------------| 
| `shadow` | Shadow/Echo | Pronunciation, rhythm | Yes (immediate repeat) | 30–60s |
| `repeat` | Prompted Recall | Vocabulary, phrases | Yes (from memory) | 30–60s |
| `listen_comprehend` | Listen & Respond | Listening comprehension | Varies (MCQ or spoken) | 30–90s |
| `vocabulary_present` | Vocabulary Introduction | Vocabulary acquisition | Yes (echo + produce) | 45–60s |
| `conversation` | Multi-turn Dialogue | Speaking, fluency | Yes (role-play) | 90–300s |
| `time_pressure` | Timed Response | Automaticity, speed | Yes (within time limit) | 30–45s |
| `reconstruct` | Sentence Reconstruction | Memory, word order | Yes (full sentence recall) | 45–60s |
| `parallel_tracks` | Register Comparison | Formality awareness | Yes (produce correct register) | 45–60s |
| `rescue` | Error Correction | Metalinguistic awareness | Yes (improve bad example) | 45–60s |
| `dictation` | Number/Address Dictation | Listening precision | Written/typed response | 30–60s |

---

## 3. Common Exercise Schema

All exercise types share this base structure:

```yaml
- id: "ex_m01_001_02"
  type: "shadow"                               # From type registry
  order: 2                                     # Position in mission sequence
  phase: "equip"                               # ignite | equip | challenge | land
  
  # ─── Content ────────────────────────────────────────────────
  prompt_text_en: "Listen and repeat: the professional greeting."
  prompt_text_darija: "سمع وعاود: التحية المهنية."
  target_text_de: "Guten Tag, wie kann ich Ihnen helfen?"
  target_audio_native: "audio/missions/m01_001_d/ex02_native.opus"
  target_audio_slow: "audio/missions/m01_001_d/ex02_slow.opus"
  
  # ─── Evaluation ─────────────────────────────────────────────
  evaluation_mode: "pronunciation_match"
  evaluation_config:
    minimum_score: 0.45
    keywords_required: ["Guten", "Tag", "helfen"]
    keywords_optional: ["kann", "ich", "Ihnen"]
    pronunciation_weight: 0.6
    completeness_weight: 0.4
  
  # ─── Scaffolding ────────────────────────────────────────────
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
  
  # ─── Feedback ───────────────────────────────────────────────
  feedback:
    on_success: "Clean. Professional. That's your new phone greeting."
    on_partial: "Good structure! The ending needs a rising tone — it's a question."
    on_retry: "Listen once more. Focus on the rhythm: GU-ten TAG... wie KANN ich..."
  
  # ─── Configuration ──────────────────────────────────────────
  max_attempts: 3
  time_limit_seconds: null                     # null = no time limit
  estimated_duration_seconds: 45
  vocabulary_ids: ["v_guten_tag", "v_wie_kann_ich_ihnen_helfen"]
  srs_trigger: true                            # Creates/updates SRS item on completion
```

---

## 4. Detailed Type Specifications

### 4.1 SHADOW

**Purpose:** Build motor memory through immediate imitation. The learner hears a model and repeats it within 1–2 seconds.

**Cognitive demand:** Low (imitation, not recall)  
**When used:** Equip phase, pronunciation warm-ups, new phrase introduction

```yaml
type: "shadow"
evaluation_mode: "pronunciation_match"
evaluation_config:
  minimum_score: 0.40                          # Lower threshold (it's imitation)
  keywords_required: [...]                     # Must attempt all key words
  pronunciation_weight: 0.7                    # Pronunciation is primary concern
  completeness_weight: 0.3
```

**Flow:**
1. Audio model plays (native speed)
2. Brief pause (0.5s)
3. Recording indicator appears
4. Learner speaks (repeating what they heard)
5. Recording stops automatically after silence detection
6. Evaluation compares to model
7. Feedback displayed

---

### 4.2 REPEAT (Prompted Recall)

**Purpose:** Test whether the learner can produce a phrase from MEMORY, given a situational prompt.

**Cognitive demand:** Medium (recall from memory, not imitation)  
**When used:** Challenge phase, review exercises, SRS reviews

```yaml
type: "repeat"
evaluation_mode: "pronunciation_match"
evaluation_config:
  minimum_score: 0.50                          # Higher threshold (recall is harder)
  keywords_required: [...]
  pronunciation_weight: 0.5
  completeness_weight: 0.5                     # Completeness matters more than in shadow
```

**Flow:**
1. Situational prompt shown (e.g., "Greet the customer professionally")
2. NO audio model plays (learner must recall)
3. Recording begins
4. Learner produces from memory
5. Evaluation
6. Feedback + model audio plays for comparison

---

### 4.3 LISTEN_COMPREHEND

**Purpose:** Verify the learner understood spoken German. Can involve spoken or tapped responses.

**Cognitive demand:** Medium (parsing real-speed German)  
**When used:** Ignite phase (warm-up), after character input turns

```yaml
type: "listen_comprehend"
evaluation_mode: "comprehension_check"         # or "spoken_response"
evaluation_config:
  # For multiple choice:
  question_en: "What did the customer ask about?"
  question_darija: "على شنو سول الزبون؟"
  options:
    - text_en: "Their order status"
      correct: true
    - text_en: "A price change"
      correct: false
    - text_en: "A new subscription"
      correct: false
  # For spoken response:
  # expected_response_keywords: ["Bestellung", "Status"]
  # minimum_score: 0.5
```

**Variants:**
| Variant | Response Type | Module Range |
|---------|--------------|--------------|
| Multiple choice | Tap correct option | 1–6 (early modules) |
| Spoken gist | Say in German what they understood | 5–12 (mid/advanced) |
| Action | Type number/address they heard | 4–12 (data extraction) |

---

### 4.4 VOCABULARY_PRESENT

**Purpose:** Introduce a new vocabulary item through the hear → shadow → produce cycle.

**Cognitive demand:** Low → Medium (progresses within the exercise)  
**When used:** Equip phase (2–5 per mission for new items)

```yaml
type: "vocabulary_present"
evaluation_mode: "pronunciation_match"
evaluation_config:
  minimum_score: 0.40
  keywords_required: ["Selbstverständlich"]
  pronunciation_weight: 0.7
  completeness_weight: 0.3
```

**Internal Flow (within single exercise):**
1. Audio plays (native, with context sentence)
2. Translation briefly appears (English + Darija)
3. Audio plays again (slow, isolated chunk)
4. Learner shadows (immediate repeat)
5. Brief pause
6. Prompt: use it in context
7. Learner produces independently
8. Feedback

---

### 4.5 CONVERSATION

**Purpose:** Multi-turn dialogue simulation. The core exercise type for speaking practice.

**Cognitive demand:** High (sustained production, real-time responses)  
**When used:** Challenge phase (the peak of every mission)

```yaml
type: "conversation"
evaluation_mode: "dialogue_completion"
evaluation_config:
  dialogue_id: "dlg_m01_001_d"
  minimum_overall_score: 0.45
  per_turn_minimum: 0.35
  weight_per_turn:
    turn_2: 0.35
    turn_4: 0.35
    turn_6: 0.30
```

**Flow:**
1. Narration sets the scene
2. Character speaks (audio plays)
3. Learner responds (production turn)
4. Immediate per-turn feedback (brief)
5. Next turn begins
6. Continues until dialogue complete
7. Overall debrief at end

---

### 4.6 TIME_PRESSURE

**Purpose:** Build automaticity by requiring production within a time constraint.

**Cognitive demand:** High (speed + accuracy)  
**When used:** Challenge/Land phases (Modules 5+), SRS reviews (when items should be automatic)

```yaml
type: "time_pressure"
evaluation_mode: "pronunciation_match"
evaluation_config:
  minimum_score: 0.50
  keywords_required: [...]
  pronunciation_weight: 0.4
  completeness_weight: 0.4
  speed_weight: 0.2                            # Bonus for fast response
time_limit_seconds: 5                          # Must begin speaking within 5 seconds
```

**Flow:**
1. Situational prompt appears
2. Timer starts (visible countdown)
3. Learner must begin speaking before timer expires
4. If timer expires: feedback ("In a real call, the customer is waiting. Try to respond faster.")
5. If answered in time: speed bonus applied to score

**Time Limits by Module:**
| Module Range | Time Limit | Rationale |
|-------------|-----------|-----------|
| 5–6 | 8 seconds | Generous — building awareness |
| 7–8 | 6 seconds | Moderate pressure |
| 9–10 | 5 seconds | Professional speed expected |
| 11–12 | 4 seconds | Near-native response time |

---

### 4.7 RECONSTRUCT

**Purpose:** Hear a sentence, hold it in memory, then reproduce it fully. Tests working memory + production.

**Cognitive demand:** High (memory load + production)  
**When used:** Equip/Challenge phases for grammar pattern absorption

```yaml
type: "reconstruct"
evaluation_mode: "pronunciation_match"
evaluation_config:
  minimum_score: 0.50
  keywords_required: ["Bestellung", "überprüfen", "sofort"]
  keywords_optional: ["Ihre", "ich", "werde"]
  pronunciation_weight: 0.4
  completeness_weight: 0.6                     # Completeness is primary
```

**Flow:**
1. Full sentence audio plays (native speed)
2. 3-second pause (text NOT shown)
3. Prompt: "Now say it back. As much as you remember."
4. Learner speaks
5. Evaluation shows what they got + what they missed
6. Full sentence plays again (reinforcement)
7. Optional: learner tries once more

---

### 4.8 PARALLEL_TRACKS

**Purpose:** Train register awareness. Learner hears/sees both formal and informal versions, then produces the CORRECT register for the situation.

**Cognitive demand:** Medium-High (register selection + production)  
**When used:** From Module 5 onward (after formal register is established)

```yaml
type: "parallel_tracks"
evaluation_mode: "register_match"
evaluation_config:
  expected_register: "formal"
  formal_version: "Ich werde das umgehend für Sie prüfen."
  informal_version: "Ich schau mal schnell nach."
  keywords_required_formal: ["werde", "umgehend", "prüfen", "Sie"]
  keywords_informal_markers: ["schau", "mal", "schnell"]  # These should be ABSENT
  minimum_score: 0.55
```

**Flow:**
1. Show both versions (formal + informal) with labels
2. Set the scene: "A customer is waiting. Which register?"
3. Learner produces the FORMAL version
4. Evaluation checks for formal markers (and absence of informal markers)
5. Feedback highlights the difference

---

### 4.9 RESCUE

**Purpose:** Hear a BAD response (from "Amir," the fellow trainee) and produce an IMPROVED version. Trains metalinguistic awareness without direct personal correction.

**Cognitive demand:** Medium-High (error detection + correction + production)  
**When used:** Practice/Challenge phases (Module 3+)

```yaml
type: "rescue"
evaluation_mode: "pronunciation_match"
evaluation_config:
  minimum_score: 0.50
  keywords_required: ["Entschuldigung", "Moment", "nachschauen"]
  keywords_forbidden: ["ähm", "weiß nicht", "vielleicht"]  # Markers from the BAD version
  pronunciation_weight: 0.4
  completeness_weight: 0.6
```

**Flow:**
1. Context: "Amir responded to the customer like this:"
2. Bad audio plays: "Ähm... ich weiß nicht... vielleicht kann ich... äh..."
3. Prompt: "That was too uncertain. How should it sound professionally?"
4. Learner produces improved version
5. Model answer plays for comparison
6. Feedback: what was better, why it matters professionally

---

### 4.10 DICTATION

**Purpose:** Hear German speech (numbers, addresses, names) and type what was heard. Critical for call center work.

**Cognitive demand:** Medium (listening precision + writing)  
**When used:** Modules 4+ (when phone scenarios begin)

```yaml
type: "dictation"
evaluation_mode: "text_match"
evaluation_config:
  expected_text: "47382"                       # or full address, name, etc.
  allow_formatting_variants: true              # "4 7 3 8 2" = "47382"
  minimum_accuracy: 0.8                        # 80% character accuracy
```

**Dictation Subtypes:**
| Subtype | Content | Module |
|---------|---------|--------|
| Number dictation | Order numbers, phone numbers | 4+ |
| Address dictation | German street addresses | 5+ |
| Name spelling | German names spelled out | 4+ |
| Email dictation | Email addresses | 6+ |
| Date dictation | Dates in German format | 4+ |

---

## 5. Phase Assignment Rules

| Phase | Purpose | Exercise Types Typical | Support Level |
|-------|---------|----------------------|---------------|
| `ignite` | Warm-up, activate German mode | shadow, listen_comprehend | Minimal (familiar material) |
| `equip` | Introduce new material | shadow, vocabulary_present, reconstruct | High → Standard |
| `challenge` | Full scenario application | conversation, time_pressure, parallel_tracks | Standard → Minimal |
| `land` | Cool-down, consolidation | repeat, shadow | Standard (end on success) |

### Phase Distribution (Exercises per Phase)

| Phase | Exercises | Time Allocation |
|-------|-----------|----------------|
| Ignite | 1–2 | ~2 minutes |
| Equip | 2–4 | ~5 minutes |
| Challenge | 1–2 (but longer) | ~6 minutes |
| Land | 1–2 | ~2 minutes |

---

## 6. Evaluation Modes

| Mode | Used By | How It Works |
|------|---------|-------------|
| `pronunciation_match` | shadow, repeat, vocabulary_present, reconstruct, time_pressure | Compare transcription to expected keywords + phonetic scoring |
| `comprehension_check` | listen_comprehend | Multiple choice or keyword detection in spoken response |
| `dialogue_completion` | conversation | Aggregate of per-turn acceptable_response matching |
| `register_match` | parallel_tracks | Check for expected register markers + absence of wrong register |
| `text_match` | dictation | Character-by-character comparison of typed response |
| `error_detection` | rescue | Check that forbidden keywords are absent + required present |

---

## 7. Feedback Language Standards

### 7.1 Approved Feedback Tones

| Context | Tone | Example |
|---------|------|---------|
| Success | Brief, specific, warm | "Clean. That's professional quality." |
| Partial | Acknowledge + guide | "Right structure! Polish the ending — it's a question, so rise ↗" |
| Retry | Normalize + support | "Long sentence. Try the first half alone: 'Guten Tag, TeleService...'" |

### 7.2 Forbidden Feedback Patterns

| Never Say | Why | Replace With |
|-----------|-----|--------------|
| "Wrong!" / "Incorrect!" | Shaming | "Not quite — listen to the difference:" |
| "Try harder" | Implies insufficient effort | "Try once more — focus on [specific element]" |
| "Good job!" (generic) | Empty, erodes trust | [Specific acknowledgment of what was good] |
| "You failed this exercise" | Binary failure framing | "Let's come back to this one. It'll click." |
| "That was easy, right?" | Invalidates if it wasn't | (Say nothing about difficulty) |

---

## 8. Ordering Rules Within a Mission

1. Every mission begins with 1–2 `ignite` exercises using KNOWN material
2. `equip` exercises follow, introducing 3–5 NEW items via shadow + vocabulary_present
3. `challenge` exercises use ALL material (new + review) in a full scenario
4. `land` exercises end the session with 1–2 consolidation exercises
5. Speaking exercises are never back-to-back with identical types
6. Every 3rd exercise should use a DIFFERENT type (variety rule)
7. The LAST exercise of every mission is always something the learner can succeed at
8. Difficulty NEVER decreases within a phase (only increases or stays flat)

---

*End of Part 07. Continue to `08_grammar_pronunciation.md` for grammar discovery and pronunciation coaching.*
