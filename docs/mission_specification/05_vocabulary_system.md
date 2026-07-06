# Phoenix Mission Specification — Part 05: Vocabulary System

**Specification Version:** 1.0.0  

---

## 1. Core Philosophy: Chunks, Not Words

Project Phoenix does not teach "vocabulary" in the traditional sense. We teach **communicative chunks** — the smallest usable unit of language that accomplishes something in the real world.

| Traditional App | Phoenix |
|----------------|---------|
| Teaches: "helfen" (to help) | Teaches: "Wie kann ich Ihnen helfen?" |
| Teaches: "Bestellung" (order) | Teaches: "Ihre Bestellnummer, bitte" |
| Teaches: "sofort" (immediately) | Teaches: "Ich kümmere mich sofort darum" |
| Result: Learner knows words | Result: Learner can SAY things that WORK |

### Why Chunks Win

1. **Retrieval speed:** A memorized chunk is retrieved as one unit (200ms). Assembled word-by-word production takes 1–3 seconds per word.
2. **Grammar for free:** "Wie kann ich Ihnen helfen?" teaches modal verbs, word order, dative case — without any grammar explanation.
3. **Professional sound:** Real professionals speak in formulas. Call center agents use the SAME phrases thousands of times. Chunks mirror reality.
4. **Working memory relief:** A chunk occupies 1 slot in working memory. Individual words occupy 5–7 slots for the same content.

---

## 2. Vocabulary Schema

```yaml
vocabulary:
  # ─── Core ───────────────────────────────────────────────────
  # Items that MUST be taught in this mission (3–5 items max)
  core:
    - id: "v_guten_tag"
      chunk_phrase: "Guten Tag"
      literal_meaning: "Good day"
      functional_meaning: >
        Professional greeting used any time of day in business contexts.
        The standard opening for all customer service interactions.
      translation_en: "Good day (formal hello)"
      translation_darija: "نهاركم مبروك (رسمي)"
      translation_fr: "Bonjour (formel)"
      ipa: "/ˈɡuːtən taːk/"
      audio_path: "audio/missions/m01_001_d/vocab_guten_tag.opus"
      part_of_speech: "phrase"
      article: null                            # Only for nouns
      register: "formal"
      frequency_rank: 1
      domain: "greeting"
      cluster: "openers"
      
      example_in_context:
        de: "Guten Tag, TeleService GmbH, mein Name ist Youssef."
        en: "Good day, TeleService GmbH, my name is Youssef."
        darija: "نهار مبروك، تيلي سيرفيس، سميتي يوسف."
        audio_path: "audio/missions/m01_001_d/example_guten_tag.opus"
      
      common_errors:
        - error: "Guten Tak"
          correction: "Tag — final 'g' is /k/ (voiceless velar), not /t/ (voiceless alveolar)"
          source: "Arabic speakers often substitute /t/ for final /k/"
        - error: "Gutn Tag"
          correction: "Gu-TEN — the '-en' is a full syllable, not swallowed"
          source: "Fast speech reduction (acceptable later, but learn the full form first)"
      
      phonetic_bridge:
        language: "french"
        bridge: "Like saying 'Bonjour' — same social function, same formality level"
      
      srs_config:
        initial_interval_hours: 12
        initial_ease_factor: 2.5
        review_exercise_types: ["repeat", "conversation", "time_pressure"]
        context_variations:
          - "Guten Tag, hier ist die Serviceabteilung."
          - "Guten Tag, Sie sprechen mit Youssef Ben-Ali."
          - "Guten Tag, wie kann ich Ihnen weiterhelfen?"
  
  # ─── Supporting ─────────────────────────────────────────────
  # Items used in exercises but not the primary teaching focus
  supporting:
    - id: "v_bitte"
      chunk_phrase: "bitte"
      functional_meaning: "Politeness marker — makes any request professional"
      translation_en: "please"
      translation_darija: "عافاك"
      audio_path: "audio/vocab/common/bitte.opus"
      register: "universal"
      # ... (same structure as core, abbreviated here)
  
  # ─── Review ─────────────────────────────────────────────────
  # Previously learned items that appear in this mission for embedded review
  review:
    - id: "v_entschuldigung"                   # References an existing vocabulary entry
      review_context: "Used when interrupting the customer to ask for information"
      appears_in_exercise: "ex_m01_003_06"
```

---

## 3. Vocabulary Field Reference

### 3.1 Required Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique ID following format `v_{keyword}` |
| `chunk_phrase` | string | Yes | The phrase as taught (never isolated word unless truly atomic) |
| `functional_meaning` | string | Yes | What this phrase DOES in communication |
| `translation_en` | string | Yes | Natural English equivalent |
| `translation_darija` | string | Yes | Natural Moroccan Darija equivalent |
| `ipa` | string | Yes | IPA transcription of the chunk |
| `audio_path` | string | Yes | Path to native speaker recording |
| `register` | enum | Yes | `formal` / `informal` / `neutral` / `universal` |
| `domain` | string | Yes | Career domain this belongs to |
| `cluster` | string | Yes | Tactical cluster (see §5) |
| `example_in_context` | object | Yes | Full sentence showing the phrase in use |
| `srs_config` | object | Yes | Spaced repetition scheduling parameters |

### 3.2 Optional Fields

| Field | Type | When Used |
|-------|------|-----------|
| `literal_meaning` | string | When literal meaning aids understanding |
| `translation_fr` | string | When French cognate exists or aids understanding |
| `article` | enum | For nouns: `der` / `die` / `das` |
| `part_of_speech` | string | `phrase` / `noun` / `verb` / `adjective` / `adverb` / `noun_phrase` |
| `frequency_rank` | integer | Position in project-wide frequency list (1 = most common) |
| `common_errors` | list | Errors specific to Moroccan/Arabic speakers |
| `phonetic_bridge` | object | L1 sound connection |

---

## 4. Vocabulary Item Limits

| Mission Type | Core Items (max) | Supporting Items (max) | Review Items (recommended) |
|-------------|-----------------|----------------------|---------------------------|
| Discovery | 5 | 3 | 3–5 |
| Practice | 3 | 2 | 5–8 |
| Challenge | 0 | 0 | 8–12 |
| Simulation | 2 | 2 | 10–15 |
| Recovery | 0 | 0 | 5–8 |

**Rationale:** Each core item requires ~60 seconds of teaching time. More than 5 per 12-minute session leaves insufficient time for the challenge phase.

---

## 5. Tactical Clusters

Vocabulary is organized by communicative purpose — what the phrase DOES in a professional interaction:

### 5.1 Cluster Registry

| Cluster ID | Name | Function | Example Phrases |
|-----------|------|----------|-----------------|
| `openers` | Openers | Start professional interactions | Guten Tag; Mein Name ist...; TeleService GmbH |
| `bridges` | Bridges | Buy thinking time | Einen Moment bitte; Ich schaue kurz nach; Lassen Sie mich prüfen |
| `shields` | Shields | Handle not understanding | Können Sie das bitte wiederholen?; Etwas langsamer, bitte |
| `empathy` | Empathy Bombs | De-escalate, show understanding | Ich verstehe Ihre Frustration; Das tut mir sehr leid |
| `actions` | Action Verbs | Describe what you're doing | Ich prüfe das; Ich notiere mir das; Ich verbinde Sie |
| `confirmers` | Confirmers | Verify information | Ich wiederhole: ...; Habe ich das richtig verstanden? |
| `closers` | Closers | End interactions professionally | Kann ich sonst noch etwas tun?; Schönen Tag noch |
| `rescue` | Rescue Kit | Emergency fallbacks | Ich verbinde Sie mit einem Kollegen; Ich rufe Sie zurück |
| `affirmers` | Affirmers | Confirm willingness to help | Selbstverständlich; Gerne; Kein Problem; Das mache ich sofort |
| `deniers` | Professional No | Decline politely within policy | Leider ist das nicht möglich; Ich kann Ihnen alternativ anbieten |
| `quantifiers` | Numbers & Data | Amounts, dates, IDs | Ihre Bestellnummer; Das Datum ist...; Der Betrag beträgt... |
| `transitions` | Transitions | Move between topics | Außerdem möchte ich...; Bezüglich Ihrer Frage...; Darüber hinaus |
| `fillers` | Professional Fillers | Fill silence without "ähm" | Also; Genau; Richtig; Moment, ich schaue... |

### 5.2 Cluster Assignment Rules

| Rule | Rationale |
|------|-----------|
| Every vocabulary item belongs to exactly ONE cluster | Clean categorization |
| Cluster determines review exercise type preferences | "Openers" drill speed; "Empathy" drills emotional register |
| Emergency clusters (`shields`, `rescue`) are taught early (Module 1–3) | Survival vocabulary first |
| Professional clusters (`deniers`, `transitions`) appear from Module 6+ | Require foundation first |

---

## 6. Vocabulary Verification Standards

All German vocabulary is verified against authoritative sources before production:

### 6.1 Primary References

| Source | Authority | Verified Against |
|--------|-----------|-----------------|
| **Duden Online** (duden.de) | Official German orthography and grammar | Spelling, gender, plural forms, hyphenation |
| **DWDS** (dwds.de) | Berlin-Brandenburg Academy of Sciences | Frequency data, usage examples, collocations |
| **PONS** (pons.com) | Professional bilingual dictionaries | Translations (DE↔EN, DE↔FR) |
| **Goethe-Institut Wortlisten** | Official CEFR vocabulary | A1/A2/B1 level assignment |

### 6.2 Context Verification

| Source | Purpose |
|--------|---------|
| **Reverso Context** (context.reverso.net) | Verify phrases in real usage contexts |
| **DeepL** (deepl.com) | Cross-check translation accuracy |
| **Linguee** (linguee.de) | Bilingual concordance for professional contexts |
| **German Call Center corpora** (internal) | Verify workplace frequency and naturalness |

### 6.3 Verification Checklist (Per Vocabulary Item)

- [ ] Spelling matches Duden online
- [ ] Gender/article verified (for nouns)
- [ ] IPA transcription matches standard German pronunciation
- [ ] Register label is correct for the context
- [ ] Translations are natural (not literal) in English AND Darija
- [ ] Example sentence is grammatically perfect
- [ ] Example sentence demonstrates the FUNCTION of the phrase
- [ ] Frequency rank is data-supported (DWDS corpus)
- [ ] Common errors are specific to Arabic/French speakers
- [ ] Phonetic bridge (if present) is accurate

---

## 7. The Vocabulary Teaching Sequence

Every core vocabulary item passes through five stages within a single mission:

```
STAGE 1: ENCOUNTER (passive)
─────────────────────────────
Learner HEARS the phrase in the dialogue or a model sentence.
No production required. Brain registers the sound pattern.
Exercise type: listen_comprehend or dialogue (input turn)

STAGE 2: SHADOW (motor activation)
────────────────────────────────────
Learner REPEATS the phrase immediately after the model.
Full support (text visible, audio model plays first).
Exercise type: shadow

STAGE 3: SUPPORTED PRODUCTION (guided recall)
──────────────────────────────────────────────
Learner produces the phrase from a prompt WITH support.
Partial support (keywords visible, or first word given).
Exercise type: repeat (with scaffolding)

STAGE 4: FREE PRODUCTION (independent recall)
──────────────────────────────────────────────
Learner produces the phrase from a situational prompt.
No support. Must recall from memory.
Exercise type: conversation (agent turn) or free_response

STAGE 5: CONTEXTUAL VARIATION (generalization)
──────────────────────────────────────────────
Learner uses the phrase in a DIFFERENT context than where it was learned.
This happens in future missions (via embedded review).
Exercise type: conversation in new scenario
```

### Minimum Encounters Before SRS Graduation

| Stage | Minimum Encounters Before "Known" |
|-------|----------------------------------|
| 1 (Encounter) | 1 (in this mission) |
| 2 (Shadow) | 2 (in this mission) |
| 3 (Supported) | 1 (in this mission) |
| 4 (Free) | 1 (in this mission) + 2 (in review) |
| 5 (Variation) | 3+ (across multiple future missions) |

---

## 8. SRS Configuration

Every vocabulary item that enters the spaced repetition system carries these parameters:

```yaml
srs_config:
  initial_interval_hours: 12              # First review 12 hours after learning
  initial_ease_factor: 2.5                # Standard SM-2 starting value
  review_exercise_types:                  # HOW this item is reviewed
    - "repeat"                            # Produce from memory
    - "conversation"                      # Use in a dialogue context
    - "time_pressure"                     # Produce under time constraint
  context_variations:                     # DIFFERENT sentences for each review
    - "Guten Tag, hier ist die Serviceabteilung."
    - "Guten Tag, Sie sprechen mit Youssef."
    - "Guten Tag, wie kann ich Ihnen weiterhelfen?"
```

### SRS Rules

| Rule | Value | Rationale |
|------|-------|-----------|
| Minimum initial interval | 12 hours | Same-day review is too soon for encoding |
| Maximum initial interval | 48 hours | Beyond this, first-time forgetting is likely |
| Context variations minimum | 3 per item | Prevents rote sentence memorization |
| Review exercise types minimum | 2 per item | Multi-modal strengthening |
| Context variation rule | Item NEVER appears in the same sentence twice in a row | Forces genuine recall |

---

## 9. Register Awareness

Every vocabulary item declares its formality level. This information:
- Guides exercise feedback ("You used the informal form — switch to formal")
- Drives the Parallel Tracks exercise type (formal vs. informal comparison)
- Enables register-checking in confidence scoring

### Register Definitions

| Register | When Used | Markers | Example |
|----------|-----------|---------|---------|
| `formal` | With customers, superiors, strangers | Sie/Ihnen, full sentences, no slang | "Wie kann ich Ihnen helfen?" |
| `informal` | With close colleagues (after invitation to use du) | du/dir, contractions, slang okay | "Kannst du mir mal helfen?" |
| `neutral` | Written communication, standard phrases | Grammatically complete, no familiarity markers | "Bitte beachten Sie die Öffnungszeiten." |
| `universal` | Works in any context | No register-specific markers | "Ja" / "Nein" / "Danke" |

### Register Rules for Phoenix

| Rule | Rationale |
|------|-----------|
| All customer-facing vocabulary is `formal` | Non-negotiable professional standard |
| Informal vocabulary taught only from Module 5 (colleague interactions) | Formal-first prevents register confusion |
| The learner NEVER uses `du` with customers in any scenario | Strict workplace rule, must be automatic |
| Register errors in scoring never exceed -10% penalty | Communicate correctness, not punish |

---

## 10. Darija & French Translation Standards

### 10.1 Darija Translation Rules

| Rule | Example |
|------|---------|
| Use Moroccan Darija, not MSA | "كيفاش نقدر نعاونك" not "كيف يمكنني مساعدتك" |
| Include French loanwords where natural | "تيليفون" (téléphone), "بيرو" (bureau) |
| Keep informal register (Darija IS informal) | Warm, approachable tone |
| Translate the MEANING, not the words | "Guten Tag" → "نهاركم مبروك" (not "يوم جيد") |
| Provide both Arabic script AND optional transliteration | For learners more comfortable with Latin script |

### 10.2 French Translation Rules

| Rule | When Applied |
|------|-------------|
| Provided when French cognate helps German recall | "Selbstverständlich" ~ "Évidemment" (similar function) |
| Provided for phonetic bridges | "ü = French 'u' in 'tu'" |
| NOT provided for every item (only when useful) | Avoid translation overload |
| Formal register (matching the German register) | "Comment puis-je vous aider?" |

### 10.3 English Translation Rules

| Rule | Application |
|------|-------------|
| Always provided (primary translation language) | Every vocabulary item has `translation_en` |
| Natural English, not literal | "Wie kann ich Ihnen helfen?" → "How can I help you?" (not "How can I you help?") |
| American English preferred for consistency | "Color" not "Colour"; "organized" not "organised" |
| Professional register matching | If German is formal, English is formal |

---

## 11. Common Errors Specific to Moroccan Learners

Based on contrastive analysis of Arabic/French phonological and grammatical systems vs. German:

### 11.1 Phonological Errors

| Error Type | Example | Source | Correction Strategy |
|-----------|---------|--------|-------------------|
| /p/ → /b/ confusion | "Broblem" for "Problem" | Arabic has no /p/ phoneme | French bridge: "parfait" shows /p/ exists |
| Final consonant cluster reduction | "helf" for "helft" | Arabic syllable structure | Slow articulation drills |
| /ʁ/ → /r/ substitution | Trilled 'r' instead of uvular | Arabic ر is alveolar trill | French bridge: French 'r' is uvular like German |
| /ç/ → /ʃ/ substitution | "ish" for "ich" | No palatal fricative in Arabic | Articulatory instruction: "whispered 'hee'" |
| Vowel length neutralization | "Stadt" = "Staat" | Arabic vowel length differs | Minimal pair drilling |
| /v/ → /w/ substitution | "wie" with English 'w' sound | English interference | French bridge: "vin" has correct /v/ |

### 11.2 Grammatical Errors

| Error Type | Example | Source | Prevention |
|-----------|---------|--------|-----------|
| Gender assignment | "die Bestellnummer" → "der Bestellnummer" | Arbitrary assignment, no L1 parallel | Teach with article as part of chunk |
| Case after preposition | "mit die Kundin" → "mit der Kundin" | No case system in Darija | Embed in chunks, reveal later |
| V2 word order violation | "Ich sofort schaue nach" → "Ich schaue sofort nach" | English/Arabic word order transfer | Massive exposure in correct form |
| Separable verb error | "Ich nachschaue" → "Ich schaue nach" | No separable verbs in L1 | Teach as two-part chunk from start |

### 11.3 Register Errors

| Error Type | Example | Source | Prevention |
|-----------|---------|--------|-----------|
| du/Sie confusion | "Wie kann ich dir helfen?" (to customer) | Darija doesn't stratify register as strictly | Drill formal as DEFAULT, always |
| Incomplete greeting formula | "Hallo?" (instead of full formula) | Darija phone answer: "Allo?" | Train complete formula as one chunk |
| Too direct refusal | "Nein, das geht nicht." | Arabic directness patterns | Teach professional softening: "Leider ist das nicht möglich" |

---

## 12. Vocabulary ID Naming Convention

```
v_{keyword}[_{disambiguator}]

Rules:
- Lowercase
- Underscore-separated
- Based on the primary German keyword
- Disambiguator only when the same word appears in different chunks
- Maximum 40 characters

Examples:
  v_guten_tag                          # "Guten Tag"
  v_wie_kann_ich_ihnen_helfen          # "Wie kann ich Ihnen helfen?"
  v_bestellnummer                      # "Ihre Bestellnummer"
  v_selbstverstaendlich                # "Selbstverständlich"
  v_einen_moment_bitte                 # "Einen Moment bitte"
  v_ich_kuemmere_mich_darum            # "Ich kümmere mich darum"
  v_das_tut_mir_leid                   # "Das tut mir leid"
  v_schaue_nach                        # "Ich schaue sofort nach"
```

---

*End of Part 05. Continue to `06_dialogue_system.md` for the multi-turn dialogue specification.*
