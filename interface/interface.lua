-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.interface = {}

local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

local config = {
	key = "test",
	title = "|cffee2200PossiblyEngine|r Config",
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
			text = "Checked Box",
			default = false
		},
		{
			type = "checkbox",
			text = "Box Check",
			default = false
		},
		{ type = 'rule' },
		{
			type = "checkbox",
			text = "OJ Did It",
			default = true
		},
		{
			type = "spinner",
			text = "A Num Value",
			default = 25
		},
		{
			type = "spinner",
			text = "Another Num",
			default = 75
		},
		{
			type = "checkbox",
			text = "Some Value",
			default = true
		},
		{ type = 'rule' },
		{
			type = "checkspin",
			text = "Its Both",
			default_bool = true,
			default_spin = 40
		},
		{
			type = "checkspin",
			text = "How Awesome",
			default_bool = true,
			default_spin = 100
		},
		{ type = 'rule' },
		{
			type = "combo",
			text = "Combo #5",
			combo = {
				{
					text = "Some Value",
					key = "value1"
				},
				{
					text = "Other Value",
					key = "value2"
				}
			}
		}
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
			tmp:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 13)
			tmp:SetWidth(window.content:GetWidth()-10)
			if element.align then
				tmp:SetJustifyH(strupper(element.align))
			end

		elseif element.type == 'rule' then

			local tmp = CreateFrame('Frame')
			tmp:SetParent(window.content)
			tmp:SetPoint('TOPLEFT', window.content, 'TOPLEFT', 5, offset-3)
			tmp:SetWidth(window.content:GetWidth()-10)
			tmp:SetHeight(1)
			tmp.texture = tmp:CreateTexture()
			tmp.texture:SetTexture(0,0,0,0.5)
			tmp.texture:SetAllPoints(tmp)

		elseif element.type == 'checkbox' then

			local tmp = DiesalGUI:Create('CheckBox')
			tmp:SetParent(window.content)
			tmp:SetPoint("TOPLEFT", window.content, "TOPLEFT", 5, offset)
			
			if element.default then
				tmp:SetChecked(true)
			end

			local tmp_text = window:CreateRegion("FontString", 'name', window.content)
			tmp_text:SetPoint("TOPLEFT", window.content, "TOPLEFT", 20, offset)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)

		elseif element.type == 'spinner' then

			local tmp = DiesalGUI:Create('Spinner')
			tmp:SetParent(window.content)
			tmp:SetPoint("TOPLEFT", window.content, "TOPRIGHT", -35, offset)
			tmp:SetNumber(element.default)

			local tmp_text = window:CreateRegion("FontString", 'name', window.content)
			tmp_text:SetPoint("TOPLEFT", window.content, "TOPLEFT", 8, offset-2)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')
			tmp_text:SetWidth(window.content:GetWidth()-10)

		elseif element.type == 'checkspin' then

			local tmp_spin = DiesalGUI:Create('Spinner')
			tmp_spin:SetParent(window.content)
			tmp_spin:SetPoint("TOPLEFT", window.content, "TOPRIGHT", -35, offset)
			tmp_spin:SetNumber(element.default_spin)

			local tmp_spin = DiesalGUI:Create('CheckBox')
			tmp_spin:SetParent(window.content)
			tmp_spin:SetPoint("TOPLEFT", window.content, "TOPLEFT", 5, offset-2)

			if element.default_bool then
				tmp_spin:SetChecked(true)
			end

			local tmp_text = window:CreateRegion("FontString", 'name', window.content)
			tmp_text:SetPoint("TOPLEFT", window.content, "TOPLEFT", 20, offset-2)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')
			tmp_text:SetWidth(window.content:GetWidth()-10)

		elseif element.type == 'combo' then

			local tmp_list = DiesalGUI:Create('ComboBox')
			tmp_list:SetParent(window.content)
			tmp_list:SetPoint("TOPRIGHT", window.content, "TOPRIGHT", -5, offset)
			local orderdKeys = { }
			local combo = { }
			for i, value in pairs(element.combo) do
				orderdKeys[i] = value.key
				combo[value.key] = value.text
			end
			tmp_list:SetList(combo, orderdKeys)

			local tmp_text = window:CreateRegion("FontString", 'name', window.content)
			tmp_text:SetPoint("TOPLEFT", window.content, "TOPLEFT", 5, offset-3)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')
			tmp_text:SetWidth(window.content:GetWidth()-10)

		end

		if element.type == 'rule' then
			offset = offset + -10
		elseif element.type == 'spinner' or element.type == 'checkspin' then
			offset = offset + -19
		else
			offset = offset + -16

		end

	end

end

--buildGUI(config)

PossiblyEngine.interface.init = function()
	PossiblyEngine.interface.minimap.create()
end
