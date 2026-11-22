# Horn Signals wiki macros for Redmine

Three wiki macros for teams that document railway, harbour or event safety
procedures in Redmine: signal plans for a heritage railway, a boat club's
start sequence, a noise study around a level crossing.

| Macro | Output |
|---|---|
| `{{horn_signal(- - o -)}}` | the signal drawn to scale as bars, with total duration |
| `{{horn_signal(crossing)}}` | catalog signal plus its meaning |
| `{{horn_signal(o o o o o, long=5000)}}` | custom `short=`, `long=`, `gap=` in ms |
| `{{horn_onset(45)}}` | "45 mph: start between 1320 ft and 990 ft before the crossing" (49 CFR 222.21) |
| `{{horn_level(110, 1000)}}` | "90.0 dB(A) at 1000 ft (from 110 dB(A) at 100 ft, free-field estimate)" |

Catalog names: `crossing`, `proceed`, `acknowledge`, `back-up`, `request`
(US railway, GCOR 5.8.2) and `starboard`, `port`, `astern`, `danger`, `fog`
(COLREGS Rules 34 and 35). In patterns `-` (or `L`) is a long sound and `o`
(or `S`) a short one.

The level macro uses the inverse-square law (6 dB less per doubling of
distance) from a reference level at 100 ft, the distance at which US
locomotive horns must measure 96-110 dB(A) (49 CFR 229.129). Real levels are
usually lower because of ground, buildings and air absorption.

## Install

```sh
cd $REDMINE_ROOT/plugins
git clone https://github.com/bosshorncom-cmd/redmine_horn_signals.git
# restart Redmine
```

No database migrations, no settings. Redmine 5.0 or later.
Uninstall by removing the directory and restarting.

## Tests

The pattern arithmetic is plain Ruby: `ruby test/unit/pattern_test.rb`.

## Background

Written while collecting decibel figures for a portable
[train horn](https://hornguns.com/) comparison: a wiki page full of
signal patterns and dB-at-distance numbers is easier to review when the
patterns are drawn and the numbers are computed from one formula.

## License

GPL-2.0-or-later (same as Redmine). Copyright (c) 2026 Train Horns Lab.
