-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.interface = {}

local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")

local config = {
	key = "test",
	title = "PossiblyEngine Config",
	width = 200,
	height = 300,
	config = {
		{
			type = "header",
			text = "A Test Config",
		},
		{ type = 'rule' },
		{
			type = "checkbox",
			text = "Some Value",
			default = false
		},
		{
			type = "checkbox",
			text = "Some Value",
			default = false
		},
		{ type = 'rule' },
}}

function buildGUI(config)

	window = DiesalGUI:Create('Window')
	window:SetWidth(200)
	window:SetHeight(300)

	if config.title then
		window:SetTitle(config.title)
	end
	if config.width then
		window:SetWidth(config.width)
	end
	if config.height then
		window:SetHeight(config.height)
	end

	config._elements = { } -- a place to store the frames

	local offset = -5

	for _, element in ipairs(config.config) do

		if element.type == 'header' then

			local tmp = window:CreateRegion("FontString", 'name', window.content)
			tmp:SetPoint("TOPLEFT", window.content, "TOPLEFT", 5, offset)
			tmp:SetText(element.text)
			tmp:SetJustifyH('LEFT')
			tmp:SetWidth(window.content:GetWidth()-10)
			if element.align then
				tmp:SetJustifyH(strupper(element.align))
			end

		elseif element.type == 'hr' or element.type == 'rule' then

			local tmp = CreateFrame('Frame')
			tmp:SetParent(window.content)
			tmp:SetPoint('TOPLEFT', window.content, 'TOPLEFT', 5, offset-4)
			tmp:SetWidth(window.content:GetWidth()-10)
			tmp:SetHeight(3)
			tmp.texture = tmp:CreateTexture()
			tmp.texture:SetTexture(0,0,0,0.5)
			tmp.texture:SetAllPoints(tmp)

		elseif element.type == 'checkbox' then

			local tmp = DiesalGUI:Create('CheckBox')
			tmp:SetParent(window.content)
			tmp:SetPoint("TOPLEFT", window.content, "TOPLEFT", 5, offset)

			local tmp_text = window:CreateRegion("FontString", 'name', window.content)
			tmp_text:SetPoint("TOPLEFT", window.content, "TOPLEFT", 20, offset)
			tmp_text:SetText(element.text)

		elseif element.type == 'spinner' then




		end

		offset = offset + -14
	end

end

--buildGUI(config)

PossiblyEngine.interface.init = function()
	PossiblyEngine.interface.minimap.create()
end
