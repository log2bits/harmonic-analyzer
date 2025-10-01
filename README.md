# Harmonic Analyzer

A Rust + WebAssembly project for analyzing audio harmonics, exploring dissonance in musical scales, and creating digital instruments from arbitrary sounds.

## Project Overview

This project explores the relationship between musical harmony, the physics of sound, and instrument design through two interconnected goals:

1. **Analyze musical dissonance**: Investigate why the Western equal-tempered scale, while mathematically elegant, doesn’t always align perfectly with naturally harmonic sounds.
1. **Create custom digital instruments**: Record any sound (voice, nature, instruments, etc.) and create a playable digital instrument that reproduces that sound’s unique character across the entire chromatic scale.

## Music Theory Foundations

### The Western Musical Scale

The Western music system divides an octave into 12 equal semitones, called **equal temperament**. Each semitone is separated by a frequency ratio of 2^(1/12) ≈ 1.0595.

**Example: Starting from A4 (440 Hz)**

- A4: 440 Hz
- A#4: 466.16 Hz
- B4: 493.88 Hz
- C5: 523.25 Hz
- …
- A5: 880 Hz (exactly double, one octave up)

This system allows instruments to be tuned consistently and to play in any key, but it involves a compromise…

### The Problem: Natural Harmonics vs Equal Temperament

When a string vibrates, a drum resonates, or a voice produces sound, it doesn’t just create one pure frequency. It creates a **fundamental frequency** (the pitch you hear) plus **overtones** (higher frequencies that color the sound).

For many naturally resonating objects, these overtones follow the **harmonic series**: integer multiples of the fundamental.

**Natural harmonic series starting from 100 Hz:**

- 1st harmonic (fundamental): 100 Hz
- 2nd harmonic (octave): 200 Hz ✓ matches equal temperament
- 3rd harmonic: 300 Hz (perfect fifth) ✗ slightly different from equal temperament
- 4th harmonic: 400 Hz (two octaves) ✓ matches
- 5th harmonic: 500 Hz (major third) ✗ noticeably different
- 6th harmonic: 600 Hz ✗ slightly off
- And so on…

**The conflict**: Natural harmonics follow simple integer ratios (2:1, 3:2, 5:4), while equal temperament uses irrational ratios (2^(n/12)). This mismatch creates subtle **dissonance** even in “consonant” chords.

### What is Dissonance?

**Dissonance** is the perceived harshness or instability when two or more frequencies sound together. It occurs when:

1. **Frequencies are very close but not identical** (creates beating - a wobbling sound)
1. **Overtones clash** (harmonics of different notes interfere with each other)
1. **Critical band interference** (frequencies too close for the ear to resolve separately)

**Consonance** is the opposite - a sense of stability and pleasantness when frequencies align well.

**Historical context**: Before equal temperament, musicians used various tuning systems like “just intonation” (based on pure integer ratios) which sounded better in specific keys but couldn’t modulate easily. Equal temperament was a compromise that enabled musical flexibility at the cost of perfect harmonic alignment.

## What is Timbre?

**Timbre** (pronounced “TAM-ber”) is what makes a piano sound different from a violin even when playing the same note at the same volume. It’s the “color” or “texture” of sound.

### Components of Timbre

Timbre is determined by several factors:

1. **Harmonic content**: The relative amplitudes of different overtones
1. **Formants**: Fixed resonant frequencies that don’t change with pitch
1. **Attack and decay**: How the sound begins and ends
1. **Temporal evolution**: How the sound changes over time
1. **Noise components**: Non-harmonic elements (breath, bow friction, etc.)

### Example: Piano vs Violin

**Piano playing A4 (440 Hz):**

- Strong fundamental at 440 Hz
- Harmonics at 880, 1320, 1760, 2200 Hz…
- Sharp attack, gradual decay
- Each harmonic decays at different rates (higher harmonics fade faster)

**Violin playing A4 (440 Hz):**

- Strong fundamental at 440 Hz
- Different harmonic amplitude ratios (more emphasis on certain harmonics)
- Slow attack (bow gradually starts string vibration)
- Sustained harmonics with vibrato (periodic pitch variation)
- Body resonances create formants around 300 Hz, 600 Hz, 1200 Hz

Even though both play 440 Hz, they sound completely different!

## Spectral Fingerprinting: Capturing Sound’s DNA

A **spectral fingerprint** is a complete mathematical description of a sound’s characteristics. It’s like extracting the “DNA” that makes a sound unique.

### What We Extract

#### 1. Harmonics (Pitch-Dependent Components)

**Definition**: Frequency components that are integer multiples of the fundamental frequency.

**Why they matter**: Harmonics determine the “richness” of a sound and move proportionally when you change pitch.

**Example**:

```
Voice singing at 200 Hz:
  - 1st harmonic: 200 Hz (amplitude: 1.0)
  - 2nd harmonic: 400 Hz (amplitude: 0.7)
  - 3rd harmonic: 600 Hz (amplitude: 0.5)
  - 4th harmonic: 800 Hz (amplitude: 0.3)

When transposed to 300 Hz:
  - 1st harmonic: 300 Hz (amplitude: 1.0)
  - 2nd harmonic: 600 Hz (amplitude: 0.7)
  - 3rd harmonic: 900 Hz (amplitude: 0.5)
  - 4th harmonic: 1200 Hz (amplitude: 0.3)

The amplitude ratios stay the same!
```

#### 2. Formants (Pitch-Independent Components)

**Definition**: Broad resonant peaks in the frequency spectrum that remain at fixed frequencies regardless of the pitch being played.

**Why they matter**: Formants are THE key to recognizable timbre. They’re what makes a voice sound like a voice, and what distinguishes different vowel sounds.

**Physical origin**:

- **Voices**: Shape of vocal tract cavities (mouth, throat, nasal passages)
- **Instruments**: Body resonances, air cavity resonances, material properties

**Example - Vowel sounds**:

```
Voice saying "Eee":
  - Formant 1 (F1): ~300 Hz
  - Formant 2 (F2): ~2300 Hz
  - Formant 3 (F3): ~3000 Hz

Voice saying "Ahh":
  - Formant 1 (F1): ~800 Hz
  - Formant 2 (F2): ~1200 Hz
  - Formant 3 (F3): ~2500 Hz

These formant positions stay constant whether you whisper (no pitch) or sing high or low!
```

**Guitar body resonances**:

```
Acoustic guitar has formants around:
  - ~100 Hz (air cavity resonance)
  - ~200 Hz (back plate resonance)
  - ~400 Hz (top plate resonance)

These are present whether you play low E or high E!
```

#### 3. Amplitude Envelope

**Definition**: How the loudness of a sound changes over time.

**Components (ADSR)**:

- **Attack**: How quickly sound reaches full volume (milliseconds to seconds)
- **Decay**: Initial drop after peak
- **Sustain**: Steady-state volume level
- **Release**: How sound fades after note ends

**Examples**:

```
Piano:
  - Attack: Very fast (~10ms)
  - Decay: Immediate drop
  - Sustain: Gradual fade
  - Release: Long tail with damper pedal

Violin (bowed):
  - Attack: Slow (~100ms)
  - Decay: Minimal
  - Sustain: Constant (as long as bow moves)
  - Release: Quick when bow lifts

Snare Drum:
  - Attack: Instant (~1ms)
  - Decay: Very fast
  - Sustain: None
  - Release: Fast (~100ms)
```

#### 4. Spectral Centroid

**Definition**: The “center of mass” of the frequency spectrum - a measure of how “bright” or “dark” a sound is.

**Calculation**: Weighted average of frequencies, where the weight is the amplitude at each frequency.

**Examples**:

```
Dark sounds (low spectral centroid):
  - Bass guitar: ~200 Hz
  - Male voice: ~300 Hz
  - Cello: ~400 Hz

Bright sounds (high spectral centroid):
  - Cymbals: ~8000 Hz
  - Flute: ~2000 Hz
  - Violin: ~1500 Hz
```

## How This Project Works

### Part 1: Dissonance Analysis

1. **Record any musical sound** (instrument, voice, etc.)
1. **Perform FFT (Fast Fourier Transform)** to decompose it into frequency components
1. **Identify fundamental and harmonics**
1. **Calculate dissonance** between pairs of notes based on:
- Frequency ratios
- Overtone interactions
- Critical band theory (Plomp-Levelt curve)
1. **Visualize dissonance landscape** showing which notes clash and which harmonize

**Goal**: Understand why certain intervals sound consonant or dissonant in equal temperament, and explore alternative tuning systems.

### Part 2: Digital Instrument Synthesis

This is where things get really interesting!

#### The Process

**Step 1: Record Any Sound**
Record anything - your voice saying “ahh”, a cat meow, a door creaking, ocean waves, etc.

**Step 2: Extract Spectral Fingerprint**

- Analyze with FFT to get frequency spectrum
- Separate harmonics (pitch-dependent) from formants (pitch-independent)
- Extract amplitude envelope
- Calculate phase relationships

**Step 3: Create Synthesis Model**
Build a digital model that can:

- Generate harmonics at any target frequency
- Apply fixed formant filtering
- Reproduce the amplitude envelope

**Step 4: Play the Chromatic Scale**
Now you can “play” your recorded sound at any pitch! The result sounds like the original source but at whatever note you choose.

#### The Magic: Harmonics + Formants

This is the key insight that makes it work:

**Harmonics scale with pitch** (they move):

```
Original recording at 220 Hz (A3):
  Harmonics: 220, 440, 660, 880, 1100 Hz...

Playing at 440 Hz (A4):
  Harmonics: 440, 880, 1320, 1760, 2200 Hz...
  
(Each harmonic doubles in frequency)
```

**Formants stay fixed** (they don’t move):

```
Original recording "ahh" sound:
  Formants: 800, 1200, 2500 Hz

Playing at ANY pitch:
  Formants: Still 800, 1200, 2500 Hz!
  
(These resonances are independent of pitch)
```

**Result**: The formants preserve the recognizable character (“ahh”-ness, “cat”-ness, “ocean”-ness) while the harmonics give you the pitch you want.

#### Example: Voice Instrument

**Record**: Someone singing “ooo” at any comfortable pitch

**Extract**:

- Harmonics: [fundamental, 2×fundamental, 3×fundamental, …]
- Formants: ~300 Hz, ~800 Hz, ~2500 Hz (defines “ooo” vowel)
- Envelope: Slow attack, sustained tone, medium release

**Synthesize at middle C (261.6 Hz)**:

- Generate harmonics at 261.6 Hz, 523.2 Hz, 784.8 Hz…
- Apply bandpass filters at 300, 800, 2500 Hz (preserves “ooo”)
- Apply recorded envelope shape

**Result**: Sounds like a voice saying “ooo” at middle C pitch!

You can now “play” this on a keyboard and have a voice that sings “ooo” at any note you press.

#### Example: Nature Sounds Instrument

**Record**: Ocean waves crashing

**Extract**:

- Harmonics: Complex, noisy spectrum (waves aren’t perfectly periodic)
- Formants: Broad resonances from the beach cavity and water
- Envelope: Build-up (wave approaching), sharp attack (crash), long decay (foam)

**Synthesize at any pitch**: The result sounds like ocean waves but with a definable “pitch” - creating an ethereal, otherworldly instrument.

## Technical Implementation

### Signal Processing Pipeline

```
Input Audio
    ↓
[Windowing & FFT]
    ↓
Frequency Spectrum (magnitudes + phases)
    ↓
[Peak Detection]
    ↓
Fundamental Frequency
    ↓
[Harmonic Analysis]          [Formant Analysis]
    ↓                              ↓
Harmonic Series           Formant Peaks
(integer multiples)    (broad resonances)
    ↓                              ↓
[Envelope Extraction]
    ↓
Complete Spectral Fingerprint
    ↓
[Synthesis Model]
    ↓
Digital Instrument
```

### Synthesis Method

**Additive Synthesis + Formant Filtering**:

1. Generate harmonic series at target pitch using sinusoids
1. Apply resonant filters at formant frequencies
1. Modulate with amplitude envelope
1. Normalize output

This is similar to how vocoders work, but with explicit control over every parameter!

## Musical and Scientific Applications

### Musical Applications

- Create impossible instruments (e.g., a tuba that sounds like a human voice)
- Explore alternative tuning systems
- Understand why certain chords sound “out of tune”
- Design custom scales optimized for specific timbres
- Educational tool for understanding acoustics and music theory

### Scientific Applications

- Visualize harmonic relationships
- Study psychoacoustics (how we perceive dissonance)
- Analyze speech and voice characteristics
- Research instrument acoustics
- Audio synthesis and sound design

## Project Goals

1. **Education**: Demystify why music sounds the way it does
1. **Exploration**: Discover the relationship between physics and perception
1. **Creation**: Build genuinely new and interesting instruments
1. **Analysis**: Provide tools to visualize and understand sound

## Why This Matters

Music theory and physics have been intertwined for centuries, from Pythagoras discovering harmonic ratios to modern digital synthesis. This project bridges:

- **Mathematics**: Fourier analysis, frequency ratios, signal processing
- **Physics**: Resonance, wave mechanics, acoustics
- **Perception**: Psychoacoustics, how we hear harmony and timbre
- **Art**: Creating new sounds and musical possibilities

By understanding these connections, we can both appreciate why traditional music works and imagine entirely new sonic possibilities.

-----

## Project Structure

```
├── src/
│   └── lib.rs              # Main Rust WASM module
├── tests/
│   └── wasm_tests.rs       # WASM-specific tests
├── www/
│   ├── index.html          # Web interface
│   ├── audio-processor.js  # JavaScript audio handling
│   └── package.json        # Web dependencies
├── docker/
│   └── nginx.conf          # Nginx configuration for production
├── scripts/
│   └── dev.sh              # Development helper script
├── Dockerfile              # Multi-stage Docker build
├── docker-compose.yml      # Docker services configuration
├── Makefile               # Docker command shortcuts
├── .dockerignore          # Docker build exclusions
├── Cargo.toml             # Rust dependencies
└── README.md
```

## Setup

### Option 1: Docker (Recommended)

1. **Prerequisites:**
   - Docker
   - Docker Compose

2. **Quick start:**
   ```bash
   # Start development server
   make dev
   # OR
   docker-compose up --build dev
   # OR use the helper script
   chmod +x scripts/dev.sh
   ./scripts/dev.sh dev
   ```

3. **Open in browser:**
   Navigate to `http://localhost:8000`

### Option 2: Local Development

1. **Install Rust and wasm-pack:**
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
   ```

2. **Build the WASM module:**
   ```bash
   wasm-pack build --target web --out-dir www/pkg
   ```

3. **Serve the web app:**
   ```bash
   cd www
   python3 -m http.server 8000
   ```

## Docker Commands

```bash
# Development
make dev                # Start development server
make rebuild-wasm       # Rebuild WASM module
make shell              # Open shell in Rust container

# Testing
make test               # Run all tests
make test-rust          # Run Rust tests only
make test-wasm          # Run WASM tests only

# Production
make prod               # Start production server

# Utilities
make build              # Build all images
make clean              # Clean up containers/images
make help               # Show all commands
```

## Testing

**Docker testing:**
```bash
make test               # Run all tests in container
make test-rust          # Rust tests only
make test-wasm          # WASM tests only
```

**Local testing:**
```bash
cargo test                              # Rust tests
wasm-pack test --headless --firefox     # WASM tests
```

## Implementation Tasks

### Phase 1: FFT Foundation
- [ ] Implement basic FFT using `rustfft`
- [ ] Write tests with known sine waves
- [ ] Set up audio input in JavaScript

### Phase 2: Audio Analysis  
- [ ] Real-time spectrogram visualization
- [ ] Fundamental frequency detection
- [ ] Harmonic detection and filtering

### Phase 3: Dissonance Analysis
- [ ] Implement dissonance calculation model
- [ ] Visualize dissonance curves
- [ ] Test with various frequency pairs

### Phase 4: Scale Design
- [ ] Optimal scale generation algorithm
- [ ] Scale comparison tools
- [ ] Custom tuning system

### Phase 5: Instrument Design
- [ ] Reverse engineering for optimal fret positions
- [ ] Custom tuner for new instrument
- [ ] Audio synthesis for testing

## Resources

- [Rust WASM Book](https://rustwasm.github.io/docs/book/)
- [rustfft Documentation](https://docs.rs/rustfft/)
- [Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API) harmonic-analyzer
