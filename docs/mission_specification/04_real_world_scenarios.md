# Phoenix Mission Specification — Part 04: Real-World Scenarios

**Specification Version:** 1.0.0  

---

## 1. Scenario Design Philosophy

Every mission takes place inside a real-world scenario. There are no abstract exercises, no "practice pages," no decontextualized drills. The learner is always SOMEWHERE, talking to SOMEONE, for a REASON.

### The Real Test

Every scenario must pass this test:

> "Would this exact situation occur within the first 90 days of working at a German call center?"

If yes → the scenario is valid.  
If no → the scenario is rejected, regardless of its pedagogical utility.

### Why This Matters

- Contextual encoding is 3–5× stronger than decontextualized encoding (Godden & Baddeley, 1975)
- Career anchoring maintains motivation over months of study
- The learner always knows WHY they are learning something
- Transfer to real workplace is direct (no "but at work it's different" gap)

---

## 2. Scenario Schema

```yaml
scenario:
  # ─── Setting ────────────────────────────────────────────────
  setting: "Call center desk, Monday 9:05 AM, first day of training"
  
  # ─── Character ──────────────────────────────────────────────
  character: "frau_schmidt"                    # From character registry (§4)
  character_mood: "neutral_friendly"           # From mood vocabulary (§5)
  
  # ─── Situation Description ──────────────────────────────────
  situation: >
    It's your first morning at TeleService GmbH. You've been shown your 
    desk, your headset, your screen. Frau Müller, your team lead, says: 
    "Your first real call is coming. Remember the greeting formula. 
    You've got this." Your headset beeps. Incoming call.
  
  # ─── Stakes ─────────────────────────────────────────────────
  stakes: >
    First impression with a real customer. Professional reputation begins now.
  
  # ─── Sensory Details ────────────────────────────────────────
  sensory_details:
    visual: "Clean desk, headset, screen showing caller ID: Frau Schmidt"
    audio: "Phone ring tone, then subtle office ambiance"
  
  # ─── Trigger ────────────────────────────────────────────────
  trigger: "Headset beeps. Caller ID shows: Frau Schmidt. Answer now."
```

---

## 3. Field Specifications

### 3.1 Setting

A single sentence describing WHERE and WHEN the scenario takes place.

| Rule | Example |
|------|---------|
| Must include location | "Call center desk" / "Team meeting room" / "Interview office" |
| Should include time when relevant | "Monday 9:05 AM" / "End of shift, 17:45" |
| May include narrative position | "first day of training" / "second week on the floor" |
| Must be realistic for German workplace | No fantasy, no unlikely situations |

### 3.2 Character

References a character from the official registry (§4). Every scenario involves ONE primary interaction partner.

### 3.3 Character Mood

The character's emotional state at the START of the interaction. Affects:
- Their speech pace and tone (audio recording direction)
- The learner's required emotional register in response
- The scenario's overall difficulty

### 3.4 Situation

2–4 sentences that immerse the learner in the scenario. Written in second person ("You"). Present tense. Must include:
- What just happened (context)
- What's about to happen (anticipation)
- The learner's role (agent, interviewee, colleague)

### 3.5 Stakes

What depends on the learner's performance? This is the emotional hook that transforms "practice" into "performance." Stakes must be:
- Realistic (not melodramatic)
- Professional (connected to workplace success)
- Motivating without being anxiety-inducing

### 3.6 Sensory Details

Brief descriptions that guide UI/audio design:
- `visual`: What the learner sees on screen (guides UI mockup)
- `audio`: Environmental sounds (guides audio mixing)

### 3.7 Trigger

The moment that requires the learner's FIRST action. Always ends with an imperative or clear signal that "your turn starts NOW."

---

## 4. Character Registry

All scenarios use characters from this official registry. Characters provide:
- Consistent voice and personality across 500+ missions
- Narrative continuity (learner builds relationships)
- Memory hooks (information tied to characters is recalled better)
- Emotional variety (different characters create different challenges)

### 4.1 Customer Characters

| ID | Name | Role | Speech Pace | Register | Personality | Typical Mood |
|----|------|------|------------|----------|-------------|-------------|
| `frau_schmidt` | Frau Schmidt | Regular customer | Slow, very clear | Formal | Kind, patient, elderly, appreciative | Friendly → Grateful |
| `herr_weber` | Herr Weber | Difficult customer | Fast, clipped | Formal (sometimes drops) | Impatient, skeptical, history of complaints | Frustrated → Angry |
| `frau_bauer` | Frau Bauer | Confused customer | Moderate, repetitive | Formal | Elderly, uncertain, asks same thing twice | Confused → Reassured |
| `herr_klein` | Herr Klein | Busy customer | Very fast, efficient | Formal but terse | Business-minded, no small talk, values speed | Neutral → Impatient if slow |
| `dr_hoffmann` | Dr. Hoffmann | VIP client | Fast, precise, complex sentences | Very formal | Demanding, expects perfection, educated | Neutral → Critical |
| `jana_mueller` | Jana Müller | Young customer | Natural pace, casual | Mixed (uses du sometimes) | Friendly, tech-savvy, informal | Casual → Confused |

### 4.2 Colleague Characters

| ID | Name | Role | Speech Pace | Register | Personality | Purpose in Missions |
|----|------|------|------------|----------|-------------|-------------------|
| `frau_mueller_tl` | Frau Müller (TL) | Team leader | Moderate, clear | Professional | Supportive, structured, occasionally dry humor | Briefings, debriefs, guidance |
| `thomas` | Thomas | Senior colleague | Casual, natural | Informal with colleagues | Friendly, relaxed, uses slang occasionally | Informal German practice, tips |
| `amir` | Amir | Fellow trainee | Moderate, accented | Informal | Encouraging, also learning, makes mistakes | Normalizes struggle, relatability |
| `lisa` | Lisa | IT support | Moderate, technical | Neutral | Patient, methodical, explains clearly | Technical vocabulary scenarios |
| `herr_braun` | Herr Braun | Supervisor | Measured, authoritative | Formal | Fair, direct, evaluative | Assessment scenarios, feedback |

### 4.3 System Characters

| ID | Name | Role | Purpose |
|----|------|------|---------|
| `system` | System/Narrator | App narration | Stage directions, transitions, scene-setting |
| `coach` | Coach (Frau Müller voice) | Session coaching | Daily coaching messages, pre/post-mission guidance |

### 4.4 Character Usage Rules

| Rule | Rationale |
|------|-----------|
| Frau Schmidt appears in Modules 1–6 (early, accessible) | Gentle introduction to customer interactions |
| Herr Weber appears from Module 5 onward (difficulty) | Challenge escalation |
| Dr. Hoffmann appears from Module 8 onward (advanced) | Very formal register pressure |
| Amir appears throughout (peer support) | Continuous emotional safety |
| Thomas provides informal contrast from Module 5 | Register awareness training |
| Each character maintains consistent personality across all missions | Narrative coherence |
| Characters NEVER break their personality for pedagogical convenience | Authenticity > pedagogy |

---

## 5. Mood Vocabulary (Controlled)

The `character_mood` field uses standardized values:

### Customer Moods

| Mood ID | Description | Speech Characteristics | Challenge Level |
|---------|-------------|----------------------|-----------------|
| `neutral_friendly` | Polite, standard interaction | Clear, patient, normal pace | Low |
| `neutral_business` | Professional, no emotion | Efficient, minimal small talk | Low |
| `mildly_confused` | Doesn't fully understand something | Repetitive, asks clarifying questions | Medium |
| `moderately_frustrated` | Experienced a problem, losing patience | Slightly faster, more direct | Medium |
| `openly_angry` | Very upset, may raise voice | Fast, interrupts, emotional language | High |
| `anxious_urgent` | Time-sensitive problem | Rushed, stressed, needs reassurance | Medium-High |
| `disappointed_resigned` | Has given up expecting help | Flat affect, short answers | Medium |
| `grateful_relieved` | Problem was solved | Warm, appreciative, relaxed | Low |
| `formal_demanding` | Expects high-quality service | Precise, evaluative, no tolerance for errors | High |

### Colleague Moods

| Mood ID | Description |
|---------|-------------|
| `supportive_coaching` | Teaching, guiding, patient |
| `casual_friendly` | Relaxed, humorous, informal |
| `professionally_neutral` | Work-focused, neither warm nor cold |
| `evaluative_fair` | Assessing performance, giving honest feedback |

---

## 6. Emotional Goal Framework

Every mission declares the emotional experience it intends to create.

### Schema

```yaml
emotional_goal:
  primary_emotion: "professional_confidence"
  entry_feeling: "Slightly nervous but ready — this is what I came here for"
  exit_feeling: "I just answered a phone in German. Professionally. On my first mission."
  confidence_vector: "positive"
  vulnerability_level: "moderate"
```

### 6.1 Primary Emotion (Controlled Vocabulary)

| Emotion ID | Description | When Used |
|-----------|-------------|-----------|
| `professional_confidence` | "I can do this job" | Career scenarios, successful completions |
| `discovery_excitement` | "I didn't know I could do that!" | Phonetic bridges, first successes |
| `calm_competence` | "This is routine now" | Practice/review of mastered material |
| `productive_challenge` | "This is hard but I'm growing" | Challenge missions, new difficulty |
| `earned_pride` | "I accomplished something real" | Major simulation completions |
| `safe_exploration` | "It's okay to experiment here" | New material introduction |
| `relieved_recovery` | "I'm back on track" | Recovery missions |
| `forward_momentum` | "I can see where this is going" | Module transitions |

### 6.2 Confidence Vector

| Value | Meaning | Effect on Design |
|-------|---------|-----------------|
| `positive` | Learner should feel MORE confident after | End with clear success, celebrate |
| `consolidating` | Learner should feel STABLE (maintaining) | Steady, no big highs or lows |
| `stretching` | Learner should feel CHALLENGED but not defeated | Hard content, explicit acknowledgment of difficulty |

### 6.3 Vulnerability Level

| Level | Description | Support Design |
|-------|-------------|---------------|
| `low` | Learner is in familiar territory | Standard scaffolding |
| `moderate` | Learner is stretching into new territory | Extra safety nets, reassuring feedback |
| `high` | Learner faces significant challenge (first simulation, first interview) | Maximum emotional safety, explicit normalization |

---

## 7. Scenario Progression Across the Curriculum

Scenarios follow a narrative arc across all 12 modules:

```
Module 1–2: "PREPARING"
────────────────────────
Scenarios: Daily life in Germany (apartment, transport, shopping)
Interaction partner: Service staff, landlord, acquaintances
Emotional tone: Discovery, building first confidence
Register: Mix of formal and informal

Module 3–4: "ARRIVING AT WORK"
──────────────────────────────
Scenarios: First day, orientation, learning the phone system
Interaction partner: Frau Müller (TL), Thomas, Amir
Emotional tone: Nervous excitement, steep learning curve
Register: Workplace professional

Module 5–6: "TRAINING ON THE FLOOR"
────────────────────────────────────
Scenarios: First calls (supervised), basic customer issues
Interaction partner: Frau Schmidt, gentle customers, then Herr Weber
Emotional tone: Growing confidence → first real challenges
Register: Strictly formal with customers

Module 7–8: "HANDLING REAL PROBLEMS"
────────────────────────────────────
Scenarios: Complex calls, angry customers, billing, technical
Interaction partner: Herr Weber, Frau Bauer, Herr Klein
Emotional tone: Professional challenge, occasional overwhelm
Register: Formal + empathy register

Module 9–10: "ADVANCING"
─────────────────────────
Scenarios: Job interviews, team meetings, performance reviews
Interaction partner: Herr Braun, external interviewers
Emotional tone: Professional identity forming
Register: Very formal (interview) + collegial (meetings)

Module 11–12: "MASTERING"
──────────────────────────
Scenarios: Full shifts, complex multi-issue calls, quality evaluation
Interaction partner: All characters, unpredictable combinations
Emotional tone: Confidence → readiness
Register: All registers as situation demands
```

---

## 8. Scenario Writing Checklist

Before any scenario is finalized, it must pass these checks:

- [ ] Passes the "Real Test" (would happen in a German workplace)
- [ ] Names a specific character from the registry
- [ ] Declares a mood from the controlled vocabulary
- [ ] Includes stakes that motivate without inducing anxiety
- [ ] Situation is written in second person, present tense
- [ ] Trigger clearly signals "your turn to speak"
- [ ] Setting is specific enough to guide UI/audio design
- [ ] Emotional goal is declared and achievable within the mission
- [ ] Scenario connects to at least one career domain
- [ ] No cultural stereotypes or assumptions about the learner

---

*End of Part 04. Continue to `05_vocabulary_system.md` for the chunk-first vocabulary specification.*
