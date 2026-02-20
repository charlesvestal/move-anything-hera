# Hera for Move Everything

Juno-60 emulation synthesizer module based on [Hera](https://github.com/jpcima/Hera) by Jean Pierre Cimalando (jpcima).

Analog-modeled polyphonic synthesizer with DCO, resonant VCF, BBD chorus, and LFO — faithful to the Roland Juno-60 architecture.

## Features

- 6-voice polyphonic (balanced for Move's ARM CPU)
- Faust-generated DSP: DCO, VCF, VCA, HPF, and chorus
- BBD (bucket-brigade device) chorus simulation with Chorus I / II modes
- Resonant lowpass filter with envelope, LFO, and key tracking modulation
- Full ADSR envelope with gate mode option
- 56 factory presets
- Works standalone or as a sound generator in Signal Chain patches

## Prerequisites

- [Move Everything](https://github.com/charlesvestal/move-anything) installed on your Ableton Move
- SSH access enabled: http://move.local/development/ssh

## Install

### Via Module Store (Recommended)

1. Launch Move Everything on your Move
2. Select **Module Store** from the main menu
3. Navigate to **Sound Generators** > **Hera**
4. Select **Install**

### Build from Source

Requires Docker (recommended) or ARM64 cross-compiler.

```bash
git clone https://github.com/charlesvestal/move-anything-hera
cd move-anything-hera
./scripts/build.sh
./scripts/install.sh
```

## Controls

| Control | Function |
|---------|----------|
| Jog wheel | Browse presets |
| Knobs 1-8 | Adjust parameters for current category |

In Shadow UI / Signal Chain, parameters are organized into navigable categories.

## Parameters (26 total)

### DCO (Oscillator)
`saw_level`, `pulse_level`, `sub_level`, `noise_level`, `pwm_depth`, `pwm_mod` (LFO/Manual/Env), `pitch_range`, `pitch_mod`

### VCF (Filter)
`vcf_cutoff`, `vcf_resonance`, `vcf_env`, `vcf_lfo`, `vcf_key`, `vcf_bend`

### VCA (Amplifier)
`vca_depth`, `vca_type` (Envelope/Gate)

### Envelope
`attack`, `decay`, `sustain`, `release`

### LFO
`lfo_rate`, `lfo_delay`, `lfo_trigger` (free/key trigger)

### HPF
`hpf`

### Chorus
`chorus_i` (on/off), `chorus_ii` (on/off)

## Troubleshooting

**No sound:**
- Check that a preset is loaded (preset name shows in display)
- Ensure `saw_level` or `pulse_level` is above 0
- Try a different preset — some may have very specific settings

**Thin or dull sound:**
- Increase `vcf_cutoff` — filter may be closing off harmonics
- Enable Chorus I or II for stereo width and warmth

**CPU usage high:**
- Play fewer simultaneous notes
- Chorus adds BBD simulation overhead — disable if not needed

## License

GPL-3.0 — See [LICENSE](LICENSE)

Based on Hera by Jean Pierre Cimalando, which is also GPL-3.0 licensed. Individual components use compatible licenses:

| Component | License |
|-----------|---------|
| Core synth engine (envelopes, LFO, tables) | GPL-3.0-or-later |
| Faust DSP (DCO, VCA, HPF) | GPL-3.0-or-later |
| Faust DSP (Chorus, VCF filter) | ISC |
| BBD simulation (bbd_filter, bbd_line) | ISC |
| Utilities (SmoothValue, LerpTable, FaustHelpers) | ISC |

All licenses are compatible with the GPL-3.0 module license. ISC is a permissive license that allows inclusion in GPL-licensed works.

## AI Assistance Disclaimer

This module is part of Move Everything and was developed with AI assistance, including Claude, Codex, and other AI assistants.

All architecture, implementation, and release decisions are reviewed by human maintainers.  
AI-assisted content may still contain errors, so please validate functionality, security, and license compatibility before production use.
