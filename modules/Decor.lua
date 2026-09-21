-------------------------------------
-- Transmog Loot Helper: Decor.lua --
-------------------------------------

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
	if not app.Cache.Decor[recordID] then
		app.Cache.Decor[recordID] = { owned = 0 }
	end

	app.Cache.Decor[recordID].owned = app.Cache.Decor[recordID].owned + 1
	app.Cache.Decor[recordID].grantsXP = false

	local decorInfo = C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, recordID, true)
	if decorInfo then
		app.Cache.Decor[recordID].xp = decorInfo.firstAcquisitionBonus
	end
	api:UpdateOverlay()
end)
