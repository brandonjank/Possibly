-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("PLAYER_STARTED_MOVING", function(...)
	PossiblyEngine.module.player.moving = true
	PossiblyEngine.module.player.movingTime = GetTime()
end)

PossiblyEngine.listener.register("PLAYER_STOPPED_MOVING", function(...)
	PossiblyEngine.module.player.moving = false
	PossiblyEngine.module.player.movingTime = GetTime()
end)
