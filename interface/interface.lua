-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.interface = {}

local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

local test_data = {
	key = "testdata",
	title = "Player Position",
	width = 250,
	height = 105,
	resize = false,
	config = {
		{
			type = "text",
			text = "X: ",
			size = 20,
			offset = -20
		},
		{
			key = 'x',
			type = "text",
			text = "Random",
			size = 20,
			align = "right",
			offset = 5
		},
		{
			type = "text",
			text = "Y: ",
			size = 20,
			offset = -20
		},
		{
			key = 'y',
			type = "text",
			text = "Random",
			size = 20,
			align = "right",
			offset = 5
		},
		{
			type = "text",
			text = "Z: ",
			size = 20,
			offset = -20
		},
		{
			key = 'z',
			type = "text",
			text = "Random",
			size = 20,
			align = "right",
			offset = 5
		}
	}
}

local test_config = {
	key = "testconf",
	title = "Example Config",
	subtitle = "It's awesome!",
	color = "005522",
	width = 200,
	height = 300,
	config = {
		{
			type = 'header',
			text = 'Example Header'
		},
		{ type = 'rule' },
		{
			type = "texture",
			texture = "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_8",
			width = 32,
			height = 32,
			offset = 34,
			y = 12,
			center = true
		},
		{
			type = 'text',
			text = "Example text block."
		},
		{
			type = 'text',
			text = "Some Smaller text, because why not.",
			size = 8
		},
		{
			type = "checkbox",
			text = "Example Check",
			desc = "This is a description for the checkbox!",
			key = "check1",
			default = false
		},
		{
			type = "spinner",
			text = "Simple Spinner",
			desc = "This is a description for the spinner! This is a description for the spinner! This is a description for the spinner!",
			key = "spin1",
			default = 25
		},
		{
			type = "checkspin",
			text = "Spinner Check",
			desc = "Blah blah blah, blah blah!",
			key = "checkspin1",
			default_check = true,
			default_spin = 100
		},
		{ type = 'rule' },
		{
			type = "dropdown",
			text = "Dropdown",
			key = "dropdown1",
			list = {
				{
					text = "Some Value",
					key = "value1"
				},
				{
					text = "Other Value",
					key = "value2"
				}
			},
			default = "value1",
			desc = "Chicken chicken chicken, chicken chicken!",
		},
		{
			type = "button",
			text = "A Button",
			desc = "Buttons too, what the fuck.",
			width = 75,
			height = 15,
			callback = function()
				print('It Works!')
			end
		},
}}
local test_nest

test_nest = {
	title = "Sub Windows",
	subtitle = "Wooo!",
	width = 200,
	height = 60,
	resize = false,
	config = {
		{
			type = "button",
			text = "Open Window",
			width = 180,
			height = 20,
			callback = function()
				PossiblyEngine.interface.buildGUI(test_nest)
			end
		}
	}
}


local buttonStyleSheet = {
	['frame-color'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '2f353b',
		offset		= 0,
	},
	['frame-highlight'] = {
		type			= 'texture',
		layer			= 'BORDER',
		gradient	= 'VERTICAL',
		color			= 'FFFFFF',
		alpha 		= 0,
		alphaEnd	= .1,
		offset		= -1,
	},
	['frame-outline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= '000000',
		offset		= 0,
	},
	['frame-inline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		gradient	= 'VERTICAL',
		color			= 'ffffff',
		alpha 		= .02,
		alphaEnd	= .09,
		offset		= -1,
	},
	['frame-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha			= .1,
		offset		= 0,
	},
	['text-color'] = {
		type			= 'Font',
		color			= 'b8c2cc',
	},
}
local spinnerStyleSheet = {
	['bar-background'] = {
		type			= 'texture',
		layer			= 'BORDER',
		color			= 'ee2200',
	},
}

function buildElements(table, parent)

	local offset = -5

	for _, element in ipairs(table.config) do

		local push, pull = 0, 0

		if element.type == 'header' then

			local tmp = parent:CreateRegion("FontString", 'name', parent.content)
			tmp:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset)
			tmp:SetText(element.text)
			tmp:SetJustifyH('LEFT')
			tmp:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 13)
			tmp:SetWidth(parent.content:GetWidth()-10)

			if element.align then
				tmp:SetJustifyH(strupper(element.align))
			end

			if element.key then
				table.window.elements[element.key] = tmp
			end

		elseif element.type == 'text' then

			local tmp = parent:CreateRegion("FontString", 'name', parent.content)
			tmp:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset)
			tmp:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset)
			tmp:SetText(element.text)
			tmp:SetJustifyH('LEFT')
			tmp:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), element.size or 10)
			tmp:SetWidth(parent.content:GetWidth()-10)

			if not element.offset then
				element.offset = tmp:GetStringHeight()
			end

			if element.align then
				tmp:SetJustifyH(strupper(element.align))
			end

			if element.key then
				table.window.elements[element.key] = tmp
			end

		elseif element.type == 'rule' then

			local tmp = CreateFrame('Frame')
			tmp:SetParent(parent.content)
			tmp:SetPoint('TOPLEFT', parent.content, 'TOPLEFT', 5, offset-3)
			tmp:SetPoint('BOTTOMRIGHT', parent.content, 'BOTTOMRIGHT', -5, offset-3)
			tmp:SetWidth(parent.content:GetWidth()-10)
			tmp:SetHeight(1)
			tmp.texture = tmp:CreateTexture()
			tmp.texture:SetTexture(0,0,0,0.5)
			tmp.texture:SetAllPoints(tmp)

			if element.key then
				table.window.elements[element.key] = tmp
			end

		elseif element.type == 'texture' then

			local tmp = CreateFrame('Frame')
			tmp:SetParent(parent.content)
			if element.center then
				tmp:SetPoint('CENTER', parent.content, 'CENTER', (element.x or 0), offset-(element.y or 0))
			else
				tmp:SetPoint('TOPLEFT', parent.content, 'TOPLEFT', 5+(element.x or 0), offset-3+(element.y or 0))
			end

			tmp:SetWidth(parent:GetWidth()-10)
			tmp:SetHeight(element.height)
			tmp:SetWidth(element.width)
			tmp.texture = tmp:CreateTexture()
			tmp.texture:SetTexture(element.texture)
			tmp.texture:SetAllPoints(tmp)

			if element.key then
				table.window.elements[element.key] = tmp
			end

		elseif element.type == 'checkbox' then

			local tmp = DiesalGUI:Create('CheckBox')
			tmp:SetParent(parent.content)
			tmp:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset)

			tmp:SetEventListener('OnValueChanged', function(this, event, checked)
				PossiblyEngine.config.write(table.key .. '_' .. element.key, checked)
			end)

			tmp:SetChecked(PossiblyEngine.config.read(table.key .. '_' .. element.key, element.default or false))

			local tmp_text = table.window:CreateRegion("FontString", 'name1', parent.content)
			tmp_text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 20, offset-1)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)

			if element.desc then
				local tmp_desc = table.window:CreateRegion("FontString", 'name', parent.content)
				tmp_desc:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-15)
				tmp_desc:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset-15)
				tmp_desc:SetText(element.desc)
				tmp_desc:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 9)
				tmp_desc:SetWidth(parent.content:GetWidth()-10)
				tmp_desc:SetJustifyH('LEFT')
				push = tmp_desc:GetStringHeight() + 5
			end

			if element.key then
				table.window.elements[element.key..'Text'] = tmp_text
				table.window.elements[element.key] = tmp
			end

		elseif element.type == 'spinner' then

			local tmp_spin = DiesalGUI:Create('Spinner')
			tmp_spin:SetParent(parent.content)
			tmp_spin:SetPoint("TOPLEFT", parent.content, "TOPRIGHT", -35, offset)
			tmp_spin:SetNumber(
				PossiblyEngine.config.read(table.key .. '_' .. element.key, element.default)
			)
			tmp_spin:AddStyleSheet(spinnerStyleSheet)

			tmp_spin:SetEventListener('OnValueChanged', function(this, event, userInput, number)
				if not userInput then return end
				PossiblyEngine.config.write(table.key .. '_' .. element.key, number)
			end)

			local tmp_text = table.window:CreateRegion("FontString", 'name', parent.content)
			tmp_text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-4)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')
			tmp_text:SetWidth(parent.content:GetWidth()-10)

			if element.desc then
				local tmp_desc = table.window:CreateRegion("FontString", 'name', parent.content)
				tmp_desc:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-18)
				tmp_desc:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset-18)
				tmp_desc:SetText(element.desc)
				tmp_desc:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 9)
				tmp_desc:SetWidth(parent.content:GetWidth()-10)
				tmp_desc:SetJustifyH('LEFT')
				push = tmp_desc:GetStringHeight() + 5
			end

			if element.key then
				table.window.elements[element.key..'Text'] = tmp_text
				table.window.elements[element.key] = tmp_spin
			end

		elseif element.type == 'checkspin' then

			local tmp_spin = DiesalGUI:Create('Spinner')
			tmp_spin:SetParent(parent.content)
			tmp_spin:SetPoint("TOPLEFT", parent.content, "TOPRIGHT", -35, offset)
			tmp_spin:SetNumber(
				PossiblyEngine.config.read(table.key .. '_' .. element.key .. '_spin', element.default_spin or 0)
			)
			tmp_spin:AddStyleSheet(spinnerStyleSheet)

			tmp_spin:SetEventListener('OnValueChanged', function(this, event, userInput, number)
				if not userInput then return end
				PossiblyEngine.config.write(table.key .. '_' .. element.key .. '_spin', number)
			end)

			local tmp_check = DiesalGUI:Create('CheckBox')
			tmp_check:SetParent(parent.content)
			tmp_check:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-2)

			tmp_check:SetEventListener('OnValueChanged', function(this, event, checked)
				PossiblyEngine.config.write(table.key .. '_' .. element.key .. '_check', checked)
			end)

			tmp_check:SetChecked(PossiblyEngine.config.read(table.key .. '_' .. element.key .. '_check', element.default_check or false))

			local tmp_text = table.window:CreateRegion("FontString", 'name', parent.content)
			tmp_text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 20, offset-4)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')
			tmp_text:SetWidth(parent.content:GetWidth()-10)

			if element.desc then
				local tmp_desc = table.window:CreateRegion("FontString", 'name', parent.content)
				tmp_desc:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-18)
				tmp_desc:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset-18)
				tmp_desc:SetText(element.desc)
				tmp_desc:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 9)
				tmp_desc:SetWidth(parent.content:GetWidth()-10)
				tmp_desc:SetJustifyH('LEFT')
				push = tmp_desc:GetStringHeight() + 5
			end

			if element.key then
				table.window.elements[element.key..'Text'] = tmp_text
				table.window.elements[element.key..'Check'] = tmp_check
				table.window.elements[element.key..'Spin'] = tmp_spin
			end

		elseif element.type == 'combo' or element.type == 'dropdown' then

			local tmp_list = DiesalGUI:Create('Dropdown')
			tmp_list:SetParent(parent.content)
			tmp_list:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset)
			local orderdKeys = { }
			local list = { }
			for i, value in pairs(element.list) do
				orderdKeys[i] = value.key
				list[value.key] = value.text
			end
			tmp_list:SetList(list, orderdKeys)

			tmp_list:SetEventListener('OnValueChanged', function(this, event, value)
				PossiblyEngine.config.write(table.key .. '_' .. element.key, value)
			end)

			tmp_list:SetValue(PossiblyEngine.config.read(table.key .. '_' .. element.key, element.default))

			local tmp_text = table.window:CreateRegion("FontString", 'name', parent.content)
			tmp_text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-3)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')
			tmp_text:SetWidth(parent.content:GetWidth()-10)

			if element.desc then
				local tmp_desc = table.window:CreateRegion("FontString", 'name', parent.content)
				tmp_desc:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-18)
				tmp_desc:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset-18)
				tmp_desc:SetText(element.desc)
				tmp_desc:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 9)
				tmp_desc:SetWidth(parent.content:GetWidth()-10)
				tmp_desc:SetJustifyH('LEFT')
				push = tmp_desc:GetStringHeight() + 5
			end

			if element.key then
				table.window.elements[element.key..'Text'] = tmp_text
				table.window.elements[element.key] = tmp_list
			end

		elseif element.type == 'button' then

			local tmp = DiesalGUI:Create("Button")
			tmp:SetParent(parent.content)
			tmp:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset)
			tmp:SetText(element.text)
			tmp:SetWidth(element.width)
			tmp:SetHeight(element.height)

			tmp:AddStyleSheet(buttonStyleSheet)

			tmp:SetEventListener("OnClick", element.callback)

			if element.desc then
				local tmp_desc = table.window:CreateRegion("FontString", 'name', parent.content)
				tmp_desc:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-element.height-3)
				tmp_desc:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset-element.height-3)
				tmp_desc:SetText(element.desc)
				tmp_desc:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 9)
				tmp_desc:SetWidth(parent.content:GetWidth()-10)
				tmp_desc:SetJustifyH('LEFT')
				push = tmp_desc:GetStringHeight() + 5
			end

			if element.align then
				tmp:SetJustifyH(strupper(element.align))
			end

			if element.key then
				table.window.elements[element.key] = tmp
			end

		elseif element.type == 'spacer' then

			-- NOTHING!

		end

		if element.type == 'rule' then
			offset = offset + -10
		elseif element.type == 'spinner' or element.type == 'checkspin' then
			offset = offset + -19
		elseif element.type == 'combo' or element.type == 'dropdown' then
			offset = offset + -20
		elseif element.type == 'texture' then
			offset = offset + -(element.offset or 0)
		elseif element.type == "text" then
			offset = offset + -(element.offset) - (element.size or 10)
		elseif element.type == 'button' then
			offset = offset + -20
		elseif element.type == 'spacer' then
			offset = offset + -(element.size or 10)
		else
			offset = offset + -16
		end

		offset = offset + -(push)
		offset = offset + pull

	end

end

function PossiblyEngine.interface.buildGUI(config)

	local parent = DiesalGUI:Create('Window')
	parent:SetWidth(config.width or 200)
	parent:SetHeight(config.height or 300)

	if config.key then
		parent:SetEventListener('OnDragStop', function(self, event, left, top)
			PossiblyEngine.config.write(config.key .. '_windowPos', {left, top})
		end)
		local left, top = unpack(PossiblyEngine.config.read(config.key .. '_windowPos', {false, false}))
		if left and top then
			parent.settings.left = left
			parent.settings.top = top
			parent:UpdatePosition()
		end
	end

	local window = DiesalGUI:Create('ScrollFrame')
	window:SetParent(parent.content)
	window:SetAllPoints(parent.content)
	window.parent = parent

	if not config.color then config.color = "ee2200" end

	spinnerStyleSheet['bar-background']['color'] = config.color

	if config.title then
		parent:SetTitle("|cff"..config.color..config.title.."|r", config.subtitle)
	end
	if config.width then
		parent:SetWidth(config.width)
	end
	if config.height then
		parent:SetHeight(config.height)
	end
	if config.minWidth then
		parent.settings.minWidth = config.minWidth
	end
	if config.minHeight then
		parent.settings.minHeight = config.minHeight
	end
	if config.maxWidth then
		parent.settings.maxWidth = config.maxWidth
	end
	if config.maxHeight then
		parent.settings.maxHeight = config.maxHeight
	end
	if config.resize == false then
		parent.settings.minHeight = config.height
		parent.settings.minWidth = config.width
		parent.settings.maxHeight = config.height
		parent.settings.maxWidth = config.width
	end

	parent:ApplySettings()

	config.window = window

	window.elements = { }

	buildElements(config, window)

	return window

end
--[[
PossiblyEngine.timer.register('gui', function()
	PossiblyEngine.interface.buildGUI(test_config)
	PossiblyEngine.timer.unregister('gui')
end, 200)

local windowRef = PossiblyEngine.interface.buildGUI(test_data)

function updatePositions()
	local x, y, z = ObjectPosition('player')
	windowRef.elements.x:SetText(math.round(x, 2))
	windowRef.elements.y:SetText(math.round(y, 2))
	windowRef.elements.z:SetText(math.round(z, 2))
end

C_Timer.NewTicker(0.01, updatePositions, nil)

PossiblyEngine.interface.buildGUI(test_nest)


local casting = {
	title = "PossiblyEngine",
	subtitle = "Current Spell",
	width = 250,
	height = 70,
	resize = false,
	config = {
		{
			type = "text",
			text = "Current Spell: ",
			size = 14,
			offset = -14
		},
		{
			key = 'current',
			type = "text",
			text = "Random",
			size = 14,
			align = "right",
			offset = 5,
		},
		{
			type = "text",
			text = "Last Spell: ",
			size = 14,
			offset = -14
		},
		{
			key = 'last',
			type = "text",
			text = "Random",
			size = 14,
			align = "right",
		},
	}
}

local windowRef = PossiblyEngine.interface.buildGUI(casting)

function updateSpell()
	windowRef.elements.current:SetText(PossiblyEngine.current_spell or 'Idle')
	windowRef.elements.last:SetText(PossiblyEngine.parser.lastCast or 'Idle')
end

C_Timer.NewTicker(0.01, updateSpell, nil)
]]

PossiblyEngine.interface.init = function()
	PossiblyEngine.interface.minimap.create()
end
