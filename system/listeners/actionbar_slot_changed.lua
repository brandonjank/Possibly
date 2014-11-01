-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register('ACTIONBAR_SLOT_CHANGED', function ()
	table.empty(PossiblyEngine.faceroll.buttonMap)
	local bars = {
		"ActionButton",
		"MultiBarBottomRightButton",
		"MultiBarBottomLeftButton",
		"MultiBarRightButton",
		"MultiBarLeftButton"
	}
	for _, group in ipairs(bars) do
		for i =1, 12 do
			local button = _G[group .. i]
			if button then
				local actionType, id, subType = GetActionInfo(ActionButton_CalculateAction(button, "LeftButton"))
				if actionType == 'spell' then
					local spell = GetSpellInfo(id)
					if spell then
						PossiblyEngine.faceroll.buttonMap[spell] = button
					end
				end
			end
		end
	end
end)