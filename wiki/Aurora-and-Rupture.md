# Aurora, Spacetime Rupture and Modify Sky Effect

## Start options (both)
| Option | Meaning |
|---|---|
| Altitude | Height of the band. |
| Shape | Band, arc, wave, ring, spiral or random. All clients draw the same shape. |
| Spawn / Despawn Speed | Fade in and fade out time of each light. |
| Lifetime | How long each light lives. |
| Density | Lights per second. |
| Size Scale | Size of each light. |
| Length Scale | How far the band stretches. |
| Shape Switch Interval | Every X seconds the band takes a new form (0 = never). |
| Movement Speed / Movement (rupture) | Drift on one heading or wander around the start point. |
| Start Held in Place (3DEN) | Fills once, then holds. |

Only renders at night. Paused instances keep what is in the sky but add nothing.

## Modify Sky Effect
Zeus: place near a running aurora or rupture. 3DEN: activates with its trigger (or at mission start) and changes the nearest one within its search range.

| Option | Meaning |
|---|---|
| Keep As Is | Holds every light exactly where it is. No light fades and no new one appears. |
| Allow New Particles | New lights keep appearing. |
| Allow Particles To Fade Out | Off = every light visible now (and any new one) stays for good. |
| Size / Length Scale | Live resize. |
| Shape, Shape Switch Interval | Live reshape. |
| Movement Speed / Movement | Start, stop or change movement. |

Changes apply immediately to every client; nothing restarts.
