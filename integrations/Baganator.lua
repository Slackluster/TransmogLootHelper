local appName, app = ...	-- Returns the AddOn name and a unique table

-- Baganator icon integration
EventUtil.ContinueOnAddOnLoaded("Baganator", function()
	Baganator.API.RegisterCornerWidget("Transmog Loot Helper", "transmogloothelper",
		function(icon, itemDetails)
			if not C_Item.IsItemDataCachedByID(itemDetails.itemID) then
				return
			end
			local containerInfo
			if itemDetails.itemLocation then
				containerInfo = C_Container.GetContainerItemInfo(itemDetails.itemLocation.bagID, itemDetails.itemLocation.slotIndex)
			end
			app.ItemOverlay(icon.overlay, itemDetails.itemLink, nil, containerInfo)
			return icon:IsShown()
		end,
		function(itemButton)
			local overlay = CreateFrame("Frame", nil, itemButton)
			app.ItemOverlay(overlay, "item:65500")
			overlay.icon.padding = -2
			overlay.icon.overlay = overlay
			return overlay.icon
		end,
		{ corner = "top_right", priority = 1 }
	)
end)