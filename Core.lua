------------------------------------
-- Transmog Loot Helper: Core.lua --
------------------------------------
-- Main AddOn code

-- Initialisation
local appName, app = ...	-- Returns the AddOn name and a unique table
app.api = {}	-- Create a table to use for our "API"
TransmogLootHelper = app.api	-- Create a namespace for our "API"
local api = app.api	-- Our "API" prefix

---------------------------
-- WOW API EVENT HANDLER --
---------------------------

app.Event = CreateFrame("Frame")
app.Event.handlers = {}

-- Register the event and add it to the handlers table
function app.Event:Register(eventName, func)
    if not self.handlers[eventName] then
        self.handlers[eventName] = {}
        self:RegisterEvent(eventName)
    end
    table.insert(self.handlers[eventName], func)
end

-- Run all handlers for a given event, when it fires
app.Event:SetScript("OnEvent", function(self, event, ...)
    if self.handlers[event] then
        for _, handler in ipairs(self.handlers[event]) do
            handler(...)
        end
    end
end)


----------------------
-- HELPER FUNCTIONS --
----------------------

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
	
	-- Enable default user settings
	if TransmogLootHelper_Settings["hide"] == nil then TransmogLootHelper_Settings["hide"] = false end
	if TransmogLootHelper_Settings["message"] == nil then TransmogLootHelper_Settings["message"] = "Do you need the %item you looted? If not, I'd like to have it for transmog. :)" end
	if TransmogLootHelper_Settings["windowPosition"] == nil then TransmogLootHelper_Settings["windowPosition"] = { ["left"] = 1295, ["bottom"] = 836, ["width"] = 200, ["height"] = 200, } end
	if TransmogLootHelper_Settings["windowLocked"] == nil then TransmogLootHelper_Settings["windowLocked"] = false end
	if TransmogLootHelper_Settings["windowSort"] == nil then TransmogLootHelper_Settings["windowSort"] = 1 end

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
	app.ClassID = PlayerUtil.GetClassID()
	app.Whispered = {}
	app.Flag = {}
	app.Flag["lastUpdate"] = 0
	app.Flag["versionCheck"] = 0

	-- Register our AddOn communications channel
	C_ChatInfo.RegisterAddonMessagePrefix("TransmogLootHelp")
end

-- When the AddOn is fully loaded, actually run the components
app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.InitialiseCore()
		app.CreateWindow()
		app.Update()
		app.CreateGeneralAssets()
		app.MessagePopup()
		app.ItemOverlayHooks()
		app.Settings()

		-- Slash commands
		SLASH_TransmogLootHelper1 = "/tlh";
		function SlashCmdList.TransmogLootHelper(msg, editBox)
			-- Split message into command and rest
			local command, rest = msg:match("^(%S*)%s*(.-)$")

			-- Default message
			if command == "default" then
				TransmogLootHelper_Settings["message"] = "Do you need the %item you looted? If not, I'd like to have it for transmog. :)"
				app.Print('Message set to: "'..TransmogLootHelper_Settings["message"]..'"')
			-- Customise message
			elseif command == "msg" then
				app.RenamePopup:Show()
			-- Open settings
			elseif command == "settings" then
				app.OpenSettings()
			-- Reset window positions
			elseif command == "resetpos" then
				-- Set the window size and position back to default
				TransmogLootHelper_Settings["windowPosition"] = { ["left"] = GetScreenWidth()/2-100, ["bottom"] = GetScreenHeight()/2-100, ["width"] = 200, ["height"] = 200, }
				TransmogLootHelper_Settings["pcWindowPosition"] = TransmogLootHelper_Settings["windowPosition"]

				-- Show the window, which will also run setting its size and position
				app.Show()
			-- Toggle window
			elseif command == "" then
				app.Toggle()
			end
		end
	end
end)

------------
-- WINDOW --
------------

-- Move the window
function app.MoveWindow()
	if TransmogLootHelper_Settings["windowLocked"] then
		-- Highlight the Unlock button
		app.UnlockButton:LockHighlight()
	else
		-- Start moving the window, and hide any visible tooltips
		app.Window:StartMoving()
		GameTooltip:ClearLines()
		GameTooltip:Hide()
	end
end

-- Save the window position and size
function app.SaveWindow()
	-- Stop highlighting the unlock button
	app.UnlockButton:UnlockHighlight()

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
	app.Window:SetClampedToScreen(true)
	app.Window:SetResizable(true)
	app.Window:SetResizeBounds(140, 140, 600, 600)
	app.Window:RegisterForDrag("LeftButton")
	app.Window:SetScript("OnDragStart", function() app.MoveWindow() end)
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
	local close = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
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

	-- Lock button
	app.LockButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.LockButton:SetPoint("TOPRIGHT", close, "TOPLEFT", -2, 0)
	app.LockButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.LockButton:GetNormalTexture():SetTexCoord(183/256, 219/256, 1/128, 39/128)
	app.LockButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.LockButton:GetDisabledTexture():SetTexCoord(183/256, 219/256, 41/128, 79/128)
	app.LockButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.LockButton:GetPushedTexture():SetTexCoord(183/256, 219/256, 81/128, 119/128)
	app.LockButton:SetScript("OnClick", function()
		TransmogLootHelper_Settings["windowLocked"] = true
		app.Window.Corner:Hide()
		app.LockButton:Hide()
		app.UnlockButton:Show()
	end)
	app.LockButton:SetScript("OnEnter", function()
		app.WindowTooltipShow(app.LockButtonTooltip)
	end)
	app.LockButton:SetScript("OnLeave", function()
		app.LockButtonTooltip:Hide()
	end)

	-- Unlock button
	app.UnlockButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.UnlockButton:SetPoint("TOPRIGHT", close, "TOPLEFT", -2, 0)
	app.UnlockButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.UnlockButton:GetNormalTexture():SetTexCoord(148/256, 184/256, 1/128, 39/128)
	app.UnlockButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.UnlockButton:GetDisabledTexture():SetTexCoord(148/256, 184/256, 41/128, 79/128)
	app.UnlockButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.UnlockButton:GetPushedTexture():SetTexCoord(148/256, 184/256, 81/128, 119/128)
	app.UnlockButton:SetScript("OnClick", function()
		TransmogLootHelper_Settings["windowLocked"] = false
		app.Window.Corner:Show()
		app.LockButton:Show()
		app.UnlockButton:Hide()
	end)
	app.UnlockButton:SetScript("OnEnter", function()
		app.WindowTooltipShow(app.UnlockButtonTooltip)
	end)
	app.UnlockButton:SetScript("OnLeave", function()
		app.UnlockButtonTooltip:Hide()
	end)

	if TransmogLootHelper_Settings["windowLocked"] then
		app.Window.Corner:Hide()
		app.LockButton:Hide()
		app.UnlockButton:Show()
	else
		app.Window.Corner:Show()
		app.LockButton:Show()
		app.UnlockButton:Hide()
	end

	-- Settings button
	app.SettingsButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.SettingsButton:SetPoint("TOPRIGHT", app.LockButton, "TOPLEFT", -2, 0)
	app.SettingsButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.SettingsButton:GetNormalTexture():SetTexCoord(112/256, 148/256, 1/128, 39/128)
	app.SettingsButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.SettingsButton:GetDisabledTexture():SetTexCoord(112/256, 148/256, 41/128, 79/128)
	app.SettingsButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.SettingsButton:GetPushedTexture():SetTexCoord(112/256, 148/256, 81/128, 119/128)
	app.SettingsButton:SetScript("OnClick", function()
		app.OpenSettings()
	end)
	app.SettingsButton:SetScript("OnEnter", function()
		app.WindowTooltipShow(app.SettingsButtonTooltip)
	end)
	app.SettingsButton:SetScript("OnLeave", function()
		app.SettingsButtonTooltip:Hide()
	end)

	-- Clear button
	app.ClearButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.ClearButton:SetPoint("TOPRIGHT", app.SettingsButton, "TOPLEFT", -2, 0)
	app.ClearButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.ClearButton:GetNormalTexture():SetTexCoord(1/256, 37/256, 1/128, 39/128)
	app.ClearButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.ClearButton:GetDisabledTexture():SetTexCoord(1/256, 37/256, 41/128, 79/128)
	app.ClearButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.ClearButton:GetPushedTexture():SetTexCoord(1/256, 37/256, 81/128, 119/128)
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

	-- Sort button
	app.SortButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.SortButton:SetPoint("TOPRIGHT", app.ClearButton, "TOPLEFT", -2, 0)
	app.SortButton:SetNormalTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.SortButton:GetNormalTexture():SetTexCoord(76/256, 112/256, 1/128, 39/128)
	app.SortButton:SetDisabledTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.SortButton:GetDisabledTexture():SetTexCoord(76/256, 112/256, 41/128, 79/128)
	app.SortButton:SetPushedTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\buttons.blp")
	app.SortButton:GetPushedTexture():SetTexCoord(76/256, 112/256, 81/128, 119/128)
	app.SortButton:SetScript("OnClick", function()
		if TransmogLootHelper_Settings["windowSort"] == 1 then
			TransmogLootHelper_Settings["windowSort"] = 2
			app.SortButtonTooltip1:Hide()
			app.WindowTooltipShow(app.SortButtonTooltip2)
		elseif TransmogLootHelper_Settings["windowSort"] == 2 then
			TransmogLootHelper_Settings["windowSort"] = 1
			app.SortButtonTooltip2:Hide()
			app.WindowTooltipShow(app.SortButtonTooltip1)
		end
		app.Update()
	end)
	app.SortButton:SetScript("OnEnter", function()
		if TransmogLootHelper_Settings["windowSort"] == 1 then
			app.WindowTooltipShow(app.SortButtonTooltip1)
		elseif TransmogLootHelper_Settings["windowSort"] == 2 then
			app.WindowTooltipShow(app.SortButtonTooltip2)
		end
	end)
	app.SortButton:SetScript("OnLeave", function()
		app.SortButtonTooltip1:Hide()
		app.SortButtonTooltip2:Hide()
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
function app.Update()
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

	-- Create Weapons header
	if not app.Window.Weapons then
		app.Window.Weapons = CreateFrame("Button", nil, app.Window.Child)
		app.Window.Weapons:SetSize(0,16)
		app.Window.Weapons:SetPoint("TOPLEFT", app.Window.Child, -1, 0)
		app.Window.Weapons:SetPoint("RIGHT", app.Window.Child)
		app.Window.Weapons:RegisterForDrag("LeftButton")
		app.Window.Weapons:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		app.Window.Weapons:SetScript("OnDragStart", function() app.MoveWindow() end)
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
			"|cnIQ6",	-- Artifact
			"|cnIQ5",	-- Legendary
			"|cnIQ4",	-- Epic
			"|cnIQ3",	-- Rare
			"|cnIQ2",	-- Uncommon
			"|cnIQ1",	-- Common
			"|cnIQ0",	-- Poor (quantity 0)
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

		if TransmogLootHelper_Settings["windowSort"] == 1 then
			table.sort(weaponsSorted, customSort)
		elseif TransmogLootHelper_Settings["windowSort"] == 2 then
			table.sort(weaponsSorted, function(a, b) return a.index > b.index end)
		end

		-- Create rows
		for _, lootInfo in ipairs(weaponsSorted) do
			rowNo1 = rowNo1 + 1

			local row = CreateFrame("Button", nil, app.Window.Weapons)
			row:SetSize(0,16)
			row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
			row:RegisterForDrag("LeftButton")
			row:RegisterForClicks("AnyDown")
			row:SetScript("OnDragStart", function() app.MoveWindow() end)
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

				-- Check if empty line has been added
				local emptyLine = false

				-- If the player who looted the item learned an appearance from it
				if app.WeaponLoot[lootInfo.index].icon == app.IconMog then
					GameTooltip:AddLine(" ")
					emptyLine = true
					GameTooltip:AddLine("|T"..app.IconMog..":0|t |c"..lootInfo.color..lootInfo.playerShort.."|R collected an appearance from this item")
				end

				-- Show how many times the player has been whispered by TLH users
				local count = 0
				if app.Whispered[lootInfo.player] then
					count = app.Whispered[lootInfo.player]
				end
				if count >= 1 and emptyLine == false then
					GameTooltip:AddLine(" ")
				end
				if count == 1 then
					GameTooltip:AddLine("|c"..lootInfo.color..lootInfo.playerShort.."|R has been whispered by "..app.NameShort.." users "..count.." time")
				elseif count > 1 then
					GameTooltip:AddLine("|c"..lootInfo.color..lootInfo.playerShort.."|R has been whispered by "..app.NameShort.." users "..count.." times")
				end
				
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
						if app.WeaponLoot[lootInfo.index].recentlyWhispered == 0 then
							-- Send whisper message
							local msg = string.gsub(TransmogLootHelper_Settings["message"], "%%item", lootInfo.item)
							SendChatMessage(msg, "WHISPER", "", lootInfo.player)
							-- Share with TLH users that we whispered this player
							local message = "player:"..lootInfo.player
							app.SendAddonMessage(message)

							-- Add a timeout to prevent spamming
							local whisperTime = GetServerTime()
							app.WeaponLoot[lootInfo.index].recentlyWhispered = whisperTime
							C_Timer.After(30, function()
								for k, v in ipairs(app.WeaponLoot) do
									if v.recentlyWhispered == whisperTime then
										v.recentlyWhispered = 0
									end
								end
							end)
						elseif app.WeaponLoot[lootInfo.index].recentlyWhispered ~= 0 then
							app.Print("You may only whisper a player once every 30 seconds per item.")
						end
					end
				-- Shift+RMB
				elseif button == "RightButton" and IsShiftKeyDown() then
					-- Remove the item
					table.remove(app.WeaponLoot, lootInfo.index)
					-- And update the window
					RunNextFrame(app.Update)
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

	-- Create Armour header
	if not app.Window.Armour then
		app.Window.Armour = CreateFrame("Button", nil, app.Window.Child)
		app.Window.Armour:SetSize(0,16)
		app.Window.Armour:SetPoint("TOPLEFT", app.Window.Child, -1, 0)
		app.Window.Armour:SetPoint("RIGHT", app.Window.Child)
		app.Window.Armour:RegisterForDrag("LeftButton")
		app.Window.Armour:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		app.Window.Armour:SetScript("OnDragStart", function() app.MoveWindow() end)
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
	if #app.WeaponLoot >= 1 and app.ShowWeapons == true then offset = -16*#app.WeaponLoot end
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
			"|cnIQ6",	-- Artifact
			"|cnIQ5",	-- Legendary
			"|cnIQ4",	-- Epic
			"|cnIQ3",	-- Rare
			"|cnIQ2",	-- Uncommon
			"|cnIQ1",	-- Common
			"|cnIQ0",	-- Poor (quantity 0)
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

		if TransmogLootHelper_Settings["windowSort"] == 1 then
			table.sort(armourSorted, customSort)
		elseif TransmogLootHelper_Settings["windowSort"] == 2 then
			table.sort(armourSorted, function(a, b) return a.index > b.index end)
		end

		-- Create rows
		for _, lootInfo in ipairs(armourSorted) do
			rowNo2 = rowNo2 + 1

			local row = CreateFrame("Button", nil, app.Window.Armour)
			row:SetSize(0,16)
			row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
			row:RegisterForDrag("LeftButton")
			row:RegisterForClicks("AnyDown")
			row:SetScript("OnDragStart", function() app.MoveWindow() end)
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

				-- Check if empty line has been added
				local emptyLine = false

				-- If the player who looted the item learned an appearance from it
				if app.ArmourLoot[lootInfo.index].icon == app.IconMog then
					GameTooltip:AddLine(" ")
					emptyLine = true
					GameTooltip:AddLine("|T"..app.IconMog..":0|t |c"..lootInfo.color..lootInfo.playerShort.."|R collected an appearance from this item")
				end

				-- Show how many times the player has been whispered by TLH users
				local count = 0
				if app.Whispered[lootInfo.player] then
					count = app.Whispered[lootInfo.player]
				end
				if count >= 1 and emptyLine == false then
					GameTooltip:AddLine(" ")
				end
				if count == 1 then
					GameTooltip:AddLine("|c"..lootInfo.color..lootInfo.playerShort.."|R has been whispered by "..app.NameShort.." users "..count.." time")
				elseif count > 1 then
					GameTooltip:AddLine("|c"..lootInfo.color..lootInfo.playerShort.."|R has been whispered by "..app.NameShort.." users "..count.." times")
				end

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
						if app.ArmourLoot[lootInfo.index].recentlyWhispered == 0 then
							-- Send whisper message
							local msg = string.gsub(TransmogLootHelper_Settings["message"], "%%item", lootInfo.item)
							SendChatMessage(msg, "WHISPER", "", lootInfo.player)
							-- Share with TLH users that we whispered this player
							local message = "player:"..lootInfo.player
							app.SendAddonMessage(message)

							-- Add a timeout to prevent spamming
							local whisperTime = GetServerTime()
							app.ArmourLoot[lootInfo.index].recentlyWhispered = whisperTime
							C_Timer.After(30, function()
								for k, v in ipairs(app.ArmourLoot) do
									if v.recentlyWhispered == whisperTime then
										v.recentlyWhispered = 0
									end
								end
							end)
						elseif app.ArmourLoot[lootInfo.index].recentlyWhispered ~= 0 then
							app.Print("You may only whisper a player once every 30 seconds per item.")
						end
					end
				-- Shift+RMB
				elseif button == "RightButton" and IsShiftKeyDown() then
					-- Remove the item
					table.remove(app.ArmourLoot, lootInfo.index)
					-- And update the window
					RunNextFrame(app.Update)
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

	-- Create Filtered header
	if not app.Window.Filtered then
		app.Window.Filtered = CreateFrame("Button", nil, app.Window.Child)
		app.Window.Filtered:SetSize(0,16)
		app.Window.Filtered:SetPoint("TOPLEFT", app.Window.Child, -1, 0)
		app.Window.Filtered:SetPoint("RIGHT", app.Window.Child)
		app.Window.Filtered:RegisterForDrag("LeftButton")
		app.Window.Filtered:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		app.Window.Filtered:SetScript("OnDragStart", function() app.MoveWindow() end)
		app.Window.Filtered:SetScript("OnDragStop", function() app.SaveWindow() end)
		app.Window.Filtered:SetScript("OnEnter", function()
			app.WindowTooltipShow(app.FilteredHeaderTooltip)
		end)
		app.Window.Filtered:SetScript("OnLeave", function()
			app.FilteredHeaderTooltip:Hide()
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

	-- Update header
	local offset = -2
	if #app.ArmourLoot >= 1 and app.ShowArmour == true then offset = -16*#app.ArmourLoot end
	app.Window.Filtered:SetPoint("TOPLEFT", app.Window.Armour, "BOTTOMLEFT", 0, offset)
	if #app.FilteredLoot >= 100 then
		app.FilteredHeader:SetText("Filtered (100+)")
	elseif #app.FilteredLoot >= 1 then
		app.FilteredHeader:SetText("Filtered ("..#app.FilteredLoot..")")
	else
		app.FilteredHeader:SetText("Filtered")
	end

	-- If there is loot to process
	if #app.FilteredLoot >= 1 then
		-- Custom comparison function based on the beginning of the string & a key (thanks ChatGPT)
		local customSortList = {
			"|cnIQ6",	-- Artifact
			"|cnIQ5",	-- Legendary
			"|cnIQ4",	-- Epic
			"|cnIQ3",	-- Rare
			"|cnIQ2",	-- Uncommon
			"|cnIQ1",	-- Common
			"|cnIQ0",	-- Poor (quantity 0)
		}
		local function customSort(a, b)
			-- Primary sort by playerShort
			if a.playerShort ~= b.playerShort then
				return a.playerShort < b.playerShort
			end
			
			-- Secondary sort by item quality
			for _, v in ipairs(customSortList) do
				local indexA = string.find(a.item, v, 1, true)
				local indexB = string.find(b.item, v, 1, true)
		
				if indexA == 1 and indexB ~= 1 then
					return true
				elseif indexA ~= 1 and indexB == 1 then
					return false
				end
			end
		
			-- If custom sort index is the same, compare alphabetically by the remaining part of the item string
			return string.gsub(a.item, ".-(:%|h)", "") < string.gsub(b.item, ".-(:%|h)", "")
		end

		-- Sort loot
		local filteredSorted = {}
		for k, v in pairs(app.FilteredLoot) do
			filteredSorted[#filteredSorted+1] = { item = v.item, icon = v.icon, player = v.player, playerShort = v.playerShort, color = v.color, itemType = v.itemType, index = k}
		end

		if TransmogLootHelper_Settings["windowSort"] == 1 then
			table.sort(filteredSorted, customSort)
		elseif TransmogLootHelper_Settings["windowSort"] == 2 then
			table.sort(filteredSorted, function(a, b) return a.index > b.index end)
		end

		-- Create rows
		for _, lootInfo in ipairs(filteredSorted) do
			rowNo3 = rowNo3 + 1

			local row = CreateFrame("Button", nil, app.Window.Filtered)
			row:SetSize(0,16)
			row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
			row:RegisterForDrag("LeftButton")
			row:RegisterForClicks("AnyDown")
			row:SetScript("OnDragStart", function() app.MoveWindow() end)
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
						app.Print("Debugging "..lootInfo.item.."  |  Filter reason: "..lootInfo.playerShort.."  |  itemType: "..lootInfo.itemType.."  |  Looted by: "..lootInfo.player)
					end
				-- Shift+RMB
				elseif button == "RightButton" and IsShiftKeyDown() then
					-- Remove the item
					table.remove(app.FilteredLoot, lootInfo.index)
					-- And update the window
					RunNextFrame(app.Update)
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
		local windowHeight = 64
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
	-- Create Weapons/Armour header tooltip
	app.LootHeaderTooltip = app.WindowTooltip("|RLMB|cffFFFFFF: Whisper and request the item\n|RShift+LMB|cffFFFFFF: Link the item\n|RShift+RMB|cffFFFFFF: Remove the item")

	-- Create Filtered header tooltip
	app.FilteredHeaderTooltip = app.WindowTooltip("|RLMB|cffFFFFFF: Debug this item\n|RShift+LMB|cffFFFFFF: Link the item\n|RShift+RMB|cffFFFFFF: Remove the item")

	-- Create Close button tooltip
	app.CloseButtonTooltip = app.WindowTooltip("Close the window")

	-- Create Lock/Unlock button tooltip
	app.LockButtonTooltip = app.WindowTooltip("Lock the window")
	app.UnlockButtonTooltip = app.WindowTooltip("Unlock the window")

	-- Create Settings button tooltip
	app.SettingsButtonTooltip = app.WindowTooltip("Open the settings")

	-- Create Clear button tooltip
	app.ClearButtonTooltip = app.WindowTooltip("Clear all items\nHold Shift to skip confirmation")

	-- Create Sort button tooltip
	app.SortButtonTooltip1 = app.WindowTooltip("Sort the items by newest first\nCurrent sorting:|cffFFFFFF alphabetical|R")
	app.SortButtonTooltip2 = app.WindowTooltip("Sort the items alphabetically\nCurrent sorting:|cffFFFFFF newest first|R")

	-- Create corner button tooltip
	app.CornerButtonTooltip = app.WindowTooltip("Double-click|cffFFFFFF: Autosize to fit the window")
end

-- Show window
function app.Show()
	-- Set window to its proper position and size
	app.Window:ClearAllPoints()
	app.Window:SetSize(TransmogLootHelper_Settings["windowPosition"].width, TransmogLootHelper_Settings["windowPosition"].height)
	app.Window:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", TransmogLootHelper_Settings["windowPosition"].left, TransmogLootHelper_Settings["windowPosition"].bottom)

	-- Show the windows
	app.Window:Show()
	app.Update()
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

-- Clear all entries
function app.Clear()
	app.WeaponLoot = {}
	app.ArmourLoot = {}
	app.FilteredLoot = {}
	app.Update()
end

-------------------
-- ITEM TRACKING --
-------------------

-- Delay open/update window
function app.Stagger(t, show)
	C_Timer.After(t, function()
		-- If it's been at least t seconds
		if GetServerTime() - app.Flag["lastUpdate"] >= t then
			if show and TransmogLootHelper_Settings["autoOpen"] then
				app.Show()
			else
				app.Update()
			end
		-- Otherwise, check one more time with double delay
		else
			C_Timer.After(t, function()
				-- If it's been at least t seconds
				if GetServerTime() - app.Flag["lastUpdate"] >= t then
					if show and TransmogLootHelper_Settings["autoOpen"] then
						app.Show()
					else
						app.Update()
					end
				end
			end)
		end
	end)
end

-- Get an item's SourceID (thank you Plusmouse!)
function app.GetSourceID(itemLink)
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
	if sourceID then
		return sourceID
	end

	local _, sourceID = C_TransmogCollection.GetItemInfo((C_Item.GetItemInfoInstant(itemLink)))
	return sourceID
end

-- Check if an item's appearance is collected (thank you Plusmouse!)
function api.IsAppearanceCollected(itemLink)
	local sourceID = app.GetSourceID(itemLink)
	if not sourceID then
		if app.GetTooltipText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) then
			return false
		else
			return true	-- Should be nil if the item does not have an appearance, but for our purposes this is fine
		end
	else
		local subClass = select(7, C_Item.GetItemInfoInstant(itemLink))
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		local allSources = C_TransmogCollection.GetAllAppearanceSources(sourceInfo.visualID)
		if #allSources == 0 then
			allSources = {sourceID}
	  	end

		local anyCollected = false
		for _, alternateSourceID in ipairs(allSources) do
			local altInfo = C_TransmogCollection.GetSourceInfo(alternateSourceID)
			local altSubClass = select(7, C_Item.GetItemInfoInstant(altInfo.itemID))
			if altInfo.isCollected and altSubClass == subClass then
				anyCollected = true
				break
			end
		end
		return anyCollected
	end
end

-- Check if an item's source is collected (thank you Plusmouse!)
function api.IsSourceCollected(itemLink)
	local sourceID = app.GetSourceID(itemLink)
	if not sourceID then
		if app.GetTooltipText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) or app.GetTooltipText(itemLink, TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) then
			return false
		else
			return true	-- Should be nil if the item does not have an appearance, but for our purposes this is fine
		end
	else
		return C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
	end
end

-- Scan the tooltip for any text
function app.GetTooltipText(itemLinkie, searchString)
	-- Grab the original value for this setting
	local cvar = C_CVar.GetCVarInfo("missingTransmogSourceInItemTooltips")
	
	-- Enable this CVar, because we need it if checking for the Blizz text, which we do as a fallback
	C_CVar.SetCVar("missingTransmogSourceInItemTooltips", 1)

	-- Get our tooltip information
	local tooltip = C_TooltipInfo.GetHyperlink(itemLinkie)

	-- Return the CVar to its original setting
	C_CVar.SetCVar("missingTransmogSourceInItemTooltips", cvar)

	-- Read all the lines as plain text
	if tooltip and tooltip["lines"] then
		for k, v in ipairs(tooltip["lines"]) do
			-- And if the search string was found
			if v["leftText"] and v["leftText"]:find(searchString) then
				return true
			end
		end
	end

	-- Otherwise
	return false
end

-- Add to filtered loot and update the window
function app.AddFilteredLoot(itemLink, itemID, itemTexture, playerName, itemType, filterReason)
	-- Add to filtered loot and update the window
	app.FilteredLoot[#app.FilteredLoot+1] = { item = itemLink, itemID = itemID, icon = itemTexture, player = playerName, playerShort = filterReason, color = "ffFFFFFF", itemType = itemType }

	-- Check if the table exceeds 100 entries
	if #app.FilteredLoot > 100 then
		-- Remove the oldest entry
		table.remove(app.FilteredLoot, 1)
	end
	
	-- Stagger show/update the window
	app.Flag["lastUpdate"] = GetServerTime()
	app.Stagger(1, false)
end

-- Remove item and update the window
function app.RemoveLootedItem(itemID)
	for k = #app.WeaponLoot, 1, -1 do
		if app.WeaponLoot[k].itemID == itemID then
			-- Remove entry from table
			table.remove(app.WeaponLoot, k)
		end
	end

	for k = #app.ArmourLoot, 1, -1 do
		if app.ArmourLoot[k].itemID == itemID then
			-- Remove entry from table
			table.remove(app.ArmourLoot, k)
		end
	end

	-- And update the window
	app.Update()
end

-- When an item is looted
app.Event:Register("CHAT_MSG_LOOT", function(text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
	-- Extract item string
	local itemString = string.match(text, "(|cnIQ.-|h%[.-%]|h)")

	-- Only proceed if the item is equippable and a player is specified (aka it is not a need/greed roll)
	if itemString and C_Item.IsEquippableItem(itemString) and guid ~= nil then
		-- Player name
		local playerNameShort = string.match(playerName, "^(.-)-")
		local realmName = string.match(playerName, ".*-(.*)")
		local unitName = playerNameShort, realmName
		local selfName = UnitName("player")

		-- Class colour
		local className, classFilename, classId = UnitClass(unitName)
		local _, _, _, classColor = GetClassColor(classFilename)

		-- Get item info
		local _, itemLink, itemQuality, _, _, _, _, _, itemEquipLoc, itemTexture, _, classID, subclassID = C_Item.GetItemInfo(itemString)
		local itemID = C_Item.GetItemInfoInstant(itemString)
		local itemType = classID.."."..subclassID

		-- Continue only if it's not an item we looted ourselves
		if unitName ~= selfName then
			-- Do stuff depending on if the appearance or source is new
			if not api.IsAppearanceCollected(itemLink) or (not api.IsSourceCollected(itemLink) and TransmogLootHelper_Settings["collectMode"] == 2) then
				-- Remix filter
				if (TransmogLootHelper_Settings["remixFilter"] == true and PlayerGetTimerunningSeasonID() ~= nil and itemQuality < 3)
				-- Or if the item is Account/Warbound
				or app.GetTooltipText(itemLink, ITEM_BIND_TO_ACCOUNT) or app.GetTooltipText(itemLink, ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP) or app.GetTooltipText(itemLink, ITEM_BIND_TO_BNETACCOUNT) or app.GetTooltipText(itemLink, ITEM_BNETACCOUNTBOUND) then
					-- Add to filtered loot and update the window
					app.AddFilteredLoot(itemLink, itemID, itemTexture, playerName, itemType, "Untradeable")
				-- Rarity filter
				elseif itemQuality >= TransmogLootHelper_Settings["rarity"] then
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
					if (itemType == "4.0" and itemEquipLoc ~= "INVTYPE_HOLDABLE") or itemType == "4.1" or itemType == "4.2" or itemType == "4.3" or itemType == "4.4" then
						itemCategory = "armor"
						if itemType == app.Type["General"] or itemEquipLoc == "INVTYPE_CLOAK" or itemType == app.Type[armorClass] then
							equippable = true
						end
					end
					-- Check if a weapon can be equipped
					for k, v in pairs(app.Type) do
						if v == itemType and not ((itemType == "4.0" and itemEquipLoc ~= "INVTYPE_HOLDABLE") or itemType == "4.1" or itemType == "4.2" or itemType == "4.3" or itemType == "4.4") then
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
							app.WeaponLoot[#app.WeaponLoot+1] = { item = itemLink, itemID = itemID, icon = itemTexture, player = playerName, playerShort = playerNameShort, color = classColor, recentlyWhispered = 0 }
						elseif itemCategory == "armor" then
							app.ArmourLoot[#app.ArmourLoot+1] = { item = itemLink, itemID = itemID, icon = itemTexture, player = playerName, playerShort = playerNameShort, color = classColor, recentlyWhispered = 0 }
						end

						-- Stagger show/update the window
						app.Flag["lastUpdate"] = GetServerTime()
						app.Stagger(1, true)
					else
						-- Add to filtered loot and update the window
						app.AddFilteredLoot(itemLink, itemID, itemTexture, playerName, itemType, "Unusable transmog")
					end
				else
					-- Add to filtered loot and update the window
					app.AddFilteredLoot(itemLink, itemID, itemTexture, playerName, itemType, "Rarity too low")
				end
			else
				-- Ignore necks, rings, trinkets (as they never have a learnable appearance)
				if itemType ~= app.Type["General"] or (itemType == app.Type["General"] and itemEquipLoc ~= "INVTYPE_FINGER"	and itemEquipLoc ~= "INVTYPE_TRINKET" and itemEquipLoc ~= "INVTYPE_NECK") then
					-- Add to filtered loot and update the window
					app.AddFilteredLoot(itemLink, itemID, itemTexture, playerName, itemType, "Known appearance")
				end
			end
		end
	end
end)

-- When a new appearance is learned
app.Event:Register("TRANSMOG_COLLECTION_SOURCE_ADDED", function(itemModifiedAppearanceID)
	-- Grab the itemID
	local itemID = C_TransmogCollection.GetSourceInfo(itemModifiedAppearanceID).itemID

	-- Remove it from our own list
	app.RemoveLootedItem(itemID)

	-- Share the itemID with other TLH users
	local message = "itemID:"..itemID
	app.SendAddonMessage(message)
end)

------------------------
-- MESSAGE CUSTOMIZER --
------------------------

-- Pop-up window
function app.MessagePopup()
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

-----------------
-- ADDON COMMS --
-----------------

-- Send information to other TLH users
function app.SendAddonMessage(message)
	-- Check which channel to use
	if IsInRaid(2) or IsInGroup(2) then
		-- Share with instance group first
		ChatThrottleLib:SendAddonMessage("NORMAL", "TransmogLootHelp", message, "INSTANCE_CHAT")
	elseif IsInRaid() then
		-- If not in an instance group, share it with the raid
		ChatThrottleLib:SendAddonMessage("NORMAL", "TransmogLootHelp", message, "RAID")
	elseif IsInGroup() then
		-- If not in a raid group, share it with the party
		ChatThrottleLib:SendAddonMessage("NORMAL", "TransmogLootHelp", message, "PARTY")
	end
end

-- When joining a group
app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	-- Share our AddOn version with other users
	local message = "version:"..C_AddOns.GetAddOnMetadata("TransmogLootHelper", "Version")
	app.SendAddonMessage(message)
end)

-- When we receive information over the addon comms
app.Event:Register("CHAT_MSG_ADDON", function(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	-- If it's our message
	if prefix == "TransmogLootHelp" then
		-- ItemID
		local itemID = tonumber(text:match("itemID:(.+)"))
		if itemID then
			-- Check if it exists in our tables
			for k, v in ipairs(app.WeaponLoot) do
				if v.player == sender and v.itemID == itemID then
					-- And if it does, mark it as new transmog for the looter
					app.WeaponLoot[k].icon = app.IconMog
				end
			end

			for k, v in ipairs(app.ArmourLoot) do
				if v.player == sender and v.itemID == itemID then
					-- And if it does, mark it as new transmog for the looter
					app.ArmourLoot[k].icon = app.IconMog
				end
			end

			-- Stagger show/update the window
			app.Flag["lastUpdate"] = GetServerTime()
			app.Stagger(1, false)
		end

		-- Version
		local version = text:match("version:(.+)")
		if version then
			if version ~= "@project-version@" then
				-- Extract the interface and version from this
				local expansion, major, minor, iteration = version:match("v(%d+)%.(%d+)%.(%d+)%-(%d%d%d)")
				expansion = string.format("%02d", expansion)
				major = string.format("%02d", major)
				minor = string.format("%02d", minor)
				local otherGameVersion = tonumber(expansion..major..minor)
				local otherAddonVersion = tonumber(iteration)

				-- Do the same for our local version
				local localVersion = C_AddOns.GetAddOnMetadata("TransmogLootHelper", "Version")
				if localVersion ~= "@project-version@" then
					expansion, major, minor, iteration = localVersion:match("v(%d+)%.(%d+)%.(%d+)%-(%d%d%d)")
					expansion = string.format("%02d", expansion)
					major = string.format("%02d", major)
					minor = string.format("%02d", minor)
					local localGameVersion = tonumber(expansion..major..minor)
					local localAddonVersion = tonumber(iteration)

					-- Now compare our versions
					if otherGameVersion > localGameVersion or (otherGameVersion == localGameVersion and otherAddonVersion > localAddonVersion) then
						-- But only send the message once every 10 minutes
						if GetServerTime() - app.Flag["versionCheck"] > 600 then
							app.Print("There is a newer version of "..app.NameLong.." available: "..version)
							app.Flag["versionCheck"] = GetServerTime()
						end
					end
				end
			end
		end

		-- Player
		local player = text:match("player:(.+)")
		if player then
			-- Add the user to our table, if it doesn't exist there yet
			if app.Whispered[player] == nil then
				app.Whispered[player] = 0
			end

			-- Add +1 to the amount of times this player has been whispered by TLH users
			for k, v in pairs(app.Whispered) do
				if k == player then
					app.Whispered[k] = app.Whispered[k] + 1
				end
			end		
		end
	end
end)

app.Event:Register("START_LOOT_ROLL", function(rollID, rollTime, lootHandle)
	if TransmogLootHelper_Settings["hideGroupRolls"] and GroupLootHistoryFrame then
		local hidden = false
		GroupLootHistoryFrame:HookScript("OnShow", function()
			if hidden == false then
				GroupLootHistoryFrame:Hide()
				hidden = true
			end
		end)
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

	local variable, name, tooltip = "usableMog", "Only Usable Appearances", "Only show usable appearances (weapons you can equip, and your armor class)."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

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

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Tweaks"))

	local variable, name, tooltip = "hideGroupRolls", "Hide loot roll window", "Hide the window that shows loot rolls and their results. You can show the window again with |cff00ccff/loot|r."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

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
end