# Drone Feed

Streams a camera onto any screen object (render to texture).

## Modes
- **Drone**: the feed follows a drone. Views: gunner (follows the turret gimbal wherever it points), driver (nose camera) or both, alternating on a timer.
- **Satellite**: looks straight down from the set altitude over a map position.

## Screen actions
Within 6 m of the screen:
- **Take Control / Release Control**: anyone can take the controller seat.
- Controller only: **Zoom In / Zoom Out**, **Vision** (normal, night vision, thermal).
- Drone only: **Cycle Camera View** (gunner, driver, both).
- Satellite only: **Retarget Satellite (Map Click)**: opens the map, the next click becomes the new spot.

Controller, zoom, vision, view and satellite position are shared, so every viewer sees the same picture.

## Notes
- Render mode *Proxy* shows the ground point the gunner camera aims at from straight above.
- View distance is raised while a player is near a feed and restored afterwards.
