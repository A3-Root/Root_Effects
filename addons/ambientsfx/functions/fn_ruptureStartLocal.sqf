#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one spacetime rupture: a shimmering band of
 * volumetric lights in the night sky. A slow watcher loop shows the band at
 * night, hides it during the day and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Shape index <NUMBER>
 * 2: Fade in seconds <NUMBER>
 * 3: Fade out seconds <NUMBER>
 * 4: Particle lifetime seconds <NUMBER>
 * 5: Density 0.1 - 1 <NUMBER>
 * 6: Fixed in place <BOOL>
 * 7: Shape seed <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 0, 20, 20, 120, 0.5, false, 1234] call root_effects_ambientsfx_fnc_ruptureStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_shape", 0, [0]], ["_fadeIn", 20, [0]], ["_fadeOut", 20, [0]], ["_lifetime", 180, [0]], ["_density", 0.5, [0]], ["_fixed", false, [false]], ["_seed", 0, [0]]];

[_anchor, "rupture", _shape, _fadeIn, _fadeOut, _lifetime, _density, _fixed, _seed] call FUNC(skyBandLocal);
