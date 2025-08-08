--------------------------------------
-- Transmog Loot Helper: Tweaks.lua --
--------------------------------------

-- Initialisation
local appName, app = ...

------------
-- TWEAKS --
------------

-- Hide group loot rolls
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
