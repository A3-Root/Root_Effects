#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Particle timer callback of the ejected rocks. Leaves a smoke puff behind
 * the rock whose size shrinks the longer the burst has been running, so
 * trails thin out while the rocks fall. The engine calls this with _this set
 * to the particle position.
 */

private _trailPos = _this;
private _elapsed = diag_tickTime - (missionNamespace getVariable [QGVAR(rockTrailStart), diag_tickTime]);
private _shrink = (_elapsed / 0.3) min 50;

drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 8, 1], "", "Billboard", 1, 5 + random 10, [(_trailPos select 0) + selectRandom [random 3, random -3], (_trailPos select 1) + selectRandom [random 3, random -3], _trailPos select 2], [0, 0, 0], 7, 10, 8, 3, [31 - _shrink, 41 - _shrink, 51 - _shrink], [[1, 1, 1, 0.5], [1, 1, 1, 0.3], [1, 1, 1, 0]], [0.5], 1, 0, "", "", _trailPos];
