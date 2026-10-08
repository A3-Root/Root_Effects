# Orbital Laser and Singularity

## Damage slider (both)
- **0%**: harmless, visuals only.
- **Above 0%**: a real GBU-12 detonates at the impact and scaled damage is added on top, falling off to 25% at the edge of the radius. Units, vehicles, statics and their crews are hit.
- At the core of a strong strike (90%+ after falloff) everything is destroyed outright, also with ACE.
- **100%** flattens buildings, walls and trees in roughly the inner half of the radius. Structures collapse in batches to avoid a frame spike.
- Street lamps, floodlights and vehicle lights inside the radius go out.
- Respects the global damage setting and the per-component damage setting.

## Singularity
- Charges for the set time while a pulsing core and warning alarm play. The charge is never shorter than one full alarm (about 7 s); longer charges repeat it, and the collapse always comes after the last alarm ends.
- On collapse, people are torn into ragdoll and thrown (same technique as the Steamer and Worm anomalies), and vehicles, boats, statics, crates and physics props within the radius are thrown up and outwards. Heavier objects go less far.
- With damage above 0%, about a second after the throw, while they are still in the air, every unit in the zone (on foot or in a vehicle) is killed and the GBU-12 blast goes off; every building, wall and tree inside the radius is destroyed outright.
