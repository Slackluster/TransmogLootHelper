------------------------------------
-- Transmog Loot Helper: Core.lua --
------------------------------------

-- Initialisation
local appName, app = ...	-- Returns the addon name and a unique table
app.locales = {}	-- Localisation table
app.api = {}	-- Our "API" prefix
TransmogLootHelper = app.api	-- Create a namespace for our "API"
local L = app.locales
local api = app.api

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
	return "|cff3FC7EB" .. string .. "|R"
end

-- Print with addon prefix
function app.Print(...)
	print(app.NameShort .. ":", ...)
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
	local string = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
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
	border:SetBackdropBorderColor(0.25, 0.78, 0.92)
end

-- Button
function app.Button(parent, text)
	local frame = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	frame:SetText(text)
	frame:SetWidth(frame:GetTextWidth()+20)

	app.Border(frame, 0, 0, 0, -1)
	return frame
end

-- Scan the tooltip for any text
function app.GetTooltipText(itemLinkie, searchString)
	local tooltip = app.Tooltip[itemLinkie] or C_TooltipInfo.GetHyperlink(itemLinkie)
	app.Tooltip[itemLinkie] = tooltip

	if tooltip and tooltip["lines"] then
		for k, v in ipairs(tooltip["lines"]) do
			if v["leftText"] and v["leftText"]:find(searchString) then
				return true
			end
		end
	end
	return false
end

function app.GetTransmogText(itemLinkie, searchString)
	local cvar = C_CVar.GetCVarInfo("missingTransmogSourceInItemTooltips")
	if cvar ~= "1" then C_CVar.SetCVar("missingTransmogSourceInItemTooltips", 1) end
	local tooltip = app.Tooltip[itemLinkie] or C_TooltipInfo.GetHyperlink(itemLinkie)
	app.Tooltip[itemLinkie] = tooltip
	if cvar ~= "1" then C_CVar.SetCVar("missingTransmogSourceInItemTooltips", cvar) end

	if tooltip and tooltip["lines"] then
		for k, v in ipairs(tooltip["lines"]) do
			if v["leftText"] and v["leftText"]:find(searchString) then
				return true
			end
		end
	end
	return false
end

function app.IsLearned(itemLinkie)
	local tooltip = C_TooltipInfo.GetHyperlink(itemLinkie)

	if tooltip and tooltip.lines then
		for _, line in ipairs(tooltip.lines) do
			if line.type == Enum.TooltipDataLineType.RestrictedSpellKnown then
				return true
			end
		end
	end
	return false
end

function app.GetBonding(itemLinkie)
	local tooltip = C_TooltipInfo.GetHyperlink(itemLinkie)

	if tooltip and tooltip.lines then
		for _, line in ipairs(tooltip.lines) do
			if line.bonding then
				if line.bonding == 1 or line.bonding == 2 or line.bonding == 4 or line.bonding == 5 then
					return "BoA"
				elseif line.bonding == 3 or line.bonding == 6 then
					return "BoP"
				elseif line.bonding == 7 or line.bonding == 8 then
					return "BoE"
				elseif line.bonding == 9 or line.bonding == 10 then
					return "WuE"
				end
			end
		end
	end
	return false
end

-- Detect unusable text on tooltips
function app.GetTooltipRedText(itemLink)
	local tooltip = C_TooltipInfo.GetHyperlink(itemLink)
	if tooltip and tooltip["lines"] then
		for k, v in ipairs(tooltip["lines"]) do
			if v.leftColor["r"] == 1 and v.leftColor["g"] > 0.1 and v.leftColor["g"] < 0.2 and v.leftColor["b"] > 0.1 and v.leftColor["b"] < 0.2 then
				return true
			end
		end
		return false
	end
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
		if app.GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) then
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
		if app.GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) or app.GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) then
			return false
		else
			return true	-- Should be nil if the item does not have an appearance, but for our purposes this is fine
		end
	else
		return C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
	end
end

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Flag = {}
		app.Flag.VersionCheck = 0
		app.Tooltip = {}

		C_ChatInfo.RegisterAddonMessagePrefix("TransmogLootHelp")

		SLASH_RELOADUI1 = "/rl"
		SlashCmdList.RELOADUI = ReloadUI

		SLASH_TransmogLootHelper1 = "/tlh"
		function SlashCmdList.TransmogLootHelper(msg, editBox)
			-- Split message into command and rest
			local command, rest = msg:match("^(%S*)%s*(.-)$")

			-- Default message
			if command == "default" then
				TransmogLootHelper_Settings["message"] = L.DEFAULT_MESSAGE
				app.Print(L.WHISPER_POPUP_SUCCESS, "\"" .. TransmogLootHelper_Settings["message"] .. "\"")
			-- Customise message
			elseif command == "msg" then
				app.RenamePopup:Show()
			-- Open settings
			elseif command == "settings" then
				app.OpenSettings()
			-- Reset window positions
			elseif command == "resetpos" then
				TransmogLootHelper_Settings["windowPosition"] = { ["left"] = GetScreenWidth()/2-100, ["bottom"] = GetScreenHeight()/2-100, ["width"] = 200, ["height"] = 200, }
				TransmogLootHelper_Settings["pcWindowPosition"] = TransmogLootHelper_Settings["windowPosition"]
				app.Show()
			-- Delete character from cache
			elseif command == "delete" then
				api.DeleteCharacter(rest)
			-- Toggle window
			elseif command == "" then
				api.Toggle()
			-- Unlisted command
			else
				app.Print(L.INVALID_COMMAND)
			end
		end
	end
end)

-------------------
-- VERSION COMMS --
-------------------

-- Send information to other TLH users
function app.SendAddonMessage(message)
	if IsInRaid(2) or IsInGroup(2) then
		ChatThrottleLib:SendAddonMessage("NORMAL", "TransmogLootHelp", message, "INSTANCE_CHAT")
	elseif IsInRaid() then
		ChatThrottleLib:SendAddonMessage("NORMAL", "TransmogLootHelp", message, "RAID")
	elseif IsInGroup() then
		ChatThrottleLib:SendAddonMessage("NORMAL", "TransmogLootHelp", message, "PARTY")
	end
end

-- When joining a group
app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	local message = "version:" .. C_AddOns.GetAddOnMetadata("TransmogLootHelper", "Version")
	app.SendAddonMessage(message)
end)

-- When we receive information over the addon comms
app.Event:Register("CHAT_MSG_ADDON", function(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	if prefix == "TransmogLootHelp" then
		-- Version
		local version = text:match("version:(.+)")
		if version then
			if version ~= "@project-version@" then
				local expansion, major, minor, iteration = version:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
				expansion = string.format("%02d", expansion)
				major = string.format("%02d", major)
				minor = string.format("%02d", minor)
				local otherGameVersion = tonumber(expansion .. major .. minor)
				local otherAddonVersion = tonumber(iteration)

				local localVersion = C_AddOns.GetAddOnMetadata("TransmogLootHelper", "Version")
				if localVersion ~= "@project-version@" then
					expansion, major, minor, iteration = localVersion:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
					expansion = string.format("%02d", expansion)
					major = string.format("%02d", major)
					minor = string.format("%02d", minor)
					local localGameVersion = tonumber(expansion .. major .. minor)
					local localAddonVersion = tonumber(iteration)

					if otherGameVersion > localGameVersion or (otherGameVersion == localGameVersion and otherAddonVersion > localAddonVersion) then
						if GetServerTime() - app.Flag.VersionCheck > 600 then
							app.Print(L.NEW_VERSION_AVAILABLE, version)
							app.Flag.VersionCheck = GetServerTime()
						end
					end
				end
			end
		end
	end
end)
