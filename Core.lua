------------------------------------
-- Transmog Loot Helper: Core.lua --
------------------------------------

local appName, app = ...
app.locales = {}
app.api = {}
TransmogLootHelper = app.api
local api = app.api
local L = app.locales

---------------------------
-- WOW API EVENT HANDLER --
---------------------------

app.Event = CreateFrame("Frame")
app.Event.handlers = {}

function app.Event:Register(eventName, func)
	if not self.handlers[eventName] then
		self.handlers[eventName] = {}
		self:RegisterEvent(eventName)
	end
	table.insert(self.handlers[eventName], func)
end

app.Event:SetScript("OnEvent", function(self, event, ...)
	if self.handlers[event] then
		for _, handler in ipairs(self.handlers[event]) do
			handler(...)
		end
	end
end)

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Flag = {}
		app.Tooltip = {}

		C_ChatInfo.RegisterAddonMessagePrefix("TransmogLootHelp")
		app:CreateSlashCommands()
	end
end)

-------------------
-- VERSION COMMS --
-------------------

function app:SendAddonMessage(message)
	if IsInRaid(2) or IsInGroup(2) then
		ChatThrottleLib:SendAddonMessage("NORMAL", app.NamePrefix, message, "INSTANCE_CHAT")
	elseif IsInRaid() then
		ChatThrottleLib:SendAddonMessage("NORMAL", app.NamePrefix, message, "RAID")
	elseif IsInGroup() then
		ChatThrottleLib:SendAddonMessage("NORMAL", app.NamePrefix, message, "PARTY")
	end
end

app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	local message = "version:" .. C_AddOns.GetAddOnMetadata(appName, "Version")
	app:SendAddonMessage(message)
end)

app.Event:Register("CHAT_MSG_ADDON", function(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	if prefix == app.NamePrefix then
		local version = text:match("version:(.+)")
		if version and not app.Flag.VersionCheck then
			local expansion, major, minor, iteration = version:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
			if expansion then
				expansion = string.format("%02d", expansion)
				major = string.format("%02d", major)
				minor = string.format("%02d", minor)
				local otherGameVersion = tonumber(expansion .. major .. minor)
				local otherAddonVersion = tonumber(iteration)

				local localVersion = C_AddOns.GetAddOnMetadata(appName, "Version")
				local expansion2, major2, minor2, iteration2 = localVersion:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
				if expansion2 then
					expansion2 = string.format("%02d", expansion2)
					major2 = string.format("%02d", major2)
					minor2 = string.format("%02d", minor2)
					local localGameVersion = tonumber(expansion2 .. major2 .. minor2)
					local localAddonVersion = tonumber(iteration2)

					if otherGameVersion > localGameVersion or (otherGameVersion == localGameVersion and otherAddonVersion > localAddonVersion) then
						app:Print(L.NEW_VERSION_AVAILABLE, version)
						app.Flag.VersionCheck = true
					end
				end
			end
		end
	end
end)

--------------------
-- SLASH COMMANDS --
--------------------

function app:CreateSlashCommands()
	SLASH_RELOADUI1 = "/rl"
	SlashCmdList.RELOADUI = ReloadUI

	SLASH_TransmogLootHelper1 = "/tlh"
	function SlashCmdList.TransmogLootHelper(msg, editBox)
		local command, rest = msg:match("^(%S*)%s*(.-)$")

		if command == "default" then
			app.Settings["message"] = L.DEFAULT_MESSAGE
			app:Print(L.WHISPER_POPUP_SUCCESS, "\"" .. app.Settings["message"] .. "\"")
		elseif command == "msg" then
			app.RenamePopup:Show()
		elseif command == "settings" then
			app:OpenSettings()
		elseif command == "resetpos" then
			app.Settings["windowPosition"] = { ["left"] = GetScreenWidth()/2-100, ["bottom"] = GetScreenHeight()/2-100, ["width"] = 200, ["height"] = 200, }
			app.Settings["pcWindowPosition"] = app.Settings["windowPosition"]
			app:ShowWindow()
		elseif command == "delete" then
			api:DeleteCharacter(rest)
		elseif command == "" then
			api:ToggleWindow()
		else
			app:Print(L.INVALID_COMMAND)
		end
	end
end

-----------------------
-- ADDON COMPARTMENT --
-----------------------

function TransmogLootHelper_Click(self, button)
	if button == "LeftButton" then
		api:ToggleWindow()
	elseif button == "RightButton" then
		app:OpenSettings()
	end
end

function TransmogLootHelper_Enter(self, button)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(type(self) ~= "string" and self or button, "ANCHOR_LEFT")
	GameTooltip:AddLine(L.SETTINGS_TOOLTIP)
	GameTooltip:Show()
end

function TransmogLootHelper_Leave()
	GameTooltip:Hide()
end

----------------------
-- HELPER FUNCTIONS --
----------------------

function app:Colour(string)
	return "|cff3FC7EB" .. string .. "|r"
end

function app:Print(...)
	print(app.NameShort .. ":", ...)
end

function app:SetBorder(parent, a, b, c, d)
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

function app:MakeButton(parent, text)
	local frame = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	frame:SetText(text)
	frame:SetWidth(frame:GetTextWidth()+20)

	app:SetBorder(frame, 0, 0, 0, -1)
	return frame
end

function app:GetTooltipText(itemLinkie, searchString)
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

function app:GetTransmogText(itemLinkie, searchString)
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

function app:IsLearned(itemLinkie)
	local tooltip = C_TooltipInfo.GetHyperlink(itemLinkie)

	if tooltip and tooltip.lines then
		for _, line in ipairs(tooltip.lines) do
			if line.requirementType == Enum.TooltipDataUsageRequirementType.NotAlreadyKnown then
				return true
			end
		end
	end
	return false
end

function app:GetLearnedSpell(itemLinkie)
	local tooltip = app.Tooltip[itemLinkie] or C_TooltipInfo.GetHyperlink(itemLinkie)
	app.Tooltip[itemLinkie] = tooltip

	if tooltip and tooltip.lines then
		for _, line in ipairs(tooltip.lines) do
			if line.type == Enum.TooltipDataLineType.ItemSpellTriggerLearn then
				return line.spellID
			end
		end
	end
end

function app:GetBonding(itemLinkie)
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

function app:HasRedTooltipText(itemLink)
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

function app:GetSourceID(itemLink) -- Thank you Plusmouse!
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
	if sourceID then
		return sourceID
	end

	local _, sourceID = C_TransmogCollection.GetItemInfo((C_Item.GetItemInfoInstant(itemLink)))
	return sourceID
end

function api:IsAppearanceCollected(itemLink, sourceID) -- Thank you Plusmouse!
	assert(self == api, "Call TransmogLootHelper:IsAppearanceCollected(), not TransmogLootHelper.IsAppearanceCollected()")

	local sourceID = sourceID or app:GetSourceID(itemLink)
	if not sourceID then
		if app:GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) then
			return false
		else
			return true
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

function api:IsSourceCollected(itemLink, sourceID) -- Thank you Plusmouse!
	assert(self == api, "Call TransmogLootHelper:IsSourceCollected(), not TransmogLootHelper.IsSourceCollected()")

	local sourceID = sourceID or app:GetSourceID(itemLink)
	if not sourceID then
		if app:GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) or app:GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) then
			return false
		else
			return true
		end
	else
		return C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
	end
end
