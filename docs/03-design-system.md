# ARTYBLANC — Design System

## Color Palette

### Primary

| Token | Hex | Usage |
|-------|-----|-------|
| Ivory | #FDFBF7 | Page background, primary surface |
| Cream | #FAF7F2 | Secondary surface, cards |
| Sand | #F3EDE4 | Tertiary surface, hover states |
| Stone | #E8DFD3 | Borders, dividers, skeletons |
| Taupe | #B8A99A | Secondary text, overlines |
| Warm Gray | #8C8178 | Body text |
| Charcoal | #3B3632 | Primary text |
| Dark | #2A2523 | Headlines, emphasis |
| Black | #1A1614 | Darkest text, buttons |
| True Black | #0D0B0A | Footer, dark sections |

### Accent

| Token | Hex | Usage |
|-------|-----|-------|
| Gold | #C4A96A | Primary accent, stars, highlights |
| Gold Muted | #B89B5E | Hover accent |
| Gold Light | #D4BE8A | Selection, subtle accent |
| Brown | #6B4C3B | Links, warm emphasis |
| Brown Dark | #4A3429 | Button hover, CTA alt |

### Functional

| Token | Value | Usage |
|-------|-------|-------|
| Glass | rgba(253, 251, 247, 0.85) | Navigation backdrop |
| Overlay | rgba(13, 11, 10, 0.5) | Modals, drawers |
| Success | #4A7C59 | Confirmations |
| Error | #9B3B3B | Validation |

## Typography

### Font Stack

- **Display / Headings:** Cormorant Garamond (300, 400, 500, 600)
- **Body / UI:** Inter (300, 400, 500)

### Type Scale (Fluid)

| Token | Desktop | Mobile | Usage |
|-------|---------|--------|-------|
| Hero | 6rem | 3.2rem | Homepage hero |
| Display | 4.5rem | 2.4rem | Page titles |
| H1 | 3.5rem | 2rem | Section headers |
| H2 | 3rem | 1.8rem | Sub-headers |
| H3 | 2rem | 1.4rem | Card titles |
| H4 | 1.5rem | 1.1rem | Component headers |
| Body Large | 1.125rem | 1.125rem | Feature text |
| Body | 1rem | 1rem | Default text |
| Body Small | 0.9375rem | 0.9375rem | Secondary text |
| Caption | 0.8125rem | 0.8125rem | Labels, meta |
| Overline | 0.6875rem | 0.6875rem | Categories, tags |
| Micro | 0.625rem | 0.625rem | Badges |

### Typography Rules

- Headings: weight 300, tight line-height (1.1–1.2)
- Body: weight 300, generous line-height (1.7–1.8)
- Overlines: weight 400, letter-spacing 0.2em, uppercase
- Never bold headings — weight 300 or 400 only
- Maximum line width for body: 65ch

## Spacing System

Based on 4px base unit (0.25rem):

| Token | Value | Usage |
|-------|-------|-------|
| space-1 | 0.25rem | Micro gaps |
| space-2 | 0.5rem | Tight inline |
| space-3 | 0.75rem | Small gaps |
| space-4 | 1rem | Standard gap |
| space-5 | 1.25rem | Component internal |
| space-6 | 1.5rem | Component padding |
| space-8 | 2rem | Card padding |
| space-10 | 2.5rem | Section internal |
| space-12 | 3rem | Group spacing |
| space-16 | 4rem | Section internal |
| space-20 | 5rem | Section padding |
| space-24 | 6rem | Large section |
| space-32 | 8rem | Section gap |
| space-40 | 10rem | Major section gap |
| space-48 | 12rem | Hero-level spacing |
| space-64 | 16rem | Dramatic spacing |

### Section Spacing

- Standard section gap: clamp(5rem, 10vw, 10rem)
- Small section gap: clamp(3rem, 6vw, 6rem)
- Hero padding: clamp(4rem, 8vw, 8rem)

## Grid System

- Max container: 1440px
- Content container: 1200px
- Narrow container: 860px
- Text container: 680px
- Gutters: clamp(1.5rem, 4vw, 4rem)

### Product Grid
- Desktop: 3 columns
- Tablet: 2 columns
- Mobile: 2 columns (compact) or 1 column (featured)

### Editorial Grid
- Asymmetric: 60/40 or 55/45 splits
- Masonry for lifestyle galleries
- Full-bleed for hero/editorial moments

## Button System

| Variant | Background | Text | Border | Hover |
|---------|-----------|------|--------|-------|
| Primary | Black | Ivory | Black | Brown Dark bg |
| Secondary | Transparent | Black | Charcoal | Black bg, Ivory text |
| Ghost | Transparent | Ivory | Ivory 50% | Ivory bg, Black text |
| Gold | Transparent | Gold | Gold | Gold bg, Black text |
| Text | None | Current | Bottom 1px | Opacity 0.6 |

### Button Sizes
- Large: 1.4rem 4rem padding
- Default: 1.15rem 3.2rem padding
- Small: 0.85rem 2rem padding

### Button Typography
- Font: Inter
- Size: 0.6875rem (overline)
- Weight: 400
- Letter-spacing: 0.18em
- Transform: uppercase

## Shadow System

| Token | Value | Usage |
|-------|-------|-------|
| sm | 0 2px 8px rgba(13,11,10,0.04) | Cards hover |
| md | 0 4px 24px rgba(13,11,10,0.06) | Elevated cards |
| lg | 0 8px 48px rgba(13,11,10,0.08) | Modals |
| xl | 0 16px 64px rgba(13,11,10,0.12) | Feature elements |

## Animation Tokens

| Token | Value | Usage |
|-------|-------|-------|
| ease-out | cubic-bezier(0.16, 1, 0.3, 1) | Reveals, entrances |
| ease-in-out | cubic-bezier(0.4, 0, 0.2, 1) | General transitions |
| ease-luxury | cubic-bezier(0.25, 0.46, 0.45, 0.94) | Smooth, premium |
| ease-spring | cubic-bezier(0.34, 1.56, 0.64, 1) | Playful micro |
| duration-fast | 200ms | Hover, focus |
| duration-base | 400ms | Standard transitions |
| duration-slow | 700ms | Overlays, drawers |
| duration-reveal | 1000ms | Scroll reveals |
| duration-hero | 1500ms | Hero entrance |

## Luxury Design Principles

1. **Breathe** — Every element needs generous space around it
2. **Contrast through space, not color** — Use whitespace for hierarchy
3. **Photography-first** — Images carry the emotion, text guides
4. **Asymmetry** — Slight asymmetry feels editorial, centered feels corporate
5. **Restraint** — If in doubt, remove it
6. **Slow** — Animations should feel unhurried, confident
7. **Texture** — Subtle grain, paper-like backgrounds add warmth
8. **Consistency** — Same animation language throughout
