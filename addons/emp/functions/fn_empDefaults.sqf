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
 * domeInsideAlpha (dome opacity seen from inside, 0 auto), endMode (0 fade, 1 implode),
 * implodeBlast (0 none, 1 small, 2 large explosion at the implosion),
 * fog (fog inside the dome), fogAlpha (0..1),
 * flickerGear / flickerVehicles / flickerLamps (lights switched on inside flicker),
 * flickerOnMin / flickerOnMax / flickerOffMin / flickerOffMax (s lit / dark per flicker cycle),
 * marker (0 none, 1 area, 2 area and label), markerSync (Zeus resize changes the radius),
 * restore (recover on leaving), grace (s before units entering later are hit),
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
    ["radius", 300],
    ["altitude", -1],
    ["countdown", 0],
    ["linger", 60],
    ["shockSpeed", 150],
    ["effectDelay", 1],
    ["vehicles", 1],
    ["aircraft", 1],
    ["uavs", 1],
    ["lamps", 1],
    ["gear", 1],
    ["ai", true],
    ["radios", true],
    ["channels", false],
    ["fuelDrain", 0],
    ["hud", true],
    ["shake", true],
    ["visuals", true],
    ["chargeGlow", true],
    ["dome", true],
    ["domeColor", [0.5, 0.5, 0.5]],
    ["domeAlpha", 0.03],
    ["domeShimmer", true],
    ["domeLightning", true],
    ["domeMirage", true],
    ["domeInsideAlpha", 0],
    ["endMode", 0],
    ["implodeBlast", 0],
    ["fog", false],
    ["fogAlpha", 0.5],
    ["flickerGear", false],
    ["flickerVehicles", false],
    ["flickerLamps", false],
    ["flickerOnMin", 5],
    ["flickerOnMax", 20],
    ["flickerOffMin", 2],
    ["flickerOffMax", 10],
    ["marker", 1],
    ["markerSync", true],
    ["restore", true],
    ["grace", 5],
    ["warnGround", 50],
    ["warnHeli", 200],
    ["warnPlane", 500],
    ["beep", true],
    ["timer3D", true],
    ["timerHint", false],
    ["interaction", 3],
    ["holdTime", 10],
    ["interactDistance", 5],
    ["requiredItem", ""],
    ["abortCountdown", true],
    ["endOnDestroyed", true],
    ["itemsExtra", ""],
    ["itemsImmune", ""],
    ["vehiclesImmune", ""]
]
