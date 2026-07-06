# Phoenix Mission Specification — Part 01: Overview

**Specification Version:** 1.0.0  
**Date:** July 6, 2026  
**Status:** Definitive Reference  

---

## 1. Purpose

This specification is the authoritative blueprint for every mission in Project Phoenix. It serves three audiences:

| Audience | How They Use This |
|----------|-------------------|
| **Human content authors** | Write missions by following the YAML schema and validation rules |
| **AI generators** | Produce conformant mission drafts from structured prompts |
| **Engineering team** | Build the mission engine and content pipeline consuming these files |

Every mission file that enters the content database MUST conform to this specification. Non-conforming missions are rejected at the automated validation gate.

---

## 2. Specification Architecture

The Phoenix Mission Specification (PMS) is divided into modular documents:

| File | Contents |
|------|----------|
| `01_overview.md` | Purpose, principles, taxonomy, file format overview |
| `02_metadata.md` | Mission ID, CEFR alignment, skills, career domains |
| `03_learning_objectives.md` | Objective writing standard, observable outcomes |
| `04_real_world_scenarios.md` | Scenario design, character registry, emotional goals |
| `05_vocabulary_system.md` | Chunk-first vocabulary, clustering, SRS integration |
| `06_dialogue_system.md` | Multi-turn dialogue, scaffolding, acceptable responses |
| `07_exercise_types.md` | All exercise types, evaluation modes, phase assignment |
| `08_grammar_pronunciation.md` | Grammar discovery, phonetic bridges, pronunciation coaching |
| `09_assessment_system.md` | Confidence scoring, success criteria, career transfer |
| `10_ai_generation_protocol.md` | AI prompt templates, validation, batch generation |
| `11_sample_mission.yaml` | Complete Mission Zero YAML (reference implementation) |

---

## 3. Immutable Design Principles

Every mission is governed by these 10 laws. No exception is permitted.

| # | Principle | Enforcement Mechanism |
|---|-----------|----------------------|
| 1 | **Speaking dominates.** ≥60% of exercise time requires learner speech production. | `metadata.skills.speaking ≥ 50` validated in schema |
| 2 | **Context is mandatory.** No vocabulary exists outside a real-world scenario. | Every vocabulary item requires `example_in_context` field |
| 3 | **Forward motion only.** Missions never send learners backward. | Prerequisite graph validated for cycles |
| 4 | **Career-anchored.** Every mission has an explicit career transfer statement. | `career_transfer.statement_en` is a required non-empty field |
| 5 | **Emotionally safe.** No exercise produces shame, guilt, or punishment. | Feedback templates use approved language only |
| 6 | **Grammar invisible until revealed.** Grammar is embedded, never the primary objective. | `grammar_discovery.mode` must be `embedded` or `revelation` |
| 7 | **Chunk-first.** Vocabulary is taught as usable phrases, never isolated words. | `vocabulary.core[].chunk_phrase` is a required field |
| 8 | **Adaptive by default.** Every production exercise has three scaffolding levels. | `scaffolding.support_high/standard/minimal` required |
| 9 | **One clear objective.** Each mission teaches ONE communicative skill. | `learning_objective` is a single sentence with one verb |
| 10 | **Completable in one session.** Maximum 15 minutes. | `metadata.estimated_duration_minutes ≤ 15` enforced |

---

## 4. Mission Taxonomy

### 4.1 Mission Types

| Type ID | Name | Purpose | Duration | Proportion |
|---------|------|---------|----------|------------|
| `discovery` | Discovery Mission | Introduce new material inside a scenario | 10–15 min | ~60% |
| `practice` | Practice Mission | Reinforce material in a different scenario | 8–12 min | ~20% |
| `challenge` | Challenge Mission | Test independent production, minimal support | 10–15 min | ~10% |
| `simulation` | Simulation Mission | Full scenario (call center / interview) | 10–20 min | ~7% |
| `recovery` | Recovery Mission | Consolidate after detected struggle | 5–8 min | ~3% |

### 4.2 Module-to-CEFR Mapping

| Modules | Narrative Chapter | CEFR Entry | CEFR Exit | Career Focus |
|---------|-------------------|------------|-----------|--------------|
| 1–3 | Preparing (daily life) | A0 | A1 | Foundation: sounds, greetings, survival |
| 4–6 | Training (workplace entry) | A1 | A2 | Phone, formal register, customer basics |
| 7–9 | Working (professional execution) | A2 | B1 | Complaints, technical, interview |
| 10–12 | Advancing (career growth) | B1 | B1+ | Advanced communication, assessment |

### 4.3 Mission ID Convention

Format: `m{module:02d}_{sequence:03d}_{type_code}`

| Type | Code | Example |
|------|------|---------|
| Discovery | `d` | `m01_001_d` — Module 1, Mission 1, Discovery |
| Practice | `p` | `m03_007_p` — Module 3, Mission 7, Practice |
| Challenge | `c` | `m02_004_c` — Module 2, Mission 4, Challenge |
| Simulation | `s` | `m05_012_s` — Module 5, Mission 12, Simulation |
| Recovery | `r` | `m06_003_r` — Module 6, Mission 3, Recovery |

---

## 5. File Format Overview

Every mission is a single YAML file stored at:

```
content_source/missions/{module_id}/{mission_id}.yaml
```

Example paths:
```
content_source/missions/m01/m01_001_d.yaml
content_source/missions/m05/m05_012_s.yaml
content_source/missions/m09/m09_003_c.yaml
```

Audio assets are co-located:
```
assets/audio/missions/{mission_id}/{description}.opus
```

### 5.1 Top-Level YAML Structure

```yaml
spec_version: "1.0.0"
metadata: { ... }
learning_objective: { ... }
scenario: { ... }
emotional_goal: { ... }
vocabulary: { ... }
dialogue: { ... }
exercises: [ ... ]
grammar_discovery: { ... }
pronunciation_coaching: { ... }
common_mistakes: [ ... ]
cultural_notes: [ ... ]
smart_review: { ... }
confidence_scoring: { ... }
success_criteria: { ... }
career_transfer: { ... }
quality_report: { ... }
```

Each section is fully defined in its corresponding specification document.

---

## 6. Quality Gate Process

A mission progresses through three validation layers before production:

```
┌─────────────────────────────────────────────┐
│  Layer 1: STRUCTURAL VALIDATION (automated)  │
│  ─────────────────────────────────────────── │
│  • YAML parses without errors                │
│  • All required fields present               │
│  • ID convention followed                    │
│  • Skills sum to 100                         │
│  • Audio paths resolve                       │
│  • Cross-references valid                    │
│  • Duration within limits                    │
│                                              │
│  GATE: Pass all automated checks            │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│  Layer 2: PEDAGOGICAL REVIEW (human)         │
│  ─────────────────────────────────────────── │
│  • Learning objective is observable          │
│  • Scenario passes "Real Test"               │
│  • Grammar is embedded (not stated)          │
│  • Feedback language is safe                 │
│  • Difficulty progression is correct         │
│  • Scaffolding degrades naturally            │
│                                              │
│  GATE: Content expert approves              │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│  Layer 3: QUALITY VERIFICATION (expert)      │
│  ─────────────────────────────────────────── │
│  • German grammar verified (Duden/DWDS)      │
│  • Vocabulary verified by native speaker     │
│  • Cultural accuracy confirmed               │
│  • Darija translations verified              │
│  • Audio recorded at studio quality          │
│  • CEFR alignment confirmed                  │
│                                              │
│  GATE: Quality report all-green             │
└─────────────────────────────────────────────┘
```

Only missions that pass all three gates enter the content database.

---

## 7. Offline-First Content Design

All mission content must function without any network connectivity:

| Requirement | Implementation |
|-------------|---------------|
| Audio | Opus-encoded files bundled with app (no streaming) |
| Text | All strings embedded in YAML → compiled to SQLite |
| Evaluation | Keyword matching + phonetic comparison (no cloud ASR) |
| SRS scheduling | Local algorithm, no server sync |
| Progress | SQLite user database on device |
| Translations | All languages pre-authored, not machine-translated at runtime |
| Adaptive logic | Rule-based engine on device (no cloud AI) |

---

## 8. AI-Ready Architecture

The specification is designed so that AI systems (GPT-4, Claude, Gemini) can generate conformant missions:

| AI-Ready Feature | How It Helps |
|-----------------|-------------|
| Strict YAML schema | AI can follow structural templates exactly |
| Standardized emotion vocabulary | AI selects from fixed list (no invention needed) |
| Character registry | AI selects from known characters |
| Exercise type registry | AI selects from defined types |
| Grammar pattern IDs | AI references existing tracked patterns |
| Vocabulary cluster IDs | AI assigns correct tactical category |
| Quality report template | AI honestly declares what it can/cannot verify |

AI-generated missions STILL require human review (Layer 2 and 3 of the Quality Gate).

---

## 9. Moroccan Learner Optimization

This specification is built specifically for learners whose linguistic background includes:

| Language | Role in Phoenix |
|----------|----------------|
| **Darija** (Moroccan Arabic) | Primary comfort language; phonetic bridges; cultural comparison |
| **Modern Standard Arabic** | Grammar concepts (gender, agreement); limited direct bridging |
| **French** | Primary phonetic bridge (ü, ö, r, ch); formal register familiarity; cognates |
| **English** | Professional vocabulary cognates; quick translations; technical terms |
| **German** (target) | 100% of learning content; progressive immersion |

Every mission leverages this multilingual background through:
- Phonetic bridges from French/Arabic to German sounds
- Cultural comparisons (Moroccan workplace norms vs. German expectations)
- Darija explanations for difficult concepts (warm, informal register)
- Cognate exploitation (French/English → German professional vocabulary)
- Progressive L1 fade (from heavy support to German-only instructions)

---

*End of Part 01. Continue to `02_metadata.md` for the complete metadata schema.*
