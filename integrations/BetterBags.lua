local appName, app = ...

-- BetterBags integration
EventUtil.ContinueOnAddOnLoaded("BetterBags", function()
	local betterbags = LibStub("AceAddon-3.0"):GetAddon("BetterBags")
	local events = betterbags:GetModule("Events")

	local function UpdateButton(_, item)
		if not item then return end

		local containerInfo, itemLocation, itemLink

		local bag, slot = string.match(item.slotkey, "(%d+)_(%d+)")
		bag = tonumber(bag)
		slot = tonumber(slot)

		if not item.isFreeSlot then
			containerInfo = C_Container.GetContainerItemInfo(bag, slot)
			itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
			itemLink = C_Container.GetContainerItemLink(bag, slot)
			if not C_Item.DoesItemExist(itemLocation) then
				itemLocation = nil
			end
		end

		if not item.TLHOverlay then
			local frame
			if bag <= 5 then
				frame = betterbags.Bags.Backpack.frame
			else
				frame = betterbags.Bags.Bank.frame
			end

			item.TLHOverlay = CreateFrame("Frame", nil, frame)
			item.TLHOverlay:SetAllPoints(item.button)
			item.TLHOverlay:SetFrameStrata("TOOLTIP")
		end

		if itemLink then
			app.ItemOverlay(item.TLHOverlay, itemLink, itemLocation, containerInfo, true)
		elseif item.isFreeSlot or not itemLink then
			item.TLHOverlay:Hide()
		end
	end
	events:RegisterMessage("item/Updated", UpdateButton)
end)
