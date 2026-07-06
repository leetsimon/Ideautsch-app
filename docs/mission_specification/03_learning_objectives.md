# Phoenix Mission Specification — Part 03: Learning Objectives

**Specification Version:** 1.0.0  

---

## 1. The Standard

Every mission has exactly ONE learning objective. It follows this formula:

> **"After this mission, the learner can [OBSERVABLE ACTION] in [SPECIFIC CONTEXT]."**

The objective must be:
- **Observable** — You can hear or see whether they achieved it
- **Producible** — It describes something they can DO (speak, write, respond), not know or understand
- **Contextual** — It specifies WHERE this skill is used
- **Singular** — One skill. Not two. Not five. One.
- **Testable** — The success criteria can validate it directly

---

## 2. Schema

```yaml
learning_objective:
  statement_en: >
    After this mission, the learner can answer a phone call with a 
    professional German greeting including company name and offer to help.
  statement_darija: >
    بعد هاد المهمة، المتعلم يقدر يجاوب على تيليفون بتحية ألمانية 
    احترافية فيها اسم الشركة وعرض المساعدة.
```

### Rules

| Field | Required | Constraints |
|-------|----------|-------------|
| `statement_en` | Yes | Must start with "After this mission, the learner can" |
| `statement_darija` | Yes | Natural Darija translation (not word-for-word) |

---

## 3. Approved Action Verbs

Objectives MUST use verbs from this list. These are all producible, observable actions:

### Speaking Verbs (Primary)

| Verb | Meaning | Example Context |
|------|---------|-----------------|
| `answer` | Respond verbally to a prompt | answer a phone call |
| `greet` | Produce an appropriate greeting | greet a customer professionally |
| `introduce` | Present oneself verbally | introduce themselves in an interview |
| `ask` | Formulate a question | ask for the customer's order number |
| `explain` | Describe a process or situation | explain a delivery status |
| `confirm` | Verify information verbally | confirm an address change |
| `apologize` | Produce an appropriate apology | apologize for a delay professionally |
| `de-escalate` | Calm an upset interlocutor | de-escalate a frustrated customer |
| `redirect` | Guide a conversation elsewhere | redirect a customer to the correct department |
| `negotiate` | Discuss terms or alternatives | negotiate a solution with a customer |
| `present` | Deliver prepared content | present their work experience |
| `narrate` | Tell a sequence of events | narrate what happened with an order |
| `request` | Ask for something formally | request the customer to hold |
| `refuse` | Decline politely | refuse a request within company policy |
| `summarize` | Condense information verbally | summarize the call resolution |
| `instruct` | Give step-by-step guidance | instruct a customer to reset their password |

### Listening Verbs (Secondary)

| Verb | Meaning | Example Context |
|------|---------|-----------------|
| `identify` | Recognize key information from audio | identify the customer's main issue |
| `extract` | Pull specific data from speech | extract an order number from a phone call |
| `distinguish` | Tell apart similar items | distinguish a complaint from an inquiry |
| `follow` | Track multi-step audio content | follow a customer's description of their problem |

### Writing Verbs (Tertiary)

| Verb | Meaning | Example Context |
|------|---------|-----------------|
| `compose` | Write a short professional text | compose a follow-up email |
| `document` | Write a record of an interaction | document a customer complaint |
| `type` | Enter information accurately | type a dictated address correctly |

---

## 4. Forbidden Verbs

These verbs are NEVER used in learning objectives because they are not observable or producible:

| Forbidden Verb | Why | Replace With |
|---------------|-----|--------------|
| understand | Not observable (internal state) | respond to, identify, explain |
| know | Not producible | produce, recall, use |
| learn | Describes process, not outcome | produce, demonstrate, perform |
| practice | Activity, not achievement | produce, handle, complete |
| remember | Not directly observable | recall, produce from memory |
| recognize | Passive (recognition ≠ production) | produce, respond with |
| appreciate | Internal emotional state | demonstrate awareness of |
| be familiar with | Vague, untestable | use correctly, produce |
| review | Activity, not outcome | produce independently |
| memorize | Process, not outcome | produce from memory in context |

---

## 5. Context Specifications

The `[SPECIFIC CONTEXT]` part of the objective must reference a real-world situation:

### Approved Contexts (Examples by Module)

| Module | Context Examples |
|--------|-----------------|
| 1 | "in a basic social introduction" |
| 2 | "when ordering food at a restaurant" |
| 3 | "during a phone call to make an appointment" |
| 4 | "when answering a business phone call" |
| 5 | "in a standard customer service interaction" |
| 6 | "when a customer is upset about a delivery" |
| 7 | "during a technical troubleshooting call" |
| 8 | "in a multi-step billing inquiry" |
| 9 | "during a German job interview" |
| 10 | "in a team meeting discussion" |
| 11 | "under time pressure in a live call center environment" |
| 12 | "during a formal B1 speaking assessment" |

### Context Rules

| Rule | Rationale |
|------|-----------|
| Must name a specific location or situation | Forces real-world applicability |
| Must be a situation the learner will actually encounter | Career anchoring |
| Must be testable within the mission's exercises | The mission itself validates the objective |
| Cannot be abstract ("in German") — must be specific | Precision drives design |

---

## 6. Examples: Correct vs. Incorrect

### Module 1 (A0 → A1.1)

| Status | Objective |
|--------|-----------|
| ✅ Correct | "After this mission, the learner can answer a phone call with a professional German greeting including company name and offer to help." |
| ❌ Incorrect | "The learner will learn phone greetings." |
| ❌ Incorrect | "After this mission, the learner understands how to greet." |
| ❌ Incorrect | "After this mission, the learner can greet, introduce, ask questions, and close a call." (Multiple objectives) |

### Module 5 (A1.2 → A2.1)

| Status | Objective |
|--------|-----------|
| ✅ Correct | "After this mission, the learner can acknowledge a customer's frustration using at least two empathy phrases in German." |
| ❌ Incorrect | "The learner will practice empathy phrases." |
| ❌ Incorrect | "After this mission, the learner knows 5 empathy phrases." |

### Module 9 (A2.2 → B1.1)

| Status | Objective |
|--------|-----------|
| ✅ Correct | "After this mission, the learner can present their work experience in a German job interview for at least 45 seconds with appropriate structure and vocabulary." |
| ❌ Incorrect | "The learner will prepare for interviews." |

---

## 7. Darija Translation Standard

The `statement_darija` field must:

| Rule | Example |
|------|---------|
| Use Moroccan Darija (not MSA) | "يقدر يجاوب" not "يستطيع أن يجيب" |
| Be natural speech (not literal translation) | Rewrite for how a Moroccan would explain it |
| Include French loanwords where natural in Darija | "تيليفون" not "هاتف" |
| Transliterate when helpful | Can include Latin-script Darija alongside Arabic script |
| Match the MEANING, not the words | The Darija should convey the same skill goal |

### Translation Example

```
English: "After this mission, the learner can answer a phone call with 
a professional German greeting including company name and offer to help."

Darija: "بعد هاد المهمة، المتعلم يقدر يجاوب على تيليفون بتحية ألمانية 
احترافية فيها اسم الشركة وعرض المساعدة."

(NOT MSA: "بعد هذه المهمة، يستطيع المتعلم الرد على مكالمة هاتفية...")
```

---

## 8. Objective-to-Assessment Alignment

Every learning objective MUST be directly testable by the mission's success criteria. The alignment works as follows:

| Objective Component | Maps To |
|--------------------|---------|
| The ACTION verb | The exercise type that tests it (e.g., "answer" → conversation exercise) |
| The CONTEXT | The scenario setting |
| The QUALITY standard | The confidence scoring thresholds |
| The SPECIFICS | The acceptable_responses patterns in the dialogue |

If you cannot test the objective within the mission's exercises, the objective is wrong — not the exercises.

---

*End of Part 03. Continue to `04_real_world_scenarios.md` for scenario design and character registry.*
