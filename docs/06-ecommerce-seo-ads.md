# ARTYBLANC — Ecommerce Strategy, SEO & Meta Ads

## Ecommerce Strategy

### Funnel Architecture

```
COLD TRAFFIC (Meta Ads)
    → $49 Wallet / $49 Cardholder (Entry Product)
    → Cart Upsell: Leather Care Kit $19
    → Average First Order: $55-68
    
WARM TRAFFIC (Email / Retargeting)
    → Premium Bags $220-450
    → Average Second Order: $280-380
    
HOT TRAFFIC (Returning Customers)
    → Travel Bags $350-650
    → Gift Cards
    → Average Lifetime Value: $600-900
```

### Average Order Value Strategy
1. **Entry wallet funnel:** $49 entry → upsell care kit → cross-sell cardholder
2. **Bundle suggestion:** Wallet + Cardholder pairing (-10%)
3. **Free shipping threshold:** $150 (pushes $49 → add $100+ item)
4. **Gift wrapping:** $12 add-on at cart
5. **Engraving/personalization:** $15 premium on wallets

### Cross-Selling Rules
- Wallet buyers → show bags in same color family
- Bag buyers → show matching wallets/accessories
- Travel bag → show travel accessories bundle
- Never show more than 3 cross-sell items
- Always present as "Complete the Collection"

### Email Capture Strategy
- Newsletter popup (7-second delay, exit-intent on desktop)
- Inline capture on journal articles
- Footer permanent capture
- Offer: "First access to new collections" (never discount)
- Post-purchase: "Join the circle" for updates

### Review Strategy
- Post-delivery email (7 days after delivery)
- Photo review incentive: Featured on website
- Display reviews with city/country for international credibility
- Curate 3-5 hero reviews per product

---

## SEO Strategy

### Target Keywords

| Page | Primary Keyword | Secondary |
|------|----------------|-----------|
| Homepage | luxury leather goods | premium leather bags, european leather |
| Leather Bags | luxury leather bags | designer leather tote, professional bag |
| Wallets | leather wallet for men | slim leather wallet, full grain wallet |
| Travel Bags | luxury travel bag | leather weekender, leather duffle |
| About | artyblanc story | european leather brand |
| Journal | leather care tips, travel style | luxury travel accessories |

### Schema Markup
- Organization schema (brand info)
- Product schema (price, availability, reviews)
- BreadcrumbList schema
- Article schema (journal posts)
- FAQ schema (FAQ page)

### Meta Title Format
- Homepage: "ARTYBLANC | European Luxury Leather Goods"
- Collections: "Luxury [Collection Name] | ARTYBLANC"
- Products: "[Product Name] — Full-Grain Leather | ARTYBLANC"
- Journal: "[Article Title] | ARTYBLANC Journal"

### Meta Description Format
- Keep under 155 characters
- Include brand name and key differentiator
- Action-oriented when possible
- Example: "Discover the Voyager Tote — a structured leather tote crafted from full-grain Italian leather. Designed for professionals who move between cities and ambition."

### Content Marketing (Journal)
- 2-4 articles per month
- Topics: Leather care, travel guides, style guides, craftsmanship stories
- Each article includes product placement (1-2 products)
- Internal linking to collection/product pages
- Optimized for long-tail keywords

---

## Meta Ads Strategy

### Campaign Structure

```
CAMPAIGN 1: COLD — WALLET TRAFFIC (Conversion, Purchase)
├── Ad Set 1: Broad US (25-55, interests: luxury, travel, fashion)
├── Ad Set 2: Broad UK+EU
├── Ad Set 3: Lookalike 1% Purchasers
└── Ad Set 4: Lookalike 2-5% Website Visitors

CAMPAIGN 2: WARM — RETARGETING (Conversion, Purchase)
├── Ad Set 1: Website Visitors 7-day (exclude purchasers)
├── Ad Set 2: Website Visitors 30-day
├── Ad Set 3: Add to Cart Abandoners
└── Ad Set 4: Email List (non-purchasers)

CAMPAIGN 3: HOT — PREMIUM BAGS (Conversion, Purchase)
├── Ad Set 1: Past Purchasers (exclude 14-day)
├── Ad Set 2: High-value Lookalike
└── Ad Set 3: Email VIP Segment
```

### Creative Concepts

**Concept 1: "The Last Wallet" (Static Image)**
- Image: Wallet on luxury hotel desk, morning light
- Copy: "The last wallet you'll buy. Full-grain leather. European craft. $49."
- CTA: Shop Now

**Concept 2: "Between Cities" (Video, 15s)**
- Scene 1: Airport terminal, bag in hand
- Scene 2: Hotel lobby, setting bag down
- Scene 3: Meeting room, opening briefcase
- Copy: "Designed for movement between cities, work, and ambition."
- CTA: Discover Collection

**Concept 3: "2 Years Later" (Carousel)**
- Slide 1: New wallet (day 1)
- Slide 2: Same wallet with patina (year 1)
- Slide 3: Beautiful aged leather (year 2)
- Copy: "Other wallets wear out. Ours wear in."
- CTA: Explore

**Concept 4: "What's Inside" (Video, 30s)**
- Detailed product walkthrough
- Focus on materials, stitching, organization
- Copy: "Full-grain leather. Hand-burnished edges. 27-point inspection."
- CTA: Shop the Collection

**Concept 5: UGC Review (Video, 15-30s)**
- Real customer unboxing
- Authentic reaction to quality
- "I can't believe this is $49"
- CTA: Shop Now

### Testing Plan
- Test 3-5 creatives per ad set per week
- Kill underperformers at $30 spend (no purchase)
- Scale winners by 20% daily
- Refresh creative every 2-3 weeks
- A/B test landing pages: Collection vs. Product page

### Landing Pages
- **Wallet LP:** Hero image + wallet grid + reviews + trust signals
- **Premium LP:** Hero video + bag showcase + craftsmanship + testimonials
- **Gift LP:** Seasonal hero + gift selection + wrapping options

---

## Shopify Architecture

### Theme Structure
```
theme/
├── assets/
│   ├── styles.css
│   ├── components.css
│   ├── animations.css
│   ├── layouts.css
│   ├── main.js
│   └── images/
├── layout/
│   └── theme.liquid
├── sections/
│   ├── header.liquid
│   ├── footer.liquid
│   ├── hero.liquid
│   ├── brand-values.liquid
│   ├── featured-collection.liquid
│   ├── brand-story.liquid
│   ├── lifestyle-gallery.liquid
│   ├── craftsmanship.liquid
│   ├── testimonials.liquid
│   ├── newsletter.liquid
│   ├── product-gallery.liquid
│   ├── product-info.liquid
│   ├── product-recommendations.liquid
│   ├── collection-header.liquid
│   ├── collection-grid.liquid
│   └── contact-form.liquid
├── templates/
│   ├── index.json
│   ├── product.json
│   ├── collection.json
│   ├── page.about.json
│   ├── page.contact.json
│   ├── page.faq.json
│   ├── blog.json
│   ├── article.json
│   ├── cart.json
│   ├── search.json
│   └── 404.json
├── snippets/
│   ├── product-card.liquid
│   ├── trust-badge.liquid
│   ├── icon.liquid
│   ├── breadcrumb.liquid
│   └── pagination.liquid
└── config/
    ├── settings_schema.json
    └── settings_data.json
```

### Recommended Apps
1. **Reviews:** Judge.me or Loox
2. **Email:** Klaviyo
3. **Upsells:** ReConvert or CartHook
4. **Wishlist:** Wishlist Plus
5. **SEO:** JSON-LD for SEO
6. **Analytics:** Triple Whale or Northbeam
7. **Shipping:** ShipBob or Easyship
8. **Returns:** Loop Returns
9. **Gift Cards:** Rise.ai

### Performance Targets
- Lighthouse Score: 90+ (Performance, Accessibility, SEO)
- First Contentful Paint: < 1.5s
- Largest Contentful Paint: < 2.5s
- Total Blocking Time: < 200ms
- Cumulative Layout Shift: < 0.1
- Image format: WebP with AVIF fallback
- Font loading: swap display, preconnect
