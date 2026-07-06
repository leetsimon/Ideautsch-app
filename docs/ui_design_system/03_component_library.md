# Phoenix UI Design System — Part 03: Component Library

**Version:** 1.0.0  

---

## 1. Buttons

### Primary Button (Filled)

```
┌─────────────────────────────────┐
│    ▶  Start Mission              │  ← icon + label
└─────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| Height | 52px |
| Padding | 16px vertical, 24px horizontal |
| Radius | 12px |
| Background | brand.primary |
| Text | label.large, white, 500 weight |
| Icon | 20px, white, 8px gap before label |
| Press state | scale(0.97), 150ms |
| Disabled | 40% opacity, no press feedback |
| Full-width variant | Available (isExpanded=true) |

### Secondary Button (Outlined)

| Property | Value |
|----------|-------|
| Border | 1.5px, brand.primary |
| Background | transparent |
| Text | label.large, brand.primary |
| Hover/Focus | primarySoft background at 8% |

### Text Button

| Property | Value |
|----------|-------|
| Background | none |
| Text | label.large, brand.primary |
| Press | background primarySoft at 8% |

---

## 2. Cards

### Standard Card

```
┌─────────────────────────────────┐
│                                  │
│  Card content                    │
│                                  │
└─────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| Background | surface.card |
| Border | 1px, border color |
| Radius | 16px |
| Padding | 16px |
| Shadow | shadow.sm (light) / none (dark, uses border) |
| Hover (desktop) | shadow.md, border.primary at 20% |

### Highlighted Card (Yasmina, info)

| Property | Value |
|----------|-------|
| Background | primarySoft at 40% |
| Border | 1px, primary at 20% |
| Radius | 16px |

### Stat Card

| Property | Value |
|----------|-------|
| Background | semantic color at 6% |
| Border | 1px, semantic color at 12% |
| Radius | 16px |
| Content | Icon (20px, color) + value (title.small, bold) + label (label.small) |

---

## 3. Microphone Button

### Idle State

```
      ╔═══════╗
      ║       ║
      ║   🎤  ║   80px circle
      ║       ║   brand.primary bg
      ╚═══════╝   shadow.glow (primary/20%)
```

### Recording State

```
      ╔═══════╗
      ║       ║   
      ║   ⏹  ║   80px circle
      ║       ║   error.red bg
      ╚═══════╝   pulsing scale (1.0→1.06, 1200ms loop)
                   shadow.glow (red/30%)
```

| Property | Idle | Recording |
|----------|------|-----------|
| Size | 80px | 80px |
| Background | brand.primary | feedback.error (red) |
| Icon | mic_rounded, 32px, white | stop_rounded, 32px, white |
| Shadow | primary glow | red glow (stronger) |
| Animation | none | scale pulse 1200ms |
| Touch target | 80px (exceeds 48px min) | Same |

---

## 4. Progress Bar

### Linear (Mission Progress)

```
  3/10  ━━━━━━━●━━━━━━━━━━━  30%
```

| Property | Value |
|----------|-------|
| Height | 6px |
| Track color | surface.dim |
| Fill color | brand.primary |
| Radius | 3px (fully rounded) |
| Animation | TweenAnimationBuilder, 400ms, easeOutCubic |
| Counter | label.medium left (text.secondary) |
| Percentage | label.medium right (primary, bold) |

### Circular (Career Readiness)

| Property | Value |
|----------|-------|
| Diameter | 120px (home), 80px (compact) |
| Stroke | 8px (home), 6px (compact) |
| Track | surface.dim |
| Fill | brand.primary |
| Cap | StrokeCap.round |
| Animation | 800ms, easeOutCubic |
| Center content | Percentage (heading.medium, primary) + label (label.small) |

---

## 5. Audio Waveform

```
  ▎▌█▎▌▎█▌▎█▎▌▎▌█▎█▌▎█▎▌▎█▌
```

| Property | Value |
|----------|-------|
| Height | 48px |
| Bar count | 24 |
| Bar width | 3px |
| Bar gap | 3px (1.5px padding each side) |
| Bar radius | 2px |
| Idle color | surface.dim |
| Active color | brand.primary (recording) / accent.teal (playback) |
| Animation | Randomized heights, 150ms update interval |
| Reduced motion | Static bars at varied heights (no animation) |

---

## 6. Yasmina Card

```
┌─────────────────────────────────────┐
│  (Y) Yasmina                         │
│                                      │
│  Coaching message text goes here.    │
│  Multiple lines with generous        │
│  line height for readability.        │
│                                      │
│                     [Continue →]     │
└─────────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| Background | primarySoft at 40% |
| Border | 1px, primary at 20% |
| Radius | 16px |
| Padding | 16px |
| Avatar | YasminaAvatar, 32px, top-left |
| Name label | title.small, primary, bold, 8px from avatar |
| Message | body.medium, text.primary, height 1.6, 12px below name |
| Action button | TextButton "Continue →", primary, bottom-right |
| Entrance animation | fadeIn + slideY(10%), 400ms, easeOut |

---

## 7. Feedback Overlay

### Bottom Sheet Style

| Property | Value |
|----------|-------|
| Position | Bottom of screen, slides up |
| Background | surface.card |
| Top radius | 16px |
| Shadow | shadow.lg (upward) |
| Padding | 24px |
| Max height | 40% of screen |
| Animation | slideY(30%→0) + fadeIn, 300ms |

### Content Layout

| Row | Content |
|-----|---------|
| 1 | Icon (28px, state color) + Label (title.medium, state color) |
| 2 | Feedback text (body.medium, text.primary) — 16px below |
| 3 | Buttons row (Model + [Retry +] Continue) — 24px below |

---

## 8. Exercise Container

Every exercise screen shares this structure:

```
┌─────────────────────────────────────┐
│  [Progress Bar]                      │  ← Fixed top
│                                     │
│  [Exercise Content Area]             │  ← Scrollable center
│  (varies by type)                    │
│                                     │
│  [Action Area]                       │  ← Fixed bottom (mic, button, etc.)
│                                     │
│  [Feedback Overlay]                  │  ← Slides over when showing
└─────────────────────────────────────┘
```

| Zone | Behavior |
|------|----------|
| Progress bar | Always visible, 52px height (bar + counters + 16px padding) |
| Content area | Fills available space, vertically centered content |
| Action area | Fixed to bottom, contains primary interaction (mic, button) |
| Feedback | Overlays bottom 40%, pushes content up slightly |

---

## 9. Option Buttons (Comprehension)

```
┌─────────────────────────────────────┐
│  Answer option text here             │
└─────────────────────────────────────┘
```

| State | Background | Border | Text Color |
|-------|-----------|--------|-----------|
| Default | transparent | 1.5px border | text.primary |
| Hover | primarySoft at 5% | border | text.primary |
| Selected (correct) | successSoft | 2px success | success |
| Selected (incorrect) | warningSoft | 2px warning | warning |
| Disabled | surface.dim at 50% | border at 50% | text.tertiary |

| Property | Value |
|----------|-------|
| Height | auto (min 52px) |
| Padding | 16px |
| Radius | 12px |
| Text | body.medium, left-aligned |
| Spacing between options | 8px |

---

## 10. German Text Display

When German text is shown to the learner as the thing they need to produce:

```
┌─────────────────────────────────────┐
│                                      │
│    Guten Tag, wie kann ich           │
│    Ihnen helfen?                     │
│                                      │
└─────────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| Container | surface.dim bg, radius.md, padding.lg |
| Text | german.display (24px), Medium weight, centered |
| Color | text.primary |
| Letter spacing | 0.1px |
| Alignment | center |
| Max width | 100% with 16px internal padding |
| Purpose | "This is the German phrase — read it, say it, own it" |

---

## 11. Page Indicator (Onboarding)

```
  ━━━●━━━━━━
```

| Property | Value |
|----------|-------|
| Bar count | Equal to page count |
| Bar height | 3px |
| Bar gap | 4px |
| Active color | brand.primary |
| Inactive color | surface.dim |
| Radius | 2px |
| Total width | Full width minus 48px margin |
| Animation | Color transition 200ms on page change |

---

## 12. Stat Tile

```
┌──────────┐
│    🎤    │
│   42s    │
│  Speaking │
└──────────┘
```

| Property | Value |
|----------|-------|
| Background | semantic color at 6% |
| Border | 1px, semantic color at 12% |
| Radius | 16px |
| Padding | 12px |
| Icon | 20px, semantic color |
| Value | title.small, bold, text.primary |
| Label | label.small, text.secondary |
| Layout | Column, center-aligned |
| Arrangement | 3 in a Row, equal flex |

---

## 13. Accessibility Compliance

| Component | Min Touch Target | Focus Ring | Screen Reader |
|-----------|-----------------|-----------|---------------|
| Button | 48×48dp | 2px primary outline, 2px offset | Label read aloud |
| Mic button | 80×80dp | Glow increases on focus | "Record. Double-tap to start recording" |
| Card (tappable) | Full card area | Border changes to primary | Title + subtitle read |
| Option | Full width × 52dp+ | Border changes to primary | Option text + "button" role |
| Switch | 48×48dp (Material default) | Focus ring on thumb | "Toggle [name]. Currently [on/off]" |
| Progress ring | N/A (display only) | N/A | "[X] percent career readiness" |
| Waveform | N/A (display only) | N/A | "Audio recording active" |

---

*End of Part 03 — Component Library complete.*
