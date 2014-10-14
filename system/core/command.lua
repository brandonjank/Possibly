-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.command = {
  commands = 0,
  handlers = { }
}

PossiblyEngine.command.print = function(message)
  print("|cFF"..PossiblyEngine.addonColor.."["..PossiblyEngine.addonName.."]|r " .. message .. "")
end

PossiblyEngine.command.register = function (command, handler)
  local name = 'PE_' .. command
  _G["SLASH_" .. name .. "1"] = '/' .. command
  SlashCmdList[name] = function(message, editbox) handler(message, editbox) end
end

PossiblyEngine.command.register_handler = function(command, handler)
  local command_type = type(command)
  if command_type == "string" then
    PossiblyEngine.command.handlers[command] = handler
  elseif command_type == "table" then
    for _,com in pairs(command) do
      PossiblyEngine.command.handlers[com] = handler
    end
  else
    PossiblyEngine.command.print(pelg('unknown_type') .. ': ' .. command_type)
  end
end

PossiblyEngine.command.register('pe', function(msg, box)
  local command, text = msg:match("^(%S*)%s*(.-)$")
  if PossiblyEngine.command.handlers[command] then
    PossiblyEngine.command.handlers[command](text)
  else
    PossiblyEngine.command.handlers['help']('help')
  end
end)
