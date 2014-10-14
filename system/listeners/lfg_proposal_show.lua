-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("LFG_PROPOSAL_SHOW", function()
  if PossiblyEngine.config.read('autolfg', false) then
    AcceptProposal()
  end
end)