-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- Functions that require FireHack

function PossiblyEngine.protected.FireHack()

    if FireHack then

        PossiblyEngine.faceroll.rolling = false

        local stickyValue = GetCVar("deselectOnClick")

        PossiblyEngine.pmethod = "FireHack"

        function IterateObjects(callback, ...)
            local totalObjects = ObjectCount()
            for i = 1, totalObjects do
                local object = ObjectWithIndex(i)
                if ObjectExists(object) and ObjectIsType(object, ...) then
                    callback(object)
                end
            end
        end

        function ObjectFromUnitID(unit)
            local unitGUID = UnitGUID(unit)
            local totalObjects = ObjectCount()
            for i = 1, totalObjects do
                local object = ObjectWithIndex(i)
                if ObjectExists(object) and UnitExists(object) and UnitGUID(object) == unitGUID then
                    return object
                end
            end
            return false
        end

        function Distance(a, b)
            if UnitExists(a) and UnitIsVisible(a) and UnitExists(b) and UnitIsVisible(b) then
                local ax, ay, az = ObjectPosition(a)
                local bx, by, bz = ObjectPosition(b)
                if a == "player" then
                  return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((UnitCombatReach(a)) + (UnitBoundingRadius(b)))
                elseif b == "player" then
                  return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((UnitBoundingRadius(a)) + (UnitCombatReach(b)))
                else
                  return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((UnitBoundingRadius(a)) + (UnitBoundingRadius(b)))
                end
            end
            return 0
        end

        local uau_cache_time = { }
        local uau_cache_count = { }
        local uau_cache_dura = 0.1
        function UnitsAroundUnit(unit, distance, checkCombat)
            local uau_cache_time_c = uau_cache_time[unit..distance..tostring(checkCombat)]
            if uau_cache_time_c and ((uau_cache_time_c + uau_cache_dura) > GetTime()) then
                return uau_cache_count[unit..distance..tostring(checkCombat)]
            end
            if UnitExists(unit) then
                local total = 0
                local totalObjects = ObjectCount()
                for i = 1, totalObjects do
                    local object = ObjectWithIndex(i)
                    if ObjectExists(object) and ObjectIsType(object, ObjectTypes.Unit) then
                        --local reaction = UnitReaction("player", object)
                        local combat = UnitAffectingCombat(object)
                        local canAttack = UnitCanAttack("player", object)
                        local isDeadOrGhost = UnitIsDeadOrGhost(object)
                        if canAttack and not isDeadOrGhost and (checkCombat or combat) then
                            if Distance(unit, object) <= distance then
                                total = total + 1
                            end
                        end
                    end
                end
                uau_cache_count[unit..distance..tostring(checkCombat)] = total
                uau_cache_time[unit..distance..tostring(checkCombat)] = GetTime()
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

        local losFlags =  bit.bor(0x10, 0x100)
        function LineOfSight(a, b)
            local ax, ay, az = ObjectPosition(a)
            local bx, by, bz = ObjectPosition(b)
            if TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags) then
                return false
            end
            return true
        end

        function CastGround(spell, target)
            if UnitExists(target) then
              CastSpellByName(spell)
              CastAtPosition(ObjectPosition(target))
              CancelPendingSpell()
              return
            end
            if not PossiblyEngine.timeout.check('groundCast') then
                PossiblyEngine.timeout.set('groundCast', 0.05, function()
                    Cast(spell)
                    if IsAoEPending() then
                        SetCVar("deselectOnClick", "0")
                        CameraOrSelectOrMoveStart(1)
                        CameraOrSelectOrMoveStop(1)
                        SetCVar("deselectOnClick", "1")
                        SetCVar("deselectOnClick", stickyValue)
                        CancelPendingSpell()
                    end
                end)
            end
        end

        function Macro(text)
            return RunMacroText(text)
        end

        function UseItem(name, target)
            return UseItemByName(name, target)
        end

        function Cast(spell, target)
            if type(spell) == "number" then
                CastSpellByID(spell, target)
            else
                CastSpellByName(spell, target)
            end
        end

        PossiblyEngine.protected.unlocked = true
        PossiblyEngine.protected.method = "firehack"
        PossiblyEngine.timer.unregister('detectUnlock')
        PossiblyEngine.print('Detected FireHack!')

    end

end
