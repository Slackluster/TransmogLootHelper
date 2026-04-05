----------------------------------------
-- Transmog Loot Helper: Settings.lua --
----------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		TransmogLootHelper_Settings = TransmogLootHelper_Settings or {}
		app.Settings = TransmogLootHelper_Settings

		app.Settings["hide"] = app.Settings["hide"] or false
		app.Settings["message"] = app.Settings["message"] or L.DEFAULT_MESSAGE
		app.Settings["windowPosition"] = app.Settings["windowPosition"] or { ["left"] = 1295, ["bottom"] = 836, ["width"] = 200, ["height"] = 200, }
		app.Settings["windowLocked"] = app.Settings["windowLocked"] or false
		app.Settings["windowSort"] = app.Settings["windowSort"] or 1

		app:CreateMinimapButton()
		app:CreateSettings()

		-- Midnight cleanup
		app.Settings["remixFilter"] = nil
		app.Settings["remixWindowFilter"] = nil
		app.Settings["remixWindowLocked"] = nil
		app.Settings["remixWindowPosition"] = nil
		if app.Settings["simpleIcon"] then app.Settings["iconStyle"] = 3 end
		app.Settings["simpleIcon"] = nil
		if TransmogLootHelper_Cache then
			TransmogLootHelper_Cache.Lemix = nil
			TransmogLootHelper_Cache.LemixCharacters = nil
		end
	end
end)

--------------
-- SETTINGS --
--------------

function app:OpenSettings()
	Settings.OpenToCategory(app.SettingsCategory:GetID())
end

function app:CreateMinimapButton()
	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject(app.NameLong, {
		type = "data source",
		text = app.NameLong,
		icon = app.Icon,

		OnClick = TransmogLootHelper_Click,

		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine(L.SETTINGS_TOOLTIP)
		end,
	})

	app.MinimapIcon = LibStub("LibDBIcon-1.0", true)
	app.MinimapIcon:Register(appName, miniButton, app.Settings)

	function app:ToggleMinimapIcon()
		if app.Settings["minimapIcon"] then
			app.Settings["hide"] = false
			app.MinimapIcon:Show(appName)
		else
			app.Settings["hide"] = true
			app.MinimapIcon:Hide(appName)
		end
	end
	app:ToggleMinimapIcon()
end

function app:CreateSettings()
	-- Helper functions
	app.LinkCopiedFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	app.LinkCopiedFrame:SetPoint("CENTER")
	app.LinkCopiedFrame:SetFrameStrata("TOOLTIP")
	app.LinkCopiedFrame:SetHeight(1)
	app.LinkCopiedFrame:SetWidth(1)
	app.LinkCopiedFrame:Hide()

	local text = app.LinkCopiedFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	text:SetPoint("CENTER", app.LinkCopiedFrame, "CENTER", 0, 0)
	text:SetPoint("TOP", app.LinkCopiedFrame, "TOP", 0, 0)
	text:SetJustifyH("CENTER")
	text:SetText(app.IconReady .. " " .. L.SETTINGS_URL_COPIED)

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

	do
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

		local close = CreateFrame("Button", "", frame, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
		close:SetScript("OnClick", function()
			frame:Hide()
		end)

		local string1 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		string1:SetPoint("CENTER", frame, "CENTER", 0, 0)
		string1:SetPoint("TOP", frame, "TOP", 0, -10)
		string1:SetJustifyH("CENTER")
		string1:SetText(L.WHISPER_POPUP_CUSTOMIZE)

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

		local string2 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		string2:SetPoint("CENTER", frame, "CENTER", 0, 0)
		string2:SetPoint("TOP", frame, "TOP", 0, -60)
		string2:SetJustifyH("CENTER")
		string2:SetText("")

		editBox:SetScript("OnEditFocusGained", function(self)
			border:SetBackdropBorderColor(0.25, 0.78, 0.92)
			string2:SetText("")
		end)
		editBox:SetScript("OnEditFocusLost", function(self)
			local newValue = self:GetText()

			if newValue == TransmogLootHelper_Settings["message"] then
			else
				local item = false
				if string.find(newValue, "%%item") ~= nil then
					item = true
				end

				if item == false then
					border:SetBackdropBorderColor(1, 0, 0)
					C_Timer.After(3, function()
						border:SetBackdropBorderColor(0.25, 0.78, 0.92)
					end)

					string2:SetText(app.IconNotReady .. " " .. L.WHISPER_POPUP_ERROR)
				else
					border:SetBackdropBorderColor(0, 1, 0)
					C_Timer.After(3, function()
						border:SetBackdropBorderColor(0.25, 0.78, 0.92)
					end)

					string2:SetText(app.IconReady .. " " .. L.WHISPER_POPUP_SUCCESS)

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

	TransmogLootHelper_SettingsTextMixin = {}
	function TransmogLootHelper_SettingsTextMixin:Init(initializer)
		local data = initializer:GetData()
		self.LeftText:SetTextToFit(data.leftText)
		self.MiddleText:SetTextToFit(data.middleText)
		self.RightText:SetTextToFit(data.rightText)
	end

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

	local category, layout

	local function button(name, buttonName, description, func)
		layout:AddInitializer(CreateSettingsButtonInitializer(name, buttonName, func, description, true))
	end

	local function checkbox(variable, name, description, default, callback, parentSetting, parentCheckbox)
		local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, app.Settings, type(default), name, default)
		local checkbox = Settings.CreateCheckbox(category, setting, description)

		if parentSetting and parentCheckbox then
			checkbox:SetParentInitializer(parentCheckbox, function() return parentSetting:GetValue() end)
			if callback then
				parentSetting:SetValueChangedCallback(callback)
			end
		elseif callback then
			setting:SetValueChangedCallback(callback)
		end

		return setting, checkbox
	end

	local function checkboxDropdown(cbVariable, cbName, description, cbDefaultValue, ddVariable, ddDefaultValue, options, callback)
		local cbSetting = Settings.RegisterAddOnSetting(category, appName.."_"..cbVariable, cbVariable, app.Settings, type(cbDefaultValue), cbName, cbDefaultValue)
		local ddSetting = Settings.RegisterAddOnSetting(category, appName.."_"..ddVariable, ddVariable, app.Settings, type(ddDefaultValue), "", ddDefaultValue)
		local function GetOptions()
			local container = Settings.CreateControlTextContainer()
			for _, option in ipairs(options) do
				container:Add(option.value, option.name, option.description)
			end
			return container:GetData()
		end

		local initializer = CreateSettingsCheckboxDropdownInitializer(cbSetting, cbName, description, ddSetting, GetOptions, "")
		layout:AddInitializer(initializer)

		if callback then
			cbSetting:SetValueChangedCallback(callback)
			ddSetting:SetValueChangedCallback(callback)
		end
	end

	local function dropdown(variable, name, description, default, options, callback)
		local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, app.Settings, type(default), name, default)
		local function GetOptions()
			local container = Settings.CreateControlTextContainer()
			for _, option in ipairs(options) do
				container:Add(option.value, option.name, option.description)
			end
			return container:GetData()
		end
		Settings.CreateDropdown(category, setting, GetOptions, description)
		if callback then
			setting:SetValueChangedCallback(callback)
		end
	end

	local function expandableHeader(name)
		local initializer = CreateFromMixins(SettingsExpandableSectionInitializer)
		local data = { name = name, expanded = false }

		initializer:Init("TransmogLootHelper_SettingsExpandTemplate", data)
		initializer.GetExtent = ScrollBoxFactoryInitializerMixin.GetExtent

		layout:AddInitializer(initializer)

		return initializer, function()
			return initializer.data.expanded
		end
	end

	local function header(name)
		layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(name))
	end

	local function keybind(name, isExpanded)
		local action = name
		local bindingIndex = C_KeyBindings.GetBindingIndex(action)
		local initializer = CreateKeybindingEntryInitializer(bindingIndex, true)
		local keybind = layout:AddInitializer(initializer)
		if isExpanded ~= nil then keybind:AddShownPredicate(isExpanded) end
	end

	local function text(leftText, middleText, rightText, customExtent, isExpanded)
		local data = { leftText = leftText, middleText = middleText, rightText = rightText }
		local text = layout:AddInitializer(Settings.CreateElementInitializer("TransmogLootHelper_SettingsText", data))
		function text:GetExtent()
			if customExtent then return customExtent end
			return 28 + select(2, string.gsub(data.leftText, "\n", "")) * 12
		end
		if isExpanded ~= nil then text:AddShownPredicate(isExpanded) end
	end

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
				app:ApplyItemOverlay(btn.TLHOverlay, "item:"..i)
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
		{ icon = 345787, name = L.SETTINGS_PREVIEW .. "\n" .. L.SETTINGS_UNLEARNED },
		{ icon = 135349, name = L.SETTINGS_PREVIEW .. "\n" .. L.SETTINGS_USABLE },
		{ icon = 134940, name = L.SETTINGS_PREVIEW .. "\n" .. L.SETTINGS_LEARNED },
		{ icon = 134344, name = L.SETTINGS_PREVIEW .. "\n" .. L.SETTINGS_UNUSABLE },
	}

	local function itemPreview()
		local initializer = Settings.CreateElementInitializer("TransmogLootHelper_SettingsItemRow", app.PreviewItem)
		layout:AddInitializer(initializer)
	end

	function app:SettingsChanged()
		if C_AddOns.IsAddOnLoaded("Baganator") then
			Baganator.API.RequestItemButtonsRefresh()
		end
	end

	function app:UpdatePreviewItems()
		for i = 1, 4 do
			app:ApplyItemOverlay(app.PreviewItem[i].frame, "item:"..i)
		end
		app:SettingsChanged()
	end

	-- Settings
	category, layout = Settings.RegisterVerticalLayoutCategory(app.Name)
	Settings.RegisterAddOnCategory(category)
	app.SettingsCategory = category

	text(L.SETTINGS_VERSION .. " |cffFFFFFF" .. C_AddOns.GetAddOnMetadata(appName, "Version"), nil, nil, 14)
	text(L.SETTINGS_SUPPORT_TEXTLONG)
	button(L.SETTINGS_SUPPORT_TEXT, L.SETTINGS_SUPPORT_BUTTON, L.SETTINGS_SUPPORT_DESC, function() StaticPopup_Show("TRANSMOGLOOTHELPER_URL", nil, nil, "https://buymeacoffee.com/Slackluster") end)
	button(L.SETTINGS_HELP_TEXT, L.SETTINGS_HELP_BUTTON, L.SETTINGS_HELP_DESC, function() StaticPopup_Show("TRANSMOGLOOTHELPER_URL", nil, nil, "https://discord.gg/hGvF59hstx") end)

	local _, isExpanded = expandableHeader(L.SETTINGS_KEYSLASH_TITLE)

		keybind("TLH_TOGGLEWINDOW", isExpanded)

		local leftText = { "|cffFFFFFF" ..
			"/tlh",
			"/tlh resetpos",
			"/tlh settings",
			"/tlh delete " .. app:Colour(L.SETTINGS_SLASH_CHARREALM),
			"/tlh msg ",
			"/tlh default " }
		local middleText = {
			L.SETTINGS_SLASH_TOGGLE,
			L.SETTINGS_SLASH_RESETPOS,
			L.WINDOW_BUTTON_SETTINGS,
			L.SETTINGS_SLASH_DELETE_DESC,
			L.SETTINGS_WHISPER_CUSTOMIZE_DESC,
			L.SETTINGS_SLASH_WHISPER_DEFAULT }
		leftText = table.concat(leftText, "\n\n")
		middleText = table.concat(middleText, "\n\n")
		text(leftText, middleText, nil, nil, isExpanded)

	header(L.GENERAL)

	checkbox("overlay", L.SETTINGS_ITEM_OVERLAY, L.SETTINGS_ITEM_OVERLAY_DESC, true, function()
		app:SettingsChanged()
	end)

	dropdown("iconPosition", L.SETTINGS_ICON_POSITION, L.SETTINGS_ICON_POSITION_DESC .. "\n\n" .. L.SETTINGS_BAGANATOR, 1, {
		{ value = 0, name = L.SETTINGS_ICONPOS_TL, description = L.SETTINGS_ICONPOS_OVERLAP1 },
		{ value = 1, name = L.SETTINGS_ICONPOS_TR, description = L.SETTINGS_ICONPOS_OVERLAP0 },
		{ value = 2, name = L.SETTINGS_ICONPOS_BL, description = L.SETTINGS_ICONPOS_OVERLAP0 },
		{ value = 3, name = L.SETTINGS_ICONPOS_BR, description = L.SETTINGS_ICONPOS_OVERLAP0 },
	}, function() app:UpdatePreviewItems() end)

	dropdown("iconStyle", L.SETTINGS_ICON_STYLE .. app.IconNew, L.SETTINGS_ICON_STYLE_DESC, 1, {
		{ value = 1, name = L.SETTINGS_ICON_STYLE1, description = L.SETTINGS_ICON_STYLE1_DESC },
		{ value = 2, name = L.SETTINGS_ICON_STYLE2, description = L.SETTINGS_ICON_STYLE2_DESC },
		{ value = 3, name = L.SETTINGS_ICON_STYLE3, description = L.SETTINGS_ICON_STYLE3_DESC },
		{ value = 4, name = L.SETTINGS_ICON_STYLE4, description = L.SETTINGS_ICON_STYLE4_DESC },
	}, function() app:UpdatePreviewItems() end)

	checkbox("animateIcon", L.SETTINGS_ICON_ANIMATE, L.SETTINGS_ICON_ANIMATE_DESC, true, function() app:UpdatePreviewItems() end)

	checkboxDropdown("iconLearned", L.SETTINGS_ICONLEARNED, L.SETTINGS_ICONLEARNED_DESC, true, "learnedStyle", 0, {
		{ value = 0, name = L.DEFAULT, description = L.SETTINGS_ICONLEARNED_DESC2 },
		{ value = 1, name = L.SETTINGS_ICON_STYLE1, description = L.SETTINGS_ICON_STYLE1_DESC },
		{ value = 2, name = L.SETTINGS_ICON_STYLE2, description = L.SETTINGS_ICON_STYLE2_DESC },
		{ value = 3, name = L.SETTINGS_ICON_STYLE3, description = L.SETTINGS_ICON_STYLE3_DESC },
		{ value = 4, name = L.SETTINGS_ICON_STYLE4, description = L.SETTINGS_ICON_STYLE4_DESC },
	}, function() app:UpdatePreviewItems() end)

	checkbox("textBind", L.SETTINGS_BINDTEXT, L.SETTINGS_BINDTEXT_DESC, true, function() app:UpdatePreviewItems() end)

	itemPreview()

	header(L.SETTINGS_HEADER_COLLECTION)

	local parentSetting, parentCheckbox = checkbox("iconNewMog", L.SETTINGS_ICON_NEW_MOG, L.SETTINGS_ICON_NEW_MOG_DESC, true, function() app:SettingsChanged() end)

	checkbox("iconNewSource", L.SETTINGS_ICON_NEW_SOURCE, L.SETTINGS_ICON_NEW_SOURCE_DESC, false, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	checkbox("iconNewCatalyst", L.SETTINGS_ICON_NEW_CATALYST, L.SETTINGS_ICON_NEW_CATALYST_DESC, true, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	checkbox("iconNewUpgrade", L.SETTINGS_ICON_NEW_UPGRADE, L.SETTINGS_ICON_NEW_UPGRADE_DESC, true, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	checkbox("iconNewIllusion", L.SETTINGS_ICON_NEW_ILLUSION, L.SETTINGS_ICON_NEW_ILLUSION_DESC, true, function() app:SettingsChanged() end)

	checkbox("iconNewMount", L.SETTINGS_ICON_NEW_MOUNT, L.SETTINGS_ICON_NEW_MOUNT_DESC, true, function() app:SettingsChanged() end)

	local parentSetting, parentCheckbox = checkbox("iconNewPet", L.SETTINGS_ICON_NEW_PET, L.SETTINGS_ICON_NEW_PET_DESC, true, function() app:SettingsChanged() end)

	checkbox("iconNewPetMax", L.SETTINGS_ICON_NEW_PET_MAX, L.SETTINGS_ICON_NEW_PET_MAX_DESC, false, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	checkbox("iconNewToy", L.SETTINGS_ICON_NEW_TOY, L.SETTINGS_ICON_NEW_TOY_DESC, true, function() app:SettingsChanged() end)

	checkbox("iconNewRecipe", L.SETTINGS_ICON_NEW_RECIPE, L.SETTINGS_ICON_NEW_RECIPE_DESC, true, function() app:SettingsChanged() end)

	local parentSetting, parentCheckbox = checkbox("iconNewDecor", L.SETTINGS_ICON_NEW_DECOR, L.SETTINGS_ICON_NEW_DECOR_DESC, true, function() app:SettingsChanged() end)

	checkbox("iconNewDecorXP", L.SETTINGS_ICON_NEW_DECORXP, L.SETTINGS_ICON_NEW_DECORXP_DESC, false, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	header(L.SETTINGS_HEADER_OTHER_INFO)

	checkbox("iconQuestGold", L.SETTINGS_ICON_QUEST_GOLD, L.SETTINGS_ICON_QUEST_GOLD_DESC, true)

	checkbox("iconUsable", L.SETTINGS_ICON_USABLE, L.SETTINGS_ICON_USABLE_DESC, true)

	checkbox("iconContainer", L.SETTINGS_ICON_OPENABLE, L.SETTINGS_ICON_OPENABLE_DESC, true)

	category, layout = Settings.RegisterVerticalLayoutSubcategory(app.SettingsCategory, L.SETTINGS_HEADER_LOOT_TRACKER)
	Settings.RegisterAddOnCategory(category)

	checkbox("minimapIcon", L.SETTINGS_MINIMAP_TITLE, L.SETTINGS_MINIMAP_DESC, true, function() app:ToggleMinimapIcon() end)

	checkbox("autoOpen", L.SETTINGS_AUTO_OPEN, L.SETTINGS_AUTO_OPEN_DESC, false)

	dropdown("collectMode", L.SETTINGS_COLLECTION_MODE, L.SETTINGS_COLLECTION_MODE_DESC, 1, {
		{ value = 1, name = L.SETTINGS_MODE_APPEARANCES, description = L.SETTINGS_MODE_APPEARANCES_DESC },
		{ value = 2, name = L.SETTINGS_MODE_SOURCES, description = L.SETTINGS_MODE_SOURCES_DESC },
	})

	dropdown("rarity", L.SETTINGS_RARITY, L.SETTINGS_RARITY_DESC, 3, {
		{ value = 0, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(0).r * 255, C_ColorOverrides.GetColorForQuality(0).g * 255, C_ColorOverrides.GetColorForQuality(0).b * 255) .. ITEM_QUALITY0_DESC .. "|r", description = nil },
		{ value = 1, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(1).r * 255, C_ColorOverrides.GetColorForQuality(1).g * 255, C_ColorOverrides.GetColorForQuality(1).b * 255) .. ITEM_QUALITY1_DESC .. "|r", description = nil },
		{ value = 2, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(2).r * 255, C_ColorOverrides.GetColorForQuality(2).g * 255, C_ColorOverrides.GetColorForQuality(2).b * 255) .. ITEM_QUALITY2_DESC .. "|r", description = nil },
		{ value = 3, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(3).r * 255, C_ColorOverrides.GetColorForQuality(3).g * 255, C_ColorOverrides.GetColorForQuality(3).b * 255) .. ITEM_QUALITY3_DESC .. "|r", description = nil },
		{ value = 4, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(4).r * 255, C_ColorOverrides.GetColorForQuality(4).g * 255, C_ColorOverrides.GetColorForQuality(4).b * 255) .. ITEM_QUALITY4_DESC .. "|r", description = nil },
	})

	button(L.SETTINGS_WHISPER, L.SETTINGS_WHISPER_CUSTOMIZE, L.SETTINGS_WHISPER_CUSTOMIZE_DESC, function() app.RenamePopup:Show() end)

	category, layout = Settings.RegisterVerticalLayoutSubcategory(app.SettingsCategory, L.SETTINGS_HEADER_TWEAKS)
	Settings.RegisterAddOnCategory(category)

	local parentSetting, parentCheckbox = checkbox("instantCatalyst", L.SETTINGS_CATALYST, L.SETTINGS_CATALYST_DESC, true)

	checkbox("instantCatalystTooltip", L.SETTINGS_INSTANT_TOOLTIP,L.SETTINGS_INSTANT_TOOLTIP_DESC, true, nil, parentSetting, parentCheckbox)

	local parentSetting, parentCheckbox = checkbox("instantVault", L.SETTINGS_VAULT, L.SETTINGS_VAULT_DESC, true)

	checkbox("instantVaultTooltip", L.SETTINGS_INSTANT_TOOLTIP,L.SETTINGS_INSTANT_TOOLTIP_DESC, true, nil, parentSetting, parentCheckbox)

	checkbox("vendorAll", L.SETTINGS_VENDOR_ALL, L.SETTINGS_VENDOR_ALL_DESC, true)

	checkbox("hideGroupRolls", L.SETTINGS_HIDE_LOOT_ROLL_WINDOW, L.SETTINGS_HIDE_LOOT_ROLL_WINDOW_DESC, false)
end
