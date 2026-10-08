#define COMPONENT strikes
#define COMPONENT_BEAUTIFIED "Strikes"
#include "\z\root_effects\addons\main\script_mod.hpp"
#include "\z\root_effects\addons\main\script_macros.hpp"

// Length in seconds of A3\Sounds_F\sfx\alarm_independent.wss. The charge is
// never shorter than one full alarm, and the collapse waits for the last one.
#define SINGULARITY_ALARM_LEN 6.7
#define SINGULARITY_MIN_CHARGE 7.2
