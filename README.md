# ARTYBLANC — European Luxury Leather Goods

A complete luxury ecommerce brand and website built to compete visually with brands like Polène, Carl Friedrik, Bleu de Chauffe, and Bennett Winch.

## Project Structure

```
artyblanc/
├── index.html              → Homepage (9 sections)
├── pages/
│   ├── product.html        → Product detail page
│   ├── shop.html           → Shop/collection page
│   ├── about.html          → Brand story page
│   └── contact.html        → Contact page
├── css/
│   ├── design-system.css   → Tokens, reset, base typography
│   ├── components.css      → Reusable UI (nav, buttons, cards, footer)
│   ├── layouts.css         → Page-level grids and sections
│   └── animations.css      → Scroll reveals, parallax, transitions
├── js/
│   └── main.js             → Interactions, IntersectionObserver, UX
└── docs/
    ├── 01-brand-strategy.md
    ├── 02-information-architecture.md
    ├── 03-design-system.md
    ├── 04-copywriting.md
    ├── 05-photography-and-animation.md
    └── 06-ecommerce-seo-ads.md
```

## Tech Stack

- **HTML5** — Semantic, accessible
- **CSS3** — Custom properties, fluid typography, CSS Grid, Flexbox
- **Vanilla JavaScript** — No dependencies
- **Google Fonts** — Cormorant Garamond + Inter
- **Images** — Unsplash (replace with product photography for production)

## Design Features

- Glass morphism navigation with scroll behavior
- Full-screen cinematic hero with entrance animation
- Scroll reveal system (IntersectionObserver)
- Parallax effects (desktop only)
- Product gallery with image zoom on hover
- Accordion with smooth animation
- Newsletter form with success state
- Responsive across all breakpoints (480, 768, 1024)
- `prefers-reduced-motion` support
- Skip links and ARIA attributes

## Brand Position

- **Price:** $49–$650 (wallets → bags → travel bags)
- **Target:** Professionals 28–55, frequent travelers
- **Markets:** USA, Canada, UK, Europe
- **Aesthetic:** Quiet luxury, editorial, European minimalism

## Shopify Conversion

The codebase is designed for Shopify Liquid conversion:
- Each homepage section maps to a Shopify section
- Product card component → snippet
- CSS architecture is modular and drop-in ready
- See `docs/06-ecommerce-seo-ads.md` for theme structure

## Quick Start

Open `index.html` in any browser. No build step required.

## License

Proprietary. All brand assets, copy, and design are original.
