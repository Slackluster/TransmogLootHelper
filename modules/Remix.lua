-------------------------------------
-- Transmog Loot Helper: Remix.lua --
-------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales
local api = app.api

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not TransmogLootHelper_Cache.Lemix then
			TransmogLootHelper_Cache.Lemix = {}
			for i, raid in ipairs(app.LemixRaidLoot) do
				for i2, cat in ipairs(raid.categories) do
					for _, itemID in pairs(cat.items) do
						TransmogLootHelper_Cache.Lemix[itemID] = { converted = false, owned = false, characters = {} }
					end
				end
			end
			TransmogLootHelper_Cache.LemixCharacters = {}
			TransmogLootHelper_Cache.LemixCharacters["FirstLemixLoad"] = true
		end
		if not TransmogLootHelper_Settings["remixWindowFilter"] then TransmogLootHelper_Settings["remixWindowFilter"] = 0 end

		app.CreateRemixWindow()
		app.RemixTooltipInfo()
	end
end)

------------
-- WINDOW --
------------

function app.RemixGetItems()
	app.CharacterName = UnitName("player") .. "-" .. GetNormalizedRealmName()
	if not TransmogLootHelper_Cache.LemixCharacters[app.CharacterName] then
		local _, className = UnitClass("player")
		TransmogLootHelper_Cache.LemixCharacters[app.CharacterName] = C_ClassColor.GetClassColor(className):GenerateHexColor()
	end

	for itemID, itemInfo in pairs(TransmogLootHelper_Cache.Lemix) do
		if itemID == 247036 then
			if C_TransmogCollection.PlayerHasTransmog(itemID, 3) and C_TransmogCollection.PlayerHasTransmog(itemID, 4) and C_TransmogCollection.PlayerHasTransmog(itemID, 5) and C_TransmogCollection.PlayerHasTransmog(itemID, 6) then
				itemInfo.converted = true
			end
		elseif C_TransmogCollection.PlayerHasTransmog(itemID, 4) then
			itemInfo.converted = true
		end

		if not itemInfo.converted then
			local owned = C_Item.GetItemCount(itemID, true, false, false, false)
			if owned > 1 then
				itemInfo.characters[app.CharacterName] = true
			elseif owned == 1 then
				if C_Item.IsEquippedItem(itemID) then
					itemInfo.characters[app.CharacterName] = "equipped"
				else
					itemInfo.characters[app.CharacterName] = true
				end
			else
				itemInfo.characters[app.CharacterName] = nil
			end

			local next = next
			if not itemInfo.owned and next(itemInfo.characters) ~= nil then
				itemInfo.owned = true
			elseif itemInfo.owned and next(itemInfo.characters) == nil then
				itemInfo.owned = false
			end
		end
	end
end

function app.MoveRemixWindow()
	if TransmogLootHelper_Settings["remixWindowLocked"] then
		app.RemixUnlockButton:LockHighlight()
	else
		app.RemixWindow:StartMoving()
		GameTooltip:ClearLines()
		GameTooltip:Hide()
	end
end

function app.SaveRemixWindow()
	app.RemixUnlockButton:UnlockHighlight()
	app.RemixWindow:StopMovingOrSizing()

	local left = app.RemixWindow:GetLeft()
	local bottom = app.RemixWindow:GetBottom()
	local width, height = app.RemixWindow:GetSize()
	TransmogLootHelper_Settings["remixWindowPosition"] = { ["left"] = left, ["bottom"] = bottom, ["width"] = width, ["height"] = height, }
end

function app.RemixShow()
	app.RemixWindow:ClearAllPoints()
	app.RemixWindow:SetSize(TransmogLootHelper_Settings["remixWindowPosition"].width, TransmogLootHelper_Settings["remixWindowPosition"].height)
	app.RemixWindow:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", TransmogLootHelper_Settings["remixWindowPosition"].left, TransmogLootHelper_Settings["remixWindowPosition"].bottom)

	app.RemixGetItems()
	app.UpdateRemixWindow()
	app.RemixWindow:Show()
end

function app.RemixToggle()
	if app.RemixWindow:IsShown() then
		app.RemixWindow:Hide()
	else
		app.RemixShow()
	end
end

function app.RemixWindowTooltipShow(frame)
	if GetScreenWidth()/2-TransmogLootHelper_Settings["remixWindowPosition"].width/2-app.RemixWindow:GetLeft() >= 0 then
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", app.RemixWindow, "RIGHT", 0, 0)
	else
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", app.RemixWindow, "LEFT", 0, 0)
	end
	frame:Show()
end

function app.RemixWindowTooltip(text)
	local frame = CreateFrame("Frame", nil, app.RemixWindow, "BackdropTemplate")
	frame:SetFrameStrata("TOOLTIP")
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	frame:SetBackdropColor(0, 0, 0, 0.9)
	frame:EnableMouse(false)
	frame:SetMovable(false)
	frame:Hide()

	local string = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	string:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
	string:SetJustifyH("LEFT")
	string:SetText(text)

	frame:SetHeight(string:GetStringHeight()+20)
	frame:SetWidth(string:GetStringWidth()+20)

	return frame
end

function app.CreateRemixWindow()
	app.RemixWindow = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	app.RemixWindow:SetPoint("CENTER")
	app.RemixWindow:SetSize(300, 300)
	app.RemixWindow:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	app.RemixWindow:SetBackdropColor(0, 0, 0, 1)
	app.RemixWindow:SetBackdropBorderColor(0.776, 0.608, 0.427)
	app.RemixWindow:EnableMouse(true)
	app.RemixWindow:SetMovable(true)
	app.RemixWindow:SetClampedToScreen(true)
	app.RemixWindow:SetResizable(true)
	app.RemixWindow:SetResizeBounds(140, 140, 600, 600)
	app.RemixWindow:RegisterForDrag("LeftButton")
	app.RemixWindow:SetScript("OnDragStart", function() app.MoveRemixWindow() end)
	app.RemixWindow:SetScript("OnDragStop", function() app.SaveRemixWindow() end)
	app.RemixWindow:Hide()

	local corner = CreateFrame("Button", nil, app.RemixWindow)
	corner:EnableMouse("true")
	corner:SetPoint("BOTTOMRIGHT")
	corner:SetSize(16,16)
	corner:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	corner:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	corner:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	corner:SetScript("OnMouseDown", function()
		app.RemixWindow:StartSizing("BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:Hide()
	end)
	corner:SetScript("OnMouseUp", function() app.SaveRemixWindow() end)
	app.RemixWindow.Corner = corner

	local close = CreateFrame("Button", "", app.RemixWindow, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", app.RemixWindow, "TOPRIGHT", 2, 2)
	close:SetScript("OnClick", function()
		app.RemixWindow:Hide()
	end)
	close:SetScript("OnEnter", function()
		app.RemixWindowTooltipShow(app.CloseButtonTooltip)
	end)
	close:SetScript("OnLeave", function()
		app.CloseButtonTooltip:Hide()
	end)

	app.RemixLockButton = CreateFrame("Button", "", app.RemixWindow, "UIPanelCloseButton")
	app.RemixLockButton:SetPoint("TOPRIGHT", close, "TOPLEFT", -2, 0)
	app.RemixLockButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixLockButton:GetNormalTexture():SetTexCoord(183/256, 219/256, 1/128, 39/128)
	app.RemixLockButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixLockButton:GetDisabledTexture():SetTexCoord(183/256, 219/256, 41/128, 79/128)
	app.RemixLockButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixLockButton:GetPushedTexture():SetTexCoord(183/256, 219/256, 81/128, 119/128)
	app.RemixLockButton:SetScript("OnClick", function()
		TransmogLootHelper_Settings["remixWindowLocked"] = true
		app.RemixWindow.Corner:Hide()
		app.RemixLockButton:Hide()
		app.RemixUnlockButton:Show()
	end)
	app.RemixLockButton:SetScript("OnEnter", function()
		app.RemixWindowTooltipShow(app.LockButtonTooltip)
	end)
	app.RemixLockButton:SetScript("OnLeave", function()
		app.LockButtonTooltip:Hide()
	end)

	app.RemixUnlockButton = CreateFrame("Button", "", app.RemixWindow, "UIPanelCloseButton")
	app.RemixUnlockButton:SetPoint("TOPRIGHT", close, "TOPLEFT", -2, 0)
	app.RemixUnlockButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixUnlockButton:GetNormalTexture():SetTexCoord(148/256, 184/256, 1/128, 39/128)
	app.RemixUnlockButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixUnlockButton:GetDisabledTexture():SetTexCoord(148/256, 184/256, 41/128, 79/128)
	app.RemixUnlockButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixUnlockButton:GetPushedTexture():SetTexCoord(148/256, 184/256, 81/128, 119/128)
	app.RemixUnlockButton:SetScript("OnClick", function()
		TransmogLootHelper_Settings["remixWindowLocked"] = false
		app.RemixWindow.Corner:Show()
		app.RemixLockButton:Show()
		app.RemixUnlockButton:Hide()
	end)
	app.RemixUnlockButton:SetScript("OnEnter", function()
		app.RemixWindowTooltipShow(app.UnlockButtonTooltip)
	end)
	app.RemixUnlockButton:SetScript("OnLeave", function()
		app.UnlockButtonTooltip:Hide()
	end)

	if TransmogLootHelper_Settings["remixWindowLocked"] then
		app.RemixWindow.Corner:Hide()
		app.RemixLockButton:Hide()
		app.RemixUnlockButton:Show()
	else
		app.RemixWindow.Corner:Show()
		app.RemixLockButton:Show()
		app.RemixUnlockButton:Hide()
	end

	app.RemixFilterButton = CreateFrame("Button", "", app.RemixWindow, "UIPanelCloseButton")
	app.RemixFilterButton:SetPoint("TOPRIGHT", app.RemixLockButton, "TOPLEFT", -2, 0)
	app.RemixFilterButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixFilterButton:GetNormalTexture():SetTexCoord(76/256, 112/256, 1/128, 39/128)
	app.RemixFilterButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixFilterButton:GetDisabledTexture():SetTexCoord(76/256, 112/256, 41/128, 79/128)
	app.RemixFilterButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixFilterButton:GetPushedTexture():SetTexCoord(76/256, 112/256, 81/128, 119/128)
	app.RemixFilterButton:SetScript("OnClick", function()
		if TransmogLootHelper_Settings["remixWindowFilter"] == 0 then
			TransmogLootHelper_Settings["remixWindowFilter"] = 1
			app.FilterButtonTooltip:Hide()
			app.FilterButtonTooltip = app.RemixWindowTooltip("Hide owned items\nCurrent filter:|cffFFFFFF Hide converted items|R")
			app.RemixWindowTooltipShow(app.FilterButtonTooltip)
		elseif TransmogLootHelper_Settings["remixWindowFilter"] == 1 then
			TransmogLootHelper_Settings["remixWindowFilter"] = 2
			app.FilterButtonTooltip:Hide()
			app.FilterButtonTooltip = app.RemixWindowTooltip("Show all items\nCurrent filter:|cffFFFFFF Hide owned items|R")
			app.RemixWindowTooltipShow(app.FilterButtonTooltip)
		elseif TransmogLootHelper_Settings["remixWindowFilter"] == 2 then
			TransmogLootHelper_Settings["remixWindowFilter"] = 0
			app.FilterButtonTooltip:Hide()
			app.FilterButtonTooltip = app.RemixWindowTooltip("Hide converted items\nCurrent filter:|cffFFFFFF Show all items|R")
			app.RemixWindowTooltipShow(app.FilterButtonTooltip)
		end
		app.UpdateRemixWindow()
	end)
	app.RemixFilterButton:SetScript("OnEnter", function()
		app.RemixWindowTooltipShow(app.FilterButtonTooltip)
	end)
	app.RemixFilterButton:SetScript("OnLeave", function()
		app.FilterButtonTooltip:Hide()
	end)

	app.RemixSettingsButton = CreateFrame("Button", "", app.RemixWindow, "UIPanelCloseButton")
	app.RemixSettingsButton:SetPoint("TOPRIGHT", app.RemixFilterButton, "TOPLEFT", -2, 0)
	app.RemixSettingsButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixSettingsButton:GetNormalTexture():SetTexCoord(112/256, 148/256, 1/128, 39/128)
	app.RemixSettingsButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixSettingsButton:GetDisabledTexture():SetTexCoord(112/256, 148/256, 41/128, 79/128)
	app.RemixSettingsButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.RemixSettingsButton:GetPushedTexture():SetTexCoord(112/256, 148/256, 81/128, 119/128)
	app.RemixSettingsButton:SetScript("OnClick", function()
		app.OpenSettings()
	end)
	app.RemixSettingsButton:SetScript("OnEnter", function()
		app.RemixWindowTooltipShow(app.SettingsButtonTooltip)
	end)
	app.RemixSettingsButton:SetScript("OnLeave", function()
		app.SettingsButtonTooltip:Hide()
	end)

	app.RemixHelpButton = CreateFrame("Button", "", app.RemixWindow, "UIPanelCloseButton")
	app.RemixHelpButton:SetSize(40,40)
	app.RemixHelpButton:SetPoint("TOPRIGHT", app.RemixSettingsButton, "TOPLEFT", 8, 8)
	app.RemixHelpButton:SetNormalTexture("Interface\\Common\\help-i.blp")
	app.RemixHelpButton:SetPushedTexture("Interface\\Common\\help-i.blp")
	app.RemixHelpButton:SetScript("OnMouseDown", function()
		app.RemixHelpButton:SetPoint("TOPRIGHT", app.RemixSettingsButton, "TOPLEFT", 9, 7)
	end)
	app.RemixHelpButton:SetScript("OnMouseUp", function()
		app.RemixHelpButton:SetPoint("TOPRIGHT", app.RemixSettingsButton, "TOPLEFT", 8, 8)
	end)
	app.RemixHelpButton:SetScript("OnClick", function()
		if not StaticPopupDialogs["TRANSMOGLOOTHELPER_LEMIX"] then
			StaticPopupDialogs["TRANSMOGLOOTHELPER_LEMIX"] = {
				text = "Hello Timerunner |c" .. TransmogLootHelper_Cache.LemixCharacters[app.CharacterName] .. UnitName("player") .. "|R!\n\n" .. app.NameLong .. " now lets you track\nwhat raid drops you have collected\nacross your characters.\n\nWhen converting a Timerunner to Retail, any Normal+ raid drop in your |cffFF0000bags and bank only|R will grant the appearances for their\nLFR, N, H, and M difficulty Remix variants.\n\nYou can view this list by clicking the minimap\nor addon compartment button for " .. app.NameShort .. ".",
				button1 = CLOSE,
				whileDead = true,
			}
		end
		StaticPopup_Show("TRANSMOGLOOTHELPER_LEMIX")
	end)
	app.RemixHelpButton:SetScript("OnEnter", function()
		app.RemixWindowTooltipShow(app.SettingsHelpTooltip)
	end)
	app.RemixHelpButton:SetScript("OnLeave", function()
		app.SettingsHelpTooltip:Hide()
	end)

	app.CloseButtonTooltip = app.RemixWindowTooltip(L.WINDOW_BUTTON_CLOSE)
	app.LockButtonTooltip = app.RemixWindowTooltip(L.WINDOW_BUTTON_LOCK)
	app.UnlockButtonTooltip = app.RemixWindowTooltip(L.WINDOW_BUTTON_UNLOCK)
	if TransmogLootHelper_Settings["remixWindowFilter"] == 0 then
		app.FilterButtonTooltip = app.RemixWindowTooltip("Hide converted items\nCurrent filter:|cffFFFFFF Show all items|R")
	elseif TransmogLootHelper_Settings["remixWindowFilter"] == 1 then
		app.FilterButtonTooltip = app.RemixWindowTooltip("Hide owned items\nCurrent filter:|cffFFFFFF Hide converted items|R")
	elseif TransmogLootHelper_Settings["remixWindowFilter"] == 2 then
		app.FilterButtonTooltip = app.RemixWindowTooltip("Show all items\nCurrent filter:|cffFFFFFF Hide owned items|R")
	end
	app.SettingsButtonTooltip = app.RemixWindowTooltip(L.WINDOW_BUTTON_SETTINGS)
	app.SettingsHelpTooltip = app.RemixWindowTooltip(INFO)

	local ScrollBox = CreateFrame("Frame", nil, app.RemixWindow, "WowScrollBoxList")
	ScrollBox:SetPoint("TOPLEFT", app.RemixWindow, "TOPLEFT", 8, -4)
	ScrollBox:SetPoint("BOTTOMRIGHT", app.RemixWindow, "BOTTOMRIGHT", -18, 4)
	ScrollBox:SetScript("OnDragStart", function() app.MoveRemixWindow() end)
	ScrollBox:SetScript("OnDragStop", function() app.SaveRemixWindow() end)
	local ScrollBar = CreateFrame("EventFrame", nil, app.RemixWindow, "MinimalScrollBar")
	ScrollBar:SetPoint("TOPLEFT", ScrollBox, "TOPRIGHT")
	ScrollBar:SetPoint("BOTTOMLEFT", ScrollBox, "BOTTOMRIGHT")
	ScrollBar:SetScript("OnDragStart", function() app.MoveRemixWindow() end)
	ScrollBar:SetScript("OnDragStop", function() app.SaveRemixWindow() end)

	app.ScrollView = CreateScrollBoxListTreeListView()
	ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, app.ScrollView)

	local function Initializer(button, node)
		local data = node:GetData()

		if data.index then
			button.LeftText1:SetText(data.Left1 or "???")
			button.LeftText2:SetText("")
			button.RightText:SetText("")
		elseif data.itemID then
			button.LeftText2:SetText("Retrieving...")
			local item = Item:CreateFromItemID(data.itemID)
			item:ContinueOnItemLoad(function()
				button.LeftText1:SetText("|T" .. C_Item.GetItemIconByID(data.itemID) .. ":16|t")
				button.LeftText2:SetText(("|c" .. data.qualityColor .. "[" .. C_Item.GetItemNameByID(data.itemID) .. "]") or "N/A")
				button.RightText:SetText(data.icon)
			end)
		end

		button:SetScript("OnClick", function()
			node:ToggleCollapsed()
			if data.subindex then
				app.LemixRaidLoot[data.index].categories[data.subindex].collapsed = node:IsCollapsed()
			elseif data.index then
				app.LemixRaidLoot[data.index].collapsed = node:IsCollapsed()
			end
		end)
		button:RegisterForDrag("LeftButton")
		button:SetScript("OnDragStart", function() app.MoveRemixWindow() end)
		button:SetScript("OnDragStop", function() app.SaveRemixWindow() end)
		button:SetScript("OnEnter", function()
			local text = ""
			local notFirst = false
			if TransmogLootHelper_Cache.Lemix[data.itemID] then
				if TransmogLootHelper_Cache.Lemix[data.itemID].converted then
					text = "Item already converted!"
				else
					for character, have in pairs(TransmogLootHelper_Cache.Lemix[data.itemID].characters) do
						if have then
							if notFirst then
								text = text .. "\n"
							end
							text = text .. "|c" .. TransmogLootHelper_Cache.LemixCharacters[character] .. character .. "|R"
							if have == "equipped" then
								text = text .. " |cffce7d1e(equipped)|R"
							end
							notFirst = true
						end
					end
				end
			end
			if text ~= "" then
				app.Players = app.RemixWindowTooltip(text)
				app.RemixWindowTooltipShow(app.Players)
			end
		end)
		button:SetScript("OnLeave", function()
			if app.Players then
				app.Players:Hide()
			end
		end)
	end

	app.ScrollView:SetElementInitializer("TransmogLootHelper_ListButton", Initializer)
end

function app.UpdateRemixWindow()
	app.RemixGetItems()
	local _, _, _, poorQualityColor = C_Item.GetItemQualityColor(0)
	local _, _, _, epicQualityColor = C_Item.GetItemQualityColor(4)

	if not app.LemixRaidLootConverted then
		for _, raid in ipairs(app.LemixRaidLoot) do
			raid.collapsed = false
			raid.total = 0
			for _, cat in ipairs(raid.categories) do
				cat.collapsed = false
				raid.total = raid.total + #cat.items
				for i, itemID in ipairs(cat.items) do
					cat.items[i] = { itemID = itemID, icon = app.IconNotReady, qualityColor = epicQualityColor }
				end
			end
		end
		app.LemixRaidLootConverted = true
	end

	for i, raid in ipairs(app.LemixRaidLoot) do
		raid.owned = 0
		for i2, cat in ipairs(raid.categories) do
			cat.owned = 0
			for _, item in ipairs(cat.items) do
				if TransmogLootHelper_Cache.Lemix[item.itemID] then
					if TransmogLootHelper_Cache.Lemix[item.itemID].converted then
						cat.owned = cat.owned + 1
						item.qualityColor = poorQualityColor
						item.icon = app.IconReady
					elseif TransmogLootHelper_Cache.Lemix[item.itemID].owned then
						cat.owned = cat.owned + 1
						for character, have in pairs(TransmogLootHelper_Cache.Lemix[item.itemID].characters) do
							if have == "equipped" then
								item.icon = "|T"..app.IconMaybeReady..":0|t"
							else
								item.icon = app.IconReady
								break
							end
						end
					end
				end
			end
			raid.owned = raid.owned + cat.owned
		end
	end

	local DataProvider = CreateTreeDataProvider()

	for i, raid in ipairs(app.LemixRaidLoot) do
		local raidNode = DataProvider:Insert({ index = i, Left1 = raid.name .. " (" .. raid.owned .. "/" .. raid.total .. ")" })
		if raid.collapsed then raidNode:ToggleCollapsed() end

		for i2, cat in ipairs(raid.categories) do
			local catNode = raidNode:Insert({ index = i, subindex = i2, Left1 = cat.name .. " (" .. cat.owned .. "/" .. #cat.items .. ")" })
			if cat.collapsed then catNode:ToggleCollapsed() end

			for _, item in ipairs(cat.items) do
				if TransmogLootHelper_Settings["remixWindowFilter"] >= 1 and TransmogLootHelper_Cache.Lemix[item.itemID].converted then
					-- Filter
				elseif TransmogLootHelper_Settings["remixWindowFilter"] == 2 and TransmogLootHelper_Cache.Lemix[item.itemID].owned then
					-- Filter
				else
					catNode:Insert({ itemID = item.itemID, icon = item.icon, qualityColor = item.qualityColor })
				end
			end
		end
	end

	app.ScrollView:SetDataProvider(DataProvider, true)
end

app.LemixRaidLoot = {
	[1] = {
		name = "Emerald Nightmare",
		categories = {
			[1] = { name = "Cloaks", items = { 247560, 247512 } },
			[2] = { name = "Cloth", items = { 247517, 247514, 247513, 247520, 247521, 247507, 247561, 247505, 247515, 247519, 247518, 247509, 247516, 247522 } },
			[3] = { name = "Leather", items = { 247525, 247531, 247511, 247528, 247524, 247562, 247533, 247523, 247530, 247532, 247529, 247534, 247527, 247526, 247535 } },
			[4] = { name = "Mail", items = { 247544, 247537, 247541, 247564, 247538, 247506, 247536, 247504, 247547, 247542, 247546, 247545, 247540, 247543, 247036 } },
			[5] = { name = "Plate", items = { 247555, 247510, 247552, 247549, 247508, 247548, 247556, 247557, 247550, 247554, 247565, 247558, 247553, 247551, 247559 } },
		},
	},
	[2] = {
		name = "Trial of Valor",
		categories = {
			[1] = { name = "Cloaks", items = { 247591, 247592, 247568 } },
			[2] = { name = "Cloth", items = { 247567, 247571, 249684, 247569, 249685, 247584, 247566, 247570 } },
			[3] = { name = "Leather", items = { 247585, 247587, 247573, 249683, 247575, 247572, 247574, 249682 } },
			[4] = { name = "Mail", items = { 247576, 247579, 247588, 247589, 247577, 249680, 247578, 249681 } },
			[5] = { name = "Plate", items = { 247583, 247586, 247581, 249678, 247580, 247582, 247590, 249679 } },
		},
	},
	[3] = {
		name = "The Nighthold",
		categories = {
			[1] = { name = "Cloaks", items = { 247489, 247481, 247482, 247491, 247436, 247492, 247490 } },
			[2] = { name = "Cloth", items = { 247430, 247431, 247493, 247467, 247486, 247435, 247465, 247466 } },
			[3] = { name = "Leather", items = { 247469, 247438, 247439, 247441, 247488, 247440, 247494, 247437 } },
			[4] = { name = "Mail", items = { 247470, 247448, 247447, 247453, 247456, 247454, 247495 } },
			[5] = { name = "Plate", items = { 247458, 247473, 247460, 247496, 247472, 247477, 247475, 247464, 247471, 247484 } },
		},
	},
	[4] = {
		name = "Tomb of Sargeras",
		categories = {
			[1] = { name = "Cloth", items = { 247617, 247596, 247594, 247599, 247598, 247618, 247595, 247597 } },
			[2] = { name = "Leather", items = { 247605, 247602, 247620, 247603, 247601, 247600, 247604, 247619, 247616 } },
			[3] = { name = "Mail", items = { 247608, 247606, 247610, 247622, 247607, 247621, 247609 } },
			[4] = { name = "Plate", items = { 247615, 247624, 247611, 247613, 247614, 247623, 247612 } },
		},
	},
	[5] = {
		name = "Antorus, the Burning Throne",
		categories = {
			[1] = { name = "Cloth", items = { 247632, 247627, 247630, 247629, 247628, 247631, 247626, 247625 } },
			[2] = { name = "Leather", items = { 247637, 247654, 247635, 247653, 247638, 247633, 247636, 247634 } },
			[3] = { name = "Mail", items = { 247639, 247641, 247656, 247640, 247643, 247642, 247651, 247655 } },
			[4] = { name = "Plate", items = { 247645, 247644, 247646, 247648, 247649, 247647, 247650, 247652 } },
		},
	},
}

app.Event:Register("PLAYER_ENTERING_WORLD", function()
	if TransmogLootHelper_Cache.LemixCharacters["FirstLemixLoad"] and PlayerGetTimerunningSeasonID() == 2 then
		TransmogLootHelper_Cache.LemixCharacters["FirstLemixLoad"] = nil
		app.RemixShow()
		StaticPopupDialogs["TRANSMOGLOOTHELPER_LEMIX"] = {
			text = "Hello Timerunner |c" .. TransmogLootHelper_Cache.LemixCharacters[app.CharacterName] .. UnitName("player") .. "|R!\n\n" .. app.NameLong .. " now lets you track\nwhat raid drops you have collected\nacross your characters.\n\nWhen converting a Timerunner to Retail, any Normal+ raid drop in your |cffFF0000bags and bank only|R will grant the appearances for their\nLFR, N, H, and M difficulty Remix variants.\n\nYou can view this list by clicking the minimap\nor addon compartment button for " .. app.NameShort .. ".",
			button1 = CLOSE,
			whileDead = true,
		}
		StaticPopup_Show("TRANSMOGLOOTHELPER_LEMIX")
	end
end)

app.Event:Register("BAG_UPDATE_DELAYED", function()
	app.RemixGetItems()
	if app.RemixWindow:IsShown() then
		app.UpdateRemixWindow()
	end
end)

app.Event:Register("CHAT_MSG_LOOT", function(text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
	local itemString = string.match(text, "(|cnIQ.-|h%[.-%]|h)")
	if itemString and guid ~= nil then
		app.CharacterName = UnitName("player") .. "-" .. GetNormalizedRealmName()
		if app.CharacterName == playerName then
			local itemID = C_Item.GetItemInfoInstant(itemString)
			if itemID and TransmogLootHelper_Cache.Lemix[itemID] then
				TransmogLootHelper_Cache.Lemix[itemID].characters[app.CharacterName] = true
			end
		end
	end
end)

function app.RemixTooltipInfo()
	local function OnTooltipSetItem(tooltip)
		if PlayerGetTimerunningSeasonID() == 2 then
			local itemLink, itemID, secondaryItemLink, secondaryItemID
			local _, primaryItemLink, primaryItemID = TooltipUtil.GetDisplayedItem(GameTooltip)
			if tooltip.GetItem then _, secondaryItemLink, secondaryItemID = tooltip:GetItem() end

			-- Get our most accurate itemLink and itemID
			itemID = primaryItemID or secondaryItemID
			if itemID and TransmogLootHelper_Cache.Lemix[itemID] and not TransmogLootHelper_Cache.Lemix[itemID].converted then
				tooltip:AddLine(" ")
				tooltip:AddLine(app.IconTLH .. " This item can be converted.")
			end
		end
	end
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
end
