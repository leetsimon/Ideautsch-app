# Phoenix Mission Specification — Part 02: Metadata Schema

**Specification Version:** 1.0.0  

---

## 1. Complete Metadata Schema

```yaml
metadata:
  # ─── Identification ─────────────────────────────────────────
  id: "m01_001_d"                              # Unique mission ID (see naming convention)
  title_internal: "Greeting a Customer"        # Internal reference (English, for authors)
  title_display_en: "Your Phone is Ringing"    # Learner-facing title (English)
  title_display_de: "Ihr Telefon klingelt"     # Learner-facing title (German, shown in later modules)
  
  # ─── Placement ──────────────────────────────────────────────
  module: 1                                    # Module number (1–12)
  sequence: 1                                  # Position within module (1–15)
  type: "discovery"                            # discovery | practice | challenge | simulation | recovery
  version: 1                                   # Content version (increment on updates)
  
  # ─── Timing ─────────────────────────────────────────────────
  estimated_duration_minutes: 12               # Expected completion time
  min_duration_minutes: 8                      # Fast learner (high scaffolding skipped)
  max_duration_minutes: 15                     # Struggling learner (all retries used)
  
  # ─── CEFR Alignment ─────────────────────────────────────────
  cefr_level: "A0"                             # Entry CEFR level required
  cefr_target: "A1.1"                          # CEFR sub-level this contributes toward
  
  # ─── Difficulty ──────────────────────────────────────────────
  difficulty: 1                                # 1–10 scale (relative within module)
  
  # ─── Skills Trained ─────────────────────────────────────────
  skills:                                      # Must sum to exactly 100
    speaking: 65
    listening: 20
    vocabulary: 10
    pronunciation: 5
    reading: 0
    writing: 0
  
  # ─── Career Relevance ───────────────────────────────────────
  career_domains:                              # From controlled vocabulary (see §3)
    - "phone_communication"
    - "customer_greeting"
  career_relevance_score: 98                   # 0–100: how directly job-applicable
  
  # ─── Prerequisites ──────────────────────────────────────────
  prerequisites: []                            # List of mission IDs required first
  
  # ─── Tags ───────────────────────────────────────────────────
  tags:                                        # Free-form tags for filtering/search
    - "greeting"
    - "phone"
    - "formal_register"
    - "first_contact"
    - "module_opener"
```

---

## 2. CEFR Level Definitions (Applied to Phoenix)

Project Phoenix uses the Common European Framework of Reference for Languages with sub-levels:

| CEFR Level | Phoenix Interpretation | Productive Ability |
|-----------|----------------------|-------------------|
| **A0** | Absolute beginner. No prior German. | Can repeat memorized phrases |
| **A1.1** | Can produce basic memorized chunks in familiar contexts | Can greet, identify self, ask simple questions |
| **A1.2** | Can handle simple transactional exchanges | Can handle routine information requests |
| **A2.1** | Can communicate in routine tasks with direct exchange | Can handle standard customer service calls |
| **A2.2** | Can handle most predictable situations | Can handle complaints and multi-step processes |
| **B1.1** | Can deal with most situations while travelling/working | Can handle complex calls, conduct interviews |
| **B1.2** | Can produce connected text and describe experiences | Can work autonomously in German customer service |

### CEFR-to-Module Mapping (Detailed)

| Module | CEFR Entry | CEFR Exit | Vocabulary Target (Cumulative) |
|--------|-----------|-----------|-------------------------------|
| 1 | A0 | A1.1 | 50 active phrases |
| 2 | A0+ | A1.1 | 100 active phrases |
| 3 | A1.1 | A1.2 | 160 active phrases |
| 4 | A1.1 | A1.2 | 220 active phrases |
| 5 | A1.2 | A2.1 | 290 active phrases |
| 6 | A1.2 | A2.1 | 360 active phrases |
| 7 | A2.1 | A2.2 | 430 active phrases |
| 8 | A2.1 | A2.2 | 500 active phrases |
| 9 | A2.2 | B1.1 | 580 active phrases |
| 10 | A2.2 | B1.1 | 660 active phrases |
| 11 | B1.1 | B1.2 | 740 active phrases |
| 12 | B1.1 | B1.2 | 800+ active phrases |

"Active phrases" = phrases the learner can produce from memory in context (not recognition-only vocabulary).

### CEFR Verification Sources

All CEFR alignment decisions reference these authoritative sources:

| Source | URL | Use |
|--------|-----|-----|
| Goethe-Institut A1 Wortliste | goethe.de | Official A1 vocabulary list |
| Goethe-Institut A2 Wortliste | goethe.de | Official A2 vocabulary list |
| Profile deutsch | — | Functional specification for German CEFR levels |
| telc Prüfungsmaterial | telc.net | Real exam content at each level |
| DWDS Häufigkeitslisten | dwds.de | Word frequency data for German |
| Duden Online | duden.de | Grammar and usage verification |

---

## 3. Career Domain Controlled Vocabulary

The `career_domains` field MUST use values from this registry:

| Domain ID | Description | Modules Where Primary |
|-----------|-------------|----------------------|
| `phone_communication` | Answering, routing, holding, transferring calls | 4–12 |
| `customer_greeting` | Professional greetings and identification | 1, 4, 5 |
| `information_request` | Handling information inquiries | 5–7 |
| `order_management` | Order status, tracking, changes | 5–8 |
| `complaint_handling` | Receiving and resolving complaints | 6–9 |
| `de_escalation` | Calming frustrated/angry customers | 6–9 |
| `technical_support` | Troubleshooting and step-by-step guidance | 7–9 |
| `billing_payment` | Invoice, payment, refund discussions | 7–8 |
| `account_management` | Password resets, address changes, cancellations | 5–8 |
| `email_communication` | Professional email reading and writing | 6–10 |
| `interview_preparation` | Job interview language and strategies | 9–11 |
| `self_presentation` | Introducing oneself professionally | 1, 9 |
| `workplace_culture` | German workplace norms and behaviors | 10–11 |
| `team_communication` | Colleague interaction, meetings, handovers | 10–11 |
| `quality_monitoring` | Understanding evaluation criteria | 11 |
| `advanced_communication` | Persuasion, negotiation, complex explanation | 11–12 |
| `daily_life` | Non-work scenarios (transport, shopping, health) | 2–3 |
| `bureaucracy` | Appointments, forms, official interactions | 3 |

---

## 4. Skill Distribution Rules

The `skills` object must follow these constraints:

| Rule | Constraint | Rationale |
|------|-----------|-----------|
| Sum to 100 | `speaking + listening + vocabulary + pronunciation + reading + writing = 100` | Ensures complete allocation |
| Speaking minimum | `speaking ≥ 50` for types: discovery, practice, challenge | Speaking-first doctrine |
| Speaking simulation | `speaking ≥ 40` for simulation type | Simulations include more listening |
| No zeros without reason | If a skill is 0, it means the skill is truly absent from this mission | Prevent lazy defaults |
| Pronunciation cap | `pronunciation ≤ 15` (except dedicated pronunciation missions) | Pronunciation is embedded, not primary |
| Writing cap | `writing ≤ 15` (except email-writing missions in Modules 6+) | Writing is secondary to speaking |

### Typical Skill Distributions by Type

| Mission Type | Speaking | Listening | Vocabulary | Pronunciation | Reading | Writing |
|-------------|---------|----------|-----------|--------------|---------|---------|
| Discovery | 60–70 | 15–25 | 5–15 | 5–10 | 0–5 | 0 |
| Practice | 65–75 | 15–20 | 5–10 | 5–10 | 0–5 | 0 |
| Challenge | 70–80 | 10–20 | 0–5 | 5–10 | 0–5 | 0 |
| Simulation | 45–60 | 25–35 | 0–5 | 5–10 | 0–5 | 0–5 |
| Recovery | 55–65 | 15–20 | 10–15 | 5–10 | 0–5 | 0 |

---

## 5. Difficulty Scale Definition

The `difficulty` field uses a 1–10 scale with clear anchors:

| Level | Description | What the Learner Does | Support Available |
|-------|-------------|----------------------|-------------------|
| 1 | First encounter | Echoes single phrases after model | Full text + audio + hints |
| 2 | Basic recall | Produces memorized phrases from prompts | Text visible, model on request |
| 3 | Supported production | Produces phrases with keyword cues | Keywords only, no full text |
| 4 | Guided production | Constructs responses from situational prompts | Situation described, no German shown |
| 5 | Independent production | Handles routine scenarios without support | No scaffolding for known material |
| 6 | Complex production | Handles multi-step scenarios | Emergency phrases available only |
| 7 | Sustained production | Maintains extended German interaction (5+ turns) | No support |
| 8 | Pressured production | Responds under time constraints | Timer visible |
| 9 | Unpredictable production | Handles unexpected variations in scenarios | No preparation |
| 10 | Professional performance | Sustained high-quality output under real conditions | Assessment mode |

---

## 6. Prerequisite Rules

| Rule | Description |
|------|-------------|
| Acyclic | No circular prerequisites (validated automatically) |
| Module-bounded | Prerequisites cannot reference missions more than 2 modules ahead |
| Type-aware | Recovery missions have NO prerequisites (they must be accessible when needed) |
| First mission exemption | The first mission in Module 1 (`m01_001_d`) has no prerequisites |
| Explicit | Prerequisites are listed by ID, not implied by sequence number |
| Minimal | List only DIRECT prerequisites, not transitive chains |

---

## 7. Tag Conventions

Tags enable search, filtering, and adaptive selection. They follow these rules:

| Convention | Example | Use |
|-----------|---------|-----|
| Lowercase, underscore-separated | `formal_register` | Consistency |
| Domain tags match career_domains | `complaint_handling` | Cross-reference |
| Character tags use character ID | `herr_weber` | Filter by character |
| Emotional tags match emotion IDs | `productive_challenge` | Mood-based selection |
| Module position tags | `module_opener`, `module_closer` | Structural position |
| Grammar pattern tags | `modal_verb_kann`, `dative_case` | Grammar tracking |
| Phonetic focus tags | `ch_sound`, `umlauts` | Pronunciation focus |

---

## 8. Version Control

The `version` field tracks content updates to a mission:

| Version | Meaning |
|---------|---------|
| 1 | Initial release |
| 2+ | Content updated (vocabulary change, exercise rewrite, audio re-record) |

Version increments trigger:
- Re-validation through all three quality gates
- SRS items linked to changed vocabulary may be flagged for re-review
- Users who completed the mission see no disruption (progress is preserved)

---

*End of Part 02. Continue to `03_learning_objectives.md` for the objective writing standard.*
