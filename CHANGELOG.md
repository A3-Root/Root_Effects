# Changelog for Root's Effects

## Version: 3.0.0 - Major Release
- Complete refactor of every component onto a shared CBA framework: per-frame handlers instead of spawn/sleep loops, CBA events instead of publicVariable broadcasts, JIP-safe effect starts, and one invisible anchor object per running effect instance.
- Every effect is now available in BOTH Zeus (ZEN dialog) and the 3DEN editor (module with attributes).
- Effects are multi-instance: the same effect can run at several places at once, and the Terminate Effects module lists every running instance with per-instance stop, per-effect stop-all and a global stop.
- Added CBA settings: master enable, per-module enable (server side whitelist/blacklist), global damage kill-switch, effect view distance, particle budget, verbose debug logging and per-component tunables.
- Works with and without ACE: infantry damage routes through ACE medical when loaded, plain damage otherwise.
- New effects: Fireworks Display, Orbital Laser Strike, Napalm Strike, Carpet Bombing Strike, Lightning Storm, Acid Rain, Heat Mirage, Water Contamination, EMP Pulse, Bird Swarm, Live Briefing Map, Briefing Table diorama, plus an optional standalone red water recolor addon (watercolor).
- Fully modular: each PBO is independently deletable; the rest of the mod keeps working without it.
- Renamed the fallstar component to meteor and standardized all remaining non-English identifiers, sound class names and sound file names to English.
- Fixed: hardcoded Tanoa coordinates in the volcano lethality, damage being applied once per connected client by the AA barrage, wrong ACE medical function name in four components, several undefined variables and broken sound class references, missing JIP support, and leftover debug logging.
- Sounds moved out of the main PBO into the components that use them, so deleting a component also removes its audio.
- Rebuilt addon with HEMTT.
- Open-sourced project. You can view code, comment on how terrible or disgusting it is via issues. Bonus points if you contribute by raising pull requests [url=https://github.com/A3-Root/Root_Effects]by clicking here![/url]
- License changed to ARMA PUBLIC LICENSE SHARE ALIKE (APL-SA) - Have fun with the code. Don't forget to credit the authors (Root and Aliascartoons).
- New logo added (and now be visible in-game) with link to Github repository.
