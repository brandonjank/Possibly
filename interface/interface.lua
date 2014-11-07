-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.interface = {}

local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

DiesalGUI:RegisterObjectConstructor("FontString", function()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	local fontString = frame:CreateFontString(nil, "OVERLAY", 'DiesalFontNormal')
	self.frame		= frame
	self.fontString = fontString
	self.SetParent = function(self, parent)
		self.frame:SetParent(parent)
	end
	self.OnRelease = function(self)
		self.fontString:SetText('')
	end
	self.OnAcquire = function(self)
		self:Show()
	end
	self.type = "FontString"
	return self
end, 1)


DiesalGUI:RegisterObjectConstructor("Rule", function()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	local frame		= CreateFrame('Frame',nil,UIParent)
	self.frame		= frame
	frame:SetHeight(1)
	frame.texture = frame:CreateTexture()
	frame.texture:SetTexture(0,0,0,0.5)
	frame.texture:SetAllPoints(frame)
	self.SetParent = function(self, parent)
		self.frame:SetParent(parent)
	end
	self.OnRelease = function(self)
		self:Hide()
	end
	self.OnAcquire = function(self)
		self:Show()
	end
	self.type = "Rule"
	return self
end, 1)

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
	title = "Title",
	subtitle = "Subtitle",
	color = "005522",
	width = 200,
	height = 300,
	profiles = true,
	config = {
		{
			type = 'header',
			text = 'Header Text'
		},
		{ type = 'rule' },
		{
			type = 'text',
			text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
		},
		{
			type = 'text',
			text = "Vivamus leo elit, fermentum non rhoncus in, blandit sed quam.",
			size = 8
		},
		{
			type = "input",
			text = "Bibendum lacus",
			default = "Vivamus",
			key = "input1",
			width = 80,
		},
		{
			type = "checkbox",
			text = "Example Check",
			desc = "Mauris vitae lobortis nisl.",
			key = "check1",
			default = false
		},
		{
			type = "spinner",
			text = "Simple Spinner",
			desc = "Fusce vel nulla convallis, euismod urna vel, congue mauris. Donec bibendum lacus metus, ut ornare lorem tempor ut.",
			key = "spin1",
			width = 35,
			default = 500,
			min = 100,
			max = 1000,
			step = 100,
			shiftStep = 10
		},
		{
			type = "checkspin",
			text = "Spinner Check",
			desc = "Morbi dignissim felis vel commodo iaculis.",
			key = "checkspin1",
			default_check = true,
			default_spin = 2345,
			width = 40,
			min = 1000,
			max = 10000,
			step = 1000,
			shiftStep = 100
		},
		{ type = 'rule' },
		{
			type = "dropdown",
			text = "Dropdown",
			key = "dropdown1",
			list = {
				{
					text = "Lorem ipsum",
					key = "value1"
				},
				{
					text = "Dolor sit amet",
					key = "value2"
				}
			},
			default = "value1",
			desc = "Praesent hendrerit congue massa sed auctor. Fusce sagittis porttitor volutpat.",
		},
		{
			type = "button",
			text = "Lorem Ipsum",
			desc = "Etiam sed aliquam dolor.",
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

			local tmp = DiesalGUI:Create("FontString")
			tmp:SetParent(parent.content)
			parent:AddChild(tmp)
			tmp = tmp.fontString
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

			local tmp = DiesalGUI:Create("FontString")
			tmp:SetParent(parent.content)
			parent:AddChild(tmp)
			tmp = tmp.fontString
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

			local tmp = DiesalGUI:Create('Rule')
			parent:AddChild(tmp)
			tmp:SetParent(parent.content)
			tmp.frame:SetPoint('TOPLEFT', parent.content, 'TOPLEFT', 5, offset-3)
			tmp.frame:SetPoint('BOTTOMRIGHT', parent.content, 'BOTTOMRIGHT', -5, offset-3)
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
			parent:AddChild(tmp)
			tmp:SetParent(parent.content)
			tmp:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset)

			tmp:SetEventListener('OnValueChanged', function(this, event, checked)
				PossiblyEngine.config.write(table.key .. '_' .. element.key, checked)
			end)

			tmp:SetChecked(PossiblyEngine.config.read(table.key .. '_' .. element.key, element.default or false))

			local tmp_text = DiesalGUI:Create("FontString")
			tmp_text:SetParent(parent.content)
			parent:AddChild(tmp_text)
			tmp_text = tmp_text.fontString
			tmp_text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 20, offset-1)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)

			if element.desc then
				local tmp_desc = DiesalGUI:Create("FontString")
				tmp_desc:SetParent(parent.content)
				parent:AddChild(tmp_desc)
				tmp_desc = tmp_desc.fontString
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
			parent:AddChild(tmp_spin)
			tmp_spin:SetParent(parent.content)
			tmp_spin:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset)
			tmp_spin:SetNumber(
				PossiblyEngine.config.read(table.key .. '_' .. element.key, element.default)
			)

			if element.width then
				tmp_spin.settings.width = element.width
			end
			if element.min then
				tmp_spin.settings.min = element.min
			end
			if element.max then
				tmp_spin.settings.max = element.max
			end
			if element.step then
				tmp_spin.settings.step = element.step
			end
			if element.shiftStep then
				tmp_spin.settings.shiftStep = element.shiftStep
			end

			tmp_spin:ApplySettings()
			tmp_spin:AddStyleSheet(spinnerStyleSheet)

			tmp_spin:SetEventListener('OnValueChanged', function(this, event, userInput, number)
				if not userInput then return end
				PossiblyEngine.config.write(table.key .. '_' .. element.key, number)
			end)

			local tmp_text = DiesalGUI:Create("FontString")
			tmp_text:SetParent(parent.content)
			parent:AddChild(tmp_text)
			tmp_text = tmp_text.fontString
			tmp_text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-4)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')
			tmp_text:SetWidth(parent.content:GetWidth()-10)

			if element.desc then
				local tmp_desc = DiesalGUI:Create("FontString")
				tmp_desc:SetParent(parent.content)
				parent:AddChild(tmp_desc)
				tmp_desc = tmp_desc.fontString
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
			parent:AddChild(tmp_spin)
			tmp_spin:SetParent(parent.content)
			tmp_spin:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset)

			if element.width then
				tmp_spin.settings.width = element.width
			end
			if element.min then
				tmp_spin.settings.min = element.min
			end
			if element.max then
				tmp_spin.settings.max = element.max
			end
			if element.step then
				tmp_spin.settings.step = element.step
			end
			if element.shiftStep then
				tmp_spin.settings.shiftStep = element.shiftStep
			end

			tmp_spin:SetNumber(
				PossiblyEngine.config.read(table.key .. '_' .. element.key .. '_spin', element.default_spin or 0)
			)
			tmp_spin:AddStyleSheet(spinnerStyleSheet)
			tmp_spin:ApplySettings()

			tmp_spin:SetEventListener('OnValueChanged', function(this, event, userInput, number)
				if not userInput then return end
				PossiblyEngine.config.write(table.key .. '_' .. element.key .. '_spin', number)
			end)

			local tmp_check = DiesalGUI:Create('CheckBox')
			parent:AddChild(tmp_check)
			tmp_check:SetParent(parent.content)
			tmp_check:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-2)

			tmp_check:SetEventListener('OnValueChanged', function(this, event, checked)
				PossiblyEngine.config.write(table.key .. '_' .. element.key .. '_check', checked)
			end)

			tmp_check:SetChecked(PossiblyEngine.config.read(table.key .. '_' .. element.key .. '_check', element.default_check or false))

			local tmp_text = DiesalGUI:Create("FontString")
			tmp_text:SetParent(parent.content)
			parent:AddChild(tmp_text)
			tmp_text = tmp_text.fontString
			tmp_text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 20, offset-4)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')
			tmp_text:SetWidth(parent.content:GetWidth()-10)

			if element.desc then
				local tmp_desc = DiesalGUI:Create("FontString")
				tmp_desc:SetParent(parent.content)
				parent:AddChild(tmp_desc)
				tmp_desc = tmp_desc.fontString
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
			parent:AddChild(tmp_list)
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

			local tmp_text = DiesalGUI:Create("FontString")
			tmp_text:SetParent(parent.content)
			parent:AddChild(tmp_text)
			tmp_text = tmp_text.fontString
			tmp_text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-3)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')
			tmp_text:SetWidth(parent.content:GetWidth()-10)

			if element.desc then
				local tmp_desc = DiesalGUI:Create("FontString")
				tmp_desc:SetParent(parent.content)
				parent:AddChild(tmp_desc)
				tmp_desc = tmp_desc.fontString
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
			parent:AddChild(tmp)
			tmp:SetParent(parent.content)
			tmp:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset)
			tmp:SetText(element.text)
			tmp:SetWidth(element.width)
			tmp:SetHeight(element.height)

			tmp:AddStyleSheet(buttonStyleSheet)

			tmp:SetEventListener("OnClick", element.callback)

			if element.desc then
				local tmp_desc = DiesalGUI:Create("FontString")
				tmp_desc:SetParent(parent.content)
				parent:AddChild(tmp_desc)
				tmp_desc = tmp_desc.fontString
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

		elseif element.type == "input" then


			local tmp_input = DiesalGUI:Create('Input')
			parent:AddChild(tmp_input)
			tmp_input:SetParent(parent.content)
			tmp_input:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -5, offset)

			if element.width then
				tmp_input:SetWidth(element.width)
			end

			tmp_input:SetText(PossiblyEngine.config.read(table.key .. '_' .. element.key, element.default or ''))

			tmp_input:SetEventListener('OnEditFocusLost', function(this)
				PossiblyEngine.config.write(table.key .. '_' .. element.key, this:GetText())
			end)


			local tmp_text = DiesalGUI:Create("FontString")
			tmp_text:SetParent(parent.content)
			parent:AddChild(tmp_text)
			tmp_text = tmp_text.fontString
			tmp_text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, offset-3)
			tmp_text:SetText(element.text)
			tmp_text:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
			tmp_text:SetJustifyH('LEFT')

			if element.desc then
				local tmp_desc = DiesalGUI:Create("FontString")
				tmp_desc:SetParent(parent.content)
				parent:AddChild(tmp_desc)
				tmp_desc = tmp_desc.fontString
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
				table.window.elements[element.key] = tmp_input
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

local createButtonStyle = {
	type			= 'texture',
	texFile		= 'DiesalGUIcons',
	texCoord		= {1,6,16,256,128},
	alpha 		= .7,
	offset		= {-2,nil,-2,nil},
	width			= 16,
	height		= 16,
}
local deleteButtonStyle = {
	type			= 'texture',
	texFile		='DiesalGUIcons',
	texCoord		= {2,6,16,256,128},
	alpha 		= .7,
	offset		= {-2,nil,-2,nil},
	width			= 16,
	height		= 16,
}
local ButtonNormal = {
	type			= 'texture',
	texColor		= 'ffffff',
	alpha 		= .7,
}
local ButtonOver = {
	type			= 'texture',
	alpha 		= 1,
}
local ButtonClicked = {
	type			= 'texture',
	alpha 		= .3,
}

function PossiblyEngine.interface.fetchKey(keyA, keyB, default)
	local selectedProfile = PossiblyEngine.config.read(keyA .. '_profile', 'Default Profile')
	if selectedProfile then
		return PossiblyEngine.config.read(keyA .. selectedProfile .. '_' .. keyB, default)
	else
		return PossiblyEngine.config.read(keyA .. '_' .. keyB, default)
	end
end

function PossiblyEngine.interface.buildGUI(config)

	local parent = DiesalGUI:Create('Window')
	parent:SetWidth(config.width or 200)
	parent:SetHeight(config.height or 300)

	if not config.key_orig then
		config.key_orig = config.key
	end

	if config.profiles == true and config.key_orig then
		parent.settings.footer = true

		local createButton = DiesalGUI:Create('Button')
		parent:AddChild(createButton)
		createButton:SetParent(parent.footer)
		createButton:SetPoint('TOPLEFT',17,-1)
		createButton:SetSettings({
			width			= 20,
			height		= 20,
		}, true)
		createButton:SetText('')
		createButton:SetStyle('frame',createButtonStyle)
		createButton:SetEventListener('OnClick', function()

			local newWindow = DiesalGUI:Create('Window')
			parent:AddChild(newWindow)
			newWindow:SetTitle("Create Profile")
			newWindow.settings.width = 200
			newWindow.settings.height = 75
			newWindow.settings.minWidth = newWindow.settings.width
			newWindow.settings.minHeight = newWindow.settings.height
			newWindow.settings.maxWidth = newWindow.settings.width
			newWindow.settings.maxHeight = newWindow.settings.height
			newWindow:ApplySettings()

			local profileInput = DiesalGUI:Create('Input')
			newWindow:AddChild(profileInput)
			profileInput:SetParent(newWindow.content)
			profileInput:SetPoint("TOPLEFT", newWindow.content, "TOPLEFT", 5, -5)
			profileInput:SetPoint("BOTTOMRIGHT", newWindow.content, "TOPRIGHT", -5, -25)
			profileInput:SetText("New Profile Name")

			local profileButton = DiesalGUI:Create('Button')
			newWindow:AddChild(profileButton)
			profileButton:SetParent(newWindow.content)
			profileButton:SetPoint("TOPLEFT", newWindow.content, "TOPLEFT", 5, -30)
			profileButton:SetPoint("BOTTOMRIGHT", newWindow.content, "TOPRIGHT", -5, -50)
			profileButton:AddStyleSheet(buttonStyleSheet)
			profileButton:SetText("Create New Profile")
			profileButton:SetEventListener('OnClick', function()

				local profiles = PossiblyEngine.config.read(config.key_orig .. '_profiles', {{key='default',text='Default'}})
				local profileName = profileInput:GetText()
				local pkey = string.gsub(profileName, "%s+", "")
				if profileName ~= '' then
					for _,p in ipairs(profiles) do
						if p.key == profileName then
							profileButton:SetText('|cffff3300Profile with that name exists!|r')
							C_Timer.NewTicker(2, function()
								profileButton:SetText("Create New Profile")
							end, 1)
							return false
						end
					end
					table.insert(profiles, { key = pkey, text = profileName })
					PossiblyEngine.config.write(config.key_orig .. '_profiles', profiles)
					PossiblyEngine.config.write(config.key_orig .. '_profile', pkey)
					newWindow:Hide()
					parent:Hide()
					parent:Release()
					PossiblyEngine.interface.buildGUI(config)
				end

			end)

		end)
		createButton:SetEventListener('OnEnter', function()
			createButton:SetStyle('frame', ButtonOver)
		end)
		createButton:SetEventListener('OnLeave', function()
			createButton:SetStyle('frame', ButtonNormal)
		end)
		createButton.frame:SetScript('OnMouseDown', function()
			createButton:SetStyle('frame', ButtonNormal)
		end)
		createButton.frame:SetScript('OnMouseUp', function()
			createButton:SetStyle('frame', ButtonOver)
		end)

		local deleteButton = DiesalGUI:Create('Button')
		parent:AddChild(deleteButton)
		deleteButton:SetParent(parent.footer)
		deleteButton:SetPoint('TOPLEFT',0,-1)
		deleteButton:SetSettings({
			width			= 20,
			height		= 20,
		}, true)
		deleteButton:SetText('')
		deleteButton:SetStyle('frame',deleteButtonStyle)
		deleteButton:SetEventListener('OnEnter', function()
			deleteButton:SetStyle('frame', ButtonOver)
		end)
		deleteButton:SetEventListener('OnLeave', function()
			deleteButton:SetStyle('frame', ButtonNormal)
		end)
		deleteButton.frame:SetScript('OnMouseDown', function()
			deleteButton:SetStyle('frame', ButtonNormal)
		end)
		deleteButton.frame:SetScript('OnMouseUp', function()
			deleteButton:SetStyle('frame', ButtonOver)
		end)
		deleteButton:SetEventListener('OnClick', function()
			local selectedProfile = PossiblyEngine.config.read(config.key_orig .. '_profile', 'Default Profile')
			local profiles = PossiblyEngine.config.read(config.key_orig .. '_profiles', {{key='default',text='Default'}})
			if selectedProfile ~= 'default' then
				for i,p in ipairs(profiles) do
					if p.key == selectedProfile then
						profiles[i] = nil
						PossiblyEngine.config.write(config.key_orig .. '_profiles', profiles)
						PossiblyEngine.config.write(config.key_orig .. '_profile', 'default')
						parent:Hide()
						parent:Release()
						PossiblyEngine.interface.buildGUI(config)
					end
				end
			end
		end)

		local profiles = PossiblyEngine.config.read(config.key_orig .. '_profiles', {{key='default',text='Default'}})
		local selectedProfile = PossiblyEngine.config.read(config.key_orig .. '_profile', 'default')
		local profile_dropdown = DiesalGUI:Create('Dropdown')
		parent:AddChild(profile_dropdown)
		profile_dropdown:SetParent(parent.footer)
		profile_dropdown:SetPoint("TOPRIGHT", parent.footer, "TOPRIGHT", 1, 0)
		profile_dropdown:SetPoint("BOTTOMLEFT", parent.footer, "BOTTOMLEFT", 37, -1)

		local orderdKeys = { }
		local list = { }

		for i, value in pairs(profiles) do
			orderdKeys[i] = value.key
			list[value.key] = value.text
		end

		profile_dropdown:SetList(list, orderdKeys)

		profile_dropdown:SetEventListener('OnValueChanged', function(this, event, value)
			if selectedProfile ~= value then
				PossiblyEngine.config.write(config.key_orig .. '_profile', value)
				parent:Hide()
				parent:Release()
				PossiblyEngine.interface.buildGUI(config)
			end
		end)

		profile_dropdown:SetValue(PossiblyEngine.config.read(config.key_orig .. '_profile', 'Default Profile'))

		if selectedProfile then
			config.key = config.key_orig .. selectedProfile
		end

	else
		PossiblyEngine.config.write(config.key_orig .. '_profile', false)
	end


	if config.key_orig then
		parent:SetEventListener('OnDragStop', function(self, event, left, top)
			PossiblyEngine.config.write(config.key_orig .. '_window', {left, top})
		end)
		local left, top = unpack(PossiblyEngine.config.read(config.key_orig .. '_window', {false, false}))
		if left and top then
			parent.settings.left = left
			parent.settings.top = top
			parent:UpdatePosition()
		end
	end

	local window = DiesalGUI:Create('ScrollFrame')
	parent:AddChild(window)
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
function createTestGUI()
	PossiblyEngine.interface.buildGUI(test_config)
end

C_Timer.NewTicker(2, createTestGUI, 1)


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
