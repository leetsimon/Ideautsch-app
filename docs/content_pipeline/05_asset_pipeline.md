# Phoenix Content Pipeline — Part 05: Production Asset Pipeline

**Version:** 1.0.0  
**Status:** Production Reference  

---

## 1. Asset Categories

| Category | Format | Source | Storage Budget |
|----------|--------|--------|---------------|
| Audio (dialogue) | Opus/OGG, 64kbps | Voice actors | ~200 MB |
| Audio (vocabulary) | Opus/OGG, 48kbps | Voice actors | ~50 MB |
| Audio (UI sounds) | Opus/OGG, 48kbps | Sound design | <5 MB |
| Images (scenarios) | WebP, quality 85 | AI-generated | ~75 MB |
| Images (characters) | WebP, quality 85 | AI-generated | ~15 MB |
| Images (UI icons) | SVG or WebP | Designed | <5 MB |
| Video (pronunciation) | MP4, H.264, 720p | Recorded | ~100 MB (optional) |
| Database (content) | SQLite | Build pipeline | ~20 MB |

**Total asset budget: ~470 MB** (within 500 MB target)

---

## 2. AI Image Generation Pipeline

### 2.1 Workflow

```
1. PROMPT EXTRACTION
   → Parse mission YAML → extract image_generation_prompt fields
   → Augment with character consistency rules
   → Add style guide parameters
   
2. GENERATION
   → Submit to image model (DALL-E 3 / Midjourney / Stable Diffusion)
   → Generate at 1024×1024 (base resolution)
   → Generate 3 variants per prompt (for selection)
   
3. SELECTION & QA
   → Human selects best variant
   → Verify: character consistency, cultural sensitivity, professional quality
   → Verify: no stereotypes, correct workplace details
   
4. POST-PROCESSING
   → Resize to target dimensions (1024×1024 for scenarios, 512×512 for portraits)
   → Convert to WebP (quality 85, lossy)
   → Generate 1x, 2x, 3x density variants
   → Verify file size ≤ 150 KB (scenario) / ≤ 80 KB (portrait)
   
5. NAMING & STORAGE
   → Name according to convention
   → Place in correct asset directory
   → Register in asset manifest
```

### 2.2 Style Consistency Rules

```yaml
image_style:
  art_style: "Semi-realistic digital illustration"
  color_palette: "Deep blue primary, warm amber accents, teal growth"
  lighting: "Warm, professional, well-lit (no dramatic shadows)"
  background: "Simple, slightly blurred, contextual"
  character_rendering: "Adult, professional, dignified, diverse"
  
  forbidden:
    - "Cartoon/anime style"
    - "Photorealistic (uncanny valley risk)"
    - "Stock photo aesthetic"
    - "Childish illustrations"
    - "Stereotypical representation"
    - "Overly dramatic lighting"
    
  character_consistency:
    frau_schmidt: "Always: silver hair, pearl earrings, beige cardigan, warm smile"
    herr_weber: "Always: angular face, glasses, dark suit, furrowed brow"
    yasmina: "Always: brown eyes, professional attire, warm expression, headset"
```

### 2.3 Image Naming Convention

```
images/{category}/{mission_id_or_character}/{description}.webp

Examples:
  images/scenarios/m01_001_d/briefing.webp
  images/characters/frau_schmidt/friendly.webp
  images/characters/frau_schmidt/neutral.webp
  images/characters/yasmina/coaching.webp
  images/achievements/first_call.webp
```

---

## 3. Audio Recording Pipeline

### 3.1 Recording Workflow

```
1. SCRIPT PREPARATION
   → Extract all text_de fields from mission YAML
   → Organize by voice actor (character)
   → Mark speed variants needed (native, slow, shadow)
   → Add pronunciation direction notes
   
2. STUDIO RECORDING
   → Record in professional studio (treated room, ≤ -60 dB noise floor)
   → Use consistent microphone + position per voice actor
   → Record each line: native speed → slow speed → shadow speed
   → Record pickup lines for corrections
   
3. EDITING
   → Trim leading/trailing silence (≤100ms lead, ≤200ms trail)
   → Normalize peak to -3 dB
   → Remove mouth clicks, breaths (if distracting)
   → Verify no clipping
   
4. ENCODING
   → Encode to Opus/OGG
   → Dialogue: 64 kbps VBR
   → Vocabulary: 48 kbps VBR
   → Sample rate: 48 kHz
   → Channels: Mono
   
5. QA
   → Listen to every file (human QA)
   → Verify: correct text spoken, natural pace, character-consistent
   → Verify: no artifacts, consistent volume, clean encoding
   → Compare native vs slow (slow should be 70–80% speed, not robotic)
   
6. NAMING & DELIVERY
   → Name according to convention
   → Place in mission audio directory
   → Update audio manifest
```

### 3.2 Voice Actor QA Checklist

```markdown
Per Recording:
- [ ] Correct German text spoken (no word substitutions)
- [ ] Character voice is consistent with previous recordings
- [ ] Pace matches target (native ~150 wpm, slow ~110 wpm)
- [ ] Intonation is natural (not robotic, not over-dramatic)
- [ ] Register matches scenario (formal for customers, casual for Thomas)
- [ ] Emotional tone matches character mood tag
- [ ] No background noise audible
- [ ] Peak level between -3 dB and -1 dB
- [ ] File duration within expected range (±20% of estimate)
```

### 3.3 Audio Naming Convention

```
audio/missions/{mission_id}/{description}_{version}.opus

Versions:
  native    — natural conversational speed
  slow      — 70–80% speed, clear articulation
  shadow    — 90% speed (for shadowing exercises)

Examples:
  audio/missions/m01_001_d/vocab_guten_tag_native.opus
  audio/missions/m01_001_d/vocab_guten_tag_slow.opus
  audio/missions/m01_001_d/dlg_t2_agent_native.opus
  audio/missions/m01_001_d/dlg_t3_frau_schmidt_native.opus
```

---

## 4. Video Generation Pipeline (Optional)

### 4.1 Video Types

| Type | Content | Duration | Modules |
|------|---------|----------|---------|
| Pronunciation lip demos | Close-up of mouth forming sounds | 5–10s | 1, 3, 5 |
| Cultural vignettes | German workplace behavior | 15–30s | 5, 9, 10 |
| Monthly progress | Compilation of learner stats | 20s | Monthly |

### 4.2 Technical Specs

```yaml
video_specs:
  resolution: "1280x720 (720p)"
  frame_rate: 30
  codec: "H.264 (Main Profile)"
  audio_codec: "AAC, 128 kbps"
  max_duration_seconds: 30
  max_file_size_mb: 5
  container: "MP4"
```

### 4.3 Video is ALWAYS Optional

Videos are never required for mission completion. They are supplementary content that can be disabled by the learner to save storage.

---

## 5. Asset Compression Standards

| Asset Type | Target Size | Compression |
|-----------|-------------|-------------|
| Scenario image (1024×1024) | ≤ 150 KB | WebP lossy, quality 85 |
| Character portrait (512×512) | ≤ 80 KB | WebP lossy, quality 85 |
| Achievement badge (256×256) | ≤ 30 KB | WebP lossy, quality 90 |
| Dialogue audio (3–6s) | ≤ 50 KB | Opus 64kbps VBR |
| Vocabulary audio (1–3s) | ≤ 25 KB | Opus 48kbps VBR |
| UI sound (<1s) | ≤ 10 KB | Opus 48kbps VBR |
| Video clip (15–30s) | ≤ 5 MB | H.264 720p |

---

## 6. Versioning System

### 6.1 Asset Versioning

```
{asset_path}?v={content_hash_first_8_chars}

Example:
  audio/missions/m01_001_d/vocab_guten_tag_native.opus?v=a3f82b1c
```

### 6.2 Content Pack Versioning

```yaml
content_pack:
  version: "1.0.0"
  build_date: "2026-07-06"
  missions_count: 10
  audio_files_count: 280
  images_count: 30
  total_size_mb: 45
  
  manifest:
    - mission: "m01_001_d"
      audio_files: 28
      images: 3
      status: "complete"
```

When content is updated, only changed files are distributed (delta updates if internet available; full pack for offline install).

---

## 7. Build Pipeline

```
content_source/         # Human-authored YAML + reviewed assets
    └── missions/
    └── vocabulary/
    └── audio/
    └── images/
         │
         ▼
┌─────────────────────────────────┐
│     CONTENT BUILD PIPELINE       │
│                                  │
│  1. Validate all YAML            │
│  2. Cross-reference vocabulary   │
│  3. Verify all audio paths exist │
│  4. Compile YAML → SQLite        │
│  5. Compress images              │
│  6. Generate asset manifest      │
│  7. Package into content bundle  │
│  8. Calculate checksums          │
│                                  │
└─────────────────────────────────┘
         │
         ▼
assets/                # App-bundled production assets
    └── databases/phoenix_content.db
    └── audio/missions/...
    └── images/...
```

---

*End of Part 05. Continue to `06_quality_system.md`.*
