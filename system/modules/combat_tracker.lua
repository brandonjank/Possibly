-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- im 100% nigga


PossiblyEngine.module.register("combatTracker", {
  units = { },
})

local playerGUID = UnitGUID('player')

local units = PossiblyEngine.module.combatTracker.units
local function isUnit(object, guid)
    if bit.band(ObjectType(object), ObjectTypes.Unit, ObjectTypes.Object) and not UnitIsPlayer(guid) then

    end
end

PossiblyEngine.timer.register("updateCTHealth", function()

    table.empty(units) 

    local totalObjects = ObjectCount()
    for i = 1, totalObjects do
        local object = ObjectWithIndex(i)
        local guid = UnitGUID(object)
        if isUnit(object, guid) then
            local combat = UnitAffectingCombat(guid)
            print(guid, combat)
            if combat then
                table.insert(units, guid)
            end
        end
    end

end, 100)