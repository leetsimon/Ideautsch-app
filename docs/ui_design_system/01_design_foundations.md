# Phoenix UI Design System — Part 01: Foundations

**Version:** 1.0.0  
**Date:** July 6, 2026  

---

## 1. Design Philosophy

Phoenix's visual language is built on five principles:

| Principle | Expression | Anti-Pattern |
|-----------|-----------|-------------|
| **Calm** | Generous whitespace, soft transitions, muted palette | Cramped layouts, jarring colors, visual noise |
| **Premium** | Studio-quality typography, precise spacing, rich but restrained color | Generic Material defaults, system fonts, flat design |
| **Modern** | Clean geometry, glass morphism accents, motion design | Skeuomorphism, rounded cartoon elements, heavy shadows |
| **Adult** | Professional imagery, business context, serious tone | Cartoon mascots, childish colors, game-like UI |
| **Minimal** | One primary action per screen, content is the hero | Cluttered toolbars, multiple CTAs competing |

### Design DNA Inspirations

| Source | What We Take | What We Leave |
|--------|-------------|--------------|
| **Notion** | Clean type hierarchy, generous spacing, monochrome + single accent | Complexity, customization overload |
| **Linear** | Crisp cards, status indicators, focused workflows | Developer-centric density |
| **Headspace** | Emotional warmth, calming transitions, breathing room | Illustration-heavy style |
| **Apple HIG** | Content-first, systematic spacing, accessibility excellence | Platform-exclusive patterns |
| **Duolingo** | NOTHING | Gamification chrome, cartoon characters, neon colors |

---

## 2. Color System

### 2.1 Palette Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    LIGHT MODE                             │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Background:    #FAFBFD (cool white, slight blue tint)   │
│  Surface:       #FFFFFF (pure white cards)                │
│  Surface Dim:   #F2F3F7 (secondary surfaces)             │
│                                                          │
│  Primary:       #1E3A5F (Deep Navy)                      │
│  On Primary:    #FFFFFF                                   │
│  Primary Soft:  #E8EEF5 (primary at 10% opacity)         │
│                                                          │
│  Accent:        #D4A853 (Warm Gold — achievements)       │
│  Accent Soft:   #FBF5E8                                  │
│                                                          │
│  Success:       #2D8B57 (Confident Green)                │
│  Warning:       #D4883A (Warm Amber)                     │
│  Error:         #C4473A (Muted Red — never harsh)        │
│                                                          │
│  Text Primary:  #1A1D26 (near-black, not pure black)     │
│  Text Secondary:#6B7280 (medium gray)                    │
│  Text Tertiary: #9CA3AF (light gray)                     │
│                                                          │
│  Border:        #E5E7EB (subtle separation)              │
│  Border Focus:  #1E3A5F (primary, on focus)              │
│                                                          │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                    DARK MODE                              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Background:    #0D1117 (near-black, slight blue)        │
│  Surface:       #161B22 (elevated dark)                   │
│  Surface Dim:   #1C2128 (cards, containers)              │
│                                                          │
│  Primary:       #7EB1E0 (Soft Blue — lighter for dark)   │
│  On Primary:    #0D1117                                   │
│  Primary Soft:  #1E3A5F at 20% opacity                   │
│                                                          │
│  Accent:        #E8C97A (Brighter Gold for dark)         │
│  Success:       #5CB87A                                   │
│  Warning:       #E8A85C                                   │
│  Error:         #E06B5E                                   │
│                                                          │
│  Text Primary:  #E6EDF3 (off-white)                      │
│  Text Secondary:#8B949E                                   │
│  Text Tertiary: #6B7280                                   │
│                                                          │
│  Border:        #30363D                                   │
│  Border Focus:  #7EB1E0                                   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### 2.2 Semantic Color Usage

| Token | Light | Dark | Used For |
|-------|-------|------|----------|
| `surface.background` | #FAFBFD | #0D1117 | Page backgrounds |
| `surface.card` | #FFFFFF | #161B22 | Cards, containers |
| `surface.elevated` | #FFFFFF + shadow | #1C2128 | Modals, bottom sheets |
| `brand.primary` | #1E3A5F | #7EB1E0 | CTAs, links, active states |
| `brand.primarySoft` | #E8EEF5 | #1E3A5F/20% | Badges, soft backgrounds |
| `feedback.success` | #2D8B57 | #5CB87A | Correct answers, progress |
| `feedback.warning` | #D4883A | #E8A85C | Partial, needs improvement |
| `feedback.error` | #C4473A | #E06B5E | Incorrect (never "wrong") |
| `accent.gold` | #D4A853 | #E8C97A | Achievements, milestones |
| `accent.teal` | #1A7A6D | #4DB8A8 | Career readiness, growth |

### 2.3 Color Rules

1. **Maximum 3 colors visible simultaneously** (primary + 1 semantic + neutral)
2. **No pure black (#000000)** — always use near-black with blue tint
3. **No pure white (#FFFFFF) as background** — always slightly warm or cool
4. **Accent gold ONLY for achievements/milestones** — never for buttons
5. **Error red is NEVER labeled "wrong"** — always "adjustment needed"
6. **Success green appears AFTER learner action** — never before
7. **Primary color = trust, focus, navigation** — the app's signature

---

## 3. Typography System

### 3.1 Type Scale

| Token | Size | Weight | Line Height | Letter Spacing | Use |
|-------|------|--------|-------------|----------------|-----|
| `display.large` | 36px | Bold (700) | 1.2 | -0.5 | Module titles, hero text |
| `display.medium` | 28px | Bold (700) | 1.25 | -0.3 | Mission titles |
| `heading.large` | 22px | SemiBold (600) | 1.3 | 0 | Section headers |
| `heading.medium` | 18px | SemiBold (600) | 1.35 | 0 | Card titles |
| `heading.small` | 16px | SemiBold (600) | 1.4 | 0 | Subsection headers |
| `body.large` | 16px | Regular (400) | 1.6 | 0.2 | Primary content text |
| `body.medium` | 14px | Regular (400) | 1.5 | 0.15 | Secondary content |
| `body.small` | 12px | Regular (400) | 1.5 | 0.3 | Captions, timestamps |
| `label.large` | 14px | Medium (500) | 1.4 | 0.5 | Button text |
| `label.medium` | 12px | Medium (500) | 1.4 | 0.5 | Tags, badges |
| `label.small` | 10px | Medium (500) | 1.4 | 0.8 | Overlines, tiny labels |
| `german.display` | 24px | Medium (500) | 1.5 | 0.1 | German learning content (primary) |
| `german.body` | 20px | Regular (400) | 1.5 | 0.1 | German text in exercises |
| `german.small` | 16px | Regular (400) | 1.5 | 0.1 | German in compact contexts |

### 3.2 Font Family

**Primary:** Inter (variable weight, 400–700)
- All UI text, headings, body, labels
- Reason: Exceptional readability at all sizes, professional aesthetic, variable font for performance

**Arabic:** Noto Sans Arabic (400)
- Darija translations, Arabic script content
- Reason: Complete Arabic character support, harmonizes with Inter's metrics

**German Content:** Inter Medium (500) at larger sizes
- German phrases and vocabulary displayed to the learner
- Slightly larger (1.25x) than surrounding UI text for emphasis and readability

### 3.3 Typography Rules

1. **German text is always visually prominent** — larger, slightly heavier
2. **Maximum 2 font weights per screen** — usually Regular + SemiBold
3. **Body text NEVER below 14px** — accessibility minimum
4. **Line height for body text: always ≥ 1.5** — readability for language content
5. **Letter spacing increases at small sizes** — legibility compensation
6. **No ALL CAPS for more than 2 words** — accessibility (except labels)
7. **RTL support ready** — Darija content may need RTL rendering

---

## 4. Spacing System

### 4.1 Base Grid

All spacing uses an **8px base grid** with 4px half-steps:

| Token | Value | Use |
|-------|-------|-----|
| `space.2xs` | 2px | Optical adjustments only |
| `space.xs` | 4px | Tight internal spacing |
| `space.sm` | 8px | Between related elements |
| `space.md` | 12px | Component internal padding |
| `space.lg` | 16px | Card padding, section gaps |
| `space.xl` | 20px | Between sections |
| `space.2xl` | 24px | Page padding (horizontal) |
| `space.3xl` | 32px | Major section separation |
| `space.4xl` | 40px | Screen-level breathing room |
| `space.5xl` | 48px | Hero spacing, large gaps |
| `space.6xl` | 64px | Maximum separation |

### 4.2 Page Margins

| Context | Horizontal | Vertical (top) |
|---------|-----------|----------------|
| Phone (< 600px) | 24px | 16px |
| Tablet (600–900px) | 32px | 24px |
| Desktop (> 900px) | 48px (max-width: 680px centered) | 32px |

### 4.3 Component Spacing

| Component | Internal Padding | Between Components |
|-----------|-----------------|-------------------|
| Card | 16px all sides | 12px between cards |
| Button | 16px vertical, 24px horizontal | 12px between buttons |
| List item | 16px vertical, 0 horizontal | 0 (dividers separate) |
| Section | 0 (content defines) | 32px between sections |
| Modal/Sheet | 24px all sides | N/A |

---

## 5. Radius System

| Token | Value | Use |
|-------|-------|-----|
| `radius.xs` | 4px | Small chips, tags |
| `radius.sm` | 8px | Buttons, inputs |
| `radius.md` | 12px | Cards, containers |
| `radius.lg` | 16px | Large cards, sheets |
| `radius.xl` | 20px | Modals, hero cards |
| `radius.full` | 9999px | Pills, circular elements |

---

## 6. Shadow System

| Token | Light Mode | Dark Mode | Use |
|-------|-----------|-----------|-----|
| `shadow.sm` | 0 1px 2px rgba(0,0,0,0.04) | 0 1px 2px rgba(0,0,0,0.2) | Subtle elevation |
| `shadow.md` | 0 4px 8px rgba(0,0,0,0.06) | 0 4px 8px rgba(0,0,0,0.3) | Cards, dropdowns |
| `shadow.lg` | 0 8px 24px rgba(0,0,0,0.08) | 0 8px 24px rgba(0,0,0,0.4) | Modals, overlays |
| `shadow.glow` | 0 0 16px primary/20% | 0 0 16px primary/30% | Focus states, active mic |

**Dark mode shadow note:** In dark mode, elevation is communicated primarily through surface color lightening, not shadows. Shadows are present but less visible.

---

## 7. Motion System

### 7.1 Timing

| Token | Duration | Curve | Use |
|-------|----------|-------|-----|
| `motion.instant` | 100ms | easeOut | Micro-interactions (hover, focus) |
| `motion.fast` | 200ms | easeOut | Button presses, toggles |
| `motion.standard` | 300ms | easeOutCubic | Page elements appearing |
| `motion.emphasis` | 500ms | easeOutBack | Important reveals, celebrations |
| `motion.slow` | 800ms | easeOutCubic | Page transitions, large movements |

### 7.2 Principles

1. **Every animation has purpose** — if removing it changes nothing, remove it
2. **Enter with personality, exit quickly** — entrances are slower than exits
3. **Stagger related elements** — 50-100ms delay between siblings
4. **Never block interaction** — animations don't prevent user action
5. **Respect reduced-motion preference** — all animations respect OS settings
6. **Recording pulse is the most prominent animation** — it signals "I'm listening"

### 7.3 Key Animations

| Element | Animation | Timing |
|---------|-----------|--------|
| Page entrance | Fade in + slide up 16px | 300ms, easeOutCubic |
| Card appearance | Fade in + scale from 0.96 | 400ms, easeOut, staggered 80ms |
| Button press | Scale to 0.97, spring back | 150ms |
| Progress bar fill | Width animation | 400ms, easeOutCubic |
| Mic recording | Pulsing scale 1.0→1.06 | 1200ms, easeInOut, looping |
| Feedback slide-up | Slide from bottom + fade | 300ms, easeOut |
| Yasmina entrance | Fade in + slide from left 8px | 400ms, easeOut |
| Success state | Scale 0.8→1.0, spring | 600ms, easeOutBack |
| Number counter | Count up animation | 800ms, easeOutCubic |

---

## 8. Iconography

### 8.1 Icon Style

- **Library:** Material Symbols Rounded (weight 400, optical size 24)
- **Size:** 20px (compact), 24px (standard), 32px (emphasis)
- **Color:** Follows text color of context (primary, secondary, or on-surface)
- **Style:** Rounded corners, 2px stroke equivalent, filled variants for active states

### 8.2 Custom Icons (Phoenix-specific)

| Icon | Description | Used For |
|------|-------------|----------|
| Phoenix flame | Stylized flame (brand mark) | App icon, splash, achievements |
| Microphone active | Mic with pulse rings | Recording state |
| Career ring | Circular progress + briefcase | Career readiness |
| Yasmina | Circular avatar with "Y" initial | Coaching presence |
| Phone ringing | Handset with motion lines | Call simulation |
| Headset | Over-ear headset icon | Listening exercises |

---

## 9. Accessibility Standards

| Standard | Requirement | Implementation |
|----------|-------------|---------------|
| WCAG 2.1 AA contrast | ≥ 4.5:1 for body text, ≥ 3:1 for large text | All color pairs verified |
| Touch target | ≥ 48×48dp minimum | All interactive elements |
| Focus indicators | Visible 2px outline in primary color | All focusable elements |
| Screen reader | All images have alt text, all icons have labels | Semantic widgets used |
| Reduced motion | Animations respect `MediaQuery.disableAnimations` | Conditional animation |
| Font scaling | UI remains usable at 200% system font size | Flexible layouts, no fixed heights |
| Color independence | Information never conveyed by color alone | Icons + text always accompany color signals |

---

## 10. Responsive Breakpoints

| Breakpoint | Width | Layout | Target |
|-----------|-------|--------|--------|
| Mobile (default) | < 600px | Single column, full-width cards | Android phones |
| Tablet | 600–900px | Wider margins, max-width containers | Large phones, small tablets |
| Desktop | > 900px | Centered content (max 680px), sidebar possible | Windows desktop |

All screens are designed mobile-first, then adapted for desktop with wider margins and centered content. No screen requires a minimum width above 320px.

---

*End of Part 01. Continue to Part 02: Screen Specifications.*
