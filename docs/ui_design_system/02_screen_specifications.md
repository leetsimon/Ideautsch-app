# Phoenix UI Design System — Part 02: Screen Specifications

**Version:** 1.0.0  

---

## Screen 1: SPLASH

### Layout

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│                                     │
│                                     │
│           ╔═══╗                     │
│           ║🔥 ║  (Phoenix icon)     │
│           ╚═══╝                     │
│                                     │
│           Phoenix                   │
│                                     │
│    Dein Weg zum deutschen Beruf     │
│                                     │
│         ━━━━━━━━━━ (loader)         │
│                                     │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

### Specifications

| Element | Light | Dark |
|---------|-------|------|
| Background | #F8F9FC (cool off-white) | #0A0A12 (deep blue-black) |
| Icon | 56px, brand.primary | 56px, brand.primary |
| Icon container | 96px circle, radial gradient glow | Same, stronger glow |
| Title "Phoenix" | display.medium, text.primary | display.medium, text.primary |
| Subtitle | body.large, text.secondary | body.large, text.secondary |
| Loader | 120px wide, 3px height, primary color | Same |

### Animation Sequence

| Time | Element | Animation |
|------|---------|-----------|
| 0ms | Icon | Scale 0.6→1.0 (800ms, easeOutBack) + fadeIn |
| 300ms | Title | FadeIn + slideY 12px→0 (600ms) |
| 600ms | Subtitle | FadeIn (500ms) |
| 900ms | Loader | FadeIn (400ms), indeterminate progress |
| 2400ms | Whole screen | FadeOut (300ms) → navigate |

### Accessibility

- Screen reader: "Phoenix. Loading. Your path to a German career."
- No user interaction required
- Respects reduced-motion: instant display, no animations

---

## Screen 2: ONBOARDING (3 pages)

### Page 1: Welcome

```
┌─────────────────────────────────────┐
│  ━━━●━━━━━━  (page 1/3 indicator)   │
│                                     │
│                                     │
│           (Y)  Yasmina avatar       │
│            ↕ subtle pulse           │
│                                     │
│         مرحبا بيك                   │
│                                     │
│   I'm Yasmina. I made this         │
│   journey — Casablanca to          │
│   Düsseldorf, zero German to       │
│   Team Lead.                        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ This app teaches German for │   │
│  │ ONE goal: getting a job in  │   │
│  │ customer service.           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │         Continue →           │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Page 2: Goal Setting

```
┌─────────────────────────────────────┐
│  ━━━━━━●━━━  (page 2/3)            │
│                                     │
│          ⏱ (timer icon, 56px)       │
│                                     │
│   How much time can you             │
│   practice daily?                   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  10 minutes                  │   │
│  │  Light maintenance           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌═════════════════════════════┐   │
│  ║  25 minutes          ✓     ║   │
│  ║  Recommended — optimal     ║   │
│  └═════════════════════════════┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  45 minutes                  │   │
│  │  Intensive — fastest         │   │
│  └─────────────────────────────┘   │
│                                     │
│  You can change this anytime.       │
│                                     │
│  ┌─────────────────────────────┐   │
│  │         Continue →           │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Page 3: Ready

```
┌─────────────────────────────────────┐
│  ━━━━━━━━━●  (page 3/3)            │
│                                     │
│                                     │
│          🔥 (Phoenix icon, 72px)    │
│          ↕ scale entrance           │
│                                     │
│        You're ready.                │
│                                     │
│   In the next 10 minutes, you      │
│   will speak your first            │
│   professional German sentence.     │
│                                     │
│                                     │
│                                     │
│      ┌──────────────────┐          │
│      │ 📶 Works 100%   │          │
│      │    offline       │          │
│      └──────────────────┘          │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   🚀 Start Learning          │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Onboarding Specifications

| Element | Specification |
|---------|--------------|
| Page indicator | 3 bars, 3px height, active=primary, inactive=surfaceDim |
| Yasmina avatar | 80px, YasminaAvatar widget, isSpeaking=true |
| Arabic text (مرحبا بيك) | heading.large, text.primary |
| Body text | body.large, text.secondary, height 1.6 |
| Info card | surface.card + border, radius.md, padding.lg |
| Goal options | radius.md, border, selected=primarySoft bg + primary border 2px |
| Offline badge | accent.teal bg at 10%, teal text, radius.xs, label.medium |
| CTA button | Full width, filled, primary, radius.sm, padding 16v 24h |

---

## Screen 3: HOME DASHBOARD



### Home Layout

```
┌─────────────────────────────────────┐
│                                     │
│  Guten Morgen                       │
│  Ready for today's mission?    ⚙️   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │      ╔═══╗                  │   │
│  │      ║ 3%║  Career Ring     │   │
│  │      ╚═══╝                  │   │
│  │                             │   │
│  │   Career Readiness          │   │
│  │   Complete missions to grow │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ MISSION 1          25 min ⏱│   │
│  │                             │   │
│  │ Your Phone Is Ringing       │   │
│  │ Answer your first customer  │   │
│  │ call in German              │   │
│  │                             │   │
│  │ ┌─────────────────────┐    │   │
│  │ │   ▶ Start Mission    │    │   │
│  │ └─────────────────────┘    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌────┐ ┌────────┐ ┌──────────┐   │
│  │🎤  │ │📚      │ │🔥        │   │
│  │ 0m │ │ 0      │ │ 0 days   │   │
│  │Spk │ │Vocab   │ │Streak    │   │
│  └────┘ └────────┘ └──────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Home Specifications

| Element | Specification |
|---------|--------------|
| Greeting | heading.large, contextual (Morgen/Tag/Abend), text.primary |
| Subtitle | body.large, text.secondary |
| Settings icon | 24px, text.tertiary, top-right |
| Career ring container | Full width, primarySoft gradient bg, radius.lg, padding.2xl |
| Career ring | 120px diameter, 8px stroke, ProgressRing widget |
| Percentage text | heading.medium, brand.primary, inside ring |
| "Job Ready" label | label.small, text.secondary, inside ring |
| Mission card | surface.card, radius.lg, shadow.sm, border |
| Mission badge | "MISSION 1", label.small, primarySoft bg, primary text, radius.xs |
| Duration | label.small + timer icon 14px, text.tertiary |
| Mission title | heading.medium, text.primary |
| Mission subtitle | body.medium, text.secondary |
| Start button | PhoenixButton filled, full width, primary |
| Stat tiles | 3 equal, colored bg at 6% + colored border at 12%, radius.md |
| Stat icon | 20px, respective color |
| Stat value | title.small, bold, text.primary |
| Stat label | label.small, text.secondary |

### Home Animations

| Element | Delay | Animation |
|---------|-------|-----------|
| Greeting | 0ms | fadeIn + slideX(-3%) |
| Subtitle | 200ms | fadeIn |
| Career ring | 300ms | scale(0.8→1.0, easeOutBack) + fadeIn |
| Mission card | 600ms | fadeIn + slideY(5%) |
| Stats row | 800ms | fadeIn |

---

## Screen 4: MISSION BRIEFING

```
┌─────────────────────────────────────┐
│  ← (back)                           │
│                                     │
│  MISSION 1                          │
│  Your Phone Is Ringing              │
│  Ihr Telefon klingelt              │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ (Y) Yasmina                  │   │
│  │                              │   │
│  │ مرحبا بيك. In German call    │   │
│  │ centers, the phone greeting  │   │
│  │ is a fixed formula...        │   │
│  │                              │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ OBJECTIVE                    │   │
│  │                              │   │
│  │ Answer a phone call with a   │   │
│  │ professional German greeting │   │
│  └─────────────────────────────┘   │
│                                     │
│  ⏱ 25 min  📚 A1.1  🎤 60%       │
│                                     │
│  ┌─────────────────────────────┐   │
│  │     ▶ Begin Mission          │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Briefing Specifications

| Element | Specification |
|---------|--------------|
| Back button | Icon only, 48px touch target, top-left |
| "MISSION 1" | label.large, primary, letterSpacing 1.2 |
| English title | display.medium, text.primary |
| German title | heading.medium, text.secondary, italic |
| Yasmina card | primarySoft bg at 40%, primary border at 20%, radius.lg |
| Yasmina avatar | 32px, YasminaAvatar, inside card top-left |
| "Yasmina" label | title.small, primary, bold |
| Coaching text | body.medium, text.primary, height 1.6 |
| Objective box | surface.card, border, radius.md |
| "OBJECTIVE" label | label.medium, primary, letterSpacing 1.0 |
| Objective text | body.medium, text.primary |
| Meta chips | Row of 3, surface.dim bg, radius.xs, icon 14px + label.small |
| Begin button | PhoenixButton filled, full width, icon play_arrow |

---

## Screen 5: SPEAKING EXERCISE

```
┌─────────────────────────────────────┐
│  3/10  ━━━━━━━●━━━━━━━━━━━  30%    │
│                                     │
│                                     │
│  Listen and repeat: the greeting.   │
│                                     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                              │   │
│  │     Guten Tag                │   │
│  │                              │   │
│  └─────────────────────────────┘   │
│                                     │
│                                     │
│   ┌─────────────────────────┐      │
│   │  🔊 Play Model           │      │
│   └─────────────────────────┘      │
│                                     │
│                                     │
│                                     │
│            ╔═══╗                    │
│            ║ 🎤 ║  (80px, pulsing)  │
│            ╚═══╝                    │
│                                     │
│       Tap to speak                  │
│                                     │
│                                     │
│           💡 Hint                   │
│                                     │
└─────────────────────────────────────┘
```

### Speaking Exercise — Recording State

```
┌─────────────────────────────────────┐
│  3/10  ━━━━━━━●━━━━━━━━━━━  30%    │
│                                     │
│                                     │
│  Listen and repeat: the greeting.   │
│                                     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                              │   │
│  │     Guten Tag                │   │
│  │                              │   │
│  └─────────────────────────────┘   │
│                                     │
│                                     │
│   ▎▌█▎▌▎█▌▎█▎▌▎▌█▎█▌▎█▎▌▎█▌     │
│   (audio waveform — animated)       │
│                                     │
│                                     │
│            ╔═══╗                    │
│            ║ ⏹ ║  (RED, pulsing)   │
│            ╚═══╝                    │
│                                     │
│     Recording... tap to stop        │
│                                     │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

### Speaking Exercise Specifications

| Element | Specification |
|---------|--------------|
| Progress bar | MissionProgressIndicator, 6px, primary fill |
| Counter "3/10" | label.medium, text.secondary |
| Percentage "30%" | label.medium, primary, bold |
| Prompt text | body.large, text.secondary, centered |
| German text container | surface.dim bg, radius.md, padding.lg |
| German text | german.display (24px), text.primary, Medium weight, centered |
| Play Model button | PhoenixButton outlined, icon volume_up |
| Microphone button | 80px circle, primary bg (idle) / error bg (recording) |
| Mic icon | 32px, white |
| Pulse animation | scale 1.0→1.06, 1200ms loop (recording only) |
| Status text | body.small, text.secondary (idle) / error (recording) |
| Waveform | AudioWaveWidget, 48px height, primary color (recording) |
| Hint button | TextButton, icon lightbulb_outline 18px, text "Hint" |
| Hint card | tealSoft bg, radius.xs, body.small, teal text |

---

## Screen 6: LISTENING EXERCISE

```
┌─────────────────────────────────────┐
│  1/10  ━━●━━━━━━━━━━━━━━━━━  10%   │
│                                     │
│                                     │
│  Listen to this professional        │
│  phone greeting.                    │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ (German text if scaffolding  │   │
│  │  shows it — otherwise empty) │   │
│  └─────────────────────────────┘   │
│                                     │
│                                     │
│       ┌───────────────────┐        │
│       │    ▶ Play Audio    │        │
│       └───────────────────┘        │
│                                     │
│                                     │
│  What did you hear?                 │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Four: greeting + company +   │   │
│  │ name + offer to help         │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Two: hello + name            │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ One: just a greeting         │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Listening Specifications

| Element | Specification |
|---------|--------------|
| Options | OutlinedButton, full width, padding.lg, radius.sm, left-aligned text |
| Selected option (correct) | successSoft bg, success border, check icon |
| Selected option (incorrect) | warningSoft bg, warning border |
| Play button | FilledButton, primary, icon play_arrow |
| Playing state | "Playing..." text, icon changes to pause |
| Question | heading.small, text.primary, centered |

---

## Screen 7: CONVERSATION EXERCISE

```
┌─────────────────────────────────────┐
│  8/10  ━━━━━━━━━━━━━●━━━━━  80%    │
│                                     │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐     │
│    CALL SIMULATION                   │
│  │                            │     │
│    Caller: Frau Schmidt               │
│  │ Mood: ████████░░ Friendly  │     │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👤 Frau Schmidt:            │   │
│  │                              │   │
│  │ "Guten Tag! Hier ist        │   │
│  │  Schmidt. Ich habe eine      │   │
│  │  Frage zu meiner             │   │
│  │  Bestellung."                │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ YOUR TURN                    │   │
│  │                              │   │
│  │     ╔═══╗                    │   │
│  │     ║ 🎤 ║  Respond          │   │
│  │     ╚═══╝                    │   │
│  │                              │   │
│  │ 💡 Confirm and ask for      │   │
│  │    the order number          │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Conversation Specifications

| Element | Specification |
|---------|--------------|
| Call header | Dashed border, surface.dim bg, radius.md |
| "CALL SIMULATION" | label.small, primary, letterSpacing 1.0 |
| Caller name | body.large, bold, text.primary |
| Mood bar | 120px×4px, primary fill, surface.dim track |
| Character speech bubble | surface.card, radius.md, shadow.sm, left-aligned |
| Character avatar | 28px circle, text.tertiary bg, icon person |
| Character name | label.medium, bold |
| German text | german.body (20px), text.primary |
| "YOUR TURN" area | surface.dim bg, radius.lg, centered content |
| "YOUR TURN" label | label.small, primary, letterSpacing 0.8 |
| Mic button (conversation) | 64px, primary, centered |
| Hint text (visible) | body.small, text.secondary, italic |

---

## Screen 8: YASMINA COACHING OVERLAY

```
┌─────────────────────────────────────┐
│                                     │
│  (dimmed exercise behind)           │
│                                     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                              │   │
│  │  (Y) Yasmina     pulse ring  │   │
│  │                              │   │
│  │  Good. You just said the     │   │
│  │  full greeting — in German.  │   │
│  │  On your first day.          │   │
│  │  Most learners take a week.  │   │
│  │  You did it in 10 minutes.   │   │
│  │  Now let's use it in a       │   │
│  │  real call.                  │   │
│  │                              │   │
│  │        [Continue →]          │   │
│  │                              │   │
│  └─────────────────────────────┘   │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

### Yasmina Overlay Specifications

| Element | Specification |
|---------|--------------|
| Background dim | Black at 30% opacity (light) / 50% (dark) |
| Card | surface.card, radius.xl (20px), shadow.lg, max-width 360px, centered |
| Card padding | 24px all sides |
| Yasmina avatar | 48px, YasminaAvatar, isSpeaking=true |
| "Yasmina" | title.small, primary, bold, next to avatar |
| Message text | body.large, text.primary, height 1.6 |
| Continue button | TextButton, "Continue →", primary color |
| Animation | Card: fadeIn + slideY(10%) + scale(0.96→1.0), 400ms |
| Dismiss | Tap Continue or tap outside card |

---

## Screen 9: FEEDBACK OVERLAY

```
┌─────────────────────────────────────┐
│                                     │
│  (exercise content above — faded)   │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  ✓ Well done                        │
│                                     │
│  Clean. That's your professional    │
│  hello. Confident and clear.        │
│                                     │
│  ┌────────────┐ ┌────────────────┐ │
│  │ 🔊 Model   │ │   Continue →   │ │
│  └────────────┘ └────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

### Feedback States

| State | Icon | Color | Label |
|-------|------|-------|-------|
| Success | check_circle_rounded | success | "Well done" |
| Partial | info_rounded | accent.teal | "Almost there" |
| Retry | refresh_rounded | warning | "Let's try again" |

### Feedback Specifications

| Element | Specification |
|---------|--------------|
| Container | surface.card bg, radius.lg top corners, shadow.lg upward |
| Animation | slideY from bottom + fadeIn, 300ms easeOut |
| Icon + label | 28px icon + title.medium, respective state color |
| Feedback text | body.medium, text.primary, height 1.5 |
| Model button | IconButton volume_up, outlined style |
| Continue button | PhoenixButton filled, primary |
| Retry button (if available) | PhoenixButton outlined, beside Continue |

---

## Screen 10: MISSION COMPLETE

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│           🏆 (64px, gold)           │
│          scale entrance             │
│                                     │
│       Mission Complete              │
│                                     │
│   Your Phone Is Ringing             │
│                                     │
│                                     │
│  ┌────┐   ┌────────┐   ┌──────┐   │
│  │🎤  │   │✓       │   │📚    │   │
│  │42s │   │8/10    │   │+5    │   │
│  │Spk │   │Exer   │   │Vocab │   │
│  └────┘   └────────┘   └──────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ (Y) Yasmina                  │   │
│  │                              │   │
│  │ See what you just did? You   │   │
│  │ answered a phone in German.  │   │
│  │ That's not an exercise —     │   │
│  │ that's professional German.  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │       Continue →             │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Mission Complete Specifications

| Element | Specification |
|---------|--------------|
| Trophy icon | 64px, accent.gold color |
| Trophy animation | scale(0.5→1.0), 600ms, easeOutBack (bouncy) |
| "Mission Complete" | heading.large, text.primary |
| Mission title | body.large, text.secondary |
| Stats row | 3 columns, like Home stats, animated entry (stagger 100ms) |
| Yasmina debrief | YasminaCard widget (same as coaching) |
| Continue button | Full width, filled, primary |
| Outcome badges | Gold: workspace_premium (gold) / Silver: verified (silver) / Bronze: trending_up (bronze) |

---

## Screen 11: SETTINGS

```
┌─────────────────────────────────────┐
│  ← Settings                         │
│                                     │
│  APPEARANCE                         │
│  ┌──────┐ ┌──────┐ ┌──────┐       │
│  │ Auto │ │ Light│ │ Dark │       │
│  │  ●   │ │  ○  │ │  ○   │       │
│  └──────┘ └──────┘ └──────┘       │
│                                     │
│  LEARNING                           │
│  Daily Goal          [25 min ▼]     │
│  Audio Speed         [1.0x  ▼]     │
│                                     │
│  LANGUAGE SUPPORT                   │
│  Darija Translations     [━━●]     │
│  French Bridges          [━━●]     │
│                                     │
│  ABOUT                              │
│  Version                    0.1.0   │
│  Works Offline              100%    │
│                                     │
└─────────────────────────────────────┘
```

### Settings Specifications

| Element | Specification |
|---------|--------------|
| Section headers | label.medium, primary, UPPERCASE, letterSpacing 1.2 |
| Theme options | 3 equal columns, radius.md, surface.dim bg, selected=primarySoft + primary border |
| List items | ListTile standard, body.large title, body.small subtitle |
| Dropdowns | Material 3 DropdownButton, no underline |
| Switches | Material 3 Switch, primary active color |
| Trailing text | body.medium, text.secondary |

---

## Screen 12: PROGRESS DASHBOARD (Future)

```
┌─────────────────────────────────────┐
│  Progress                           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Career Readiness    3%      │   │
│  │                              │   │
│  │  📞 Phone       ████░░ 5%   │   │
│  │  🤝 Customer   ░░░░░░ 0%   │   │
│  │  💬 Language    ░░░░░░ 0%   │   │
│  │  🎤 Fluency    ░░░░░░ 0%   │   │
│  │  🎯 Interview  ░░░░░░ 0%   │   │
│  └─────────────────────────────┘   │
│                                     │
│  This Week                          │
│  ●●●○○○○  (3/7 sessions)          │
│                                     │
│  Speaking Time                      │
│  0h 42m total                       │
│                                     │
│  Vocabulary Arsenal                 │
│  5 phrases (5 new this week)        │
│                                     │
└─────────────────────────────────────┘
```

---

*End of Part 02 — Screen Specifications. All 12 major screens defined.*
