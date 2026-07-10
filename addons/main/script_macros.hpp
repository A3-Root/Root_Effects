#include "\x\cba\addons\main\script_macros_common.hpp"

// Logs a debug message for the current component when verbose logging is
// enabled via the CBA setting. Wrap formatted messages in FORMAT_n macros so
// their commas stay protected, e.g. DBG(FORMAT_1("started %1",_key)).
#define DBG(msg) [QUOTE(COMPONENT), msg] call EFUNC(main,log)

// Shared class name of the invisible helper object that anchors a running
// effect instance in the world.
#define ANCHOR_CLASS "Land_HelipadEmpty_F"
