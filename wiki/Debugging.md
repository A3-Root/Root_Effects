# Debugging

CBA settings > Root's Effects > General > **Debug Output**:

| Value | Result |
|---|---|
| Off | Nothing is logged. |
| RPT log | Every machine writes its own lines to its RPT. |
| RPT log + chat for Zeus/admins | As above, plus system chat for Zeus users and logged-in admins. Lines from the server and headless clients are relayed to every Zeus. |

Every line says what happened, in which component, on which machine and when:

```
[Root's Effects][zeus][CLIENT#3 Root t=812.4] Root requested root_effects_strikes_startSingularity at 123456 with [...]
[Root's Effects][main][SERVER t=812.5] started effect singularity at 123456 (anchor 2:117), client event root_effects_strikes_singularityLocal
[Root's Effects][strikes][CLIENT#3 Root t=812.5] singularityLocal running here with [...]
[Root's Effects][strikes][SERVER t=820.6] singularity collapsed at 123456, threw 14 objects, damage 1
```

What is logged:
- every Zeus module request: who, where (map grid) and the full parameters;
- every 3DEN module activation with its attributes;
- every effect start and stop on the server, with its anchor and parameters;
- every client side renderer starting on a machine;
- damage dealt (amount, type, target, source) and strike/avalanche/acid rain summaries;
- rejected requests (mod disabled, effect disabled, bad class names).
