local appName, app = ...
local api = app.api

-- Baganator integration
EventUtil.ContinueOnAddOnLoaded("Baganator", function()
	Baganator.API.RegisterCornerWidget("Transmog Loot Helper", "transmogloothelper",
		function(icon, itemDetails)
			if not C_Item.IsItemDataCachedByID(itemDetails.itemID) then
				C_Item.RequestLoadItemDataByID(itemDetails.itemID)
				return
			end
			app:CreateItemOverlay(icon.overlay, itemDetails.itemLink, nil, { hasLoot = itemDetails.hasLoot }, true)
			api:UpdateOverlay()
			return icon:IsShown()
		end,
		function(itemButton)
			local overlay = CreateFrame("Frame", nil, itemButton)
			app:CreateItemOverlay(overlay, "item:65500")
			overlay.icon.padding = -2
			overlay.icon.overlay = overlay
			return overlay.icon
		end,
		{ corner = "top_right", priority = 1 }
	)
end)
