local appName, app = ...

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		EventUtil.ContinueOnAddOnLoaded("OneWoW_Bags", function()
			if _G.OneWoW_Bags then
				local debugCount = 0
				local function UpdateItemButton(button, bagID, slotID)
					if not button then return end
					if not button.TLHOverlay then
						button.TLHOverlay = CreateFrame("Frame", nil, button)
						button.TLHOverlay:SetAllPoints(button)
						button.TLHOverlay:SetFrameLevel(button:GetFrameLevel() + 1)

						debugCount = debugCount + 1
						if debugCount <= 3 then
							local bw, bh = button:GetSize()
							local ow, oh = button.TLHOverlay:GetSize()
						end
					end

					local itemLocation = ItemLocation:CreateFromBagAndSlot(bagID, slotID)

					if C_Item.DoesItemExist(itemLocation) then
						local itemLink = C_Item.GetItemLink(itemLocation)
						local containerInfo = C_Container.GetContainerItemInfo(bagID, slotID)
						if itemLink and containerInfo then
							app:ApplyItemOverlay(button.TLHOverlay, itemLink, itemLocation, containerInfo)
						end
					else
						button.TLHOverlay:Hide()
					end
				end

				_G.OneWoW_Bags:RegisterItemButtonCallback("TransmogLootHelper", UpdateItemButton)
			end
		end)
	end
end)
