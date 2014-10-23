-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local UnitClass = UnitClass
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS

local player = {
  castCache = {},
  behind = false,
  behindTime = 0,
  infront = true,
  infrontTime = 0,
  moving = false,
  movingTime = 0
}

function player.updateSpec()
  local spec = GetSpecialization()
  local name, classFileName, classID = UnitClass('player')
  local color = RAID_CLASS_COLORS[classFileName]
  local specID, specName, _, specIcon = player.classID
  if spec then
    specID, specName, _, specIcon = GetSpecializationInfo(spec)
  end

  if specID ~= player.specID then
    if specIcon then
      PossiblyEngine.buttons.icon('MasterToggle', specIcon)
    else
      PossiblyEngine.buttons.icon('MasterToggle', 'Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES')
      local coords = CLASS_ICON_TCOORDS[player.classFileName]
      PossiblyEngine.buttons.buttons.MasterToggle.icon:SetTexCoord(unpack(coords))
    end

    PossiblyEngine.rotation.activeRotation = PossiblyEngine.rotation.rotations[specID]
    if PossiblyEngine.rotation.oocrotations[specID] then
      PossiblyEngine.rotation.activeOOCRotation = PossiblyEngine.rotation.oocrotations[specID]
    else
      PossiblyEngine.rotation.activeOOCRotation = false
    end
    PossiblyEngine.buttons.resetButtons()
    if PossiblyEngine.rotation.buttons[specID] then
      PossiblyEngine.rotation.add_buttons()
    end
    player.specID = specID
    player.specName = specName and specName or player.className

    PossiblyEngine.print('|c' .. color.colorStr .. player.specName .. ' ' .. name .. '|r ' .. pelg('rotation_loaded'))
    PossiblyEngine.rotation.loadLastRotation()
  end
end

function player.init()
  local name, classFileName, classID = UnitClass('player')
  player.classID = classID
  player.className = name
  player.classFileName = classFileName
  player.updateSpec()
end

local nextCastIndex = 1
function player.cast(spell)
  player.castCache[nextCastIndex] = spell
  nextCastIndex = nextCastIndex % 10 + 1
end

function player.casted(query)
  local count = 0

  for i = 1, 10 do
    if query == player.castCache[i] then
      count = count + 1
    end
  end

  return count
end

PossiblyEngine.module.register("player", player)
