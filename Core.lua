------------------------------------
-- Transmog Loot Helper: Core.lua --
------------------------------------
-- Main AddOn code

-- Initialisation
local appName, app = ...	-- Returns the AddOn name and a unique table
app.api = {}	-- Create a table to use for our "API"
TransmogLootHelper = app.api	-- Create a namespace for our "API"
local api = app.api	-- Our "API" prefix

----------------------
-- HELPER FUNCTIONS --
----------------------

-- WoW API Events
local event = CreateFrame("Frame")
event:SetScript("OnEvent", function(self, event, ...)
	if self[event] then
		self[event](self, ...)
	end
end)
event:RegisterEvent("ADDON_LOADED")
event:RegisterEvent("CHAT_MSG_LOOT")

-- Table dump
function app.Dump(table)
	local function dumpTable(o)
		if type(o) == 'table' then
			local s = '{ '
			for k,v in pairs(o) do
				if type(k) ~= 'number' then k = '"'..k..'"' end
				s = s .. '['..k..'] = ' .. dumpTable(v) .. ','
			end
		return s .. '} '
		else
			return tostring(o)
		end
	end
	print(dumpTable(table))
end

-- App colour
function app.Colour(string)
	return "|cffC69B6D"..string.."|R"
end

-- Print with AddOn prefix
function app.Print(...)
	print(app.NameShort..":", ...)
end

-- Pop-up window
function app.Popup(show, text)
	-- Create popup frame
	local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	frame:SetPoint("CENTER")
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:EnableMouse(true)
	if show == true then
		frame:Show()
	else
		frame:Hide()
	end

	-- Close button
	local close = CreateFrame("Button", "", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
	close:SetScript("OnClick", function()
		frame:Hide()
	end)

	-- Text
	local string = frame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	string:SetPoint("CENTER", frame, "CENTER", 0, 0)
	string:SetPoint("TOP", frame, "TOP", 0, -25)
	string:SetJustifyH("CENTER")
	string:SetText(text)
	frame:SetHeight(string:GetStringHeight()+50)
	frame:SetWidth(string:GetStringWidth()+50)

	return frame
end

-- Border
function app.Border(parent, a, b, c, d)
	local border = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	border:SetPoint("TOPLEFT", parent, a or 0, b or 0)
	border:SetPoint("BOTTOMRIGHT", parent, c or 0, d or 0)
	border:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 14,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	border:SetBackdropColor(0, 0, 0, 0)
	border:SetBackdropBorderColor(0.776, 0.608, 0.427)
end

-- Button
function app.Button(parent, text)
	local frame = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	frame:SetText(text)
	frame:SetWidth(frame:GetTextWidth()+20)

	app.Border(frame, 0, 0, 0, -1)
	return frame
end

-- Window tooltip body
function app.WindowTooltip(text)
	-- Tooltip
	local frame = CreateFrame("Frame", nil, app.Window, "BackdropTemplate")
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

	local string = frame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	string:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
	string:SetJustifyH("LEFT")
	string:SetText(text)

	-- Set the tooltip size to fit its contents
	frame:SetHeight(string:GetStringHeight()+20)
	frame:SetWidth(string:GetStringWidth()+20)

	return frame
end

-- Window tooltip show/hide
function app.WindowTooltipShow(frame)
	-- Set the tooltip to either the left or right, depending on where the window is placed
	if GetScreenWidth()/2-TransmogLootHelper_Settings["windowPosition"].width/2-app.Window:GetLeft() >= 0 then
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", app.Window, "RIGHT", 0, 0)
	else
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", app.Window, "LEFT", 0, 0)
	end
	frame:Show()
end

------------------
-- INITIAL LOAD --
------------------

-- Create SavedVariables, default user settings, and session variables
function app.InitialiseCore()
	-- Declare SavedVariables
	if not TransmogLootHelper_Settings then TransmogLootHelper_Settings = {} end
	if TransmogLootHelper_Settings["windowPosition"] == nil then TransmogLootHelper_Settings["windowPosition"] = { ["left"] = 1295, ["bottom"] = 836, ["width"] = 200, ["height"] = 200, } end
	if TransmogLootHelper_Settings["message"] == nil then TransmogLootHelper_Settings["message"] = "Do you need %item? I'd like to have it for transmog. :)" end
	if TransmogLootHelper_Settings["collectMode"] == nil then TransmogLootHelper_Settings["collectMode"] = 1 end
	if TransmogLootHelper_Settings["usableMog"] == nil then TransmogLootHelper_Settings["usableMog"] = true end
	if TransmogLootHelper_Settings["rarity"] == nil then TransmogLootHelper_Settings["rarity"] = 0 end

	-- Declare session variables
	app.Hidden = CreateFrame("Frame")
	app.WeaponLoot = {}
	app.ArmourLoot = {}
	app.FilteredLoot = {}
	app.WeaponRow = {}
	app.ArmourRow = {}
	app.FilteredRow = {}
	app.ShowWeapons = true
	app.ShowArmour = true
	app.ShowFiltered = false
	app.RecentlyWhispered = {}
	app.ClassID = PlayerUtil.GetClassID()

	-- Enable this CVar, because we need it
	SetCVar("missingTransmogSourceInItemTooltips", 1)
end

------------
-- WINDOW --
------------

-- Save the window position and size
function app.SaveWindow()
	-- Stop moving or resizing the window
	app.Window:StopMovingOrSizing()

	-- Get the window properties
	local left = app.Window:GetLeft()
	local bottom = app.Window:GetBottom()
	local width, height = app.Window:GetSize()

	-- Save the window position and size
	TransmogLootHelper_Settings["windowPosition"] = { ["left"] = left, ["bottom"] = bottom, ["width"] = width, ["height"] = height, }
end

-- Create the main window
function app.CreateWindow()
	-- Create popup frame
	app.Window = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	app.Window:SetPoint("CENTER")
	app.Window:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	app.Window:SetBackdropColor(0, 0, 0, 1)
	app.Window:SetBackdropBorderColor(0.776, 0.608, 0.427)
	app.Window:EnableMouse(true)
	app.Window:SetMovable(true)
	app.Window:SetResizable(true)
	app.Window:SetResizeBounds(140, 140, 600, 600)
	app.Window:RegisterForDrag("LeftButton")
	app.Window:SetScript("OnDragStart", function()
		app.Window:StartMoving()
		GameTooltip:ClearLines()
		GameTooltip:Hide()
	end)
	app.Window:SetScript("OnDragStop", function() app.SaveWindow() end)
	app.Window:Hide()

	-- Resize corner
	local corner = CreateFrame("Button", nil, app.Window)
	corner:EnableMouse("true")
	corner:SetPoint("BOTTOMRIGHT")
	corner:SetSize(16,16)
	corner:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	corner:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	corner:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	corner:SetScript("OnMouseDown", function()
		app.Window:StartSizing("BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:Hide()
	end)
	corner:SetScript("OnMouseUp", function() app.SaveWindow() end)
	app.Window.Corner = corner

	-- Close button
	local close = CreateFrame("Button", "pslOptionCloseButton", app.Window, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", app.Window, "TOPRIGHT", 2, 2)
	close:SetScript("OnClick", function()
		app.Window:Hide()
	end)
	close:SetScript("OnEnter", function()
		app.WindowTooltipShow(app.CloseButtonTooltip)
	end)
	close:SetScript("OnLeave", function()
		app.CloseButtonTooltip:Hide()
	end)

	-- Clear button
	app.ClearButton = CreateFrame("Button", "pslOptionClearButton", app.Window, "UIPanelCloseButton")
	app.ClearButton:SetPoint("TOPRIGHT", close, "TOPLEFT", -2, 0)
	app.ClearButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\button-clear.blp")
	app.ClearButton:GetNormalTexture():SetTexCoord(39/256, 75/256, 1/128, 38/128)
	app.ClearButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\button-clear.blp")
	app.ClearButton:GetDisabledTexture():SetTexCoord(39/256, 75/256, 41/128, 78/128)
	app.ClearButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\button-clear.blp")
	app.ClearButton:GetPushedTexture():SetTexCoord(39/256, 75/256, 81/128, 118/128)
	app.ClearButton:SetScript("OnClick", function()
		if IsShiftKeyDown() == true then
			app.Clear()
		else
			StaticPopupDialogs["CLEAR_LOOT"] = {
				text = app.NameLong.."\nDo you want to clear all loot?",
				button1 = YES,
				button2 = NO,
				OnAccept = function()
					app.Clear()
				end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				showAlert = true,
			}
			StaticPopup_Show("CLEAR_LOOT")
		end
	end)
	app.ClearButton:SetScript("OnEnter", function()
		app.WindowTooltipShow(app.ClearButtonTooltip)
	end)
	app.ClearButton:SetScript("OnLeave", function()
		app.ClearButtonTooltip:Hide()
	end)

	-- ScrollFrame inside the popup frame
	local scrollFrame = CreateFrame("ScrollFrame", nil, app.Window, "ScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", app.Window, 7, -6)
	scrollFrame:SetPoint("BOTTOMRIGHT", app.Window, -22, 6)
	scrollFrame:Show()

	scrollFrame.ScrollBar.Back:Hide()
	scrollFrame.ScrollBar.Forward:Hide()
	scrollFrame.ScrollBar:ClearAllPoints()
	scrollFrame.ScrollBar:SetPoint("TOP", scrollFrame, 0, -3)
	scrollFrame.ScrollBar:SetPoint("RIGHT", scrollFrame, 13, 0)
	scrollFrame.ScrollBar:SetPoint("BOTTOM", scrollFrame, 0, -16)
	
	-- ScrollChild inside the ScrollFrame
	local scrollChild = CreateFrame("Frame", nil, scrollFrame)
	scrollFrame:SetScrollChild(scrollChild)
	scrollChild:SetWidth(1)    -- This is automatically defined, so long as the attribute exists at all
	scrollChild:SetHeight(1)    -- This is automatically defined, so long as the attribute exists at all
	scrollChild:SetAllPoints(scrollFrame)
	scrollChild:Show()
	scrollFrame:SetScript("OnVerticalScroll", function() scrollChild:SetPoint("BOTTOMRIGHT", scrollFrame) end)
	app.Window.Child = scrollChild
	app.Window.ScrollFrame = scrollFrame
end

-- Update window contents
function app.UpdateWindow()
	-- Hide existing rows
	if app.WeaponRow then
		for i, row in pairs(app.WeaponRow) do
			row:SetParent(app.Hidden)
			row:Hide()
		end
	end
	if app.ArmourRow then
		for i, row in pairs(app.ArmourRow) do
			row:SetParent(app.Hidden)
			row:Hide()
		end
	end
	if app.FilteredRow then
		for i, row in pairs(app.FilteredRow) do
			row:SetParent(app.Hidden)
			row:Hide()
		end
	end

	-- Disable the clear button
	app.ClearButton:Disable()

	-- To count how many rows we end up with
	local rowNo1 = 0
	local rowNo2 = 0
	local rowNo3 = 0
	local maxLength1 = 0
	local maxLength2 = 0
	local maxLength3 = 0
	app.WeaponRow = {}

	-- Create header
	if not app.Window.Weapons then
		app.Window.Weapons = CreateFrame("Button", nil, app.Window.Child)
		app.Window.Weapons:SetSize(0,16)
		app.Window.Weapons:SetPoint("TOPLEFT", app.Window.Child, -1, 0)
		app.Window.Weapons:SetPoint("RIGHT", app.Window.Child)
		app.Window.Weapons:RegisterForDrag("LeftButton")
		app.Window.Weapons:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		app.Window.Weapons:SetScript("OnDragStart", function()
			app.Window:StartMoving()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end)
		app.Window.Weapons:SetScript("OnDragStop", function() app.SaveWindow() end)
		app.Window.Weapons:SetScript("OnEnter", function()
			app.WindowTooltipShow(app.LootHeaderTooltip)
		end)
		app.Window.Weapons:SetScript("OnLeave", function()
			app.LootHeaderTooltip:Hide()
		end)
		app.Window.Weapons:SetScript("OnClick", function(self)
			local children = {self:GetChildren()}
	
			if app.ShowWeapons == true then
				for _, child in ipairs(children) do child:Hide() end
				app.Window.Armour:SetPoint("TOPLEFT", app.Window.Weapons, "BOTTOMLEFT", 0, -2)
				app.ShowWeapons = false
			else
				for _, child in ipairs(children) do child:Show() end
				local offset = -2
				if #app.WeaponLoot >= 1 then offset = -16*#app.WeaponLoot end
				app.Window.Armour:SetPoint("TOPLEFT", app.Window.Weapons, "BOTTOMLEFT", 0, offset)
				app.ShowWeapons = true
			end
		end)
		
		local weapon1 = app.Window.Weapons:CreateFontString("ARTWORK", nil, "GameFontNormal")
		weapon1:SetPoint("LEFT", app.Window.Weapons)
		weapon1:SetScale(1.1)
		app.WeaponsHeader = weapon1
	end

	-- Update header
	if #app.WeaponLoot >= 1 then
		app.WeaponsHeader:SetText("Weapons ("..#app.WeaponLoot..")")
	else
		app.WeaponsHeader:SetText("Weapons")	
	end

	-- If there is loot to process
	if #app.WeaponLoot >= 1 then
		-- Custom comparison function based on the beginning of the string (thanks ChatGPT)
		local customSortList = {
			"|cffe6cc80",	-- Artifact
			"|cffff8000",	-- Legendary
			"|cffa335ee",	-- Epic
			"|cff0070dd",	-- Rare
			"|cff1eff00",	-- Uncommon
			"|cffffffff",	-- Common
			"|cff9d9d9d",	-- Poor (quantity 0)
		}
		local function customSort(a, b)
			for _, v in ipairs(customSortList) do
				local indexA = string.find(a.item, v, 1, true)
				local indexB = string.find(b.item, v, 1, true)
		
				if indexA == 1 and indexB ~= 1 then
					return true
				elseif indexA ~= 1 and indexB == 1 then
					return false
				end
			end
		
			-- If custom sort index is the same, compare alphabetically
			return string.gsub(a.item, ".-(:%|h)", "") < string.gsub(b.item, ".-(:%|h)", "")
		end

		-- Sort loot
		local weaponsSorted = {}
		for k, v in pairs(app.WeaponLoot) do
			weaponsSorted[#weaponsSorted+1] = { item = v.item, icon = v.icon, player = v.player, playerShort = v.playerShort, color = v.color, index = k}
		end
		table.sort(weaponsSorted, customSort)

		-- Create rows
		for _, lootInfo in ipairs(weaponsSorted) do
			rowNo1 = rowNo1 + 1

			local row = CreateFrame("Button", nil, app.Window.Weapons)
			row:SetSize(0,16)
			row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
			row:RegisterForDrag("LeftButton")
			row:RegisterForClicks("AnyDown")
			row:SetScript("OnDragStart", function()
				app.Window:StartMoving()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
			end)
			row:SetScript("OnDragStop", function() app.SaveWindow() end)
			row:SetScript("OnEnter", function()
				-- Show item tooltip if hovering over the actual row
				GameTooltip:ClearLines()

				-- Set the tooltip to either the left or right, depending on where the window is placed
				if GetScreenWidth()/2-TransmogLootHelper_Settings["windowPosition"].width/2-app.Window:GetLeft() >= 0 then
					GameTooltip:SetOwner(app.Window, "ANCHOR_NONE")
					GameTooltip:SetPoint("LEFT", app.Window, "RIGHT")
				else
					GameTooltip:SetOwner(app.Window, "ANCHOR_NONE")
					GameTooltip:SetPoint("RIGHT", app.Window, "LEFT")
				end
				GameTooltip:SetHyperlink(lootInfo.item)
				GameTooltip:Show()
			end)
			row:SetScript("OnLeave", function()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
			end)
			row:SetScript("OnClick", function(self, button)
				-- LMB
				if button == "LeftButton" then
					-- Shift+LMB
					if IsShiftKeyDown() == true then
						-- Try write link to chat
						ChatEdit_InsertLink(lootInfo.item)
					else
						if app.WeaponLoot[lootInfo.index].recentlyWhispered == false then
							local msg = string.gsub(TransmogLootHelper_Settings["message"], "%%item", lootInfo.item.."|r")
							SendChatMessage(msg, "WHISPER", "", lootInfo.player)

							-- Add a timeout to prevent spamming
							app.WeaponLoot[lootInfo.index].recentlyWhispered = true
							C_Timer.After(30, function() app.WeaponLoot[lootInfo.index].recentlyWhispered = false end)
						elseif app.WeaponLoot[lootInfo.index].recentlyWhispered == true then
							app.Print("You've recently whispered this player. After 30 seconds, you may do so again.")
						end
					end
				-- RMB
				elseif button == "RightButton" then
					-- Remove the item
					table.remove(app.WeaponLoot, lootInfo.index)
					-- And update the window
					RunNextFrame(app.UpdateWindow)
					do return end
				end
			end)

			app.WeaponRow[rowNo1] = row

			local icon1 = row:CreateFontString("ARTWORK", nil, "GameFontNormal")
			icon1:SetPoint("LEFT", row)
			icon1:SetScale(1.2)
			icon1:SetText("|T"..(lootInfo.icon or "Interface\\Icons\\inv_misc_questionmark")..":0|t")

			local text2 = row:CreateFontString("ARTWORK", nil, "GameFontNormal")
			text2:SetPoint("CENTER", icon1)
			text2:SetPoint("RIGHT", app.Window.Child)
			text2:SetJustifyH("RIGHT")
			text2:SetTextColor(1, 1, 1)
			text2:SetText("|c"..lootInfo.color..lootInfo.playerShort)

			local text1 = row:CreateFontString("ARTWORK", nil, "GameFontNormal")
			text1:SetPoint("LEFT", icon1, "RIGHT", 3, 0)
			text1:SetPoint("RIGHT", text2, "LEFT")
			text1:SetTextColor(1, 1, 1)
			text1:SetText(lootInfo.item)
			text1:SetJustifyH("LEFT")
			text1:SetWordWrap(false)

			maxLength1 = math.max(icon1:GetStringWidth()+text1:GetStringWidth()+text2:GetStringWidth(), maxLength1)
		end

		if app.WeaponRow then
			if #app.WeaponRow >= 1 then
				for i, row in ipairs(app.WeaponRow) do
					if i == 1 then
						row:SetPoint("TOPLEFT", app.Window.Weapons, "BOTTOMLEFT")
						row:SetPoint("TOPRIGHT", app.Window.Weapons, "BOTTOMRIGHT")
					else
						local offset = -16*(i-1)
						row:SetPoint("TOPLEFT", app.Window.Weapons, "BOTTOMLEFT", 0, offset)
						row:SetPoint("TOPRIGHT", app.Window.Weapons, "BOTTOMRIGHT", 0, offset)
					end
				end
			end
		end
		
		-- Enable the clear button
		app.ClearButton:Enable()
	end

	-- Create header
	if not app.Window.Armour then
		app.Window.Armour = CreateFrame("Button", nil, app.Window.Child)
		app.Window.Armour:SetSize(0,16)
		app.Window.Armour:SetPoint("TOPLEFT", app.Window.Child, -1, 0)
		app.Window.Armour:SetPoint("RIGHT", app.Window.Child)
		app.Window.Armour:RegisterForDrag("LeftButton")
		app.Window.Armour:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		app.Window.Armour:SetScript("OnDragStart", function()
			app.Window:StartMoving()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end)
		app.Window.Armour:SetScript("OnDragStop", function() app.SaveWindow() end)
		app.Window.Armour:SetScript("OnEnter", function()
			app.WindowTooltipShow(app.LootHeaderTooltip)
		end)
		app.Window.Armour:SetScript("OnLeave", function()
			app.LootHeaderTooltip:Hide()
		end)
		app.Window.Armour:SetScript("OnClick", function(self)
			local children = {self:GetChildren()}
	
			if app.ShowArmour == true then
				for _, child in ipairs(children) do child:Hide() end
				app.Window.Filtered:SetPoint("TOPLEFT", app.Window.Armour, "BOTTOMLEFT", 0, -2)
				app.ShowArmour = false
			else
				for _, child in ipairs(children) do child:Show() end
				local offset = -2
				if #app.ArmourLoot >= 1 then offset = -16*#app.ArmourLoot end
				app.Window.Filtered:SetPoint("TOPLEFT", app.Window.Armour, "BOTTOMLEFT", 0, offset)
				app.ShowArmour = true
			end
		end)
		
		local armour1 = app.Window.Armour:CreateFontString("ARTWORK", nil, "GameFontNormal")
		armour1:SetPoint("LEFT", app.Window.Armour)
		armour1:SetScale(1.1)
		app.ArmourHeader = armour1
	end

	-- Update header
	local offset = -2
	if #app.WeaponLoot >= 1 then offset = -16*#app.WeaponLoot end
	app.Window.Armour:SetPoint("TOPLEFT", app.Window.Weapons, "BOTTOMLEFT", 0, offset)
	if #app.ArmourLoot >= 1 then
		app.ArmourHeader:SetText("Armor ("..#app.ArmourLoot..")")
	else
		app.ArmourHeader:SetText("Armor")
	end

	-- If there is loot to process
	if #app.ArmourLoot >= 1 then
		-- Custom comparison function based on the beginning of the string (thanks ChatGPT)
		local customSortList = {
			"|cffe6cc80",	-- Artifact
			"|cffff8000",	-- Legendary
			"|cffa335ee",	-- Epic
			"|cff0070dd",	-- Rare
			"|cff1eff00",	-- Uncommon
			"|cffffffff",	-- Common
			"|cff9d9d9d",	-- Poor (quantity 0)
		}
		local function customSort(a, b)
			for _, v in ipairs(customSortList) do
				local indexA = string.find(a.item, v, 1, true)
				local indexB = string.find(b.item, v, 1, true)
		
				if indexA == 1 and indexB ~= 1 then
					return true
				elseif indexA ~= 1 and indexB == 1 then
					return false
				end
			end
		
			-- If custom sort index is the same, compare alphabetically
			return string.gsub(a.item, ".-(:%|h)", "") < string.gsub(b.item, ".-(:%|h)", "")
		end

		-- Sort loot
		local armourSorted = {}
		for k, v in pairs(app.ArmourLoot) do
			armourSorted[#armourSorted+1] = { item = v.item, icon = v.icon, player = v.player, playerShort = v.playerShort, color = v.color, index = k}
		end
		table.sort(armourSorted, customSort)

		-- Create rows
		for _, lootInfo in ipairs(armourSorted) do
			rowNo2 = rowNo2 + 1

			local row = CreateFrame("Button", nil, app.Window.Armour)
			row:SetSize(0,16)
			row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
			row:RegisterForDrag("LeftButton")
			row:RegisterForClicks("AnyDown")
			row:SetScript("OnDragStart", function()
				app.Window:StartMoving()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
			end)
			row:SetScript("OnDragStop", function() app.SaveWindow() end)
			row:SetScript("OnEnter", function()
				-- Show item tooltip if hovering over the actual row
				GameTooltip:ClearLines()

				-- Set the tooltip to either the left or right, depending on where the window is placed
				if GetScreenWidth()/2-TransmogLootHelper_Settings["windowPosition"].width/2-app.Window:GetLeft() >= 0 then
					GameTooltip:SetOwner(app.Window, "ANCHOR_NONE")
					GameTooltip:SetPoint("LEFT", app.Window, "RIGHT")
				else
					GameTooltip:SetOwner(app.Window, "ANCHOR_NONE")
					GameTooltip:SetPoint("RIGHT", app.Window, "LEFT")
				end
				GameTooltip:SetHyperlink(lootInfo.item)
				GameTooltip:Show()
			end)
			row:SetScript("OnLeave", function()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
			end)
			row:SetScript("OnClick", function(self, button)
				-- LMB
				if button == "LeftButton" then
					-- Shift+LMB
					if IsShiftKeyDown() == true then
						-- Try write link to chat
						ChatEdit_InsertLink(lootInfo.item)
					else
						if app.ArmourLoot[lootInfo.index].recentlyWhispered == false then
							local msg = string.gsub(TransmogLootHelper_Settings["message"], "%%item", lootInfo.item.."|r")
							SendChatMessage(msg, "WHISPER", "", lootInfo.player)

							-- Add a timeout to prevent spamming
							app.ArmourLoot[lootInfo.index].recentlyWhispered = true
							C_Timer.After(30, function() app.ArmourLoot[lootInfo.index].recentlyWhispered = false end)
						elseif app.ArmourLoot[lootInfo.index].recentlyWhispered == true then
							app.Print("You've recently whispered this player. After 30 seconds, you may do so again.")
						end
					end
				-- RMB
				elseif button == "RightButton" then
					-- Remove the item
					table.remove(app.ArmourLoot, lootInfo.index)
					-- And update the window
					RunNextFrame(app.UpdateWindow)
					do return end
				end
			end)

			app.ArmourRow[rowNo2] = row

			local icon1 = row:CreateFontString("ARTWORK", nil, "GameFontNormal")
			icon1:SetPoint("LEFT", row)
			icon1:SetScale(1.2)
			icon1:SetText("|T"..(lootInfo.icon or "Interface\\Icons\\inv_misc_questionmark")..":0|t")

			local text2 = row:CreateFontString("ARTWORK", nil, "GameFontNormal")
			text2:SetPoint("CENTER", icon1)
			text2:SetPoint("RIGHT", app.Window.Child)
			text2:SetJustifyH("RIGHT")
			text2:SetTextColor(1, 1, 1)
			text2:SetText("|c"..lootInfo.color..lootInfo.playerShort)

			local text1 = row:CreateFontString("ARTWORK", nil, "GameFontNormal")
			text1:SetPoint("LEFT", icon1, "RIGHT", 3, 0)
			text1:SetPoint("RIGHT", text2, "LEFT")
			text1:SetTextColor(1, 1, 1)
			text1:SetText(lootInfo.item)
			text1:SetJustifyH("LEFT")
			text1:SetWordWrap(false)

			maxLength2 = math.max(icon1:GetStringWidth()+text1:GetStringWidth()+text2:GetStringWidth(), maxLength2)
		end

		if app.ArmourRow then
			if #app.ArmourRow >= 1 then
				for i, row in ipairs(app.ArmourRow) do
					if i == 1 then
						row:SetPoint("TOPLEFT", app.Window.Armour, "BOTTOMLEFT")
						row:SetPoint("TOPRIGHT", app.Window.Armour, "BOTTOMRIGHT")
					else
						local offset = -16*(i-1)
						row:SetPoint("TOPLEFT", app.Window.Armour, "BOTTOMLEFT", 0, offset)
						row:SetPoint("TOPRIGHT", app.Window.Armour, "BOTTOMRIGHT", 0, offset)
					end
				end
			end
		end
		
		-- Enable the clear button
		app.ClearButton:Enable()
	end

	-- Create header
	if not app.Window.Filtered then
		app.Window.Filtered = CreateFrame("Button", nil, app.Window.Child)
		app.Window.Filtered:SetSize(0,16)
		app.Window.Filtered:SetPoint("TOPLEFT", app.Window.Child, -1, 0)
		app.Window.Filtered:SetPoint("RIGHT", app.Window.Child)
		app.Window.Filtered:RegisterForDrag("LeftButton")
		app.Window.Filtered:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		app.Window.Filtered:SetScript("OnDragStart", function()
			app.Window:StartMoving()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end)
		app.Window.Filtered:SetScript("OnDragStop", function() app.SaveWindow() end)
		app.Window.Filtered:SetScript("OnEnter", function()
			app.WindowTooltipShow(app.LootHeaderTooltip)
		end)
		app.Window.Filtered:SetScript("OnLeave", function()
			app.LootHeaderTooltip:Hide()
		end)
		app.Window.Filtered:SetScript("OnClick", function(self)
			local children = {self:GetChildren()}

			if app.ShowFiltered == true then
				for _, child in ipairs(children) do child:Hide() end
				app.ShowFiltered = false
			else
				for _, child in ipairs(children) do child:Show() end
				app.ShowFiltered = true
			end
		end)
		
		local filtered1 = app.Window.Filtered:CreateFontString("ARTWORK", nil, "GameFontNormal")
		filtered1:SetPoint("LEFT", app.Window.Filtered)
		filtered1:SetScale(1.1)
		app.FilteredHeader = filtered1
	end

	-- Adjust header position
	local offset = -2
	if #app.ArmourLoot >= 1 then offset = -16*#app.ArmourLoot end
	app.Window.Filtered:SetPoint("TOPLEFT", app.Window.Armour, "BOTTOMLEFT", 0, offset)
	if #app.FilteredLoot >= 1 then
		app.FilteredHeader:SetText("Filtered ("..#app.FilteredLoot..")")
	else
		app.FilteredHeader:SetText("Filtered")
	end

	-- If there is loot to process
	if #app.FilteredLoot >= 1 then
		-- Custom comparison function based on the beginning of the string (thanks ChatGPT)
		local customSortList = {
			"|cffe6cc80",	-- Artifact
			"|cffff8000",	-- Legendary
			"|cffa335ee",	-- Epic
			"|cff0070dd",	-- Rare
			"|cff1eff00",	-- Uncommon
			"|cffffffff",	-- Common
			"|cff9d9d9d",	-- Poor (quantity 0)
		}
		local function customSort(a, b)
			for _, v in ipairs(customSortList) do
				local indexA = string.find(a.item, v, 1, true)
				local indexB = string.find(b.item, v, 1, true)
		
				if indexA == 1 and indexB ~= 1 then
					return true
				elseif indexA ~= 1 and indexB == 1 then
					return false
				end
			end
		
			-- If custom sort index is the same, compare alphabetically
			return string.gsub(a.item, ".-(:%|h)", "") < string.gsub(b.item, ".-(:%|h)", "")
		end

		-- Sort loot
		local filteredSorted = {}
		for k, v in pairs(app.FilteredLoot) do
			filteredSorted[#filteredSorted+1] = { item = v.item, icon = v.icon, player = v.player, playerShort = v.playerShort, color = v.color, index = k}
		end
		table.sort(filteredSorted, customSort)

		-- Create rows
		for _, lootInfo in ipairs(filteredSorted) do
			rowNo3 = rowNo3 + 1

			local row = CreateFrame("Button", nil, app.Window.Filtered)
			row:SetSize(0,16)
			row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
			row:RegisterForDrag("LeftButton")
			row:RegisterForClicks("AnyDown")
			row:SetScript("OnDragStart", function()
				app.Window:StartMoving()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
			end)
			row:SetScript("OnDragStop", function() app.SaveWindow() end)
			row:SetScript("OnEnter", function()
				-- Show item tooltip if hovering over the actual row
				GameTooltip:ClearLines()

				-- Set the tooltip to either the left or right, depending on where the window is placed
				if GetScreenWidth()/2-TransmogLootHelper_Settings["windowPosition"].width/2-app.Window:GetLeft() >= 0 then
					GameTooltip:SetOwner(app.Window, "ANCHOR_NONE")
					GameTooltip:SetPoint("LEFT", app.Window, "RIGHT")
				else
					GameTooltip:SetOwner(app.Window, "ANCHOR_NONE")
					GameTooltip:SetPoint("RIGHT", app.Window, "LEFT")
				end
				GameTooltip:SetHyperlink(lootInfo.item)
				GameTooltip:Show()
			end)
			row:SetScript("OnLeave", function()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
			end)
			row:SetScript("OnClick", function(self, button)
				-- LMB
				if button == "LeftButton" then
					-- Shift+LMB
					if IsShiftKeyDown() == true then
						-- Try write link to chat
						ChatEdit_InsertLink(lootInfo.item)
					else
						if app.FilteredLoot[lootInfo.index].recentlyWhispered == false then
							local msg = string.gsub(TransmogLootHelper_Settings["message"], "%%item", lootInfo.item.."|r")
							SendChatMessage(msg, "WHISPER", "", lootInfo.player)

							-- Add a timeout to prevent spamming
							app.FilteredLoot[lootInfo.index].recentlyWhispered = true
							C_Timer.After(30, function() app.FilteredLoot[lootInfo.index].recentlyWhispered = false end)
						elseif app.FilteredLoot[lootInfo.index].recentlyWhispered == true then
							app.Print("You've recently whispered this player. After 30 seconds, you may do so again.")
						end
					end
				-- RMB
				elseif button == "RightButton" then
					-- Remove the item
					table.remove(app.FilteredLoot, lootInfo.index)
					-- And update the window
					RunNextFrame(app.UpdateWindow)
					do return end
				end
			end)

			app.FilteredRow[rowNo3] = row

			local icon1 = row:CreateFontString("ARTWORK", nil, "GameFontNormal")
			icon1:SetPoint("LEFT", row)
			icon1:SetScale(1.2)
			icon1:SetText("|T"..(lootInfo.icon or "Interface\\Icons\\inv_misc_questionmark")..":0|t")

			local text2 = row:CreateFontString("ARTWORK", nil, "GameFontNormal")
			text2:SetPoint("CENTER", icon1)
			text2:SetPoint("RIGHT", app.Window.Child)
			text2:SetJustifyH("RIGHT")
			text2:SetTextColor(1, 1, 1)
			text2:SetText("|c"..lootInfo.color..lootInfo.playerShort)

			local text1 = row:CreateFontString("ARTWORK", nil, "GameFontNormal")
			text1:SetPoint("LEFT", icon1, "RIGHT", 3, 0)
			text1:SetPoint("RIGHT", text2, "LEFT")
			text1:SetTextColor(1, 1, 1)
			text1:SetText(lootInfo.item)
			text1:SetJustifyH("LEFT")
			text1:SetWordWrap(false)

			maxLength3 = math.max(icon1:GetStringWidth()+text1:GetStringWidth()+text2:GetStringWidth(), maxLength3)
		end

		if app.FilteredRow then
			if #app.FilteredRow >= 1 then
				for i, row in ipairs(app.FilteredRow) do
					if i == 1 then
						row:SetPoint("TOPLEFT", app.Window.Filtered, "BOTTOMLEFT")
						row:SetPoint("TOPRIGHT", app.Window.Filtered, "BOTTOMRIGHT")
					else
						local offset = -16*(i-1)
						row:SetPoint("TOPLEFT", app.Window.Filtered, "BOTTOMLEFT", 0, offset)
						row:SetPoint("TOPRIGHT", app.Window.Filtered, "BOTTOMRIGHT", 0, offset)
					end
				end
			end
		end
		
		-- Enable the clear button
		app.ClearButton:Enable()
	end

	-- Hide rows that should be hidden
	if #app.WeaponRow >=1 and app.ShowWeapons == false then
		for i, row in pairs(app.WeaponRow) do
			row:Hide()
		end
	end
	if #app.ArmourRow >=1 and app.ShowArmour == false then
		for i, row in pairs(app.ArmourRow) do
			row:Hide()
		end
	end
	if #app.FilteredRow >=1 and app.ShowFiltered == false then
		for i, row in pairs(app.FilteredRow) do
			row:Hide()
		end
	end

	-- Corner button
	app.Window.Corner:SetScript("OnDoubleClick", function (self, button)
		local windowHeight = 66
		local windowWidth = 0
		if app.ShowWeapons == true then
			windowHeight = windowHeight + #app.WeaponLoot * 16
			windowWidth = math.max(windowWidth, maxLength1)
		end
		if app.ShowArmour == true then
			windowHeight = windowHeight + #app.ArmourLoot * 16
			windowWidth = math.max(windowWidth, maxLength2)
		end
		if app.ShowFiltered == true then
			windowHeight = windowHeight + #app.FilteredLoot * 16
			windowWidth = math.max(windowWidth, maxLength3)
		end
		if windowHeight > 600 then windowHeight = 600 end
		if windowWidth > 600 then windowWidth = 600 end
		app.Window:SetHeight(math.max(140,windowHeight))
		app.Window:SetWidth(math.max(140,windowWidth+40))
		app.Window.ScrollFrame:SetVerticalScroll(0)
		app.SaveWindow()
	end)
	app.Window.Corner:SetScript("OnEnter", function()
		app.WindowTooltipShow(app.CornerButtonTooltip)
	end)
	app.Window.Corner:SetScript("OnLeave", function()
		app.CornerButtonTooltip:Hide()
	end)
end

-- Create assets
function app.CreateGeneralAssets()
	-- Create Loot header tooltip
	app.LootHeaderTooltip = app.WindowTooltip("|RLMB|cffFFFFFF: Whisper and request the item.\n|RShift+LMB|cffFFFFFF: Link the item.\n|RRMB|cffFFFFFF: Remove the item.")

	-- Create Close button tooltip
	app.CloseButtonTooltip = app.WindowTooltip("Close the window.")

	-- Create Clear button tooltip
	app.ClearButtonTooltip = app.WindowTooltip("Clear all items. Shift+click to skip the confirmation.")

	-- Create corner button tooltip
	app.CornerButtonTooltip = app.WindowTooltip("Double-click|cffFFFFFF: Autosize to fit the window.")
end

-- Show window
function app.Show()
	-- Set window to its proper position and size
	app.Window:ClearAllPoints()
	app.Window:SetSize(TransmogLootHelper_Settings["windowPosition"].width, TransmogLootHelper_Settings["windowPosition"].height)
	app.Window:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", TransmogLootHelper_Settings["windowPosition"].left, TransmogLootHelper_Settings["windowPosition"].bottom)

	-- Show the windows
	app.Window:Show()
	app.UpdateWindow()
end

-- Toggle window
function app.Toggle()
	-- Toggle tracking windows
	if app.Window:IsShown() then
		app.Window:Hide()
	else
		app.Show()
	end
end

function app.Clear()
	app.WeaponLoot = {}
	app.ArmourLoot = {}
	app.FilteredLoot = {}
	app.UpdateWindow()
end

-- Open settings
function app.OpenSettings()
	Settings.OpenToCategory(app.Category:GetID())
end

-- Settings and minimap icon
function app.Settings()
	-- Settings page
	function app.SettingChanged(_, setting, value)
		local variable = setting:GetVariable()
		TransmogLootHelper_Settings[variable] = value
	end

	local category, layout = Settings.RegisterVerticalLayoutCategory(app.NameLong)
	Settings.RegisterAddOnCategory(category)
	app.Category = category

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(C_AddOns.GetAddOnMetadata("TransmogLootHelper", "Version")))

	local variable, name, tooltip = "collectMode", "Collection Mode", "Set when "..app.NameShort.." should show new transmog looted by others."
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, "Appearances", "Only show items if they are a new appearance.")
		container:Add(2, "Sources", "Show items if they are a new source, including for known appearances.")
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, name, variable, Settings.VarType.Number, TransmogLootHelper_Settings[variable])
	Settings.CreateDropDown(category, setting, GetOptions, tooltip)
	Settings.SetOnValueChangedCallback(variable, app.SettingChanged)

	local variable, name, tooltip = "usableMog", "Only Usable Transmog", "Only show usable transmog (weapons you can equip, and your armor class)."
	local setting = Settings.RegisterAddOnSetting(category, name, variable, Settings.VarType.Boolean, TransmogLootHelper_Settings[variable])
	local parentSetting = Settings.CreateCheckBox(category, setting, tooltip)
	Settings.SetOnValueChangedCallback(variable, app.SettingChanged)

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
	local setting = Settings.RegisterAddOnSetting(category, name, variable, Settings.VarType.Number, TransmogLootHelper_Settings[variable])
	Settings.CreateDropDown(category, setting, GetOptions, tooltip)
	Settings.SetOnValueChangedCallback(variable, app.SettingChanged)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Information"))

	local variable, name, tooltip = "", "Slash commands", "Type these in chat to use them!"
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, "/tlh", "Toggle the window.")
		container:Add(2, "/tlh settings", "Open these settings.")
		container:Add(3, "/tlh default", "Set the whisper message to its default.")
		container:Add(4, "/tlh msg |cff1B9C85message|R", "Customise the whisper message.")
		container:Add(5, '/run TransmogLootHelper.Debug("|cff1B9C85[item link]|R")', "Debug an item, if it doesn't show when you feel it should.")
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, name, variable, Settings.VarType.Number, "")
	Settings.CreateDropDown(category, setting, GetOptions, tooltip)

	--initializer:AddSearchTags
	--defaults?
end

-- When the AddOn is fully loaded, actually run the components
function event:ADDON_LOADED(addOnName, containsBindings)
	if addOnName == appName then
		app.InitialiseCore()
		app.CreateWindow()
		app.UpdateWindow()
		app.CreateGeneralAssets()
		app.Settings()

		-- Slash commands
		SLASH_PSL1 = "/tlh";
		function SlashCmdList.PSL(msg, editBox)
			-- Split message into command and rest
			local command, rest = msg:match("^(%S*)%s*(.-)$")

			-- Default message
			if command == "default" then
				TransmogLootHelper_Settings["message"] = "Do you need %item? I'd like to have it for transmog. :)"
				app.Print('Message set to: "'..TransmogLootHelper_Settings["message"]..'"')
			-- Customise message
			elseif command == "msg" then
				-- Check if the message is gucci
				local quotes = false
				local item = false
				if string.match(rest, '^".*"$') ~= nil then quotes = true end
				if string.find(rest, "%%item") ~= nil then item = true end
				
				-- Send error messages if not
				if quotes == false then
					app.Print('Error: Wrap your message in quotes: "'..TransmogLootHelper_Settings["message"]..'"')
				elseif item == false then
					app.Print('Error: Include %item in your message: "'..TransmogLootHelper_Settings["message"]..'"')
				-- Edit the message if all is gucci
				else
					TransmogLootHelper_Settings["message"] = rest:gsub('^"(.*)"$', '%1')
					app.Print('Message set to: "'..TransmogLootHelper_Settings["message"]..'"')
				end
			-- Open settings
			elseif command == "settings" then
				app.OpenSettings()
			-- Toggle window
			elseif command == "" then
				app.Toggle()
			end
		end
	end
end

-- When an item is looted
function event:CHAT_MSG_LOOT(text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
	-- Player name
	local playerNameShort = string.match(playerName, "^(.-)-")
	local realmName = string.match(playerName, ".*-(.*)")
	local unitName = playerNameShort, realmName
	local selfName = UnitName("player")

	-- Class colour
	local className, classFilename, classId = UnitClass(unitName)
	local _, _, _, classColor = GetClassColor(classFilename)

	-- Continue only if it's not an item we looted ourselves
	-- if unitName ~= selfName then
		-- Extract item string
		local itemString = string.match(text, "(|cff.-|h%[.-%]|h)")

		-- Get item texture and type
		local _, _, itemQuality, _, _, _, _, _, _, itemTexture, _, classID, subclassID = C_Item.GetItemInfo(itemString)
		local itemType = classID.."."..subclassID

		-- Scan the tooltip for the appearance text, localised
		local function ScanTooltipForAppearanceInfo(itemLink, searchString)
			-- Create a tooltip frame
			local tooltip = CreateFrame("GameTooltip", "MyScanningTooltip", UIParent, "GameTooltipTemplate")
		
			-- Set the tooltip to show the item
			tooltip:SetOwner(UIParent, "ANCHOR_NONE")
			tooltip:SetHyperlink(itemLink)
		
			-- Scan each line of the tooltip for the search string
			for i = 1, tooltip:NumLines() do
				local text = _G["MyScanningTooltipTextLeft" .. i]:GetText()
				if text and text:find(searchString) then
					tooltip:Hide()  -- Hide the tooltip after finding the string
					return true
				end
			end
		
			tooltip:Hide()  -- Hide the tooltip if the string was not found
			return false
		end
		
		-- Do stuff depending on if the appearance or source is new
		if ScanTooltipForAppearanceInfo(itemString, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) or (ScanTooltipForAppearanceInfo(itemString, TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) and TransmogLootHelper_Settings["collectMode"] == 2) then
			-- Rarity filter
			if itemQuality >= TransmogLootHelper_Settings["rarity"] then

				-- Get the player's armor class
				local armorClass
				for k, v in pairs(app.Armor) do
					for _, v2 in pairs(v) do
						if v2 == app.ClassID then
							armorClass = k
						end
					end
				end

				local itemCategory = ""
				local equippable = false
				-- Check if the item can and should be equipped (armor -> class)
				if itemType == "4.0" or itemType == "4.1" or itemType == "4.2" or itemType == "4.3" or itemType == "4.4" then
					itemCategory = "armor"
					if itemType == app.Type[armorClass] or itemType == app.Type["General"] then
						equippable = true
					end
				end
				-- Check if a weapon can be equipped
				for k, v in pairs(app.Type) do
					if v == itemType and not (itemType == "4.0" or itemType == "4.1" or itemType == "4.2" or itemType == "4.3" or itemType == "4.4") then
						itemCategory = "weapon"
						for _, v2 in pairs(app.Weapon[k]) do
							-- Check if the item can and should be equipped (weapon -> spec)
							if v2 == app.ClassID then
								equippable = true
							end
						end
					end
				end

				-- Filter for usable mog, if the setting is applied
				if ((TransmogLootHelper_Settings["usableMog"] == true and equippable == true) or TransmogLootHelper_Settings["usableMog"] == false) and itemCategory ~= nil then
					-- Write it into our loot variable
					if itemCategory == "weapon" then
						app.WeaponLoot[#app.WeaponLoot+1] = { item = itemString, icon = itemTexture, player = playerName, playerShort = playerNameShort, color = classColor, recentlyWhispered = false}
					elseif itemCategory == "armor" then
						app.ArmourLoot[#app.ArmourLoot+1] = { item = itemString, icon = itemTexture, player = playerName, playerShort = playerNameShort, color = classColor, recentlyWhispered = false}
					end

					-- And update the window
					app.Show()
					app.UpdateWindow()
				end
			end
		elseif C_Item.IsEquippableItem(itemString) == true then
			app.FilteredLoot[#app.FilteredLoot+1] = { item = itemString, icon = itemTexture, player = playerName, playerShort = playerNameShort, color = classColor, recentlyWhispered = false}
			app.UpdateWindow()
		end
	-- end
end

-- Debug function
function api.Debug(itemString)
	-- Get item texture and type
	local _, _, itemQuality, _, _, _, _, _, _, itemTexture, _, classID, subclassID = C_Item.GetItemInfo(itemString)
	local itemType = classID.."."..subclassID

	-- APPEARANCE/SOURCE KNOWN
	local appearance

	local function ScanTooltipForAppearanceInfo(itemLink, searchString)
		-- Create a tooltip frame
		local tooltip = CreateFrame("GameTooltip", "MyScanningTooltip", UIParent, "GameTooltipTemplate")
	
		-- Set the tooltip to show the item
		tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		tooltip:SetHyperlink(itemLink)
	
		-- Scan each line of the tooltip for the search string
		for i = 1, tooltip:NumLines() do
			local text = _G["MyScanningTooltipTextLeft" .. i]:GetText()
			if text and text:find(searchString) then
				tooltip:Hide()  -- Hide the tooltip after finding the string
				return true
			end
		end
	
		tooltip:Hide()  -- Hide the tooltip if the string was not found
		return false
	end
	
	if ScanTooltipForAppearanceInfo(itemString, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) then
		appearance = "New appearance"
	elseif ScanTooltipForAppearanceInfo(itemString, TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) then
		appearance = "New Source"
	else
		appearance = "Known appearance"
	end

	-- ARMOR CLASS
	local armorClass
	for k, v in pairs(app.Armor) do
		for _, v2 in pairs(v) do
			if v2 == app.ClassID then
				armorClass = k
			end
		end
	end

	local itemCategory = ""
	local equippable = false
	-- Check if the item can and should be equipped (armor -> class)
	if itemType == "4.0" or itemType == "4.1" or itemType == "4.2" or itemType == "4.3" or itemType == "4.4" then
		itemCategory = "armor"
		if itemType == app.Type[armorClass] or itemType == app.Type["General"] then
			equippable = true
		end
	end
	-- Check if a weapon can be equipped
	for k, v in pairs(app.Type) do
		if v == itemType and not (itemType == "4.0" or itemType == "4.1" or itemType == "4.2" or itemType == "4.3" or itemType == "4.4") then
			itemCategory = "weapon"
			for _, v2 in pairs(app.Weapon[k]) do
				-- Check if the item can and should be equipped (weapon -> spec)
				if v2 == app.ClassID then
					equippable = true
				end
			end
		end
	end

	if equippable == true then
		equippable = "true"
	else
		equippable = "false"
	end

	-- Print it all
	app.Print("DEBUG: "..itemString.."  |  Appearance: "..appearance.."  |  Rarity: "..itemQuality.."  |  CharArmorClass: "..armorClass.."  |  ItemType: "..itemType.."  |  ItemCategory: "..itemCategory.."  |  Equippable: "..equippable)
end