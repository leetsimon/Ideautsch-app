# Phoenix Content Pipeline — Part 06: Quality System

**Version:** 1.0.0  
**Status:** Production Reference  

---

## 1. Quality Philosophy

Every mission that reaches a learner's device has passed through
a rigorous multi-layer validation system. No exceptions.

The quality bar: **Would a professional German language school
charge €500 for a course built from this content?**

If the answer isn't clearly yes, the content doesn't ship.

---

## 2. The Eight Validation Gates

Every generated mission must pass ALL eight gates:

```
GATE 1: YAML SCHEMA VALIDATION ──────── Automated
GATE 2: CEFR ALIGNMENT ─────────────── Automated + Human
GATE 3: GRAMMAR CORRECTNESS ──────────── Automated + Native
GATE 4: VOCABULARY VALIDATION ─────────── Automated + Native
GATE 5: NATIVE NATURALNESS ──────────── Human (Native Speaker)
GATE 6: SPEAKING RATIO COMPLIANCE ────── Automated
GATE 7: CAREER USEFULNESS ────────────── Human (Domain Expert)
GATE 8: CULTURAL ACCURACY ────────────── Human (Cultural Expert)
```

---

## 3. Gate Details

### Gate 1: YAML Schema Validation (Automated)

```yaml
checks:
  - yaml_parses_without_error: true
  - spec_version_matches: "1.0.0"
  - all_required_fields_present: true
  - metadata_id_convention: "m{dd}_{ddd}_{type_code}"
  - skills_sum_equals_100: true
  - vocabulary_core_count_limit: "≤5 (discovery), ≤3 (practice)"
  - exercises_cover_all_phases: true
  - no_duplicate_ids: true
  - confidence_weights_sum_to_1: true
  - career_transfer_non_empty: true
  - learning_objective_format: "starts with 'After this mission'"
  - duration_within_limits: "≤30 minutes"
  - all_audio_paths_valid_format: true
  - all_vocabulary_refs_resolvable: true
  - scaffolding_three_levels_present: true

result: PASS (all checks) | FAIL (any check fails)
action_on_fail: "Cannot proceed. Fix structural issues first."
```

### Gate 2: CEFR Alignment (Automated + Human)

```yaml
automated_checks:
  vocabulary_level:
    rule: "All core vocabulary ≤ declared CEFR level"
    source: "Goethe-Institut Wortlisten cross-reference"
    tolerance: "1 item may be one sub-level above (with justification)"
    
  grammar_level:
    rule: "Embedded grammar patterns match CEFR expectations"
    source: "Profile deutsch grammar specifications"
    constraint: "A1 mission cannot embed B1+ grammar"
    
  sentence_length:
    rule: "Learner production turns match level expectations"
    A1: "≤8 words per production turn"
    A2: "≤12 words"
    B1: "≤18 words"
    B2: "≤25 words"

  reading_complexity:
    rule: "Any text shown to learner is at or below level"
    measurement: "Flesch-Kincaid adapted for German"

human_verification:
  assessor: "CEFR-trained language assessor"
  question: "Would this content appear in a Goethe-Institut exam at this level?"
  
result: PASS | WARN (minor deviation with justification) | FAIL
```

### Gate 3: Grammar Correctness (Automated + Native)

```yaml
automated_checks:
  - spell_check: "All German text passes Duden spell-check"
  - compound_words: "All compounds verified against DWDS"
  - article_gender: "All nouns have correct gender assignment"
  - case_usage: "All case markings verified (nom/acc/dat/gen)"
  - verb_conjugation: "All verb forms verified"
  - word_order: "V2 rule, subordinate clause order verified"
  - punctuation: "German punctuation rules applied"

native_speaker_check:
  reviewer: "Native German speaker (C2 minimum)"
  focus_areas:
    - "Does this sound like what a German professional would say?"
    - "Are there any textbook-ish constructions that sound unnatural?"
    - "Would you use this exact phrasing in this situation?"
  
  common_AI_errors_to_watch:
    - "Overly formal where natural German would be slightly softer"
    - "Direct translations from English sentence structure"
    - "Using less common synonyms where a simple word would be natural"
    - "Missing articles before nouns (common in AI-generated German)"
    
result: PASS | MINOR CORRECTIONS | MAJOR REWRITE | FAIL
```

### Gate 4: Vocabulary Validation (Automated + Native)

```yaml
automated_checks:
  - all_chunks_not_isolated_words: true
  - frequency_data_verified: "DWDS corpus confirmed"
  - no_duplicates_across_curriculum: true
  - SRS_context_variations_minimum_3: true
  - cluster_assignment_valid: true
  - register_label_correct: true
  - all_translations_present: "EN required, Darija required"
  - IPA_format_valid: true

native_checks:
  german_reviewer:
    - "Is this how Germans actually say this? (not textbook German)"
    - "Is the register label correct for this context?"
    - "Are the example sentences natural?"
  darija_reviewer:
    - "Is the Darija translation natural Moroccan Arabic?"
    - "Would a Casablanca native say it this way?"
    - "Are French loanwords used naturally (not forced)?"
    
result: PASS | CORRECTIONS NEEDED | FAIL
```

### Gate 5: Native Naturalness (Human Only)

```yaml
reviewer: "Native German speaker, 25-40, worked in customer service"
  
evaluation_criteria:
  naturalness_score: "1-5 scale"
    5: "Sounds exactly like a German colleague would say it"
    4: "Natural with very minor adjustments"
    3: "Understandable but slightly unnatural"
    2: "Noticeably non-native phrasing"
    1: "Would confuse or amuse a German speaker"
    
  minimum_score: 4 (for production)
  
  specific_checks:
    - "Would you say this exact phrase in this exact situation?"
    - "Is the intonation direction correct?"
    - "Are the collocations natural?"
    - "Would a German customer service professional recognize this?"
    
red_flags:
  - "Literal translation from English"
  - "Overly complex when simple would be natural"
  - "Using a word that's technically correct but nobody says"
  - "Missing discourse markers Germans actually use"
```

### Gate 6: Speaking Ratio Compliance (Automated)

```yaml
calculation:
  speaking_exercises: "shadow, repeat, vocabularyPresent, reconstruct,
                       conversation, timePressure, parallelTracks, rescue"
  total_time: "sum of all estimated_duration_seconds"
  speaking_time: "sum of estimated_duration_seconds for speaking types"
  ratio: "speaking_time / total_time"

thresholds:
  discovery: "≥ 0.55"
  practice: "≥ 0.60"
  challenge: "≥ 0.65"
  simulation: "≥ 0.50"
  recovery: "≥ 0.55"

result: PASS (meets threshold) | FAIL (below threshold)
action_on_fail: "Replace listen-only exercises with listen+respond or add speaking exercises"
```

### Gate 7: Career Usefulness (Human)

```yaml
reviewer: "Person with 3+ years German customer service experience"

evaluation:
  question: "Would learning this content make someone more employable?"
  
  specific_checks:
    - "Is this vocabulary actually used in German call centers?"
    - "Is this scenario realistic for the declared career domain?"
    - "Would an employer value this skill?"
    - "Does the career_transfer statement cite accurate frequency?"
    
  scoring:
    directly_applicable: 10
    mostly_relevant: 7
    partially_useful: 4
    not_career_relevant: 0
    
  minimum_score: 7

result: PASS (≥7) | FAIL (<7)
```

### Gate 8: Cultural Accuracy (Human)

```yaml
reviewer: "Person currently living/working in Germany (3+ years)"

evaluation:
  checks:
    - "Are workplace norms accurately represented?"
    - "Are cultural notes current (not outdated)?"
    - "Is there any stereotyping (German or Moroccan)?"
    - "Are professional expectations realistic?"
    - "Would a German supervisor confirm these standards?"
    
  sensitivity_check:
    - "Could any content be perceived as offensive?"
    - "Are characters portrayed with dignity?"
    - "Is the Moroccan cultural comparison respectful?"
    
  accuracy_check:
    - "Sie/du rules correctly described?"
    - "Meeting culture accurately portrayed?"
    - "Feedback norms correctly explained?"
    - "Punctuality expectations accurate?"

result: PASS | CORRECTIONS NEEDED | FAIL
```

---

## 4. Quality Score Computation

```yaml
quality_score:
  gate_1_schema: 15          # 15 or 0 (binary)
  gate_2_cefr: 15            # 0-15 based on alignment
  gate_3_grammar: 20         # 0-20 based on accuracy
  gate_4_vocabulary: 15      # 0-15 based on quality
  gate_5_naturalness: 15     # (naturalness_score - 1) × 3.75
  gate_6_speaking: 5         # 5 or 0 (binary)
  gate_7_career: 10          # career_score × 1
  gate_8_cultural: 5         # 5 or 0 (pass/fail)
  
  total: 100
  
  production_threshold: 80
  
  blocking_failures:
    - "gate_1 = 0 → Cannot proceed (structural)"
    - "gate_6 = 0 → Must add speaking exercises"
    - "gate_5 < 3 → Major rewrite required (unnatural German)"
```

---

## 5. Continuous Quality Monitoring

After production, monitor quality through learner data:

| Signal | What It Means | Action |
|--------|-------------|--------|
| Exercise skip rate > 30% | Exercise too hard or unclear | Review difficulty/scaffolding |
| Average score < 0.3 on exercise | Evaluation too strict or content too hard | Adjust evaluation_config |
| Average score > 0.9 on exercise | Too easy, no learning happening | Increase difficulty or remove |
| Consistent pronunciation errors on a word | Pronunciation guidance insufficient | Add pronunciation coaching |
| Mission completion rate < 60% | Mission is too long or too frustrating | Split or add support |
| SRS lapse rate > 40% on item | Item not well-taught or too hard | Revise teaching sequence |

---

## 6. Quality Report Template

Every mission carries this report in production:

```yaml
quality_report:
  overall_score: 92
  gate_results:
    schema_validation: { passed: true, score: 15 }
    cefr_alignment: { passed: true, score: 14, notes: "One item at upper A1 boundary — justified by high workplace frequency" }
    grammar_correctness: { passed: true, score: 19, corrections: 1, note: "Minor comma placement fixed" }
    vocabulary_validation: { passed: true, score: 15 }
    native_naturalness: { passed: true, score: 14, naturalness_rating: 4.7 }
    speaking_ratio: { passed: true, score: 5, ratio: 0.62 }
    career_usefulness: { passed: true, score: 10, rating: 9.5 }
    cultural_accuracy: { passed: true, score: 5 }
  
  reviewers:
    german_native: "Anna M. (C2, ex-call-center-agent, 8 years)"
    darija_native: "Khalid B. (Casablanca native, bilingual educator)"
    pedagogical: "Dr. Sarah K. (CEFR assessor, 12 years teaching)"
    cultural: "Thomas R. (German, 5 years call center management)"
  
  production_ready: true
  approved_date: "2026-07-06"
  version: 1
  notes: "Gold standard quality. Ready for production."
```

---

*End of Part 06 — Quality System.*

*End of Phoenix Content Pipeline documentation.*
