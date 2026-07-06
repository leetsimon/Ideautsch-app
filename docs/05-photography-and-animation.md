# ARTYBLANC — Photography & Animation Direction

## Photography Style

### Mood
- Cinematic, editorial, aspirational
- Natural lighting with warm undertones
- Shallow depth of field for product details
- Wide environmental shots for lifestyle
- Never over-produced or overly glossy
- Feels like a fashion editorial spread in Vogue or Monocle

### Color Grading
- Warm highlights (slightly golden)
- Rich midtones (brown/taupe)
- Lifted shadows (never pure black)
- Low saturation — desaturated warmth
- Film-like grain on lifestyle shots (subtle)

### Lighting
- Natural window light for product shots
- Golden hour for outdoor lifestyle
- Soft overhead for flat lays
- Ambient hotel/airport lighting for editorial

---

## Image Specifications

### Hero Images (Homepage, Collection Heroes)
- Dimensions: 1920x1080 minimum (16:9)
- Style: Cinematic, environmental
- Subject: Professional traveler in motion

**Hero Image Concepts:**
1. Business traveler walking through airport terminal, leather bag in hand
2. Morning light in a luxury hotel room, bag on bed
3. European cobblestone street, professional walking with briefcase
4. Airport lounge chair, bag beside a coffee cup

### Product Images (7 per product)
1. **Hero shot** — Product on neutral cream/sand background, 3/4 angle (3:4 ratio)
2. **Detail: leather** — Close-up of grain texture
3. **Detail: hardware** — Zipper, clasp, or buckle close-up
4. **Detail: interior** — Open bag showing organization
5. **Lifestyle: carried** — Person carrying in urban environment
6. **Lifestyle: context** — Bag on desk / hotel / airport seat
7. **Scale shot** — With common items (laptop, passport, wallet)

### Lifestyle Gallery Images
- **Airport:** Terminal, gate, lounge, boarding pass + leather goods
- **Hotel:** Lobby, room, bed with bag, bathroom counter with wallet
- **Business:** Meeting table, coffee shop, coworking space
- **Travel:** Train, car, arriving at destination, unpacking
- **European streets:** Paris, Milan, London, Barcelona
- **Coffee:** Morning ritual, cafe scene, newspaper + leather goods
- **Detail:** Hands holding wallet, bag strap on shoulder, zipper pull

### Editorial/Journal Images
- Long-form lifestyle storytelling
- City guides: architectural shots mixed with product placement
- Craftsmanship: workshop, tools, leather rolls, hands working

---

## Photography Rules

1. Never shoot products on pure white backgrounds (use cream/sand)
2. Always include environmental context when possible
3. Models should be diverse, 28-50 age range, editorial-styled
4. No logos visible on clothing
5. Wardrobe: neutral palette — black, navy, cream, camel
6. Products should never be the sole focus — tell a story
7. Include negative space for text overlay potential
8. Shoot for 3:4, 16:9, and 1:1 ratios for multi-use

---

## Animation System

### Page Load Sequence
```
0ms     — Page background renders (ivory)
200ms   — Hero image fades in with subtle scale (1.08 → 1.0)
600ms   — Hero overline reveals (fade + slide up)
900ms   — Hero headline reveals (fade + slide up)
1400ms  — Hero CTA reveals (fade + slide up)
1800ms  — Navigation reveals (fade + slide down)
2200ms  — Scroll indicator pulses
```

### Scroll Reveal System
- **Trigger:** Element enters viewport (threshold: 10%, rootMargin: -60px)
- **Animation:** Fade up (translateY 50px → 0, opacity 0 → 1)
- **Duration:** 1000ms
- **Easing:** cubic-bezier(0.16, 1, 0.3, 1)
- **Stagger:** 100ms delay between sibling elements
- **Once only:** Elements don't re-animate on scroll back

### Hover Effects
- **Product cards:** Image scale 1.0 → 1.06 (1.2s ease-luxury)
- **Buttons:** Background color transition (400ms)
- **Nav links:** Underline width 0 → 100% (400ms)
- **Text links:** Opacity 1 → 0.6
- **Gallery images:** Subtle zoom + overlay fade

### Parallax
- **Hero background:** Rate 0.3 (subtle)
- **Section divider images:** Rate 0.15
- **Story section image:** Rate 0.2
- Reserved for desktop only (disabled on mobile)

### Navigation Behavior
- **Initial:** Transparent, white text
- **On scroll (>100px):** Glass background, dark text, reduced padding
- **Transition:** All properties 700ms ease-luxury

### Micro-interactions
- **Cart count:** Scale pulse on add (ease-spring)
- **Wishlist heart:** Scale 1 → 1.3 → 1 on toggle
- **Form focus:** Border-bottom color transition (smooth)
- **Accordion:** Content slides with max-height (700ms)
- **Image lazy load:** Opacity 0 → 1 with 0.8s transition
- **Button press:** Subtle scale 0.97 on active state

### Loading Experience
- Skeleton screens use shimmer animation
- Images fade in on load (never pop)
- Content reveals as it enters viewport
- No full-page loader — progressive revelation

### Performance Rules
- Use `will-change: transform` sparingly (only during animation)
- Prefer `transform` and `opacity` for GPU acceleration
- Disable parallax and heavy animations below 768px
- Use `IntersectionObserver` for all scroll-triggered effects
- Respect `prefers-reduced-motion` — disable all animations
