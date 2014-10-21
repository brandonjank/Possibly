-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- Functions that require FireHack

if FireHack then

    function IterateObjects(callback, ...)
        local totalObjects = ObjectCount()
        for i = 1, totalObjects do
            local object = ObjectWithIndex(i)
            if bit.band(ObjectType(object), ...) > 0 then
                callback(object)
            end
        end
    end

    function ObjectFromUnitID(unit)
        local unitGUID = UnitGUID(unit)
        local totalObjects = ObjectCount()
        for i = 1, totalObjects do
            local object = ObjectWithIndex(i)
            if UnitExists(object) and UnitGUID(object) == unitGUID then
                return object
            end
        end
        return false
    end

    function Distance(a, b)
        if UnitExists(a) and UnitIsVisible(a) and UnitExists(b) and UnitIsVisible(b) then
            local ax, ay, az = ObjectPosition(a)
            local bx, by, bz = ObjectPosition(b)
            return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((UnitCombatReach(a)) + (UnitCombatReach(b)))
        end
        return 0
    end

    function UnitsAroundUnit(unit, distance, checkCombat)
        if UnitExists(unit) then
            local total = 0
            local totalObjects = ObjectCount()
            for i = 1, totalObjects do
                local object = ObjectWithIndex(i)
                if bit.band(ObjectType(object), ObjectTypes.Unit) > 0 then
                    local reaction = UnitReaction("player", object)
                    local combat = UnitAffectingCombat(object)
                    if reaction and reaction <= 4 and (checkCombat or combat) then
                        if Distance(object, unit) <= distance then
                            total = total + 1
                        end
                    end
                end
            end
            return total
        else
            return 0
        end
    end

    function FaceUnit(unit)
        if UnitExists(unit) and UnitIsVisible(unit) then
            local ax, ay, az = ObjectPosition('player')
            local bx, by, bz = ObjectPosition(unit)
            local angle = rad(atan2(by - ay, bx - ax))
            if angle < 0 then
                return FaceDirection(rad(atan2(by - ay, bx - ax) + 360))
            else
                return FaceDirection(angle)
            end
        end
    end

end
