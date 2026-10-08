#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one spacetime rupture: a shimmering band of
 * volumetric lights in the night sky. A slow watcher loop shows the band at
 * night, hides it during the day and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Fade in time in seconds <NUMBER>
 * 2: Fade out time in seconds <NUMBER>
 * 3: Particle lifetime in seconds <NUMBER>
 * 4: Density 0.1 - 1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 20, 20, 120, 0.5] call root_effects_ambientsfx_fnc_ruptureStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_fadeIn", 20, [0]], ["_fadeOut", 20, [0]], ["_lifetime", 180, [0]], ["_density", 0.5, [0]]];

[_anchor, "rupture", _fadeIn, _fadeOut, _lifetime, _density] call FUNC(skyBandLocal);
