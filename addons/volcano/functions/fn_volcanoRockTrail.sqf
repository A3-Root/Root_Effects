#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

private _trailPos = _this;
drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,8,1],"","Billboard",1,5+(random 10),[_trailPos#0+(selectRandom[random 3,random -3]),_trailPos#1+(selectRandom[random 3,random -3]),_trailPos#2],[0,0,0],7,10,8,3,[31-rockTrailProgress,41-rockTrailProgress,51-rockTrailProgress],[[1,1,1,0.5],[1,1,1,0.3],[1,1,1,0]],[0.5],1,0,"","",_trailPos];
