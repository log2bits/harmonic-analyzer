use wasm_bindgen::prelude::*;
use serde::{Deserialize, Serialize};

#[wasm_bindgen(start)]
pub fn main() {
    console_error_panic_hook::set_once();
}

#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

#[derive(Serialize, Deserialize)]
pub struct FrequencyAnalysis {
    pub frequencies: Vec<f32>,
    pub magnitudes: Vec<f32>,
    pub fundamental_freq: f32,
    pub harmonics: Vec<f32>,
}

// TODO: Implement FFT analysis
#[wasm_bindgen]
pub fn analyze_audio_fft(audio_data: &[f32], sample_rate: f32) -> JsValue {
    // Your FFT implementation here
    todo!("Implement FFT analysis")
}

// TODO: Implement dissonance calculation
#[wasm_bindgen]
pub fn calculate_dissonance(freq1: f32, freq2: f32) -> f32 {
    // Your dissonance model here
    todo!("Implement dissonance calculation")
}

// TODO: Generate optimal scale
#[wasm_bindgen]
pub fn generate_optimal_scale(fundamental: f32, num_notes: usize) -> Vec<f32> {
    // Your scale generation algorithm here
    todo!("Implement scale generation")
}

// TODO: Helper function for finding fundamental frequency
fn find_fundamental_frequency(frequencies: &[f32], magnitudes: &[f32]) -> f32 {
    // Your peak detection algorithm here
    todo!("Implement fundamental frequency detection")
}

// TODO: Helper function for finding harmonics
fn find_harmonics(fundamental: f32, frequencies: &[f32], magnitudes: &[f32]) -> Vec<f32> {
    // Your harmonic detection algorithm here
    todo!("Implement harmonic detection")
}

#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

#[macro_export]
macro_rules! console_log {
    ($($t:tt)*) => (log(&format_args!($($t)*).to_string()))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fft_with_sine_wave() {
        // TODO: Test with known 440Hz sine wave
        todo!("Write test for FFT with known sine wave")
    }

    #[test]
    fn test_dissonance_calculation() {
        // TODO: Test octave vs tritone dissonance
        todo!("Write test for dissonance calculation")
    }

    #[test]
    fn test_scale_generation() {
        // TODO: Test scale properties (ascending, correct length, etc.)
        todo!("Write test for scale generation")
    }
}
