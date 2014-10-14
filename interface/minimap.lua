-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local GetCursorPosition = GetCursorPosition
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory

PossiblyEngine.interface.minimap = {}

local minimap = PossiblyEngine.interface.minimap

local function reposition()
  minimap.button:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 52 - (80 * cos(minimap.position)), (80 * sin(minimap.position)) - 52)
end

local function onUpdate()
  local xpos, ypos = GetCursorPosition()
  local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

  xpos = xmin - xpos / UIParent:GetScale() + 70
  ypos = ypos / UIParent:GetScale() - ymin - 70
  minimap.position = math.floor(math.deg(math.atan2(ypos, xpos)))

  reposition()
end

local function onDragStart(self)
	self:LockHighlight()
  self:StartMoving()
  self:SetScript('OnUpdate', onUpdate)
end

local function onDragStop(self)
  self:SetScript('OnUpdate', nil)
  self:StopMovingOrSizing()
	self:UnlockHighlight()

  PossiblyEngine.config.write('minimap_position', minimap.position)
end

local button_moving
local function onClick(self, button)
  if button == 'RightButton' then
    if not button_moving then
      PossiblyEngine.buttons.frame:Show()
      button_moving = true
    else
      PossiblyEngine.buttons.frame:Hide()
      button_moving = false
    end
  else
    InterfaceOptionsFrame_OpenToCategory('PossiblyEngine')
    InterfaceOptionsFrame_OpenToCategory('PossiblyEngine')
  end
end

local function onEnter(self)
  GameTooltip:SetOwner( self, 'ANCHOR_BOTTOMLEFT')
  GameTooltip:AddLine('|cff' .. PossiblyEngine.addonColor .. PossiblyEngine.addonName.. '|r '.. PossiblyEngine.version)
  GameTooltip:AddLine('|cff' .. PossiblyEngine.addonColor .. pelg('left_click') .. '|r ' .. pelg('open_config'))
  GameTooltip:AddLine('|cff' .. PossiblyEngine.addonColor .. pelg('right_click') .. '|r ' .. pelg('unlock_buttons'))
  GameTooltip:AddLine('|cff' .. PossiblyEngine.addonColor .. pelg('drag') .. '|r ' ..  pelg('move_minimap'))
  GameTooltip:Show()
end

local function onLeave(self)
  GameTooltip:Hide()
end

function minimap.create()
	local button = CreateFrame('Button', 'PE_Minimap', Minimap)
	button:SetFrameStrata('MEDIUM')
	button:SetSize(33, 33)
	button:RegisterForClicks('anyUp')
	button:RegisterForDrag('LeftButton', 'RightButton')
  button:SetMovable(true)
	button:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')

	local overlay = button:CreateTexture(nil, 'OVERLAY')
	overlay:SetSize(56, 56)
	overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
	overlay:SetPoint('TOPLEFT')

	local icon = button:CreateTexture(nil, 'BACKGROUND')
	icon:SetSize(21, 21)
	icon:SetTexture('Interface\\Icons\\achievement_Goblinhead')
	icon:SetPoint('TOPLEFT', 7, -6)

	button.icon = icon

  button:SetScript('OnDragStart', onDragStart)
  button:SetScript('OnDragStop', onDragStop)
	button:SetScript('OnClick', onClick)
	button:SetScript('OnEnter', onEnter)
	button:SetScript('OnLeave', onLeave)

  minimap.button = button

  minimap.position = PossiblyEngine.config.read('minimap_position', 45)
  reposition()

	button:Show()
end

function minimap.show()
	minimap.button:Show()
end

function minimap.hide()
	minimap.button:Hide()
end
