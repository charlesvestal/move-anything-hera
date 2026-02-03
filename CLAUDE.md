# Hera Module for Move Anything

## Overview
Hera is a Juno-60 emulation synthesizer, based on the open-source Hera project by jpcima.
It provides a polyphonic virtual analog synth with DCO, VCF, VCA, LFO, envelope, HPF, and chorus.

## Build
```bash
./scripts/build.sh          # Build with Docker (ARM64 cross-compilation)
./scripts/install.sh        # Deploy to Move device
```

## Architecture

### DSP Engine (src/dsp/Engine/)
The synth engine is derived from https://github.com/jpcima/Hera with JUCE dependencies removed.

Key components:
- **HeraDCO.hxx** - Faust-generated digitally controlled oscillator (saw, pulse, sub, noise)
- **HeraVCF/JpcVCF** - 4-pole resonant lowpass filter
- **HeraVCA.hxx** - Faust-generated voltage-controlled amplifier
- **HeraHPF.hxx** - Faust-generated high-pass filter
- **HeraChorus.hxx** - Faust-generated Juno-60 chorus (BBD simulation)
- **HeraEnvelope** - ADSR envelope generator
- **HeraLFO** - Sine LFO with delay envelope
- **HeraTables** - Lookup tables for parameter curves
- **bbd_line/bbd_filter** - Bucket-brigade device simulation for chorus

### Plugin Wrapper (src/dsp/hera_plugin.cpp)
Wraps the engine in Move Anything's Plugin API v2 (instance-based).
Handles voice management, MIDI, parameters, presets, and audio rendering.

### Presets (src/presets/)
56 factory presets from the original Hera project in XML format.

## Parameters (26 total)
- **DCO**: Saw Level, Pulse Level, Sub Level, Noise Level, PWM Depth, PWM Mod, Range, Pitch Mod
- **VCF**: Cutoff, Resonance, Env Mod, LFO Mod, Key Track, Bend Depth
- **VCA**: Depth, Type (Envelope/Gate)
- **Envelope**: Attack, Decay, Sustain, Release
- **LFO**: Rate, Delay, Trigger Mode
- **HPF**: Cutoff
- **Chorus**: Chorus I, Chorus II

## License
GPL-3.0-or-later (same as original Hera project)
