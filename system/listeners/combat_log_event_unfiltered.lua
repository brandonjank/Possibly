-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.
--[[
local band = bit.band

local HostileEvents = {
        ['SWING_DAMAGE'] = true,
        ['SWING_MISSED'] = true,
        ['RANGE_DAMAGE'] = true,
        ['RANGE_MISSED'] = true,
        ['SPELL_DAMAGE'] = true,
        ['SPELL_PERIODIC_DAMAGE'] = true,
        ['SPELL_MISSED'] = true
}

PossiblyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)


end)

PossiblyEngine.listener.register("UPDATE_MOUSEOVER_UNIT", function(...)

end)
]]