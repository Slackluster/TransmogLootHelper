--------------------------------------
-- Transmoog Loot Helper: Decor.lua --
--------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

--------------------
-- DECOR TRACKING --
--------------------

app.Event:Register("PLAYER_ENTERING_WORLD", function(isInitialLogin, isReloadingUi)
	C_HousingCatalog.CreateCatalogSearcher() -- Cache Decor
end)

app.Event:Register("HOUSE_DECOR_ADDED_TO_CHEST", function(decorGUID, recordID)
	if not TransmogLootHelper_Cache.Decor[recordID] then
		TransmogLootHelper_Cache.Decor[recordID] = { owned = 0 }
	end

	TransmogLootHelper_Cache.Decor[recordID].owned = TransmogLootHelper_Cache.Decor[recordID].owned + 1
	TransmogLootHelper_Cache.Decor[recordID].grantsXP = false

	local decorInfo = C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, recordID, true)
	if decorInfo then
		TransmogLootHelper_Cache.Decor[recordID].xp = decorInfo.firstAcquisitionBonus
	end
	api:UpdateOverlay()
end)

-- This is also triggered when we run C_HousingCatalog.CreateCatalogSearcher()
app.Event:Register("HOUSING_STORAGE_UPDATED", function()
	for itemID, recordID in pairs(app.Decor) do
		local decorInfo = C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, recordID, true)
		if decorInfo then
			if not decorInfo.numStored then
				if decorInfo.quantity > 100000 then decorInfo.quantity = 0 end
				decorInfo.numStored = decorInfo.remainingRedeemable + decorInfo.quantity
			end
			if not TransmogLootHelper_Cache.Decor[recordID] then
				TransmogLootHelper_Cache.Decor[recordID] = { grantsXP = false, xp = decorInfo.firstAcquisitionBonus }
				if (decorInfo.numStored + decorInfo.numPlaced) == 0 and decorInfo.firstAcquisitionBonus > 0 then
					TransmogLootHelper_Cache.Decor[recordID].grantsXP = true
				end
			end
			TransmogLootHelper_Cache.Decor[recordID].owned = decorInfo.numStored + decorInfo.numPlaced
		end
	end
end)
