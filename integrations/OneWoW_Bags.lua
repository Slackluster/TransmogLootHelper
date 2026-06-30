local appName, app = ...

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		EventUtil.ContinueOnAddOnLoaded("OneWoW_Bags", function()
			if OneWoW_Bags_API then
				local function UpdateItemButton(button, bagID, slotID)
					if not button then return end
					if not button.TLHOverlay then
						button.TLHOverlay = CreateFrame("Frame", nil, button)
						button.TLHOverlay:SetAllPoints(button)
						button.TLHOverlay:SetFrameLevel(button:GetFrameLevel() + 1)
					end

					local itemLocation = ItemLocation:CreateFromBagAndSlot(bagID, slotID)

					if C_Item.DoesItemExist(itemLocation) then
						local itemLink = C_Item.GetItemLink(itemLocation)
						local containerInfo = C_Container.GetContainerItemInfo(bagID, slotID)
						if itemLink and containerInfo then
							app:ApplyItemOverlay(button.TLHOverlay, itemLink, itemLocation, containerInfo)
						else
							button.TLHOverlay:Hide()
						end
					else
						button.TLHOverlay:Hide()
					end
				end

				OneWoW_Bags_API.RegisterItemButtonCallback("TransmogLootHelper", UpdateItemButton)
			end
		end)
	end
end)
