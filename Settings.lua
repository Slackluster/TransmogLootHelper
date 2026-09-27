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
		app.Settings.hide = app.Settings.hide or false
		app.Settings.message = app.Settings.message or L.DEFAULT_MESSAGE
		app.Settings.windowPosition = app.Settings.windowPosition or { left = 1295, bottom = 836, width = 200, height = 200, }
		app.Settings.windowLocked = app.Settings.windowLocked or false
		app.Settings.windowSort = app.Settings.windowSort or 1
		app.Settings.seen = app.Settings.seen or {}

		app:CreateMinimapButton()
		app:CreateSettings()
	end
end)

--------------
-- SETTINGS --
--------------

function app:OpenSettings()
	if InCombatLockdown() then
		app:Print(ERR_AFFECTING_COMBAT .. ".")
	else
		Settings.OpenToCategory(app.SettingsCategory:GetID())
	end
end

function app:CreateMinimapButton()
	if app.Forever then return end

	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject(app.NameLong, {
		type = "data source",
		text = app.NameLong,
		icon = app.Icon,

		OnClick = TransmogLootHelper_Click,
		OnEnter = TransmogLootHelper_Enter,
		OnLeave = TransmogLootHelper_Leave,
	})

	app.MinimapIcon = LibStub("LibDBIcon-1.0", true)
	app.MinimapIcon:Register(appName, miniButton, app.Settings)

	function app:ToggleMinimapIcon()
		if app.Settings.minimapIcon then
			app.Settings.hide = false
			app.MinimapIcon:Show(appName)
		else
			app.Settings.hide = true
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
	text:SetPoint("CENTER", app.LinkCopiedFrame, "CENTER")
	text:SetPoint("TOP", app.LinkCopiedFrame, "TOP")
	text:SetJustifyH("CENTER")
	text:SetText(app.IconReady .. " " .. L.LINK_COPIED)

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
		text = L.CTRL_C_COPY,
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

		local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
		close:SetScript("OnClick", function()
			frame:Hide()
		end)

		local string1 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		string1:SetPoint("CENTER", frame, "CENTER")
		string1:SetPoint("TOP", frame, "TOP", 0, -10)
		string1:SetJustifyH("CENTER")
		string1:SetText(L.WHISPER_CUSTOMIZE_DESC2)

		local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
		editBox:SetSize(460, 20)
		editBox:SetPoint("CENTER", frame, "CENTER")
		editBox:SetPoint("TOP", frame, "TOP", 0, -30)
		editBox:SetAutoFocus(false)
		editBox:SetText(app.Settings.message)
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
		string2:SetPoint("CENTER", frame, "CENTER")
		string2:SetPoint("TOP", frame, "TOP", 0, -60)
		string2:SetJustifyH("CENTER")
		string2:SetText("")

		editBox:SetScript("OnEditFocusGained", function(self)
			border:SetBackdropBorderColor(0.25, 0.78, 0.92)
			string2:SetText("")
		end)
		editBox:SetScript("OnEditFocusLost", function(self)
			local newValue = self:GetText()

			if newValue == app.Settings.message then
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

					string2:SetText(app.IconNotReady .. " " .. string.format(L.WHISPER_POPUP_ERROR, "|cff3FC7EB%item|r"))
				else
					border:SetBackdropBorderColor(0, 1, 0)
					C_Timer.After(3, function()
						border:SetBackdropBorderColor(0.25, 0.78, 0.92)
					end)

					string2:SetText(app.IconReady .. " " .. L.WHISPER_POPUP_SUCCESS)

					app.Settings.message = newValue
				end
			end
		end)
		editBox:SetScript("OnEnterPressed", function(self)
			self:ClearFocus()
		end)
		editBox:SetScript("OnEscapePressed", function(self)
			self:SetText(app.Settings.message)
		end)

		app.RenamePopup = frame
	end

	TransmogLootHelper_SettingsTextMixin = {}
	function TransmogLootHelper_SettingsTextMixin:Init(initializer)
		local data = initializer:GetData()
		self.LeftText:SetTextToFit(data.leftText)
		self.MiddleText:SetTextToFit(data.middleText)
		self.RightText:SetTextToFit(data.rightText)

		SettingsPanel.Container.SettingsList.Header.Title:SetText(CreateSimpleTextureMarkup(app.Icon, 16, 16) .. " " .. app.NameLong)
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

	local function addNewTag(initializer)
		initializer.data.newTagID = appName
		app.HasNewFeatures = true
	end

	local function showNewTag(self) -- Thank you, R41Z0R!
		if self.data and self.data.newTagID and self.data.newTagID == appName then
			self.NewFeature:SetShown(true)
		end
	end
	hooksecurefunc(SettingsCheckboxControlMixin, "Init", showNewTag)
	hooksecurefunc(SettingsDropdownControlMixin, "Init", showNewTag)
	hooksecurefunc(SettingsCheckboxDropdownControlMixin, "Init", showNewTag)

	hooksecurefunc(SettingsPanel, "DisplayCategory", function(self, category)
		if category == app.SettingsCategory then
			app.Settings.seen[app.Version] = true
		end
	end)

	local function showNewCategoryTag(self)
		if app.HasNewFeatures and not app.Settings.seen[app.Version] then
			local data = self:GetData()
			if data and data.data and data.data.category and data.data.category.ID == app.SettingsCategory:GetID() then
				self.NewFeature:SetShown(true)
			end
		end
	end
	hooksecurefunc(SettingsCategoryListButtonMixin, "Init", showNewCategoryTag)

	local function button(name, buttonName, description, func)
		layout:AddInitializer(CreateSettingsButtonInitializer(name, buttonName, func, description, true))
	end

	local function checkbox(variable, name, description, default, callback, parentSetting, parentCheckbox, isNew)
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

		if isNew then addNewTag(checkbox) end

		return setting, checkbox
	end

	local function checkboxDropdown(cbVariable, cbName, description, cbDefaultValue, ddVariable, ddDefaultValue, options, callback, isNew)
		local cbSetting = Settings.RegisterAddOnSetting(category, appName .. "_" .. cbVariable, cbVariable, app.Settings, type(cbDefaultValue), cbName, cbDefaultValue)
		local ddSetting = Settings.RegisterAddOnSetting(category, appName .. "_" .. ddVariable, ddVariable, app.Settings, type(ddDefaultValue), "", ddDefaultValue)
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

		if isNew then addNewTag(initializer) end
	end

	local function dropdown(variable, name, description, default, options, callback, isNew)
		local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, app.Settings, type(default), name, default)
		local function GetOptions()
			local container = Settings.CreateControlTextContainer()
			for _, option in ipairs(options) do
				container:Add(option.value, option.name, option.description)
			end
			return container:GetData()
		end

		local initializer = Settings.CreateDropdown(category, setting, GetOptions, description)

		if callback then
			setting:SetValueChangedCallback(callback)
		end

		if isNew then addNewTag(initializer) end
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
				local btn = self["ItemButton" .. i]
				btn.Icon:SetTexture(item.icon)
				btn.Name:SetText(item.name)

				if not btn.TLHOverlay then
					btn.TLHOverlay = CreateFrame("Frame", nil, btn)
					btn.TLHOverlay:SetAllPoints(btn.Icon)
				end
				app:ApplyItemOverlay(btn.TLHOverlay, "item:" .. i)
				app.PreviewItem[i].frame = btn.TLHOverlay

				btn:SetScript("OnEnter", function()
					GameTooltip:SetOwner(btn, "ANCHOR_BOTTOM")
					GameTooltip:SetText(L.PREVIEW_TOOLTIP[i], nil, nil, nil, nil, true)
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
		{ icon = 345787, name = L.PREVIEW .. "\n" .. L.UNLEARNED },
		{ icon = 135349, name = L.PREVIEW .. "\n" .. L.USABLE },
		{ icon = 134940, name = L.PREVIEW .. "\n" .. L.LEARNED },
		{ icon = 134344, name = L.PREVIEW .. "\n" .. L.UNUSABLE },
	}

	local function itemPreview()
		local initializer = Settings.CreateElementInitializer("TransmogLootHelper_SettingsItemRow", app.PreviewItem)
		layout:AddInitializer(initializer)
	end

	function app:SettingsChanged()
		if C_AddOns.IsAddOnLoaded("Baganator") then
			Baganator.API.RequestItemButtonsRefresh()
		end
		if C_AddOns.IsAddOnLoaded("Bagforge") and Bagforge.API then
			Bagforge.API:RequestItemButtonsRefresh()
		end
	end

	function app:UpdatePreviewItems()
		for i = 1, 4 do
			app:ApplyItemOverlay(app.PreviewItem[i].frame, "item:" .. i)
		end
		app:SettingsChanged()
	end

	-- Settings
	category, layout = Settings.RegisterVerticalLayoutCategory(app.Name)
	Settings.RegisterAddOnCategory(category)
	app.SettingsCategory = category

	text(L.VERSION .. " |cffFFFFFF" .. app.Version, nil, nil, 14)
	text(L.SUPPORT_TEXTLONG1 .. "\n" .. L.SUPPORT_TEXTLONG2)
	button(L.SUPPORT, L.BUY_ME_A_COFFEE, L.THANK_YOU, function() StaticPopup_Show("TRANSMOGLOOTHELPER_URL", nil, nil, "https://buymeacoffee.com/Slackluster") end)
	button(L.FEEDBACK_AND_HELP, L.DISCORD, L.JOIN_DISCORD_SERVER, function() StaticPopup_Show("TRANSMOGLOOTHELPER_URL", nil, nil, "https://discord.gg/hGvF59hstx") end)

	local _, isExpanded = expandableHeader(L.KEYBINDINGS_AND_SLASH_COMMANDS, true)

		if app.Retail then

		keybind("TLH_TOGGLEWINDOW", isExpanded)

		end

		local leftText, middleText
		if app.Retail then
			leftText = { "|cffFFFFFF" ..
				"/tlh",
				"/tlh resetpos",
				"/tlh settings",
				"/tlh delete " .. app:Colour(L.CHARACTER_REALM),
				"/tlh msg ",
				"/tlh default " }
			middleText = {
				L.TOGGLE_TRACKING_WINDOW,
				L.RESET_WINDOW_POSITION,
				L.OPEN_SETTINGS,
				L.DELETE_CHAR_RECIPES,
				L.WHISPER_CUSTOMIZE_DESC1,
				L.WHISPER_SET_DEFAULT }
		elseif app.Forever then
			leftText = { "|cffFFFFFF" ..
				"/tlh",
				"/tlh delete " .. app:Colour(L.CHARACTER_REALM) }
			middleText = {
				L.OPEN_SETTINGS,
				L.DELETE_CHAR_RECIPES }
		end
		leftText = table.concat(leftText, "\n\n")
		middleText = table.concat(middleText, "\n\n")
		text(leftText, middleText, nil, nil, isExpanded)

	header(L.GENERAL)

	checkbox("overlay", L.ITEM_OVERLAY, L.ITEM_OVERLAY_DESC .. "\n\n|cffFF0000" .. L.REQUIRES_RELOAD, true, function()
		app:SettingsChanged()
	end)

	dropdown("iconPosition", L.ICON_POSITION, L.ICON_POSITION_DESC .. "\n\n" .. L.BAGANATOR_SETTINGS, 1, {
		{ value = 0, name = L.TOP_LEFT, description = L.OVERLAP_ISSUES_QUALITY },
		{ value = 1, name = L.TOP_RIGHT, description = L.OVERLAP_ISSUES_NONE },
		{ value = 2, name = L.BOTTOM_LEFT, description = L.OVERLAP_ISSUES_NONE },
		{ value = 3, name = L.BOTTOM_RIGHT, description = L.OVERLAP_ISSUES_NONE },
	}, function() app:UpdatePreviewItems() end)

	dropdown("iconStyle", L.ICON_STYLE, L.ICON_STYLE_DESC, 1, {
		{ value = 1, name = L.ICON_STYLE_FANCYCIRCLE, description = L.ICON_STYLE_FANCYCIRCLE_DESC },
		{ value = 2, name = L.ICON_STYLE_SIMPLECIRCLE, description = L.ICON_STYLE_SIMPLECIRCLE_DESC },
		{ value = 3, name = L.ICON_STYLE_SIMPLEICON, description = L.ICON_STYLE_SIMPLEICON_DESC },
		{ value = 4, name = L.ICON_STYLE_COSMETICICON, description = L.ICON_STYLE_COSMETICICON_DESC },
	}, function() app:UpdatePreviewItems() end)

	checkbox("animateIcon", L.ICON_ANIMATION, L.ICON_ANIMATION_DESC, true, function() app:UpdatePreviewItems() end)

	checkboxDropdown("iconLearned", L.ICON_LEARNED, L.ICON_LEARNED_DESC, true, "learnedStyle", 0, {
		{ value = 0, name = L.DEFAULT, description = L.ICON_LEARNED_DESC2 },
		{ value = 1, name = L.ICON_STYLE_FANCYCIRCLE, description = L.ICON_STYLE_FANCYCIRCLE_DESC },
		{ value = 2, name = L.ICON_STYLE_SIMPLECIRCLE, description = L.ICON_STYLE_SIMPLECIRCLE_DESC },
		{ value = 3, name = L.ICON_STYLE_SIMPLEICON, description = L.ICON_STYLE_SIMPLEICON_DESC },
		{ value = 4, name = L.ICON_STYLE_COSMETICICON, description = L.ICON_STYLE_COSMETICICON_DESC },
	}, function() app:UpdatePreviewItems() end)

	checkbox("textBind", L.BINDING_TEXT, L.BINDING_TEXT_DESC .. "\n\n" .. L.BAGANATOR_SETTINGS, true, function() app:UpdatePreviewItems() end)

	itemPreview()

	header(L.COLLECTION_INFO)

	local parentSetting, parentCheckbox = checkbox("iconNewMog", L.APPEARANCES, L.APPEARANCES_ICON_DESC, true, function() app:SettingsChanged() end)

	checkbox("iconNewSource", L.APPEARANCE_SOURCES, L.APPEARANCE_SOURCES_ICON_DESC, false, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	if app.Retail then

	checkbox("iconNewCatalyst", L.CATALYST, L.CATALYST_ICON_DESC, true, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	checkbox("iconNewUpgrade", L.UPGRADE, L.UPGRADE_ICON_DESC, true, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	checkbox("iconNewIllusion", L.ILLUSIONS, L.ILLUSIONS_ICON_DESC, true, function() app:SettingsChanged() end)

	end

	checkbox("iconNewMount", L.MOUNTS, L.MOUNTS_ICON_DESC, true, function() app:SettingsChanged() end)

	local parentSetting, parentCheckbox = checkbox("iconNewPet", L.PETS, L.PETS_ICON_DESC, true, function() app:SettingsChanged() end)

	if app.Retail then

	checkbox("iconNewPetMax", L.PETS_COLLECT_MAX, L.SETTINGS_ICON_NEW_PET_MAX_DESC, false, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	checkbox("iconNewToy", L.TOYS, L.TOYS_ICON_DESC, true, function() app:SettingsChanged() end)

	end

	local parentSetting, parentCheckbox = checkbox("iconNewRecipe", L.RECIPES, L.RECIPES_ICON_DESC, true, function() app:SettingsChanged() end)

	checkbox("recipesPerChar", L.TRACK_PER_CHARACTER, L.TRACK_PER_CHARACTER_ICON_DESC, false, function() app:SettingsChanged() end, parentSetting, parentCheckbox, true)

	if app.Retail then

	local parentSetting, parentCheckbox = checkbox("iconNewDecor", L.DECOR, L.DECOR_ICON_DESC, true, function() app:SettingsChanged() end)

	checkbox("iconNewDecorXP", L.ONLY_HOUSE_XP, L.ONLY_HOUSE_XP_ICON_DESC, false, function() app:SettingsChanged() end, parentSetting, parentCheckbox)

	end

	header(L.OTHER_INFORMATION)

	checkbox("iconQuestGold", L.QUEST_REWARD_SELL_VALUE, L.QUEST_REWARD_SELL_VALUE_ICON_DESC, true)

	checkbox("iconUsable", L.USABLE_ITEMS, L.SETTINGS_ICON_USABLE_DESC, true)

	checkbox("iconContainer", L.CONTAINERS, L.CONTAINERS_ICON_DESC, true)

	if app.Retail then

	category, layout = Settings.RegisterVerticalLayoutSubcategory(app.SettingsCategory, L.LOOT_TRACKER)
	Settings.RegisterAddOnCategory(category)

	checkbox("minimapIcon", L.SHOW_MINIMAP_ICON, string.format(L.SHOW_MINIMAP_ICON_DESC, app.NameShort), true, function() app:ToggleMinimapIcon() end)

	checkbox("autoOpen", L.AUTO_OPEN_WINDOW, string.format(L.AUTO_OPEN_WINDOW_DESC, app.NameShort), false)

	dropdown("collectMode", L.COLLECTION_MODE, string.format(L.COLLECTION_MODE_DESC, app.NameShort), 1, {
		{ value = 1, name = L.APPEARANCES, description = L.COLLECTION_MODE_APPEARANCES_DESC },
		{ value = 2, name = L.APPEARANCE_SOURCES, description = L.COLLECTION_MODE_SOURCES_DESC },
	})

	dropdown("rarity", L.RARITY, string.format(L.RARITY_SETTING_DESC, app.NameShort), 3, {
		{ value = 0, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(0).r * 255, C_ColorOverrides.GetColorForQuality(0).g * 255, C_ColorOverrides.GetColorForQuality(0).b * 255) .. ITEM_QUALITY0_DESC .. "|r", description = nil },
		{ value = 1, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(1).r * 255, C_ColorOverrides.GetColorForQuality(1).g * 255, C_ColorOverrides.GetColorForQuality(1).b * 255) .. ITEM_QUALITY1_DESC .. "|r", description = nil },
		{ value = 2, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(2).r * 255, C_ColorOverrides.GetColorForQuality(2).g * 255, C_ColorOverrides.GetColorForQuality(2).b * 255) .. ITEM_QUALITY2_DESC .. "|r", description = nil },
		{ value = 3, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(3).r * 255, C_ColorOverrides.GetColorForQuality(3).g * 255, C_ColorOverrides.GetColorForQuality(3).b * 255) .. ITEM_QUALITY3_DESC .. "|r", description = nil },
		{ value = 4, name = "|cff" .. string.format("%02x%02x%02x", C_ColorOverrides.GetColorForQuality(4).r * 255, C_ColorOverrides.GetColorForQuality(4).g * 255, C_ColorOverrides.GetColorForQuality(4).b * 255) .. ITEM_QUALITY4_DESC .. "|r", description = nil },
	})

	button(L.WHISPER_MESSAGE, L.CUSTOMIZE, L.WHISPER_CUSTOMIZE_DESC1, function() app.RenamePopup:Show() end)

	category, layout = Settings.RegisterVerticalLayoutSubcategory(app.SettingsCategory, L.TWEAKS)
	Settings.RegisterAddOnCategory(category)

	local parentSetting, parentCheckbox = checkbox("instantCatalyst", L.INSTANT_CATALYST, L.INSTANT_CATALYST_DESC, true)

	checkbox("instantCatalystTooltip", L.SHOW_TOOLTIP,L.SETTINGS_INSTANT_TOOLTIP_DESC, true, nil, parentSetting, parentCheckbox)

	local parentSetting, parentCheckbox = checkbox("instantVault", L.INSTANT_VAULT, L.INSTANT_VAULT_DESC, true)

	checkbox("instantVaultTooltip", L.SHOW_TOOLTIP,L.SETTINGS_INSTANT_TOOLTIP_DESC, true, nil, parentSetting, parentCheckbox)

	checkbox("vendorAll", L.DISABLE_VENDOR_FILTER, L.DISABLE_VENDOR_FILTER_DESC, true)

	checkbox("hideGroupRolls", L.HIDE_LOOT_ROLL_WINDOW, string.format(L.HIDE_LOOT_ROLL_WINDOW_DESC, "|cff00CCFF/loot|r"), false)

	end
end
