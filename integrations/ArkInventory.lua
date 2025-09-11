local appName, app = ...

-- ArkInventory integration (thank you Plusmouse, again! I could not figure this one out)
EventUtil.ContinueOnAddOnLoaded("ArkInventory", function()
	local function InitButton(itemButton)
		itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
		itemButton.TLHOverlay:SetAllPoints()
	end

	local function UpdateButton(itemButton)
		local data = ArkInventory.API.ItemFrameItemTableGet(itemButton)
		local containerInfo, itemLocation

		if not ArkInventory.API.LocationIsOffline(data.loc_id) then
			containerInfo = C_Container.GetContainerItemInfo(itemButton.ARK_Data.blizzard_id, itemButton.ARK_Data.slot_id)
			itemLocation = ItemLocation:CreateFromBagAndSlot(itemButton.ARK_Data.blizzard_id, itemButton.ARK_Data.slot_id)
			if not C_Item.DoesItemExist(itemLocation) then
				itemLocation = nil
			end
		end

		if data.h then
			app.ItemOverlay(itemButton.TLHOverlay, data.h, itemLocation, containerInfo)
		else
			itemButton.TLHOverlay:Hide()
		end
	end

	for _, itemButton in ArkInventory.API.ItemFrameLoadedIterate() do
		InitButton(itemButton)
	end

	hooksecurefunc(ArkInventory.API, "ItemFrameLoaded", function(itemButton)
		InitButton(itemButton)
	end)

	hooksecurefunc(ArkInventory.API, "ItemFrameUpdated", function(itemButton)
		UpdateButton(itemButton)
	end)
end)
