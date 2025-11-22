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
			TransmogLootHelper_Cache.Lemix = {
				[247560] = { converted = false, characters = {}, },
				[247512] = { converted = false, characters = {}, },

				[247517] = { converted = false, characters = {}, },
				[247514] = { converted = false, characters = {}, },
				[247513] = { converted = false, characters = {}, },
				[247520] = { converted = false, characters = {}, },
				[247521] = { converted = false, characters = {}, },
				[247507] = { converted = false, characters = {}, },
				[247561] = { converted = false, characters = {}, },
				[247505] = { converted = false, characters = {}, },
				[247515] = { converted = false, characters = {}, },
				[247519] = { converted = false, characters = {}, },
				[247518] = { converted = false, characters = {}, },
				[247509] = { converted = false, characters = {}, },
				[247516] = { converted = false, characters = {}, },
				[247522] = { converted = false, characters = {}, },

				[247525] = { converted = false, characters = {}, },
				[247531] = { converted = false, characters = {}, },
				[247511] = { converted = false, characters = {}, },
				[247528] = { converted = false, characters = {}, },
				[247524] = { converted = false, characters = {}, },
				[247562] = { converted = false, characters = {}, },
				[247533] = { converted = false, characters = {}, },
				[247523] = { converted = false, characters = {}, },
				[247530] = { converted = false, characters = {}, },
				[247532] = { converted = false, characters = {}, },
				[247529] = { converted = false, characters = {}, },
				[247534] = { converted = false, characters = {}, },
				[247527] = { converted = false, characters = {}, },
				[247526] = { converted = false, characters = {}, },
				[247535] = { converted = false, characters = {}, },

				[247544] = { converted = false, characters = {}, },
				[247537] = { converted = false, characters = {}, },
				[247541] = { converted = false, characters = {}, },
				[247564] = { converted = false, characters = {}, },
				[247538] = { converted = false, characters = {}, },
				[247506] = { converted = false, characters = {}, },
				[247536] = { converted = false, characters = {}, },
				[247504] = { converted = false, characters = {}, },
				[247547] = { converted = false, characters = {}, },
				[247542] = { converted = false, characters = {}, },
				[247546] = { converted = false, characters = {}, },
				[247545] = { converted = false, characters = {}, },
				[247540] = { converted = false, characters = {}, },
				[247543] = { converted = false, characters = {}, },
				[247036] = { converted = false, characters = {}, },

				[247555] = { converted = false, characters = {}, },
				[247510] = { converted = false, characters = {}, },
				[247552] = { converted = false, characters = {}, },
				[247549] = { converted = false, characters = {}, },
				[247508] = { converted = false, characters = {}, },
				[247548] = { converted = false, characters = {}, },
				[247556] = { converted = false, characters = {}, },
				[247557] = { converted = false, characters = {}, },
				[247550] = { converted = false, characters = {}, },
				[247554] = { converted = false, characters = {}, },
				[247565] = { converted = false, characters = {}, },
				[247558] = { converted = false, characters = {}, },
				[247553] = { converted = false, characters = {}, },
				[247551] = { converted = false, characters = {}, },
				[247559] = { converted = false, characters = {}, },

				[247591] = { converted = false, characters = {}, },
				[247592] = { converted = false, characters = {}, },
				[247568] = { converted = false, characters = {}, },

				[247567] = { converted = false, characters = {}, },
				[247571] = { converted = false, characters = {}, },
				[249684] = { converted = false, characters = {}, },
				[247569] = { converted = false, characters = {}, },
				[249685] = { converted = false, characters = {}, },
				[247584] = { converted = false, characters = {}, },
				[247566] = { converted = false, characters = {}, },
				[247570] = { converted = false, characters = {}, },

				[247585] = { converted = false, characters = {}, },
				[247587] = { converted = false, characters = {}, },
				[247573] = { converted = false, characters = {}, },
				[249683] = { converted = false, characters = {}, },
				[247575] = { converted = false, characters = {}, },
				[247572] = { converted = false, characters = {}, },
				[247574] = { converted = false, characters = {}, },
				[249682] = { converted = false, characters = {}, },

				[247576] = { converted = false, characters = {}, },
				[247579] = { converted = false, characters = {}, },
				[247588] = { converted = false, characters = {}, },
				[247589] = { converted = false, characters = {}, },
				[247577] = { converted = false, characters = {}, },
				[249680] = { converted = false, characters = {}, },
				[247578] = { converted = false, characters = {}, },
				[249681] = { converted = false, characters = {}, },

				[247583] = { converted = false, characters = {}, },
				[247586] = { converted = false, characters = {}, },
				[247581] = { converted = false, characters = {}, },
				[249678] = { converted = false, characters = {}, },
				[247580] = { converted = false, characters = {}, },
				[247582] = { converted = false, characters = {}, },
				[247590] = { converted = false, characters = {}, },
				[249679] = { converted = false, characters = {}, },

				[247489] = { converted = false, characters = {}, },
				[247481] = { converted = false, characters = {}, },
				[247482] = { converted = false, characters = {}, },
				[247491] = { converted = false, characters = {}, },
				[247436] = { converted = false, characters = {}, },
				[247492] = { converted = false, characters = {}, },
				[247490] = { converted = false, characters = {}, },

				[247430] = { converted = false, characters = {}, },
				[247431] = { converted = false, characters = {}, },
				[247493] = { converted = false, characters = {}, },
				[247467] = { converted = false, characters = {}, },
				[247486] = { converted = false, characters = {}, },
				[247435] = { converted = false, characters = {}, },
				[247465] = { converted = false, characters = {}, },
				[247466] = { converted = false, characters = {}, },

				[247469] = { converted = false, characters = {}, },
				[247438] = { converted = false, characters = {}, },
				[247439] = { converted = false, characters = {}, },
				[247441] = { converted = false, characters = {}, },
				[247488] = { converted = false, characters = {}, },
				[247440] = { converted = false, characters = {}, },
				[247494] = { converted = false, characters = {}, },
				[247437] = { converted = false, characters = {}, },

				[247470] = { converted = false, characters = {}, },
				[247448] = { converted = false, characters = {}, },
				[247447] = { converted = false, characters = {}, },
				[247453] = { converted = false, characters = {}, },
				[247456] = { converted = false, characters = {}, },
				[247454] = { converted = false, characters = {}, },
				[247495] = { converted = false, characters = {}, },

				[247458] = { converted = false, characters = {}, },
				[247473] = { converted = false, characters = {}, },
				[247460] = { converted = false, characters = {}, },
				[247496] = { converted = false, characters = {}, },
				[247472] = { converted = false, characters = {}, },
				[247477] = { converted = false, characters = {}, },
				[247475] = { converted = false, characters = {}, },
				[247464] = { converted = false, characters = {}, },
				[247471] = { converted = false, characters = {}, },
				[247484] = { converted = false, characters = {}, },

				[247617] = { converted = false, characters = {}, },
				[247596] = { converted = false, characters = {}, },
				[247594] = { converted = false, characters = {}, },
				[247599] = { converted = false, characters = {}, },
				[247598] = { converted = false, characters = {}, },
				[247618] = { converted = false, characters = {}, },
				[247595] = { converted = false, characters = {}, },
				[247597] = { converted = false, characters = {}, },

				[247605] = { converted = false, characters = {}, },
				[247602] = { converted = false, characters = {}, },
				[247620] = { converted = false, characters = {}, },
				[247603] = { converted = false, characters = {}, },
				[247601] = { converted = false, characters = {}, },
				[247600] = { converted = false, characters = {}, },
				[247604] = { converted = false, characters = {}, },
				[247619] = { converted = false, characters = {}, },
				[247616] = { converted = false, characters = {}, },

				[247608] = { converted = false, characters = {}, },
				[247606] = { converted = false, characters = {}, },
				[247610] = { converted = false, characters = {}, },
				[247622] = { converted = false, characters = {}, },
				[247607] = { converted = false, characters = {}, },
				[247621] = { converted = false, characters = {}, },
				[247609] = { converted = false, characters = {}, },

				[247615] = { converted = false, characters = {}, },
				[247624] = { converted = false, characters = {}, },
				[247611] = { converted = false, characters = {}, },
				[247613] = { converted = false, characters = {}, },
				[247614] = { converted = false, characters = {}, },
				[247623] = { converted = false, characters = {}, },
				[247612] = { converted = false, characters = {}, },

				[247632] = { converted = false, characters = {}, },
				[247627] = { converted = false, characters = {}, },
				[247630] = { converted = false, characters = {}, },
				[247629] = { converted = false, characters = {}, },
				[247628] = { converted = false, characters = {}, },
				[247631] = { converted = false, characters = {}, },
				[247626] = { converted = false, characters = {}, },
				[247625] = { converted = false, characters = {}, },

				[247637] = { converted = false, characters = {}, },
				[247654] = { converted = false, characters = {}, },
				[247635] = { converted = false, characters = {}, },
				[247653] = { converted = false, characters = {}, },
				[247638] = { converted = false, characters = {}, },
				[247633] = { converted = false, characters = {}, },
				[247636] = { converted = false, characters = {}, },
				[247634] = { converted = false, characters = {}, },

				[247639] = { converted = false, characters = {}, },
				[247641] = { converted = false, characters = {}, },
				[247656] = { converted = false, characters = {}, },
				[247640] = { converted = false, characters = {}, },
				[247643] = { converted = false, characters = {}, },
				[247642] = { converted = false, characters = {}, },
				[247651] = { converted = false, characters = {}, },
				[247655] = { converted = false, characters = {}, },

				[247645] = { converted = false, characters = {}, },
				[247644] = { converted = false, characters = {}, },
				[247646] = { converted = false, characters = {}, },
				[247648] = { converted = false, characters = {}, },
				[247649] = { converted = false, characters = {}, },
				[247647] = { converted = false, characters = {}, },
				[247650] = { converted = false, characters = {}, },
				[247652] = { converted = false, characters = {}, },
			}
			TransmogLootHelper_Cache.LemixCharacters = {}
			TransmogLootHelper_Cache.LemixCharacters["FirstLemixLoad"] = true
		end

		app.CreateRemixWindow()
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
		else
			local count = C_Item.GetItemCount(itemID, true, false, false, false)
			if count > 1 then
				itemInfo.characters[app.CharacterName] = true
			elseif count == 1 then
				if C_Item.IsEquippedItem(itemID) then
					itemInfo.characters[app.CharacterName] = "equipped"
				else
					itemInfo.characters[app.CharacterName] = true
				end
			else
				itemInfo.characters[app.CharacterName] = nil
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

	app.RemixSettingsButton = CreateFrame("Button", "", app.RemixWindow, "UIPanelCloseButton")
	app.RemixSettingsButton:SetPoint("TOPRIGHT", app.RemixLockButton, "TOPLEFT", -2, 0)
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

	app.CloseButtonTooltip = app.RemixWindowTooltip(L.WINDOW_BUTTON_CLOSE)
	app.LockButtonTooltip = app.RemixWindowTooltip(L.WINDOW_BUTTON_LOCK)
	app.UnlockButtonTooltip = app.RemixWindowTooltip(L.WINDOW_BUTTON_UNLOCK)
	app.SettingsButtonTooltip = app.RemixWindowTooltip(L.WINDOW_BUTTON_SETTINGS)

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

		button.LeftText1:SetText(data.Left1 or "")
		button.LeftText2:SetText(data.Left2 or "")
		button.RightText:SetText(data.Right or "")

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
		raid.collected = 0
		for i2, cat in ipairs(raid.categories) do
			cat.collected = 0
			for _, item in pairs(cat.items) do
				if TransmogLootHelper_Cache.Lemix[item.itemID] then
					if TransmogLootHelper_Cache.Lemix[item.itemID].converted then
						cat.collected = cat.collected + 1
						item.qualityColor = poorQualityColor
						item.icon = app.IconReady
					else
						local haveItem = false
						for character, have in pairs(TransmogLootHelper_Cache.Lemix[item.itemID].characters) do
							if have then
								haveItem = true
								if have == "equipped" then
									item.icon = "|T"..app.IconMaybeReady..":0|t"
								else
									item.icon = app.IconReady
									break
								end
							end
						end
						if haveItem then cat.collected = cat.collected + 1 end
					end
				end
			end
			raid.collected = raid.collected + cat.collected
		end
	end

	local DataProvider = CreateTreeDataProvider()

	for i, raid in ipairs(app.LemixRaidLoot) do
		local raidNode = DataProvider:Insert({ index = i, Left1 = raid.name .. " (" .. raid.collected .. "/" .. raid.total .. ")", collapsed = raid.collapsed })
		if raid.collapsed then raidNode:ToggleCollapsed() end

		for i2, cat in ipairs(raid.categories) do
			local catNode = raidNode:Insert({ index = 1, subindex = i2, Left1 = cat.name .. " (" .. cat.collected .. "/" .. #cat.items .. ")", collapsed = cat.collapsed })
			if cat.collapsed then catNode:ToggleCollapsed() end

			local collected2 = 0
			for _, item in pairs(cat.items) do
				local gear = Item:CreateFromItemID(item.itemID)
				gear:ContinueOnItemLoad(function()
					catNode:Insert({
						itemID = item.itemID,
						Left1 = "|T" .. C_Item.GetItemIconByID(item.itemID) .. ":16|t",
						Left2 = ("|c" .. item.qualityColor .. "[" .. GetItemInfo(item.itemID) .. "]" or "Unknown Item"),
						Right = item.icon,
					})
				end)
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
