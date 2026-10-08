# Root's Effects Wiki

Effects suite rebuilt on CBA. Every effect is a Zeus module (ZEN dialog) and a 3DEN module (attributes) under **Root's Effects**.

Works in single player, hosted multiplayer and on dedicated servers, with or without headless clients:
- the server owns every running effect (one invisible anchor per instance) and applies all damage;
- each client renders the visuals locally, started through a JIP-safe event, so late joiners see running effects;
- anything that needs the owning machine (velocity, hitpoint damage, ACE wounds) is routed there by the server.

ACE is optional. With ACE medical loaded, infantry damage goes through ACE; otherwise plain damage is used.

## Pages
- [Debugging](Debugging.md)
- [Drone Feed](Drone-Feed.md)
- [Briefing Table](Briefing-Table.md)
- [Orbital Laser and Singularity](Orbital-Laser-and-Singularity.md)
- [Scree Avalanche](Scree-Avalanche.md)
- [Acid Rain](Acid-Rain.md)
- [Lightning Storm and Tornado](Lightning-Storm-and-Tornado.md)
- [Artillery Barrage](Artillery-Barrage.md)
- [Aurora, Spacetime Rupture and Modify Sky Effect](Aurora-and-Rupture.md)

Stop any running effect with the **Terminate Effects** module.
