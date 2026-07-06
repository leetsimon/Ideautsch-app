# Phoenix Mission Specification — Part 06: Dialogue System

**Specification Version:** 1.0.0  

---

## 1. Dialogue Philosophy

Dialogues are not "listening exercises with gaps." They are **simulated professional interactions** where the learner IS one of the participants. Every dialogue:

- Has a real-world purpose (handle a customer, answer a question, resolve an issue)
- Requires the learner to PRODUCE German speech (not just listen)
- Escalates in difficulty within its turns
- Uses characters from the official registry (Part 04)
- Includes full scaffolding at three support levels

### The Production Ratio Rule

In every dialogue, the learner speaks ≥50% of the total turns. A 6-turn dialogue has at minimum 3 agent (learner) turns.

---

## 2. Dialogue Schema

```yaml
dialogue:
  id: "dlg_m01_001"
  context: "First customer call — Frau Schmidt asks about her order"
  total_turns: 6
  estimated_duration_seconds: 90
  
  turns:
    - turn: 1
      speaker: "system"
      type: "narration"
      text_en: "Your headset beeps. Incoming call. Answer professionally."
      audio_path: "audio/missions/m01_001_d/phone_ring.opus"
      
    - turn: 2
      speaker: "agent"
      type: "production"
      text_de: "Guten Tag, TeleService GmbH, mein Name ist Youssef, wie kann ich Ihnen helfen?"
      text_de_slow: "Guten Tag... TeleService GmbH... mein Name ist Youssef... wie kann ich Ihnen helfen?"
      audio_path_native: "audio/missions/m01_001_d/dlg_t2_native.opus"
      audio_path_slow: "audio/missions/m01_001_d/dlg_t2_slow.opus"
      translation_en: "Good day, TeleService GmbH, my name is Youssef, how can I help you?"
      translation_darija: "نهار مبروك، تيلي سيرفيس، سميتي يوسف، كيفاش نقدر نعاونكم؟"
      pronunciation_notes:
        - segment: "Guten Tag"
          note: "Stress on GU-ten. Final 'g' in Tag = /k/."
        - segment: "Ihnen helfen"
          note: "'Ihnen' — 'h' is silent, vowel is long /iː/. Rising intonation on helfen? (question)."
      acceptable_responses:
        - pattern: "Guten Tag"
          required: true
          weight: 0.25
        - pattern: "wie kann ich"
          required: true
          weight: 0.30
        - pattern: "helfen"
          required: true
          weight: 0.30
        - pattern: "Name"
          required: false
          weight: 0.15
      scaffolding:
        support_high:
          description: "Full text visible. Audio model plays first. Learner repeats."
          text_visible: true
          audio_model_first: true
          word_bank: null
          hint_available: true
        support_standard:
          description: "First word of each segment visible as prompt."
          text_visible: false
          first_words_visible: true
          audio_model_first: false
          word_bank: null
          hint_available: true
        support_minimal:
          description: "Situation prompt only. Free production."
          text_visible: false
          first_words_visible: false
          audio_model_first: false
          word_bank: null
          hint_available: false
      
    - turn: 3
      speaker: "frau_schmidt"
      type: "input"
      text_de: "Guten Tag! Hier ist Schmidt. Ich habe eine Frage zu meiner Bestellung."
      audio_path_native: "audio/missions/m01_001_d/dlg_t3_native.opus"
      audio_path_slow: "audio/missions/m01_001_d/dlg_t3_slow.opus"
      translation_en: "Good day! This is Schmidt. I have a question about my order."
      translation_darija: "نهار مبروك! أنا شميت. عندي سؤال على الكوموند ديالي."
      comprehension_check:
        type: "multiple_choice"
        question_en: "What does Frau Schmidt need?"
        question_darija: "شنو بغات مدام شميت؟"
        options:
          - text_en: "She has a question about her order"
            correct: true
          - text_en: "She wants to make a complaint"
            correct: false
          - text_en: "She wants to cancel her account"
            correct: false
```

---

## 3. Turn Types

| Type | Speaker | What Happens | Learner Action |
|------|---------|-------------|----------------|
| `narration` | system | Stage direction, scene setting | Reads/listens (no production) |
| `production` | agent | Learner must speak this turn | Speaks (recorded + evaluated) |
| `input` | character | Character speaks, learner listens | Listens (optional comprehension check) |

---

## 4. Acceptable Responses Specification

For every `production` turn, the system must evaluate what the learner said. Since this is offline (no cloud AI), evaluation uses **keyword pattern matching** with weighted scoring.

### 4.1 Pattern Structure

```yaml
acceptable_responses:
  - pattern: "Guten Tag"                     # Text to detect in transcription
    required: true                           # Must be present for "accomplished"
    weight: 0.25                             # Contribution to turn score (sum = 1.0)
  - pattern: "wie kann ich"
    required: true
    weight: 0.30
  - pattern: "helfen"
    required: true
    weight: 0.30
  - pattern: "Name"
    required: false
    weight: 0.15
```

### 4.2 Scoring Rules

```
Turn Score = Σ(matched_pattern.weight) for all patterns matched

If all required patterns matched AND score ≥ 0.60:
  → Turn outcome: SUCCESS

If all required patterns matched AND score < 0.60:
  → Turn outcome: PARTIAL (correct but incomplete)

If any required pattern missing:
  → Turn outcome: RETRY (offer another attempt with more support)
```

### 4.3 Pattern Matching Tolerance

| Feature | Tolerance |
|---------|-----------|
| Case sensitivity | Case-insensitive matching |
| Word order | Flexible (patterns can appear in any order) |
| Extra words | Allowed (learner can add words not in patterns) |
| Pronunciation variants | Vosk transcription handles phonetic variants |
| Partial matches | "helf" matches "helfen" (stem matching enabled) |
| Formal/informal markers | "Ihnen" and "dir" both match "helfen" pattern but formal scores higher |

---

## 5. Scaffolding System (Three Levels)

Every production turn provides three distinct support levels. The adaptive engine selects which level to present based on learner performance history.

### 5.1 Support High (Maximum Assistance)

- Full German text visible on screen
- Audio model plays BEFORE learner speaks
- Hints available on request
- Word bank may be present
- Learner essentially reads and imitates

**When used:** First encounter with material, after 2+ failed attempts, Recovery missions

### 5.2 Support Standard (Moderate Assistance)

- No full text visible
- First word of each phrase segment shown (e.g., "Guten... TeleService... mein... wie...")
- Audio model NOT automatically played (available on tap)
- Hints available on first request
- Learner recalls with prompts

**When used:** Default for new material after initial shadow, Practice missions

### 5.3 Support Minimal (No Assistance)

- No text visible
- No audio model
- Situational prompt only (e.g., "The customer has a question. Ask for the order number.")
- No hints
- Learner produces from memory and communicative intent

**When used:** Challenge missions, Simulation missions, end-of-mission exercises

### 5.4 Scaffold Degradation Rule

Within a single mission, scaffolding ALWAYS degrades from high to minimal:

```
Exercise 1-2 (Equip phase):     support_high
Exercise 3-4 (Equip → Challenge): support_standard  
Exercise 5-6 (Challenge phase):   support_standard → support_minimal
Exercise 7 (Land phase):         support_minimal (if mission is going well)
                                  support_standard (if learner struggled)
```

---

## 6. Comprehension Checks

When a character speaks (type: `input`), an optional comprehension check can verify the learner understood:

```yaml
comprehension_check:
  type: "multiple_choice"                    # multiple_choice | spoken_response | action
  question_en: "What does the customer want?"
  question_darija: "شنو بغا الزبون؟"
  options:
    - text_en: "Help with an order"
      correct: true
    - text_en: "To file a complaint"
      correct: false
    - text_en: "To change their address"
      correct: false
```

### Comprehension Check Types

| Type | Description | When Used |
|------|-------------|-----------|
| `multiple_choice` | Select correct interpretation from options | Early modules (A0–A1) |
| `spoken_response` | Respond verbally to what was heard | Mid modules (A2) — tests listening + production |
| `action` | Perform an action based on what was heard (e.g., "type the number they said") | Advanced listening (A2–B1) |

### Rules

- Maximum 1 comprehension check per 2 input turns (don't over-test listening)
- Checks test GIST, not word-for-word recall
- Incorrect answers never punish — they trigger a replay of the audio
- Check is optional (can be null) for turns where meaning is obvious

---

## 7. Pronunciation Notes Standard

Every agent production turn includes pronunciation coaching notes:

```yaml
pronunciation_notes:
  - segment: "Selbstverständlich"
    note: "SELBST-ver-STÄND-lich. Four syllables. Primary stress on 1st, secondary on 3rd."
  - segment: "Bestellnummer"
    note: "be-STELL-num-mer. Compound word. Primary stress on second syllable."
```

### Rules for Pronunciation Notes

| Rule | Rationale |
|------|-----------|
| Maximum 3 notes per turn | Don't overwhelm with corrections |
| Focus on the HARDEST segment for Arabic/French speakers | Targeted, not generic |
| Always include stress pattern | Stress errors reduce intelligibility most |
| Mention phonetic bridges where applicable | "The 'ch' in 'ich' — like a whispered 'hee'" |
| Use CAPS for stressed syllables in the note | Visual stress indication |
| Note intonation for questions | Rising/falling critical for meaning |

---

## 8. Dialogue Construction Rules

| Rule | Constraint |
|------|-----------|
| Maximum 8 turns total | Cognitive load management |
| Minimum 4 turns | Enough for meaningful interaction |
| Agent speaks ≥ 50% of dialogue turns (excluding narration) | Speaking-first |
| Narration turns count toward total but not toward production ratio | Keep narration minimal |
| Difficulty increases across turns | Early turns easier, final turns hardest |
| Last agent turn is always the most challenging | Ends on peak production |
| Character stays in-character (mood, pace, register) throughout | Authenticity |
| Audio paths are required for ALL non-system turns | Complete audio coverage |
| Both native AND slow audio required for all turns | Supports listening progression |
| Translations required for ALL turns (English + Darija) | Comprehension safety net |

---

## 9. Dialogue Difficulty Progression

Within a single dialogue, difficulty progresses:

| Turn Position | Scaffolding Level | Content Difficulty |
|--------------|-------------------|-------------------|
| Agent Turn 1 | Can be high/standard | Formulaic (greeting, identification) |
| Agent Turn 2 | Standard | Semi-formulaic (acknowledgment + question) |
| Agent Turn 3+ | Standard → Minimal | More creative (problem-solving, novel responses) |

### Example Progression (6-turn dialogue)

```
Turn 1 (system): "Phone rings. Answer it."
Turn 2 (agent, easy): Greeting formula — highly practiced, formulaic
Turn 3 (customer): Describes problem — learner listens
Turn 4 (agent, medium): Acknowledge + ask for info — semi-formulaic
Turn 5 (customer): Provides info — learner listens + extracts data
Turn 6 (agent, hard): Confirm + promise action — requires construction
```

---

## 10. Audio Specifications for Dialogues

### 10.1 Recording Requirements

| Attribute | Specification |
|-----------|---------------|
| Format | Opus in OGG container |
| Sample rate | 48 kHz |
| Bitrate | 64 kbps (dialogue), 48 kbps (vocabulary) |
| Channels | Mono |
| Noise floor | ≤ -60 dB (studio silence) |
| Peak level | -3 dB to -1 dB (normalized) |
| Encoding | libopus encoder, VBR mode |

### 10.2 Native vs. Slow Audio

| Version | Pace | Use |
|---------|------|-----|
| `audio_path_native` | Natural conversational speed (~130–160 wpm German) | Default playback, target for learner |
| `audio_path_slow` | 70–80% of natural speed, clear articulation, pauses between phrases | Learning mode, available on request |

### 10.3 Character Voice Consistency

Each character has a consistent voice actor across ALL missions:

| Character | Voice Characteristics |
|-----------|---------------------|
| Frau Schmidt | Female, 60+, warm, clear, slow-ish, Berlin-neutral accent |
| Herr Weber | Male, 45–55, gruff, fast, slightly clipped, standard German |
| Frau Müller | Female, 35–40, professional, moderate pace, encouraging |
| Thomas | Male, 28–32, casual, natural pace, slight regional color |
| Amir | Male, 25–30, slight non-native accent (intentional), moderate |
| Dr. Hoffmann | Male, 50+, precise, formal, fast, academic diction |

---

## 11. Dialogue ID Convention

```
dlg_{mission_id}[_{variant}]

Examples:
  dlg_m01_001_d              — Main dialogue for mission m01_001_d
  dlg_m05_008_d_retry        — Retry variant with more support
  dlg_m07_003_s_branch_a     — Branch A of a simulation dialogue
```

---

*End of Part 06. Continue to `07_exercise_types.md` for the complete exercise specification.*
