# Phoenix Content Pipeline — Part 01: Mission Generator

**Version:** 1.0.0  
**Status:** Production Reference  

---

## 1. Generator Architecture

The Mission Generator is a semi-automated system that produces conformant mission YAML files at scale while maintaining the quality standard established by M001.

```
┌─────────────────────────────────────────────────────────────┐
│                   MISSION GENERATOR PIPELINE                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  INPUT                                                       │
│  ─────                                                       │
│  • Module brief (themes, vocabulary targets, grammar)        │
│  • Vocabulary Master Database (available items at level)     │
│  • Grammar Progression Map (what's embedded, what's revealed)│
│  • Character Registry + narrative continuity state           │
│  • Previous missions in module (for cross-referencing)       │
│                                                              │
│  GENERATION                                                  │
│  ──────────                                                  │
│  • AI drafts mission YAML from structured prompt             │
│  • Automatic validation (structural + linguistic)            │
│  • Quality scoring (0–100)                                   │
│                                                              │
│  VALIDATION                                                  │
│  ──────────                                                  │
│  • Layer 1: Schema validation (automated)                    │
│  • Layer 2: CEFR/vocabulary/grammar checks (automated)       │
│  • Layer 3: Native speaker review (human)                    │
│  • Layer 4: Pedagogical review (human)                       │
│                                                              │
│  OUTPUT                                                      │
│  ──────                                                      │
│  • Production-ready .yaml file                               │
│  • Audio recording brief                                     │
│  • Image generation prompts                                  │
│  • Quality report                                            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. AI Generation Prompt System

### 2.1 Master Prompt (System Message)

```
You are the Phoenix Mission Architect — an expert in German language 
pedagogy for Moroccan Arabic speakers, with deep knowledge of:
- Call center communication in German
- CEFR framework (A1–B2) with Goethe-Institut alignment
- Contrastive analysis: Arabic/French/English → German
- Spaced repetition and speaking-first methodology
- Professional German (Wirtschaftsdeutsch, Kundenservice)

You generate mission YAML files conforming to PMS v1.0.0.

ABSOLUTE RULES:
1. All German must be grammatically perfect (Duden standard)
2. Speaking exercises ≥ 60% of exercise time
3. Maximum 5 new vocabulary chunks per discovery mission
4. Grammar is ALWAYS embedded, never stated as objective
5. Every phrase is a usable chunk, never an isolated word
6. Formal register (Sie/Ihnen) with all customer scenarios
7. Darija translations use Moroccan Arabic, never MSA
8. Career transfer statement must cite real workplace frequency
9. All acceptable_responses patterns must be realistic
10. Scaffolding degrades: high → standard → minimal across exercises
```

### 2.2 Mission Generation Prompt Template

```yaml
# MISSION GENERATION REQUEST
# ═══════════════════════════

module: {N}
sequence: {S}
type: {discovery | practice | challenge | simulation}

context:
  module_theme: "{Theme of the module}"
  narrative_position: "{Where in the story arc}"
  previous_mission_summary: "{What was learned last}"
  
targets:
  cefr_level: "{A1 | A2 | B1 | B2}"
  career_domain: "{from controlled vocabulary}"
  learning_objective: "{What learner can DO after}"
  
vocabulary:
  new_items:
    - chunk: "{German phrase}"
      meaning: "{functional meaning}"
      cluster: "{tactical cluster ID}"
    - chunk: "{German phrase}"
      meaning: "{functional meaning}"
      cluster: "{tactical cluster ID}"
  review_items:
    - id: "{vocabulary_id from master DB}"
    - id: "{vocabulary_id from master DB}"

grammar:
  embedded_pattern: "{pattern_id}"
  instances_minimum: 3

character:
  primary: "{character_id}"
  mood: "{mood_id}"
  
emotional_goal:
  primary: "{emotion_id}"
  confidence_vector: "{positive | consolidating | stretching}"

constraints:
  duration_minutes: {10-25}
  speaking_percent_minimum: 60
  exercise_count: {7-12}
```

### 2.3 Generation Quality Tiers

| Tier | Score Range | Action |
|------|------------|--------|
| **Gold** | 90–100 | Ready for human review |
| **Silver** | 75–89 | Minor revisions needed, then review |
| **Bronze** | 60–74 | Significant revision required |
| **Reject** | < 60 | Regenerate from scratch |

---

## 3. Automatic Validation Engine

### 3.1 Structural Validation (Pass/Fail)

```python
STRUCTURAL_CHECKS = [
    "yaml_parses_without_error",
    "spec_version_matches",
    "all_required_fields_present",
    "mission_id_follows_convention",
    "skills_sum_to_100",
    "speaking_skill_minimum_met",
    "vocabulary_core_count_within_limit",
    "exercises_span_all_four_phases",
    "no_duplicate_exercise_ids",
    "confidence_scoring_weights_sum_to_1",
    "career_transfer_non_empty",
    "learning_objective_format_correct",
    "duration_within_limits",
    "all_audio_paths_follow_convention",
    "all_vocabulary_ids_referenced_exist",
]
```

### 3.2 CEFR Validation

```yaml
cefr_validation:
  vocabulary_check:
    rule: "All core vocabulary items must be at or below declared CEFR level"
    reference: "Goethe-Institut Wortlisten A1/A2/B1/B2"
    action_on_fail: "Flag item with suggested level correction"
    
  grammar_check:
    rule: "Embedded grammar patterns must match CEFR level"
    reference: "Profile deutsch grammar specifications"
    constraint: "A1 missions cannot embed B1 grammar patterns"
    action_on_fail: "Move pattern to later mission or simplify"
    
  sentence_complexity:
    A1: "Maximum 8 words per learner production turn"
    A2: "Maximum 12 words per learner production turn"
    B1: "Maximum 18 words per learner production turn"
    B2: "Maximum 25 words per learner production turn"
```

### 3.3 Vocabulary Coverage Analysis

```yaml
vocabulary_coverage:
  checks:
    - name: "No orphan vocabulary"
      rule: "Every vocabulary item must appear in at least 2 exercises within the mission"
      
    - name: "Review integration"
      rule: "At least 30% of vocabulary items used in exercises must be review items from previous missions"
      
    - name: "Cluster diversity"
      rule: "A module must cover at least 4 different tactical clusters"
      
    - name: "Frequency progression"
      rule: "Higher-frequency items taught before lower-frequency items"
      
    - name: "Domain alignment"
      rule: "All vocabulary items belong to the declared career_domain or 'general'"
```

### 3.4 Grammar Progression Validation

```yaml
grammar_progression:
  rules:
    - "Grammar patterns must follow the progression map (Part 08)"
    - "A pattern cannot be in 'revelation' mode until after minimum exposure missions"
    - "No more than 2 grammar patterns embedded per mission"
    - "Grammar patterns from later CEFR levels cannot appear in earlier modules"
    - "Each module must advance at least one grammar pattern toward revelation"
    
  exposure_tracking:
    format: "{pattern_id}: {mission_ids_where_embedded}"
    minimum_before_revelation: 10 missions
```

### 3.5 Speaking Ratio Validation

```yaml
speaking_ratio:
  calculation: >
    speaking_time = sum(estimated_duration_seconds for exercises where 
    type in [shadow, repeat, vocabularyPresent, reconstruct, conversation, 
    timePressure, parallelTracks, rescue])
    
    total_time = sum(all exercise estimated_duration_seconds)
    
    ratio = speaking_time / total_time
    
  thresholds:
    discovery: ">= 0.55"
    practice: ">= 0.60"
    challenge: ">= 0.65"
    simulation: ">= 0.50"
    recovery: ">= 0.55"
    
  action_on_fail: "Add speaking exercises or replace listen-only exercises with listen+respond"
```

### 3.6 Duplicate Detection

```yaml
duplicate_detection:
  checks:
    - name: "Identical exercise"
      rule: "No two exercises across entire curriculum have identical prompt_text_en + target_text_de"
      tolerance: "Same vocabulary may appear but in different contexts"
      
    - name: "Vocabulary context overlap"
      rule: "SRS context_variations must not duplicate any exercise prompt in any mission"
      
    - name: "Dialogue repetition"
      rule: "No two dialogues share more than 2 identical turns"
      
    - name: "Scenario uniqueness"
      rule: "scenario.situation must be unique (Levenshtein distance > 50% from all others)"
```

---

## 4. Human Review Workflow

### 4.1 Review Roles

| Role | Responsibility | Qualifications |
|------|---------------|----------------|
| **Native German Reviewer** | Grammar, naturalness, idiom accuracy | Native German speaker, C2 certified |
| **Darija Translator** | Darija translations, cultural bridges | Native Moroccan Arabic speaker |
| **Pedagogical Reviewer** | Learning design, exercise flow, difficulty | CEFR assessor training + teaching experience |
| **Cultural Reviewer** | German workplace accuracy, cultural notes | 3+ years working in German customer service |

### 4.2 Review Checklist (Per Mission)

```markdown
## Native German Review
- [ ] All German sentences sound natural (not textbook-ish)
- [ ] Register is appropriate for the scenario
- [ ] Compound words correctly formed
- [ ] Word order is standard (not just grammatically legal)
- [ ] Expressions are current (not outdated)
- [ ] Audio scripts match how a professional would actually speak

## Darija Translation Review
- [ ] All Darija is Moroccan (not MSA or Algerian/Tunisian)
- [ ] French loanwords used naturally where appropriate
- [ ] Register is conversational (Darija is inherently informal)
- [ ] Translations convey meaning (not word-for-word)
- [ ] Cultural references are Morocco-specific

## Pedagogical Review
- [ ] Learning objective is achievable within the mission
- [ ] Difficulty progresses correctly within exercises
- [ ] Scaffolding degrades naturally
- [ ] Speaking exercises dominate
- [ ] Grammar is truly invisible (not stated)
- [ ] Feedback language is emotionally safe
- [ ] No exercise creates anxiety or shame

## Cultural Review
- [ ] Workplace scenarios are realistic for German companies
- [ ] Cultural notes are accurate for current German norms
- [ ] No stereotyping of any culture
- [ ] Professional expectations align with real employer requirements
```

### 4.3 Review States

```
DRAFT → GENERATED → VALIDATED → REVIEWED → APPROVED → PRODUCTION
  ↑         ↑          ↑          ↑
  │         │          │          │
  └─ Revise ┘─ Fix ───┘─ Correct ┘
```

---

## 5. Quality Scoring Algorithm

```yaml
quality_score:
  components:
    structural_validity: 20         # Does it conform to spec?
    linguistic_accuracy: 25         # Is the German correct and natural?
    pedagogical_soundness: 25       # Is the learning design effective?
    cefr_alignment: 15              # Does it match declared level?
    career_relevance: 10            # Is it useful for the target job?
    emotional_safety: 5             # Is feedback language appropriate?
    
  scoring:
    structural_validity:
      all_checks_pass: 20
      1_check_fails: 10
      2+_checks_fail: 0
      
    linguistic_accuracy:
      native_approved_no_changes: 25
      minor_corrections_needed: 18
      significant_corrections: 10
      major_rewrite_needed: 0
      
    pedagogical_soundness:
      expert_approved: 25
      minor_adjustments: 18
      significant_redesign: 10
      fundamentally_flawed: 0
      
    cefr_alignment:
      perfectly_aligned: 15
      slightly_above_level: 10
      significantly_misaligned: 0
      
    career_relevance:
      directly_applicable: 10
      partially_relevant: 7
      tangentially_related: 3
      not_career_relevant: 0
      
    emotional_safety:
      fully_safe: 5
      minor_concern: 3
      unsafe_language_detected: 0
      
  production_threshold: 80
  minimum_per_component:
    structural_validity: 20         # Must be perfect
    linguistic_accuracy: 18         # Minor corrections OK
    pedagogical_soundness: 18       # Minor adjustments OK
    emotional_safety: 5             # Must be fully safe
```

---

## 6. Batch Generation Protocol

### 6.1 Module Generation Sequence

```
1. Create Module Brief
   - Theme, narrative position, CEFR targets
   - Vocabulary budget (30-50 new items for the module)
   - Grammar patterns to embed/reveal
   - Characters and narrative arcs

2. Generate Mission Manifest
   - All mission IDs, types, themes for the module
   - Vocabulary distribution across missions
   - Grammar progression across missions
   - Character rotation schedule

3. Generate Missions (Sequential)
   - Each mission references previous missions' vocabulary for review
   - Narrative continuity maintained
   - Difficulty progression verified

4. Cross-Module Validation
   - No vocabulary duplicates across missions
   - Grammar exposure count verified
   - Speaking ratio sustained across module
   - Emotional variety maintained

5. Human Review Queue
   - Prioritized by module order
   - Native review first, then pedagogical
   - Cultural review for workplace scenarios

6. Production Pipeline
   - Approved missions enter audio recording queue
   - Image generation prompts extracted
   - Final YAML compiled to SQLite
```

---

## 7. Output Artifacts Per Mission

| Artifact | Format | Destination |
|----------|--------|-------------|
| Mission YAML | `.yaml` | content_source/missions/ |
| Audio recording brief | `.md` | production/audio_briefs/ |
| Image generation prompts | `.json` | production/image_prompts/ |
| Quality report | `.json` | production/quality_reports/ |
| Validation log | `.json` | production/validation_logs/ |

---

*End of Part 01. Continue to `02_vocabulary_master_database.md`.*
