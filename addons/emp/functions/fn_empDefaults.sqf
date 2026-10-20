#include "..\script_component.hpp"

/*
 * Author: Root
 * Default EMP field settings. Keys:
 * radius (m), altitude (dome height m, -1 no limit), countdown (s), linger (s after the
 * wave, -1 until disabled), shockSpeed (m/s, 0 instant), effectDelay (s after the wave),
 * vehicles / aircraft (0 off, 1 disable, 2 destroy), uavs (0 off, 1 disconnect, 2 crash),
 * lamps (0 off, 1 off for the field, 2 broken), gear (0 off, 1 suppress, 2 fry),
 * ai, radios (ACRE jam), channels (vanilla voice channels off), fuelDrain (0..1),
 * hud, shake, visuals, chargeGlow, dome, domeColor [r,g,b], domeAlpha, domeShimmer,
 * domeLightning (arcs on the dome), domeMirage (heat haze on the dome),
 * domeDepth (dome below the object: 0 shallow, 1 deep, 2 full sphere; default: CBA Dome Depth),
 * endMode (0 fade, 1 implode: the wall runs back in at implodeSpeed),
 * implodeSpeed (m/s of the wall running back in, 0: in IMPLODE_TIME s; default: CBA Shutdown Shockwave Speed),
 * implodeBlast (0 none, 1 small, 2 large explosion at the implosion),
 * flickerGear / flickerVehicles / flickerLamps (lights switched on inside flicker),
 * flickerOnMin / flickerOnMax / flickerOffMin / flickerOffMax (s lit / dark per flicker cycle),
 * marker (0 none, 1 area, 2 area and label), markerSync (Zeus resize changes the radius),
 * restore (recover on leaving), restoreDelay (s outside the live field before recovery;
 * default: CBA Recovery Delay), grace (s before units entering later are hit),
 * warnGround / warnHeli / warnPlane (m outside the dome where HUD blinking starts, 0 off),
 * beep, timer3D, timerHint, interaction (0 none, 1 action, 2 ACE, 3 both), holdTime (s),
 * interactDistance (m from the object bounds),
 * requiredItem, abortCountdown, endOnDestroyed, itemsExtra, itemsImmune, vehiclesImmune
 * (comma separated classnames).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Settings <HASHMAP>
 *
 * Example:
 * call root_effects_emp_fnc_empDefaults
 */

createHashMapFromArray [
    ["radius", 500],
    ["altitude", 500],
    ["countdown", 10],
    ["linger", -1],
    ["shockSpeed", 25],
    ["effectDelay", 1],
    ["vehicles", 1],
    ["aircraft", 1],
    ["uavs", 1],
    ["lamps", 2],
    ["gear", 1],
    ["ai", true],
    ["radios", true],
    ["channels", false],
    ["fuelDrain", 0],
    ["hud", false],
    ["shake", true],
    ["visuals", true],
    ["chargeGlow", false],
    ["dome", true],
    ["domeColor", [1, 1, 1]],
    ["domeAlpha", 0.65],
    ["domeShimmer", false],
    ["domeLightning", true],
    ["domeMirage", true],
    ["domeDepth", GVAR(domeDepth)],
    ["endMode", 1],
    ["implodeSpeed", GVAR(implodeSpeed)],
    ["implodeBlast", 1],
    ["flickerGear", true],
    ["flickerVehicles", true],
    ["flickerLamps", false],
    ["flickerOnMin", 5],
    ["flickerOnMax", 20],
    ["flickerOffMin", 2],
    ["flickerOffMax", 10],
    ["marker", 2],
    ["markerSync", true],
    ["restore", true],
    ["restoreDelay", GVAR(restoreDelay)],
    ["grace", 5],
    ["warnGround", 50],
    ["warnHeli", 500],
    ["warnPlane", 1000],
    ["beep", true],
    ["timer3D", false],
    ["timerHint", false],
    ["interaction", 2],
    ["holdTime", 10],
    ["interactDistance", 12],
    ["requiredItem", ""],
    ["abortCountdown", true],
    ["endOnDestroyed", true],
    ["itemsExtra", ""],
    ["itemsImmune", ""],
    ["vehiclesImmune", ""]
]
