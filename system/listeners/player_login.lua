-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("PLAYER_LOGIN", function(...)
  PossiblyEngine.print('Initializing!')
  PossiblyEngine.rotation.auto_unregister()
  PossiblyEngine.listener.trigger("PLAYER_SPECIALIZATION_CHANGED", "player")
  PossiblyEngine.interface.init()
  PossiblyEngine.module.player.init()
  PossiblyEngine.raid.build()
end)
