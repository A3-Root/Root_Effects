# Debugging

CBA settings > Root's Effects > General > **Debug Output**:

| Value | Result |
|---|---|
| Off | Nothing is logged. |
| RPT log (default) | Every machine writes its own lines to its RPT. |
| RPT log + chat for Zeus/admins | As above, plus system chat for Zeus users and logged-in admins. Lines from the server and headless clients are relayed to every Zeus. |

Every line says what happened, in which component, on which machine and when:

```
[Root's Effects][zeus][CLIENT#3 Root t=812.4] Root requested root_effects_strikes_startSingularity at 123456 with [...]
[Root's Effects][main][SERVER t=812.5] started effect singularity at 123456 (anchor 2:117), client event root_effects_strikes_singularityLocal
[Root's Effects][strikes][CLIENT#3 Root t=812.5] singularityLocal running here with [...]
[Root's Effects][strikes][SERVER t=820.6] singularity collapsed at 123456, threw 14 objects, damage 1
```

What is logged:
- every function call with its full arguments (except per-frame helpers), on the machine where it ran;
- every Zeus module request: who, where (map grid) and the full parameters;
- every 3DEN module activation with its attributes;
- every effect start and stop on the server, with its anchor and parameters;
- every client side renderer starting on a machine;
- damage dealt (amount, type, target, source) and strike/avalanche/acid rain summaries;
- rejected requests (mod disabled, effect disabled, bad class names).

Searching the RPT: every line starts with `[Root's Effects]`, then the component, then the machine (`HOST`, `SERVER`, `HC#n`, `CLIENT#n` with the player name) and the mission time. Filter by component (`[briefing]`, `[dronefeed]`, `[volcano]` ...) to follow one module from the Zeus request through the server start to every client that drew it.

Module specific detail:
- Briefing Table: table class, bounding box, measured table top and how it was found, terrain tile count, sample tile and object heights against the table top.
- Drone Feed: activation per screen, every 10 s which gunner aim source was used and all candidate directions, controller changes, satellite retargets.
- Scree Avalanche: boulder path count and seed, every boulder hit (target, speed, damage, grid).
- Strikes: blast, entities hit, outright kills, structures queued, lights put out, singularity throws and aftermath kills.
