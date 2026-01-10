#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

diag_log "********************* fn_floatingObjectsServer Entry **********";

if (!isServer) exitWith {};

diag_log "********************* fn_floatingObjectsServer isServer Pass **********";

params ["_floatingObject", "_slideMove", "_bounceMove", "_rotationMove", "_rollVelocity", "_orbitMove", "_distanceDependent", "_elevation", "_allowDamage", "_allowSimulation"];

if (!isNil {_floatingObject getVariable QGVAR(isActive)}) exitWith {};
_floatingObject setVariable [QGVAR(isActive), true, true];

// _nclass = typeOf _objectName;
// _nclass = _objectName;
private _startPos = getPosATL _floatingObject;
private _targetAltitude = _elevation;
// deleteVehicle _objectName;


diag_log "********************* REXEC animateFloatingObject **********";

[_floatingObject, _slideMove, _bounceMove, _rotationMove, _rollVelocity, _orbitMove, _distanceDependent, _startPos, _targetAltitude, _allowDamage, _allowSimulation] remoteExec [QFUNC(animateFloatingObject), [0, -2] select isDedicated, true];
