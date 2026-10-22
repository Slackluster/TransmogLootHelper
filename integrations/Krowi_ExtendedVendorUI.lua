local appName, app = ...
local api = app.api

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName and app.Settings.overlay then
		EventUtil.ContinueOnAddOnLoaded("Krowi_ExtendedVendorUI", function()
			function app:UpdateKrowiOverlay()
				for i = 1, 99 do
					local itemButton = _G["KrowiEVU_MerchantItem" .. i .. "ItemButton"]
					if itemButton then
						if not itemButton.TLHOverlay then
							itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
							itemButton.TLHOverlay:SetAllPoints(itemButton)
						end

						if i == 1 and itemButton.hasItem == nil then
							RunNextFrame(function() app:UpdateKrowiOverlay() end)
							return
						end

						local itemLink = itemButton.link
						if itemLink then
							app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink)
						else
							itemButton.TLHOverlay:Hide()
						end
					end
				end
			end

			app.Event:Register("MERCHANT_SHOW", function() C_Timer.After(0.1, function() app:UpdateKrowiOverlay() end) end)
			hooksecurefunc(api, "UpdateOverlay", function() app:UpdateKrowiOverlay() end)
		end)
	end
end)
