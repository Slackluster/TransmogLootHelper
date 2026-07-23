----------------------------------------
-- Transmoog Loot Helper: Inspect.lua --
----------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.GroupMembers = {}
	end
end)

----------------
-- ITEM LEVEL --
----------------

function app:GetGroupMembers()
	app.GroupMembers = {}

	local raid = IsInRaid()
	for i = 1, GetNumGroupMembers() do
		local unit = (raid and "raid" or "party") .. i
		local guid = UnitGUID(unit)

		if guid and not (app.GroupMembers[guid] and app.GroupMembers[guid].unitToken == unit) then
			app.GroupMembers[guid] = { unitToken = unit }
		end
	end
end

app.Event:Register("PLAYER_ENTERING_WORLD", function(category, partyGUID)
	if IsInGroup() then
		app:GetGroupMembers()
	end
end)

app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	app:GetGroupMembers()
end)

app.Event:Register("INSPECT_READY", function(inspecteeGUID)
	local function inspect(inspecteeGUID)
		if app.GroupMembers[inspecteeGUID] and app.GroupMembers[inspecteeGUID].slot and not app.Flag.Inspecting then
			app.Inspecting = true
			local itemLevel = {}
			local slot = app.GroupMembers[inspecteeGUID].slot
			print(UnitName(app.GroupMembers[inspecteeGUID].unitToken), UnitGUID(app.GroupMembers[inspecteeGUID].unitToken), inspecteeGUID, app.GroupMembers[inspecteeGUID].slot)
			if slot == 11 or slot == 13 or slot == 16 then
				for i = slot, slot+1 do
					local itemLink = GetInventoryItemLink(app.GroupMembers[inspecteeGUID].unitToken, i)
					if itemLink then
						local ilv = api:GetItemLevel(itemLink)
						print(itemLink, ilv)
						table.insert(itemLevel, ilv)
					elseif slot ~= 16 then
						print("no gear found")
					end
				end
			else
				local itemLink = GetInventoryItemLink(app.GroupMembers[inspecteeGUID].unitToken, slot)
				if itemLink then
					local ilv = api:GetItemLevel(itemLink)
					print(itemLink, ilv)
					table.insert(itemLevel, ilv)
				else
					print("no gear found")
				end
			end

			itemLevel = #itemLevel > 0 and math.min(unpack(itemLevel)) or 9999
			if app.GroupMembers[inspecteeGUID].ilv > itemLevel then
				app:AddFilteredLoot(app.GroupMembers[inspecteeGUID].itemInfo.item, app.GroupMembers[inspecteeGUID].itemInfo.itemID, app.GroupMembers[inspecteeGUID].itemInfo.icon, app.GroupMembers[inspecteeGUID].itemInfo.player, app.GroupMembers[inspecteeGUID].itemInfo.itemType, L.FILTER_REASON_UNTRADEABLE .. " (ILV!)")
				print(app.GroupMembers[inspecteeGUID].itemInfo.item .. "is ilv upgrade, untradeable")
			else
				app:AddLoot(app.GroupMembers[inspecteeGUID].itemInfo, app.GroupMembers[inspecteeGUID].itemCategory)
				print(app.GroupMembers[inspecteeGUID].itemInfo.item .. "is not ilv upgrade, tradeable!")
			end
			local unitToken = app.GroupMembers[inspecteeGUID].unitToken
			app.GroupMembers[inspecteeGUID] = { unitToken = unitToken }

			ClearInspectPlayer()
			app.Inspecting = false
			print(UnitName(app.GroupMembers[inspecteeGUID].unitToken) .. " done inspecting")
		else
			C_Timer.After(0.1, function()
				inspect(inspecteeGUID)
			end)
		end
	end

	C_Timer.After(2, function()
		inspect(inspecteeGUID)
	end)
end)
