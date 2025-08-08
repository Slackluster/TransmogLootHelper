----------------------------------------
-- Transmog Loot Helper: Settings.lua --
----------------------------------------

-- Initialisation
local appName, app = ...

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not TransmogLootHelper_Settings then TransmogLootHelper_Settings = {} end
		if TransmogLootHelper_Settings["hide"] == nil then TransmogLootHelper_Settings["hide"] = false end
		if TransmogLootHelper_Settings["message"] == nil then TransmogLootHelper_Settings["message"] = "Do you need the %item you looted? If not, I'd like to have it for transmog. :)" end
		if TransmogLootHelper_Settings["windowPosition"] == nil then TransmogLootHelper_Settings["windowPosition"] = { ["left"] = 1295, ["bottom"] = 836, ["width"] = 200, ["height"] = 200, } end
		if TransmogLootHelper_Settings["windowLocked"] == nil then TransmogLootHelper_Settings["windowLocked"] = false end
		if TransmogLootHelper_Settings["windowSort"] == nil then TransmogLootHelper_Settings["windowSort"] = 1 end

		app.CreateMessagePopup()
		app.Settings()
	end
end)

--------------
-- SETTINGS --
--------------

-- Open settings
function app.OpenSettings()
	Settings.OpenToCategory(app.Category:GetID())
end

-- AddOn Compartment Click
function TransmogLootHelper_Click(self, button)
	if button == "LeftButton" then
		app.Toggle()
	elseif button == "RightButton" then
		app.OpenSettings()
	end
end

-- AddOn Compartment Enter
function TransmogLootHelper_Enter(self, button)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(type(self) ~= "string" and self or button, "ANCHOR_LEFT")
	GameTooltip:AddLine(app.NameLong.."\nLMB|cffFFFFFF: Toggle the window\n|RRMB|cffFFFFFF: Show the settings|R")
	GameTooltip:Show()
end

-- AddOn Compartment Leave
function TransmogLootHelper_Leave()
	GameTooltip:Hide()
end

-- Settings and minimap icon
function app.Settings()
	-- Minimap button
	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("TransmogLootHelper", {
		type = "data source",
		text = app.NameLong,
		icon = "Interface\\AddOns\\TransmogLootHelper\\assets\\tlh_icon",

		OnClick = function(self, button)
			if button == "LeftButton" then
				app.Toggle()
			elseif button == "RightButton" then
				app.OpenSettings()
			end
		end,

		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine(app.NameLong.."\nLMB|cffFFFFFF: Toggle the window\n|RRMB|cffFFFFFF: Show the settings|R")
		end,
	})

	local icon = LibStub("LibDBIcon-1.0", true)
	icon:Register("TransmogLootHelper", miniButton, TransmogLootHelper_Settings)

	if TransmogLootHelper_Settings["minimapIcon"] == true then
		TransmogLootHelper_Settings["hide"] = false
		icon:Show("TransmogLootHelper")
	else
		TransmogLootHelper_Settings["hide"] = true
		icon:Hide("TransmogLootHelper")
	end

	-- Settings page
	local category, layout = Settings.RegisterVerticalLayoutCategory(app.NameLong)
	Settings.RegisterAddOnCategory(category)
	app.Category = category

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(C_AddOns.GetAddOnMetadata(appName, "Version")))

	local cbVariable, cbName, cbTooltip = "overlay", "Item Overlay", "Show an icon and text on items, to indicate collection status and more.\n\n|cffFF0000" .. REQUIRES_RELOAD .. ".|r Use |cffFFFFFF/reload|r or relog.\n\nBaganator: Icon position is managed by its own settings."
	local cbSetting = Settings.RegisterAddOnSetting(category, appName.."_"..cbVariable, cbVariable, TransmogLootHelper_Settings, Settings.VarType.Boolean, cbName, true)

	local ddVariable, ddName, ddTooltip = "iconPosition", "Icon Position", "The location of the icon on the item."
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, "Top Left", "This may overlap with a crafted item's quality.")
		container:Add(1, "Top Right", "No known overlap issues.")
		container:Add(2, "Bottom Left", "No known overlap issues.")
		container:Add(3, "Bottom Right", "No known overlap issues.")
		return container:GetData()
	end
	local ddSetting = Settings.RegisterAddOnSetting(category, appName.."_"..ddVariable, ddVariable, TransmogLootHelper_Settings, Settings.VarType.Number, ddName, 1)

	local initializer = CreateSettingsCheckboxDropdownInitializer(
		cbSetting, cbName, cbTooltip,
		ddSetting, GetOptions, ddName, ddTooltip)
	layout:AddInitializer(initializer)

	local variable, name, tooltip = "simpleIcon", "Simple Icons", "Use simple, high contrast icons designed to aid with color blindness."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "animateIcon", "Icon Animation", "Show a pretty animated swirl on icons for learnable and usable icons."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Collection Info"))

	local variable, name, tooltip = "iconNewMog", "Appearances", "Show an icon to indicate an item's appearance is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewSource", "Sources", "Show an icon to indicate an item's appearance source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewMog"] end)

	local variable, name, tooltip = "iconNewIllusion", "Illusions", "Show an icon to indicate an illusion is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewMount", "Mounts", "Show an icon to indicate a mount is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewPet", "Pets", "Show an icon to indicate a pet is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewPetMax", "Collect 3/3", "Also take the maximum number of pets you can own into account (usually 3)."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewPet"] end)

	local variable, name, tooltip = "iconNewToy", "Toys", "Show an icon to indicate an item's source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewRecipe", "Recipes", "Show an icon to indicate an item's source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconLearned", "Learned", "Show an icon to indicate the above tracked collectibles are learned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	Settings.CreateCheckbox(category, setting, tooltip)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Other Info"))

	local variable, name, tooltip = "iconQuestGold", "Quest Reward Sell Value", "Show an icon to indicate which quest reward has the highest vendor sell value, if there are multiple."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconUsable", "Usable Items", "Show an icon to indicate an item can be used (profession knowledge, unlockable customisations, and spellbooks)."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconContainer", "Openable Containers", "Show an icon to indicate an item can be opened, such as lockboxes and holiday boss bags."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "textBind", "Binding Status", "Show a text indicator for Bind-on-Equip items (BoE), Warbound items (BoA), and Warbound-until-Equipped (WuE) items.\n\nBaganator: Binding text is managed by its own settings."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	-- Subcategory: Loot Tracker
	local category, layout = Settings.RegisterVerticalLayoutSubcategory(app.Category, "Loot Tracker")
	Settings.RegisterAddOnCategory(category)

	local variable, name, tooltip = "minimapIcon", "Minimap Icon", "Show the minimap icon. If you disable this, "..app.NameShort.." is still available from the AddOn Compartment."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		if TransmogLootHelper_Settings["minimapIcon"] == true then
			TransmogLootHelper_Settings["hide"] = false
			icon:Show("TransmogLootHelper")
		else
			TransmogLootHelper_Settings["hide"] = true
			icon:Hide("TransmogLootHelper")
		end
	end)

	local variable, name, tooltip = "autoOpen", "Auto Open Window", "Automatically show the "..app.NameShort.." window when an eligible item is looted."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "collectMode", "Collection Mode", "Set when "..app.NameShort.." should show new transmog looted by others."
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, "Appearances", "Show items only if they have a new appearance.")
		container:Add(2, "Sources", "Show items if they are a new source, including for known appearances.")
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Number, name, 1)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)

	local variable, name, tooltip = "remixFilter", "Remix Filter", "Filter items below |cff0070dd"..ITEM_QUALITY3_DESC.."|r quality (untradeable) for Remix characters."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "rarity", "Rarity", "Set from what quality and up "..app.NameShort.." should show loot."
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, "|cff9d9d9d"..ITEM_QUALITY0_DESC.."|r")
		container:Add(1, "|cffffffff"..ITEM_QUALITY1_DESC.."|r")
		container:Add(2, "|cff1eff00"..ITEM_QUALITY2_DESC.."|r")
		container:Add(3, "|cff0070dd"..ITEM_QUALITY3_DESC.."|r")
		container:Add(4, "|cffa335ee"..ITEM_QUALITY4_DESC.."|r")
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Number, name, 3)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)

	local function onButtonClick()
		app.RenamePopup:Show()
	end
	local initializer = CreateSettingsButtonInitializer("Whisper Message", "Customize", onButtonClick, "Customize your whisper message.", true)
	layout:AddInitializer(initializer)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Information"))

	local variable, name, tooltip = "", "Slash Commands", "Type these in chat to use them!"
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, "/tlh", "Toggle the window.")
		container:Add(2, "/tlh settings", "Open these settings.")
		container:Add(3, "/tlh resetpos", "Reset the window position.")
		container:Add(4, "/tlh default", "Set the whisper message to its default.")
		container:Add(5, "/tlh msg", "Customize the whisper message.")
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Number, name, 1)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)

	-- Subcategory: Tweaks
	local category, layout = Settings.RegisterVerticalLayoutSubcategory(app.Category, "Tweaks")
	Settings.RegisterAddOnCategory(category)

	local variable, name, tooltip = "hideGroupRolls", "Hide loot roll window", "Hide the window that shows loot rolls and their results. You can show the window again with |cff00ccff/loot|r."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)
end

-- Message change popup
function app.CreateMessagePopup()
	-- Create popup frame
	local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	frame:SetPoint("CENTER")
	frame:SetFrameStrata("TOOLTIP")
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:EnableMouse(true)
	frame:SetHeight(85)
	frame:SetWidth(500)
	frame:Hide()

	-- Close button
	local close = CreateFrame("Button", "", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
	close:SetScript("OnClick", function()
		frame:Hide()
	end)

	-- Text
	local string1 = frame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	string1:SetPoint("CENTER", frame, "CENTER", 0, 0)
	string1:SetPoint("TOP", frame, "TOP", 0, -10)
	string1:SetJustifyH("CENTER")
	string1:SetText("Customize your whisper message:")

	-- Editbox
	local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
	editBox:SetSize(460, 20)
	editBox:SetPoint("CENTER", frame, "CENTER", 0, 0)
	editBox:SetPoint("TOP", frame, "TOP", 0, -30)
	editBox:SetAutoFocus(false)
	editBox:SetText(TransmogLootHelper_Settings["message"])
	editBox:SetCursorPosition(0)

	local border = CreateFrame("Frame", nil, editBox, "BackdropTemplate")
	border:SetPoint("TOPLEFT", editBox, -6, 1)
	border:SetPoint("BOTTOMRIGHT", editBox, 2, -2)
	border:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 14,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	border:SetBackdropColor(0, 0, 0, 0)
	border:SetBackdropBorderColor(0.776, 0.608, 0.427)

	-- Text 2
	local string2 = frame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	string2:SetPoint("CENTER", frame, "CENTER", 0, 0)
	string2:SetPoint("TOP", frame, "TOP", 0, -60)
	string2:SetJustifyH("CENTER")
	string2:SetText("")

	-- Edit functions
	editBox:SetScript("OnEditFocusGained", function(self)
		-- Reset our visual feedback
		border:SetBackdropBorderColor(0.776, 0.608, 0.427)
		string2:SetText("")
	end)
	editBox:SetScript("OnEditFocusLost", function(self)
		-- Check if the message is gucci
		local newValue = self:GetText()

		if newValue == TransmogLootHelper_Settings["message"] then
			-- Do nothing
		else
			local item = false
			if string.find(newValue, "%%item") ~= nil then
				item = true
			end

			if item == false then
				-- Change the editbox border colour for some extra visual feedback
				border:SetBackdropBorderColor(1, 0, 0)
				C_Timer.After(3, function()
					border:SetBackdropBorderColor(0.776, 0.608, 0.427)
				end)

				-- Set our feedback text message
				string2:SetText(app.IconNotReady .. " Message does not include |cffC69B6D%item|r. Message is not updated.")
			-- Edit the message if all is gucci
			else
				-- Change the editbox border colour for some extra visual feedback
				border:SetBackdropBorderColor(0, 1, 0)
				C_Timer.After(3, function()
					border:SetBackdropBorderColor(0.776, 0.608, 0.427)
				end)

				-- Set our feedback text message
				string2:SetText(app.IconReady .. " Message is updated.")

				-- Save the new message
				TransmogLootHelper_Settings["message"] = newValue
			end
		end
	end)
	editBox:SetScript("OnEnterPressed", function(self)
		-- This triggers the above script
		self:ClearFocus()
	end)
	editBox:SetScript("OnEscapePressed", function(self)
		self:SetText(TransmogLootHelper_Settings["message"])
	end)

	app.RenamePopup = frame
end