#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Particle timer callback of the ash column emitter. Spawns one large
 * drifting ash cloud billboard at the position of the triggering particle.
 * The engine calls this with _this set to the particle position.
 */

drop [["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 26 + random 20, 50, _this, [(wind select 0) * 6, (wind select 1) * 6, 45], 1, 3, 2, 0, [300, 350, 400], [[1, 1, 1, 0], [0, 0, 0, 1], [1, 1, 1, 1], [0.5, 0.5, 0.5, 0]], [random 0.1], 0.5, 0, "", "", _this];
