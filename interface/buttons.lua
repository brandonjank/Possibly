-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.


PossiblyEngine.buttons = {
  frame = CreateFrame("Frame", "PE_Buttons", UIParent),
  buttonFrame = CreateFrame("Frame", "PE_Buttons_Container", UIParent),
  buttons = { },
  size = 36,
  scale = 1,
  padding = 6,
  count = 0,
}

-- Masque ?!
local MSQ = LibStub("Masque", true)
local possiblySkinGroup
if MSQ then
  possiblySkinGroup = MSQ:Group("PossiblyEngine", "Buttons")
end
-- ElvUI ?!
local E, L, V, P, G
if IsAddOnLoaded("ElvUI") then
  E, L, V, P, G = unpack(ElvUI)
  ElvSkin = E:GetModule('ActionBars')
  PossiblyEngine.buttons.padding = 3
  PossiblyEngine.buttons.size = 31
end

PossiblyEngine.buttons.frame:SetPoint("CENTER", UIParent)
PossiblyEngine.buttons.frame:SetWidth(170)
PossiblyEngine.buttons.frame:SetHeight(PossiblyEngine.buttons.size+5)
PossiblyEngine.buttons.frame:SetMovable(true)
PossiblyEngine.buttons.frame:SetFrameStrata('HIGH')

PossiblyEngine.buttons.frame:Hide()
PossiblyEngine.buttons.buttonFrame:Hide()

PossiblyEngine.buttons.statusText = PossiblyEngine.buttons.frame:CreateFontString('PE_StatusText')
PossiblyEngine.buttons.statusText:SetFont("Fonts\\ARIALN.TTF", 16)
PossiblyEngine.buttons.statusText:SetShadowColor(0,0,0, 0.8)
PossiblyEngine.buttons.statusText:SetShadowOffset(-1,-1)
PossiblyEngine.buttons.statusText:SetPoint("CENTER", PossiblyEngine.buttons.frame)
PossiblyEngine.buttons.statusText:SetText("|cffffffff"..pelg('drag_to_position').."|r")

PossiblyEngine.buttons.frame.texture = PossiblyEngine.buttons.frame:CreateTexture()
PossiblyEngine.buttons.frame.texture:SetAllPoints(PossiblyEngine.buttons.frame)
PossiblyEngine.buttons.frame.texture:SetTexture(0,0,0,0.6)

PossiblyEngine.buttons.frame:SetScript("OnMouseDown", function(self, button)
  if not self.isMoving then
   self:StartMoving()
   self.isMoving = true
  end
end)
PossiblyEngine.buttons.frame:SetScript("OnMouseUp", function(self, button)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)
PossiblyEngine.buttons.frame:SetScript("OnHide", function(self)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)

PossiblyEngine.buttons.create = function(name, icon, callback, tooltipl1, tooltipl2)
  if _G['PE_Buttons_' .. name] then
    PossiblyEngine.buttons.buttons[name] = _G['PE_Buttons_' .. name]
    _G['PE_Buttons_' .. name]:Show()
  else
    PossiblyEngine.buttons.buttons[name] = CreateFrame("CheckButton", "PE_Buttons_"..name, PossiblyEngine.buttons.buttonFrame, "ActionButtonTemplate")
  end
  PossiblyEngine.buttons.buttons[name]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  local button = PossiblyEngine.buttons.buttons[name]

  button:SetPoint("TOPLEFT", PossiblyEngine.buttons.frame, "TOPLEFT",
    (
      (PossiblyEngine.buttons.size*PossiblyEngine.buttons.count)
      +
      (PossiblyEngine.buttons.count*PossiblyEngine.buttons.padding)
      + 4
    )
  , -3)
  button:SetWidth(PossiblyEngine.buttons.size)
  button:SetHeight(PossiblyEngine.buttons.size)

  -- theme it, Masque ?
  if possiblySkinGroup then
    possiblySkinGroup:AddButton(button)
  end
  -- theme it, ElvUI ?
  if ElvSkin then
    ElvSkin.db = E.db.actionbar
    button:CreateBackdrop("ClassColor")
    ElvSkin:StyleButton(button, nil, true)
    button:SetCheckedTexture(nil)
    button:SetPushedTexture(nil)
    button.customTheme = function ()
      button:SetCheckedTexture(nil)
      local state = button.checked
      if state then
        button.backdrop:Show()
      else
        button.backdrop:Hide()
      end
    end
    local originalCallback = callback or false
    callback = function (self, mouseButton)
      if originalCallback then
        originalCallback(self, mouseButton)
      end
      button.customTheme()
    end
  end

  if icon == nil then
    button.icon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
  else
    button.icon:SetTexture(icon)
  end

  button:SetScript("OnClick", callback)

  if tooltipl1 ~= nil then
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("|cffffffff" .. tooltipl1 .. "|r")
      if tooltipl2 then
        GameTooltip:AddLine(tooltipl2)
      end
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self)
      GameTooltip:Hide()
    end)
  end

  button.checked = false

  button:SetPushedTexture(nil)

  _G['PE_Buttons_'..name.."HotKey"]:SetText('Off')
  _G['PE_Buttons_'..name.."HotKey"]:Hide()

  if PossiblyEngine.config.read('buttonVisualText', false) then
    _G['PE_Buttons_'..name.."HotKey"]:Show()
  end

  PossiblyEngine.buttons.count = PossiblyEngine.buttons.count + 1

end

PossiblyEngine.buttons.text = function(name, text)
  local hotkey = _G['PE_Buttons_'.. name .."HotKey"]
  hotkey:SetText(text);
  hotkey:Show();
end

PossiblyEngine.buttons.setActive = function(name)
  if _G['PE_Buttons_'.. name] then
    _G['PE_Buttons_'.. name].checked = true
    _G['PE_Buttons_'.. name]:SetChecked(true)
    _G['PE_Buttons_'..name.."HotKey"]:SetText('On')
    if _G['PE_Buttons_'.. name].customTheme then
      _G['PE_Buttons_'.. name].customTheme()
    end
    PossiblyEngine.config.write('button_states', name, true)
  end
end

PossiblyEngine.buttons.setInactive = function(name)
  if _G['PE_Buttons_'.. name] then
    _G['PE_Buttons_'.. name].checked = false
    _G['PE_Buttons_'.. name]:SetChecked(false)
    _G['PE_Buttons_'..name.."HotKey"]:SetText('Off')
    if _G['PE_Buttons_'.. name].customTheme then
      _G['PE_Buttons_'.. name].customTheme()
    end
    PossiblyEngine.config.write('button_states', name, false)
  end
end

PossiblyEngine.buttons.toggle = function(name)
  if _G['PE_Buttons_'.. name] then
    local state = _G['PE_Buttons_'.. name].checked
    if state then
      PossiblyEngine.buttons.setInactive(name)
    else
      PossiblyEngine.buttons.setActive(name)
    end
  end
end

PossiblyEngine.buttons.icon = function(name, icon)
  _G['PE_Buttons_'.. name ..'Icon']:SetTexture(icon)
end

PossiblyEngine.buttons.loadStates = function()

  if PossiblyEngine.config.read('uishown') then
    if PossiblyEngine.config.read('uishown') then
      PossiblyEngine.buttons.buttonFrame:Show()
    else
      PossiblyEngine.buttons.buttonFrame:Hide()
    end
  else
    PossiblyEngine.buttons.buttonFrame:Show()
    PossiblyEngine.config.write('uishown', true)
  end

  for name in pairs(PossiblyEngine.buttons.buttons) do
    local state = PossiblyEngine.config.read('button_states', name, false)
    if state == true then
      PossiblyEngine.buttons.setActive(name)
    else
      PossiblyEngine.buttons.setInactive(name)
    end
  end
end

PossiblyEngine.buttons.resetButtons = function ()
  if PossiblyEngine.buttons.buttons then
    local defaultButtons = { 'MasterToggle', 'cooldowns', 'multitarget', 'interrupt' }
    for name, button in pairs(PossiblyEngine.buttons.buttons) do
      -- button text toggles
      if PossiblyEngine.config.read('buttonVisualText', false) then
        _G['PE_Buttons_'..name.."HotKey"]:Show()
      else
        _G['PE_Buttons_'..name.."HotKey"]:Hide()
      end
      local original = false
      for _, buttonName in pairs(defaultButtons) do
        if name == buttonName then
          original = true
          break
        end
      end
      if not original then
        PossiblyEngine.buttons.buttons[name] = nil
        button:Hide()
      end
    end
    PossiblyEngine.buttons.count = table.length(PossiblyEngine.buttons.buttons)
  end
end
