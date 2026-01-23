----------------------------------------
-- Transmog Loot Helper: Settings.lua --
----------------------------------------

-- Initialisation
local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not TransmogLootHelper_Settings then TransmogLootHelper_Settings = {} end
		if TransmogLootHelper_Settings["hide"] == nil then TransmogLootHelper_Settings["hide"] = false end
		if TransmogLootHelper_Settings["message"] == nil then TransmogLootHelper_Settings["message"] = L.DEFAULT_MESSAGE end
		if TransmogLootHelper_Settings["windowPosition"] == nil then TransmogLootHelper_Settings["windowPosition"] = { ["left"] = 1295, ["bottom"] = 836, ["width"] = 200, ["height"] = 200, } end
		if TransmogLootHelper_Settings["windowLocked"] == nil then TransmogLootHelper_Settings["windowLocked"] = false end
		if TransmogLootHelper_Settings["windowSort"] == nil then TransmogLootHelper_Settings["windowSort"] = 1 end

		app:CreateMessagePopup()
		app:CreateLinkCopiedFrame()
		app:CreateSettings()

		-- Midnight cleanup
		if TransmogLootHelper_Settings["remixFilter"] ~= nil then TransmogLootHelper_Settings["remixFilter"] = nil end
		if TransmogLootHelper_Settings["remixWindowFilter"] ~= nil then TransmogLootHelper_Settings["remixWindowFilter"] = nil end
		if TransmogLootHelper_Settings["remixWindowLocked"] ~= nil then TransmogLootHelper_Settings["remixWindowLocked"] = nil end
		if TransmogLootHelper_Settings["remixWindowPosition"] ~= nil then TransmogLootHelper_Settings["remixWindowPosition"] = nil end
		if TransmogLootHelper_Cache and TransmogLootHelper_Cache.Lemix ~= nil then TransmogLootHelper_Cache.Lemix = nil end
		if TransmogLootHelper_Cache and TransmogLootHelper_Cache.LemixCharacters ~= nil then TransmogLootHelper_Cache.LemixCharacters = nil end
		if TransmogLootHelper_Settings["simpleIcon"] then TransmogLootHelper_Settings["iconStyle"] = 3 end
		TransmogLootHelper_Settings["simpleIcon"] = nil
	end
end)

--------------
-- SETTINGS --
--------------

-- Open settings
function app:OpenSettings()
	Settings.OpenToCategory(app.Settings:GetID())
end

-- Addon Compartment Click
function TransmogLootHelper_Click(self, button)
	if button == "LeftButton" then
		api:ToggleWindow()
	elseif button == "RightButton" then
		app:OpenSettings()
	end
end

-- Addon Compartment Enter
function TransmogLootHelper_Enter(self, button)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(type(self) ~= "string" and self or button, "ANCHOR_LEFT")
	GameTooltip:AddLine(L.SETTINGS_TOOLTIP)
	GameTooltip:Show()
end

-- Addon Compartment Leave
function TransmogLootHelper_Leave()
	GameTooltip:Hide()
end

-- Settings and minimap icon
function app:CreateSettings()
	-- Minimap button
	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("TransmogLootHelper", {
		type = "data source",
		text = app.NameLong,
		icon = "Interface\\AddOns\\TransmogLootHelper\\assets\\icon.png",

		OnClick = function(self, button)
			if button == "LeftButton" then
				api:ToggleWindow()
			elseif button == "RightButton" then
				app:OpenSettings()
			end
		end,

		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine(L.SETTINGS_TOOLTIP)
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
	local category, layout = Settings.RegisterVerticalLayoutCategory(app.Name)
	Settings.RegisterAddOnCategory(category)
	app.Settings = category

	TransmogLootHelper_SettingsTextMixin = {}
	function TransmogLootHelper_SettingsTextMixin:Init(initializer)
		local data = initializer:GetData()
		self.LeftText:SetTextToFit(data.leftText)
		self.MiddleText:SetTextToFit(data.middleText)
		self.RightText:SetTextToFit(data.rightText)
	end

	local data = { leftText = L.SETTINGS_VERSION .. " |cffFFFFFF" .. C_AddOns.GetAddOnMetadata(appName, "Version") }
	local text = layout:AddInitializer(Settings.CreateElementInitializer("TransmogLootHelper_SettingsText", data))
	function text:GetExtent()
		return 14
	end

	local data = { leftText = L.SETTINGS_SUPPORT_TEXTLONG }
	local text = layout:AddInitializer(Settings.CreateElementInitializer("TransmogLootHelper_SettingsText", data))
	function text:GetExtent()
		return 28 + select(2, string.gsub(data.leftText, "\n", "")) * 12
	end

	StaticPopupDialogs["TRANSMOGLOOTHELPER_URL"] = {
		text = L.SETTINGS_URL_COPY,
		button1 = CLOSE,
		whileDead = true,
		hasEditBox = true,
		editBoxWidth = 240,
		OnShow = function(dialog, data)
			dialog:ClearAllPoints()
			dialog:SetPoint("CENTER", UIParent)

			local editBox = dialog.GetEditBox and dialog:GetEditBox() or dialog.editBox
			editBox:SetText(data)
			editBox:SetAutoFocus(true)
			editBox:HighlightText()
			editBox:SetScript("OnEditFocusLost", function()
				editBox:SetFocus()
			end)
			editBox:SetScript("OnEscapePressed", function()
				dialog:Hide()
			end)
			editBox:SetScript("OnTextChanged", function()
				editBox:SetText(data)
				editBox:HighlightText()
			end)
			editBox:SetScript("OnKeyUp", function(self, key)
				if (IsControlKeyDown() and (key == "C" or key == "X")) then
					dialog:Hide()
					app.LinkCopiedFrame:Show()
					app.LinkCopiedFrame:SetAlpha(1)
					app.LinkCopiedFrame.animation:Play()
				end
			end)
		end,
		OnHide = function(dialog)
			local editBox = dialog.GetEditBox and dialog:GetEditBox() or dialog.editBox
			editBox:SetScript("OnEditFocusLost", nil)
			editBox:SetScript("OnEscapePressed", nil)
			editBox:SetScript("OnTextChanged", nil)
			editBox:SetScript("OnKeyUp", nil)
			editBox:SetText("")
		end,
	}
	local function onSupportButtonClick()
		StaticPopup_Show("TRANSMOGLOOTHELPER_URL", nil, nil, "https://buymeacoffee.com/Slackluster")
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_SUPPORT_TEXT, L.SETTINGS_SUPPORT_BUTTON, onSupportButtonClick, L.SETTINGS_SUPPORT_DESC, true))

	local function onHelpButtonClick()
		StaticPopup_Show("TRANSMOGLOOTHELPER_URL", nil, nil, "https://discord.gg/hGvF59hstx")
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_HELP_TEXT, L.SETTINGS_HELP_BUTTON, onHelpButtonClick, L.SETTINGS_HELP_DESC, true))

	local function onIssuesButtonClick()
		StaticPopup_Show("TRANSMOGLOOTHELPER_URL", nil, nil, "https://github.com/slackluster/TransmogLootHelper/issues")
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_ISSUES_TEXT, L.SETTINGS_ISSUES_BUTTON, onIssuesButtonClick, L.SETTINGS_ISSUES_DESC, true))

	TransmogLootHelper_SettingsExpandMixin = CreateFromMixins(SettingsExpandableSectionMixin)

	function TransmogLootHelper_SettingsExpandMixin:Init(initializer)
		SettingsExpandableSectionMixin.Init(self, initializer)
		self.data = initializer.data
	end

	function TransmogLootHelper_SettingsExpandMixin:OnExpandedChanged(expanded)
		SettingsInbound.RepairDisplay()
	end

	function TransmogLootHelper_SettingsExpandMixin:CalculateHeight()
		return 24
	end

	function TransmogLootHelper_SettingsExpandMixin:OnExpandedChanged(expanded)
		self:EvaluateVisibility(expanded)
		SettingsInbound.RepairDisplay()
	end

	function TransmogLootHelper_SettingsExpandMixin:EvaluateVisibility(expanded)
		if expanded then
			self.Button.Right:SetAtlas("Options_ListExpand_Right_Expanded", TextureKitConstants.UseAtlasSize)
		else
			self.Button.Right:SetAtlas("Options_ListExpand_Right", TextureKitConstants.UseAtlasSize)
		end
	end

	local function createExpandableSection(layout, name)
		local initializer = CreateFromMixins(SettingsExpandableSectionInitializer)
		local data = { name = name, expanded = false }

		initializer:Init("TransmogLootHelper_SettingsExpandTemplate", data)
		initializer.GetExtent = ScrollBoxFactoryInitializerMixin.GetExtent

		layout:AddInitializer(initializer)

		return initializer, function()
			return initializer.data.expanded
		end
	end

	local expandInitializer, isExpanded = createExpandableSection(layout, "|A:UI-Journeys-GreatVault-Tag-new:33:49|a" .. L.SETTINGS_KEYSLASH_TITLE)

		local action = "TLH_TOGGLEWINDOW"
		local bindingIndex = C_KeyBindings.GetBindingIndex(action)
		local initializer = CreateKeybindingEntryInitializer(bindingIndex, true)
		local keybind = layout:AddInitializer(initializer)
		keybind:AddShownPredicate(isExpanded)

		local data = { leftText = "|cffFFFFFF"
			.. "/tlh" .. "\n\n"
			.. "/tlh resetpos" .. "\n\n"
			.. "/tlh settings" .. "\n\n"
			.. "/tlh delete " .. app:Colour(L.SETTINGS_SLASH_CHARREALM) .. "\n\n"
			.. "/tlh msg " .. "\n\n"
			.. "/tlh default ",
		middleText =
			L.SETTINGS_SLASH_TOGGLE .. "\n\n" ..
			L.SETTINGS_SLASH_RESETPOS .. "\n\n" ..
			L.WINDOW_BUTTON_SETTINGS .. "\n\n" ..
			L.SETTINGS_SLASH_DELETE_DESC .. "\n\n" ..
			L.SETTINGS_WHISPER_CUSTOMIZE_DESC .. "\n\n" ..
			L.SETTINGS_SLASH_WHISPER_DEFAULT
		}
		local text = layout:AddInitializer(Settings.CreateElementInitializer("TransmogLootHelper_SettingsText", data))
		function text:GetExtent()
			return 28 + select(2, string.gsub(data.leftText, "\n", "")) * 12
		end
		text:AddShownPredicate(isExpanded)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.GENERAL))

	local variable, name, tooltip = "overlay", L.SETTINGS_ITEM_OVERLAY, L.SETTINGS_ITEM_OVERLAY_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconPosition", L.SETTINGS_ICON_POSITION, L.SETTINGS_ICON_POSITION_DESC .. "\n\n" .. L.SETTINGS_BAGANATOR
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, L.SETTINGS_ICONPOS_TL, L.SETTINGS_ICONPOS_OVERLAP1)
		container:Add(1, L.SETTINGS_ICONPOS_TR, L.SETTINGS_ICONPOS_OVERLAP0)
		container:Add(2, L.SETTINGS_ICONPOS_BL, L.SETTINGS_ICONPOS_OVERLAP0)
		container:Add(3, L.SETTINGS_ICONPOS_BR, L.SETTINGS_ICONPOS_OVERLAP0)
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Number, name, 1)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)
	setting:SetValueChangedCallback(function()
		for i = 1, 4 do
			app:CreateItemOverlay(app.PreviewItem[i].frame, "item:"..i)
		end
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconStyle", "|A:UI-Journeys-GreatVault-Tag-new:33:49|a" .. L.SETTINGS_ICON_STYLE, L.SETTINGS_ICON_STYLE_DESC
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, L.SETTINGS_ICON_STYLE1, L.SETTINGS_ICON_STYLE1_DESC)
		container:Add(2, L.SETTINGS_ICON_STYLE2, L.SETTINGS_ICON_STYLE2_DESC)
		container:Add(3, L.SETTINGS_ICON_STYLE3, L.SETTINGS_ICON_STYLE3_DESC)
		-- container:Add(4, L.SETTINGS_ICON_STYLE4, L.SETTINGS_ICON_STYLE4_DESC)
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Number, name, 1)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)
	setting:SetValueChangedCallback(function()
		for i = 1, 4 do
			app:CreateItemOverlay(app.PreviewItem[i].frame, "item:"..i)
		end
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "animateIcon", L.SETTINGS_ICON_ANIMATE, L.SETTINGS_ICON_ANIMATE_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		for i = 1, 4 do
			app:CreateItemOverlay(app.PreviewItem[i].frame, "item:"..i)
		end
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconLearned", L.SETTINGS_ICONLEARNED, L.SETTINGS_ICONLEARNED_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		for i = 1, 4 do
			app:CreateItemOverlay(app.PreviewItem[i].frame, "item:"..i)
		end
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "textBind", L.SETTINGS_BINDTEXT, L.SETTINGS_BINDTEXT_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		for i = 1, 4 do
			app:CreateItemOverlay(app.PreviewItem[i].frame, "item:"..i)
		end
	end)

	TransmogLootHelper_SettingsItemRowMixin = {}

	function TransmogLootHelper_SettingsItemRowMixin:Init(initializer)
		local data = initializer:GetData()

		for i = 1, 4 do
			local item = data[i]
			if item then
				local btn = self["ItemButton"..i]
				btn.Icon:SetTexture(item.icon)
				btn.Name:SetText(item.name)

				if not btn.TLHOverlay then
					btn.TLHOverlay = CreateFrame("Frame", nil, btn)
					btn.TLHOverlay:SetAllPoints(btn.Icon)
				end
				app:CreateItemOverlay(btn.TLHOverlay, "item:"..i)
				app.PreviewItem[i].frame = btn.TLHOverlay

				btn:SetScript("OnEnter", function()
					GameTooltip:SetOwner(btn, "ANCHOR_BOTTOM")
					GameTooltip:SetText(L.SETTINGS_PREVIEWTOOLTIP[i], nil, nil, nil, nil, true)
					GameTooltip:Show()
				end)
				btn:SetScript("OnLeave", GameTooltip_Hide)
			end
		end
	end

	function TransmogLootHelper_SettingsItemRowMixin:GetExtent()
		return 44
	end

	app.PreviewItem = {
		{ icon = 345787, name = L.SETTINGS_PREVIEW .. "\n" .. L.SETTINGS_NEW },
		{ icon = 135349, name = L.SETTINGS_PREVIEW .. "\n" .. L.SETTINGS_USABLE },
		{ icon = 134940, name = L.SETTINGS_PREVIEW .. "\n" .. L.SETTINGS_LEARNED },
		{ icon = 134344, name = L.SETTINGS_PREVIEW .. "\n" .. L.SETTINGS_UNUSABLE },
	}

	local initializer = Settings.CreateElementInitializer("TransmogLootHelper_SettingsItemRow", app.PreviewItem)
	layout:AddInitializer(initializer)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.SETTINGS_HEADER_COLLECTION))

	local variable, name, tooltip = "iconNewMog", L.SETTINGS_ICON_NEW_MOG, L.SETTINGS_ICON_NEW_MOG_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewSource", L.SETTINGS_ICON_NEW_SOURCE, L.SETTINGS_ICON_NEW_SOURCE_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewMog"] end)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewCatalyst", L.SETTINGS_ICON_NEW_CATALYST, L.SETTINGS_ICON_NEW_CATALYST_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewMog"] end)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewUpgrade", L.SETTINGS_ICON_NEW_UPGRADE, L.SETTINGS_ICON_NEW_UPGRADE_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewMog"] end)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewIllusion", L.SETTINGS_ICON_NEW_ILLUSION, L.SETTINGS_ICON_NEW_ILLUSION_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewMount", L.SETTINGS_ICON_NEW_MOUNT, L.SETTINGS_ICON_NEW_MOUNT_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewPet", L.SETTINGS_ICON_NEW_PET, L.SETTINGS_ICON_NEW_PET_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewPetMax", L.SETTINGS_ICON_NEW_PET_MAX, L.SETTINGS_ICON_NEW_PET_MAX_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewPet"] end)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewToy", L.SETTINGS_ICON_NEW_TOY, L.SETTINGS_ICON_NEW_TOY_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewRecipe", L.SETTINGS_ICON_NEW_RECIPE, L.SETTINGS_ICON_NEW_RECIPE_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewDecor", L.SETTINGS_ICON_NEW_DECOR, L.SETTINGS_ICON_NEW_DECOR_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	local variable, name, tooltip = "iconNewDecorXP", L.SETTINGS_ICON_NEW_DECORXP, L.SETTINGS_ICON_NEW_DECORXP_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewDecor"] end)
	setting:SetValueChangedCallback(function()
		app:SettingsChanged()
	end)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.SETTINGS_HEADER_OTHER_INFO))

	local variable, name, tooltip = "iconQuestGold", L.SETTINGS_ICON_QUEST_GOLD, L.SETTINGS_ICON_QUEST_GOLD_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconUsable", L.SETTINGS_ICON_USABLE, L.SETTINGS_ICON_USABLE_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconContainer", L.SETTINGS_ICON_OPENABLE, L.SETTINGS_ICON_OPENABLE_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	-- Subcategory: Loot Tracker
	local category, layout = Settings.RegisterVerticalLayoutSubcategory(app.Settings, L.SETTINGS_HEADER_LOOT_TRACKER)
	Settings.RegisterAddOnCategory(category)

	local variable, name, tooltip = "minimapIcon", L.SETTINGS_MINIMAP, L.SETTINGS_MINIMAP_DESC
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

	local variable, name, tooltip = "autoOpen", L.SETTINGS_AUTO_OPEN, L.SETTINGS_AUTO_OPEN_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "collectMode", L.SETTINGS_COLLECTION_MODE, L.SETTINGS_COLLECTION_MODE_DESC
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, L.SETTINGS_MODE_APPEARANCES, L.SETTINGS_MODE_APPEARANCES_DESC)
		container:Add(2, L.SETTINGS_MODE_SOURCES, L.SETTINGS_MODE_SOURCES_DESC)
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Number, name, 1)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)

	local variable, name, tooltip = "rarity", L.SETTINGS_RARITY, L.SETTINGS_RARITY_DESC
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(0).r * 255, C_ColorOverrides.GetColorForQuality(0).g * 255, C_ColorOverrides.GetColorForQuality(0).b * 255) .. ITEM_QUALITY0_DESC .. "|r")
		container:Add(1, "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(1).r * 255, C_ColorOverrides.GetColorForQuality(1).g * 255, C_ColorOverrides.GetColorForQuality(1).b * 255) .. ITEM_QUALITY1_DESC .. "|r")
		container:Add(2, "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(2).r * 255, C_ColorOverrides.GetColorForQuality(2).g * 255, C_ColorOverrides.GetColorForQuality(2).b * 255) .. ITEM_QUALITY2_DESC .. "|r")
		container:Add(3, "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(3).r * 255, C_ColorOverrides.GetColorForQuality(3).g * 255, C_ColorOverrides.GetColorForQuality(3).b * 255) .. ITEM_QUALITY3_DESC .. "|r")
		container:Add(4, "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(4).r * 255, C_ColorOverrides.GetColorForQuality(4).g * 255, C_ColorOverrides.GetColorForQuality(4).b * 255) .. ITEM_QUALITY4_DESC .. "|r")
		return container:GetData()

	end
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Number, name, 3)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)

	local function onRenameButtonClick()
		app.RenamePopup:Show()
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_WHISPER, L.SETTINGS_WHISPER_CUSTOMIZE, onRenameButtonClick, L.SETTINGS_WHISPER_CUSTOMIZE_DESC .. ".", true))

	-- Subcategory: Tweaks
	local category, layout = Settings.RegisterVerticalLayoutSubcategory(app.Settings, "Tweaks")
	Settings.RegisterAddOnCategory(category)

	local variable, name, tooltip = "instantCatalyst", L.SETTINGS_CATALYST, L.SETTINGS_CATALYST_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "instantCatalystTooltip", L.SETTINGS_INSTANT_TOOLTIP,L.SETTINGS_INSTANT_TOOLTIP_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["instantCatalyst"] end)

	local variable, name, tooltip = "instantVault", L.SETTINGS_VAULT, L.SETTINGS_VAULT_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "instantVaultTooltip", L.SETTINGS_INSTANT_TOOLTIP,L.SETTINGS_INSTANT_TOOLTIP_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["instantVault"] end)

	local variable, name, tooltip = "vendorAll", L.SETTINGS_VENDOR_ALL, L.SETTINGS_VENDOR_ALL_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "hideGroupRolls", L.SETTINGS_HIDE_LOOT_ROLL_WINDOW, L.SETTINGS_HIDE_LOOT_ROLL_WINDOW_DESC
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)
end

-- Message change popup
function app:CreateMessagePopup()
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
	local string1 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	string1:SetPoint("CENTER", frame, "CENTER", 0, 0)
	string1:SetPoint("TOP", frame, "TOP", 0, -10)
	string1:SetJustifyH("CENTER")
	string1:SetText(L.WHISPER_POPUP_CUSTOMIZE)

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
	border:SetBackdropBorderColor(0.25, 0.78, 0.92)

	-- Text 2
	local string2 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	string2:SetPoint("CENTER", frame, "CENTER", 0, 0)
	string2:SetPoint("TOP", frame, "TOP", 0, -60)
	string2:SetJustifyH("CENTER")
	string2:SetText("")

	-- Edit functions
	editBox:SetScript("OnEditFocusGained", function(self)
		-- Reset our visual feedback
		border:SetBackdropBorderColor(0.25, 0.78, 0.92)
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
					border:SetBackdropBorderColor(0.25, 0.78, 0.92)
				end)

				-- Set our feedback text message
				string2:SetText(app.IconNotReady .. " " .. L.WHISPER_POPUP_ERROR)
			-- Edit the message if all is gucci
			else
				-- Change the editbox border colour for some extra visual feedback
				border:SetBackdropBorderColor(0, 1, 0)
				C_Timer.After(3, function()
					border:SetBackdropBorderColor(0.25, 0.78, 0.92)
				end)

				-- Set our feedback text message
				string2:SetText(app.IconReady .. " " .. L.WHISPER_POPUP_SUCCESS)

				-- Save the new message
				TransmogLootHelper_Settings["message"] = newValue
			end
		end
	end)
	editBox:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
	end)
	editBox:SetScript("OnEscapePressed", function(self)
		self:SetText(TransmogLootHelper_Settings["message"])
	end)

	app.RenamePopup = frame
end

function app:CreateLinkCopiedFrame()
	app.LinkCopiedFrame= CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	app.LinkCopiedFrame:SetPoint("CENTER")
	app.LinkCopiedFrame:SetFrameStrata("TOOLTIP")
	app.LinkCopiedFrame:SetHeight(1)
	app.LinkCopiedFrame:SetWidth(1)
	app.LinkCopiedFrame:Hide()

	local string = app.LinkCopiedFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	string:SetPoint("CENTER", app.LinkCopiedFrame, "CENTER", 0, 0)
	string:SetPoint("TOP", app.LinkCopiedFrame, "TOP", 0, 0)
	string:SetJustifyH("CENTER")
	string:SetText(app.IconReady .. " " .. L.SETTINGS_URL_COPIED)

	app.LinkCopiedFrame.animation = app.LinkCopiedFrame:CreateAnimationGroup()
	local fadeOut = app.LinkCopiedFrame.animation:CreateAnimation("Alpha")
	fadeOut:SetFromAlpha(1)
	fadeOut:SetToAlpha(0)
	fadeOut:SetDuration(1)
	fadeOut:SetStartDelay(1)
	fadeOut:SetSmoothing("IN_OUT")
	app.LinkCopiedFrame.animation:SetToFinalAlpha(true)
	app.LinkCopiedFrame.animation:SetScript("OnFinished", function()
		app.LinkCopiedFrame:Hide()
	end)
end

function app:SettingsChanged()
	if C_AddOns.IsAddOnLoaded("Baganator") then
		Baganator.API.RequestItemButtonsRefresh()
	end
end
