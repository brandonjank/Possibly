-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local AceGUI = LibStub("AceGUI-3.0")

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local myOptionsTable = {
  type = "group",
  name = "PossiblyEngine",
  width = "full",
  set = function(info,val)
    local key = info[1] .. '_' .. info[2]
    PossiblyEngine.config.write(key, val)
  end,
  get = function(info)
    local key = info[1] .. '_' .. info[2]
    return PossiblyEngine.config.read(key)
  end,
  args = {

    pe = {
      type = "group",
      name = "Rotation Engine",
      desc = "Configure settings relating to the Rotation Engine.",
      width = "full",
      order = 1,
      args = {
        dynamic = {
          name = "Dynamic",
          desc = "Enables / disables the addon",
          descStyle = "inline",
          type = "toggle",
          width = "full",
        }
      }
    },

    ct = {
      type = "group",
      name = "Combat Tracker",
      desc = "Configure settings relating to the Combat Tracker.",
      width = "full",
      order = 2,
      args = {
        maxtracking = {
          name = "Max Tracking Units",
          desc = "The maximum number of units to show in the UI.",
          descStyle = "inline",
          type = "range",
          min = 4,
          max = 20,
          step = 1,
          width = "full",
        }
      }
    }



  }
}



AceConfig:RegisterOptionsTable("Possibly", myOptionsTable, {"/prb"} )
AceConfigDialog:AddToBlizOptions("Possibly", "PossiblyEngine")


PossiblyEngine.interface.config = {
  shown = false,
  moving = false,
}

PossiblyEngine.interface.config.config = {

  {
    type = 'checkbox',
    name = 'Dynamic Cycle Time',
    desc = 'Enable dynamic cycling timing to lower CPU usage.',
    ckey = 'cycle',
  },

}


PossiblyEngine.interface.config.build = function()

  PossiblyEngine.interface.config.shown = true

  -- Create the base frame
  local frame = AceGUI:Create("Frame")

  -- Set the size and title stuff
  frame:SetWidth(400)
  frame:SetTitle("PossiblyEngine Configuration")
  frame:SetStatusText("PossiblyEngine Release: " .. PossiblyEngine.version)
  frame:SetCallback("OnClose", function(widget)
    AceGUI:Release(widget)
    PossiblyEngine.interface.config.shown = false
  end)

  -- Required for the scroll frame
  frame:SetLayout("Flow")

  -- Create the scroll frame group
  scrollcontainer = AceGUI:Create("SimpleGroup")
  scrollcontainer:SetFullWidth(true)
  scrollcontainer:SetFullHeight(true)
  scrollcontainer:SetLayout("Fill")
  frame:AddChild(scrollcontainer)

  -- Create the scroll frame
  scroll = AceGUI:Create("ScrollFrame")
  scroll:SetFullWidth(true)
  scroll:SetLayout("Flow")
  scrollcontainer:AddChild(scroll)

  -- go over our config table and build the UI
  for _,configItem in pairs(PossiblyEngine.interface.config.config) do

    if configItem.type == 'checkbox' then

      -- create the checkbox


    end




  end



end

function PossiblyEngine.interface.init()
  PossiblyEngine.interface.minimap.create()
end
