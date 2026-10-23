local appName, app = ...
local api = app.api

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName and app.Settings.overlay then
		EventUtil.ContinueOnAddOnLoaded("SlackersTweakSuite", function()
			EventRegistry:RegisterCallback("SlackersTweakSuite.ExtendedMerchantFrameResized", function()
				app:MerchantOverlay()
			end, appName)
		end)
	end
end)
