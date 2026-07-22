----------------------------------------
-- Transmoog Loot Helper: Inspect.lua --
----------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

----------------
-- ITEM LEVEL --
----------------

app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	app.GroupMembers = {}

	local raid = IsInRaid()
	for i = 1, GetNumGroupMembers() do
		local unit = (raid and "raid" or "party") .. i
		local guid = UnitGUID(unit)

		if guid then
			app.GroupMembers[guid] = { unitToken = unit }
		end
	end
end)

app.Event:Register("INSPECT_READY", function(inspecteeGUID)
	if app.GroupMembers and app.GroupMembers[inspecteeGUID] and app.GroupMembers[inspecteeGUID].slot then
		local itemLevel = {}
		local slot = app.GroupMembers[inspecteeGUID].slot
		if slot == 11 or slot == 13 or slot == 16 then
			for i = slot, slot+1 do
				local itemLink = GetInventoryItemLink(app.GroupMembers[inspecteeGUID].unitToken, i)
				if itemLink then
					table.insert(itemLevel, api:GetItemLevel(itemLink))
				end
			end
		else
			local itemLink = GetInventoryItemLink(app.GroupMembers[inspecteeGUID].unitToken, slot)
			if itemLink then
				table.insert(itemLevel, api:GetItemLevel(itemLink))
			end
		end
		ClearInspectPlayer()

		itemLevel = #itemLevel > 0 and math.min(unpack(itemLevel)) or 9999
		if app.GroupMembers[guid].ilv > itemLevel then
			app:AddFilteredLoot(app.GroupMembers[inspecteeGUID].itemInfo.item, app.GroupMembers[inspecteeGUID].itemInfo.itemID, app.GroupMembers[inspecteeGUID].itemInfo.icon, app.GroupMembers[inspecteeGUID].itemInfo.player, app.GroupMembers[inspecteeGUID].itemInfo.itemType, L.FILTER_REASON_UNTRADEABLE .. "(" .. L.FILTER_REASON_ILV_UPGRADE .. ")")
			print(app.GroupMembers[inspecteeGUID].itemInfo.item .. "is ilv upgrade, untradeable")
		else
			app:AddLoot(app.GroupMembers[inspecteeGUID].itemInfo, app.GroupMembers[inspecteeGUID].itemCategory)
			print(app.GroupMembers[inspecteeGUID].itemInfo.item .. "is not ilv upgrade, tradeable!")
		end
		local unitToken = app.GroupMembers[inspecteeGUID].unitToken
		app.GroupMembers[inspecteeGUID] = { unitToken = unitToken }
	end
end)
