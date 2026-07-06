# Phoenix Mission Specification — Part 08: Grammar & Pronunciation

**Specification Version:** 1.0.0  

---

## 1. Grammar Discovery Philosophy

Grammar is NEVER the stated objective of a mission. Grammar is ALWAYS embedded within communicative chunks and revealed only after the learner has been producing the pattern unconsciously for weeks.

### The Three Modes

| Mode | Description | When Used |
|------|-------------|-----------|
| `embedded` | Grammar pattern exists in phrases; learner is unaware | ALL missions (default) |
| `revelation` | System shows learner a pattern they already produce naturally | Specific grammar milestone missions |
| `refinement` | Conscious practice of a revealed pattern in new contexts | Post-revelation missions |

---

## 2. Grammar Discovery Schema

```yaml
grammar_discovery:
  mode: "embedded"
  pattern_id: "modal_verb_koennen"
  pattern_description: "Modal verb 'können' in present tense with infinitive at clause end"
  cefr_grammar_reference: "A1 — Modalverben im Präsens (Goethe A1 Grammatik)"
  
  instances:
    - phrase: "Wie kann ich Ihnen helfen?"
      grammar_element: "kann + Infinitiv (helfen) am Satzende"
      learner_aware: false
    - phrase: "Können Sie mir bitte Ihre Bestellnummer nennen?"
      grammar_element: "Können (Subjekt-Verb-Inversion) + Infinitiv (nennen) am Satzende"
      learner_aware: false
    - phrase: "Ich kann das sofort für Sie prüfen."
      grammar_element: "kann + Infinitiv (prüfen) am Satzende"
      learner_aware: false

  revelation: null
```

### Revelation Mode (when mode = "revelation")

```yaml
grammar_discovery:
  mode: "revelation"
  pattern_id: "modal_verb_koennen"
  pattern_description: "Modal verb 'können' — you've been using it for 4 weeks"
  
  instances:
    - phrase: "Wie kann ich Ihnen helfen?"
      grammar_element: "kann + helfen"
      learner_aware: true                      # NOW they know
    - phrase: "Können Sie mir Ihre Bestellnummer nennen?"
      grammar_element: "Können + nennen"
      learner_aware: true
    - phrase: "Ich kann das sofort prüfen."
      grammar_element: "kann + prüfen"
      learner_aware: true

  revelation:
    trigger_after_exposures: 50
    reveal_text_en: >
      Notice something? In all these sentences you've been saying, 
      there's a pattern: 'kann' + another verb at the END of the sentence.
      'Kann ich... helfen?' 'Können Sie... nennen?' 'Ich kann... prüfen.'
      The action verb always goes to the end. You've been doing this 
      correctly for weeks. Now you know the rule behind it.
    reveal_text_darija: >
      شفتي شي حاجة؟ ف هاد الجمل لي كنتي كتقولهم، كاين pattern: 
      'kann' + فعل آخر ف الآخر ديال الجملة. 
      'Kann ich... helfen?' 'Können Sie... nennen?' 'Ich kann... prüfen.'
      الفعل ديال الحركة ديما كيمشي للآخر. كنتي كدير هادشي مزيان 
      من أسابيع. دابا عرفتي القاعدة لي من ورا.
    examples_from_learner_corpus:
      - "Wie kann ich Ihnen helfen? — used 47 times"
      - "Können Sie mir... nennen? — used 23 times"
      - "Ich kann das prüfen. — used 15 times"
    practice_exercises:
      - type: "reconstruct"
        prompt: "Build this: You can check the delivery status."
        target: "Ich kann den Lieferstatus überprüfen."
      - type: "repeat"
        prompt: "Tell the customer you can help."
        target: "Ich kann Ihnen gerne helfen."
```

---

## 3. Grammar Pattern Registry

All grammar patterns tracked across the curriculum:

| Pattern ID | Description | CEFR | First Exposure | Revelation Module |
|-----------|-------------|------|----------------|-------------------|
| `present_tense_regular` | Regular verb conjugation (ich -e, Sie -en) | A1 | Module 1 | Module 3 |
| `modal_verb_koennen` | können + Infinitiv am Satzende | A1 | Module 1 | Module 3 |
| `modal_verb_moechten` | möchten + Infinitiv am Satzende | A1 | Module 2 | Module 4 |
| `modal_verb_muessen` | müssen + Infinitiv am Satzende | A1 | Module 3 | Module 5 |
| `v2_word_order` | Verb-second position in main clauses | A1 | Module 1 | Module 4 |
| `accusative_case` | Akkusativ nach transitive Verben | A1 | Module 2 | Module 5 |
| `dative_case` | Dativ nach mit/von/bei/zu + indirektes Objekt | A2 | Module 3 | Module 6 |
| `perfect_tense` | Perfekt: haben/sein + Partizip II | A2 | Module 4 | Module 6 |
| `separable_verbs` | Trennbare Verben (nachschauen, anrufen) | A2 | Module 3 | Module 5 |
| `subordinate_weil` | Nebensatz mit 'weil' (Verb am Ende) | A2 | Module 5 | Module 7 |
| `subordinate_dass` | Nebensatz mit 'dass' | A2 | Module 5 | Module 7 |
| `konjunktiv_ii_hoeflich` | Höflichkeitsform (Könnten Sie...) | B1 | Module 5 | Module 8 |
| `passive_voice` | Vorgangspassiv (wird + Partizip II) | B1 | Module 7 | Module 9 |
| `relative_clauses` | Relativsätze (der/die/das + Verb am Ende) | B1 | Module 8 | Module 10 |

### Grammar Discovery Rules

| Rule | Rationale |
|------|-----------|
| Never name grammar in learner-facing text before revelation | Avoids "lesson" framing |
| Revelation only after ≥30 unconscious productions of the pattern | Procedural memory must already exist |
| Revelation always shows examples the learner ALREADY PRODUCED | Validates their existing competence |
| Post-revelation exercises test PRODUCTION not identification | "Use it correctly" not "name the case" |
| Connect to L1 parallel when one exists | Accelerates understanding |
| Never present grammar tables | Tables are for reference books, not learning |
| Grammar errors NEVER block progression | Communication > accuracy |

---

## 4. Pronunciation Coaching Philosophy

Pronunciation is trained for INTELLIGIBILITY, not accent elimination. The goal: a German listener understands without asking "Wie bitte?"

### Priority: Which Sounds to Train

Sounds are prioritized by their impact on intelligibility for German listeners:

| Priority | What | Why | Training Volume |
|----------|------|-----|-----------------|
| 1 | Sounds that cause misunderstanding | "Tür" vs "Tour" = different meanings | Every mission containing the sound |
| 2 | Sounds that mark foreign accent strongly | ch /ç/, ü /y/, ö /ø/ | Dedicated drills + embedded practice |
| 3 | Suprasegmentals (stress, intonation) | Wrong stress = unintelligible | Every speaking exercise implicitly |
| 4 | Sounds that are "different" but don't impede understanding | Uvular vs. alveolar 'r' | Brief mention, no intensive drill |

---

## 5. Pronunciation Coaching Schema

```yaml
pronunciation_coaching:
  focus_sounds:
    - sound_id: "ch_ich"
      ipa: "/ç/"
      german_example: "ich"
      position: "syllable-final after front vowels (i, e, ü, ö, ei, eu)"
      reference: "Duden Aussprachewörterbuch, §6.3.2"
      
      bridge:
        language: "none"
        explanation_en: >
          Whisper 'hee' very loudly. Feel the friction at the front of the 
          roof of your mouth? That IS the German 'ch' in 'ich'. It's NOT 
          the Arabic خ (that's the 'ch' in 'Bach') — this one is lighter, 
          more forward, almost like a cat hissing softly.
        explanation_darija: >
          قول 'هيييي' بصوت عالي بزاف. حس بالاحتكاك ف قدام سقف الفم؟ 
          هداك هو 'ch' الألمانية ف 'ich'. ماشي خ ديالنا (هديك ديال 'Bach') — 
          هادي خفيفة، من قدام، بحال مش كتنفخ بشوية.
      
      contrast_with:
        - sound: "ch_ach"
          ipa: "/x/"
          explanation: "'ich' = front, light. 'ach' = back, like Arabic خ."
      
      minimal_pairs:
        - word_a: "ich"
          word_b: "isch (dialect/error)"
          difference: "/ç/ vs /ʃ/"
          audio_a: "audio/pronunciation/ich_correct.opus"
          audio_b: "audio/pronunciation/ich_incorrect_sch.opus"
      
      drill_words:
        - word: "ich"
          audio: "audio/pronunciation/drill_ich.opus"
        - word: "nicht"
          audio: "audio/pronunciation/drill_nicht.opus"
        - word: "möchte"
          audio: "audio/pronunciation/drill_moechte.opus"
        - word: "natürlich"
          audio: "audio/pronunciation/drill_natuerlich.opus"
        - word: "Selbstverständlich"
          audio: "audio/pronunciation/drill_selbstverstaendlich.opus"
      
      common_errors:
        - error: "Replacing /ç/ with /ʃ/ ('ish' instead of 'ich')"
          source: "No palatal fricative in Arabic or French"
          frequency: "Very common for Arabic speakers"
        - error: "Replacing /ç/ with /x/ (using 'ach' sound for 'ich')"
          source: "Overgeneralization — both spelled 'ch'"
          frequency: "Common"
      
    - sound_id: "ue_vowel"
      ipa: "/yː/"
      german_example: "Tür"
      position: "Any position"
      reference: "Duden Aussprachewörterbuch, §3.4.7"
      
      bridge:
        language: "french"
        explanation_en: >
          This is EXACTLY the French 'u' in 'tu', 'rue', 'plus'. 
          If you speak French, you already produce this sound perfectly. 
          Just use your French 'u' whenever you see German 'ü'.
        explanation_darija: >
          هادي هي بالضبط 'u' الفرنسية ف 'tu', 'rue', 'plus'. 
          إلى كتهدر الفرنسية، عندك هاد الصوت مزيان. 
          غير خدم 'u' الفرنسية ديالك فين ما شفتي 'ü' ألمانية.
      
      minimal_pairs:
        - word_a: "Tür"
          word_b: "Tour"
          difference: "/yː/ vs /uː/ — door vs. tour (different words!)"
          audio_a: "audio/pronunciation/tuer_correct.opus"
          audio_b: "audio/pronunciation/tour.opus"
        - word_a: "fühlen"
          word_b: "fuhlen (error)"
          difference: "/yː/ vs /uː/"
          audio_a: "audio/pronunciation/fuehlen_correct.opus"
          audio_b: "audio/pronunciation/fuehlen_incorrect.opus"
      
      drill_words:
        - word: "Tür"
          audio: "audio/pronunciation/drill_tuer.opus"
        - word: "für"
          audio: "audio/pronunciation/drill_fuer.opus"
        - word: "natürlich"
          audio: "audio/pronunciation/drill_natuerlich.opus"
        - word: "Entschuldigung"
          audio: "audio/pronunciation/drill_entschuldigung.opus"
        - word: "zurück"
          audio: "audio/pronunciation/drill_zurueck.opus"

  intonation_pattern:
    pattern_id: "service_greeting_contour"
    description: >
      The professional greeting has a specific contour: slight rise on 
      company name, neutral on your name, clear rise on the final question.
    contour_notation: "→ Guten Tag ↗ TeleService GmbH → mein Name ist Youssef ↗ wie kann ich Ihnen helfen?"
    example_audio: "audio/pronunciation/greeting_intonation_model.opus"
    counter_example_audio: "audio/pronunciation/greeting_intonation_flat.opus"
    explanation_en: >
      The rising intonation on 'helfen?' signals: this is a question, 
      I'm open, I'm ready to help. A flat intonation sounds bored or robotic.
    explanation_darija: >
      الصعود ف الصوت على 'helfen?' كيعني: هادا سؤال، أنا مفتوح، 
      أنا جاهز نعاون. إلو الصوت مسطح كيبان بحال ملي كتكون ضايق.
```

---

## 6. Complete Phonetic Bridge Map

All sounds where Moroccan learners have an advantage or need specific guidance:

| German Sound | IPA | Bridge Language | Bridge Sound | Difficulty for Moroccan Learner |
|-------------|-----|----------------|-------------|-------------------------------|
| ch (ach-Laut) | /x/ | Arabic/Darija | خ (kha) | EASY — identical sound |
| ch (ich-Laut) | /ç/ | None (new) | — | MODERATE — fronted version of خ |
| ü (long) | /yː/ | French | u in "tu" | EASY if French-speaking |
| ü (short) | /ʏ/ | French | u in "dur" | EASY if French-speaking |
| ö (long) | /øː/ | French | eu in "peu" | EASY if French-speaking |
| ö (short) | /œ/ | French | eu in "neuf" | EASY if French-speaking |
| r (uvular) | /ʁ/ | French | r in "rouge" | EASY — French r is identical |
| w | /v/ | French | v in "vin" | EASY — German w = French v |
| v (in German words) | /f/ | None | — | MODERATE — counterintuitive spelling |
| z | /ts/ | Italian loanwords | "pizza" | MODERATE — unusual onset cluster |
| sch | /ʃ/ | French | ch in "chambre" | EASY — identical to French ch |
| sp- (word-initial) | /ʃp/ | None (rule) | — | MODERATE — spelling misleads |
| st- (word-initial) | /ʃt/ | None (rule) | — | MODERATE — spelling misleads |
| ä (long) | /ɛː/ | French | è in "père" | EASY |
| ei | /aɪ/ | English | "my", "time" | EASY — identical diphthong |
| au | /aʊ/ | English | "house", "now" | EASY — identical diphthong |
| eu/äu | /ɔɪ/ | English | "boy", "coin" | MODERATE — less common in L1 |
| ß | /s/ | French | ss in "poisson" | EASY — just a spelling convention |
| p (vs b) | /p/ | French | p in "papa" | MODERATE — Arabic lacks /p/ |
| Vowel length | /aː/ vs /a/ | None | — | HARD — Arabic vowel system differs |
| Word stress | Variable | None | — | HARD — pattern-based, must be learned per word |

---

## 7. Pronunciation Coaching Rules

| Rule | Rationale |
|------|-----------|
| Maximum 2 focus sounds per mission | Don't overwhelm |
| Always start with the bridge ("You already know this!") | Confidence first |
| Include minimal pairs when the sound creates meaning differences | Proves the sound matters |
| Provide both correct AND incorrect audio | Learner must hear the difference |
| Drill words come from vocabulary the learner already knows | Familiar context reduces load |
| Intonation coaching embedded in every dialogue (implicit) | Modeled continuously |
| Dedicated pronunciation notes on EVERY agent production turn | Consistent coaching |
| Never perfectionism ("Your accent is fine if understood") | Goal is intelligibility |
| Track pronunciation scores per sound over time | Detect persistent issues |

---

## 8. Grammar CEFR Alignment Verification

All grammar patterns are verified against official CEFR grammar specifications:

| Source | Use |
|--------|-----|
| Goethe-Institut A1 Prüfung — Grammatik-Kann-Beschreibungen | What A1 learners should produce |
| Goethe-Institut A2 Prüfung — Grammatik-Kann-Beschreibungen | What A2 learners should produce |
| telc Deutsch B1 — Sprachbausteine | B1 grammar structures |
| Profile deutsch (Glaboniat et al.) | Functional grammar specifications per level |
| Duden: Die Grammatik (Band 4) | Correctness verification |
| DWDS Kernkorpus | Real usage frequency of structures |

### CEFR Grammar Expectations by Level

| CEFR | Grammar the Learner PRODUCES (not identifies) |
|------|-----------------------------------------------|
| A1 | Present tense regular/irregular, modal verbs (kann/möchte/muss), V2 word order, simple questions, basic negation (nicht/kein), possessive articles |
| A2 | Perfect tense, dative after prepositions (mit/von/bei/zu), separable verbs, subordinate clauses (weil/dass), comparative |
| B1 | Konjunktiv II (Höflichkeit), passive voice, relative clauses, indirect speech basics, complex sentence structures |

---

*End of Part 08. Continue to `09_assessment_system.md` for confidence scoring and career transfer.*
