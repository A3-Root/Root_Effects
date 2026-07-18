#define COMPONENT dronefeed
#define COMPONENT_BEAUTIFIED "Drone Feed"
#include "\z\root_effects\addons\main\script_mod.hpp"
#include "\z\root_effects\addons\main\script_macros.hpp"

// Feed modes.
#define FEED_MODE_DRONE "DRONE"
#define FEED_MODE_SATELLITE "SATELLITE"

// Ground render modes for a drone feed.
#define RENDER_MODE_ACCURATE "ACCURATE"
#define RENDER_MODE_PROXY "PROXY"

// Camera views for a drone feed.
#define VIEW_GUNNER "GUNNER"
#define VIEW_DRIVER "DRIVER"
#define VIEW_BOTH "BOTH"

// Default camera field of view.
#define DEFAULT_FOV 0.7
