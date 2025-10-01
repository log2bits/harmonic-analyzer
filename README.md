# Harmonic Analyzer

A Rust + WebAssembly tool that analyzes and solves the dissonance problem between natural harmonics and equal temperament.

## The Problem

Natural instruments produce overtones at integer multiples of the fundamental frequency (2×, 3×, 4×, 5×…). Equal temperament uses logarithmic spacing (2^(n/12)). These don’t match.

**Example:** Playing A4 (440 Hz)

- 3rd natural harmonic: 1320 Hz
- Equal tempered E6: 1318.51 Hz
- Difference: 1.49 Hz → creates audible beating and dissonance

This happens with every note on every acoustic instrument. We’ve accepted it as normal, but it doesn’t have to be this way.

## What This Project Does

### Part 1: Dissonance Analysis

- Record any sound (voice, instrument, etc.)
- Extract its harmonic structure via FFT
- Calculate dissonance when playing equal-tempered intervals
- Visualize which intervals are most/least dissonant for that specific timbre

### Part 2: Design Modified Instruments

**The key innovation:** Don’t just transpose the sound—reshape its overtone structure.

**Standard synthesis:**

- Record sound at pitch X
- Play at pitch Y by scaling all frequencies proportionally
- Overtones still follow natural harmonic series
- Still creates dissonance with equal temperament

**Our approach:**

- Record sound and extract: harmonic amplitudes + formants
- **Modify overtone ratios** to align with equal temperament (e.g., 3× → 2^(19/12)×)
- Keep formants at original frequencies (preserves timbre character)
- Synthesize notes with the modified overtone structure

**Result:** An instrument that sounds like the original but has overtones perfectly aligned with equal temperament—no inherent dissonance.

## Key Concepts

**Harmonics:** Frequency components that scale with pitch. Define the “richness” of sound.

**Formants:** Fixed resonant peaks that don’t change with pitch. Define the recognizable “character” (what makes “ahh” sound like “ahh” or a guitar sound like a guitar).

**Inharmonicity:** When overtones deviate from integer multiples. Natural in bells and pianos. We’re deliberately creating it to match equal temperament.

**Dissonance:** Roughness when frequencies are close but not identical (beating). Calculated using the Plomp-Levelt model based on critical bandwidth.

## Technical Implementation

**Analysis Pipeline:**

1. FFT → frequency spectrum
1. Peak detection → identify harmonics vs formants
1. Harmonic analysis → extract overtone pattern
1. Formant extraction → smooth spectrum, find broad resonances
1. Dissonance calculation → Plomp-Levelt curve for all frequency pairs

**Synthesis Pipeline:**

1. For target pitch, generate overtones at **modified ratios** (not natural harmonics)
1. Apply bandpass filters at **original formant frequencies** (preserves timbre)
1. Apply original amplitude envelope (attack/decay characteristics)
1. Normalize output

**Core algorithm:**

```rust
// Natural harmonics
harmonics = [1×, 2×, 3×, 4×, 5×, 6×, 7×, 8×...]

// Modified to equal temperament
modified = [2^(0/12)×, 2^(12/12)×, 2^(19/12)×, 2^(24/12)×, 2^(28/12)×, 2^(31/12)×, 2^(34/12)×, 2^(36/12)×...]
//          fundamental, octave,     fifth,     2 octaves,  maj 3rd,     perf 5th,    min 7th,     3 octaves

// Formants stay at original frequencies regardless of pitch
formants = [800 Hz, 1200 Hz, 2500 Hz]  // unchanged
```

## Why This Matters

**Musical:** Creates genuinely new instruments with zero tuning-related dissonance. Pure consonance at all intervals.

**Scientific:** Demonstrates the physical basis of dissonance and the compromise inherent in equal temperament.

**Educational:** Makes abstract concepts (harmonics, formants, dissonance) concrete and audible.

## Tech Stack

- **Rust + WebAssembly:** High-performance audio processing in the browser
- **rustfft:** Fast Fourier Transform for spectral analysis
- **Web Audio API:** Real-time audio capture and playback
- **Docker:** Consistent development environment

## Project Structure

```
src/
├── lib.rs                    # WASM bindings
├── spectral_analysis.rs      # FFT, harmonic/formant extraction
├── digital_instrument.rs     # Synthesis with modified overtones
└── dissonance.rs            # Plomp-Levelt dissonance calculation

www/
├── index.html               # Web interface
└── audio-processor.js       # Web Audio integration
```

## Getting Started

```bash
# Using Docker
make dev

# Or locally
wasm-pack build --target web --out-dir www/pkg
cd www && python3 -m http.server 8000
```

Open http://localhost:8000

## What Makes This Novel

Existing technologies:

- **Vocoders:** Real-time timbre transfer (requires continuous input)
- **Samplers:** Pitch-shifting with formant preservation (doesn’t fix dissonance)
- **Spectral synthesis:** Can create any spectrum (doesn’t specifically address ET alignment)

This project:

- Analyzes the specific dissonance between natural harmonics and equal temperament
- Creates instruments with intentionally inharmonic overtones aligned to equal temperament
- Preserves timbral character while eliminating tuning-related dissonance
- Open-source, browser-based, educational focus

## Future Directions

- Real-time tuner that shows dissonance, not just pitch accuracy
- Custom scale designer that minimizes dissonance for specific timbres
- Physical instrument modeling (calculate string tensions, bore shapes, etc. that would produce these modified overtones)
- Comparative listening tests between natural and modified instruments