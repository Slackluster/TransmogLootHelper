local appName, app = ...

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		EventUtil.ContinueOnAddOnLoaded("WoWNotesBags", function()
			local AddOnTable

			if _G.WoWNotesBags then
				local ns = _G.WoWNotesBags.GetNamespace and _G.WoWNotesBags:GetNamespace()
				AddOnTable = ns and ns.OneBag
			end

			if not AddOnTable and _G.WoWNotes then
				AddOnTable = _G.WoWNotes.OneBag
			end

			if not AddOnTable then
				return
			end

			local function UpdateItemButton(button, bagID, slotID)
				if not button or not button:IsVisible() then return end

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
					end
				else
					button.TLHOverlay:Hide()
				end
			end

			local original_ItemSlot_Created = AddOnTable.ItemSlot_Created
			function AddOnTable:ItemSlot_Created(bagSet, containerId, subContainerId, slotId, button)
				if original_ItemSlot_Created then
					original_ItemSlot_Created(self, bagSet, containerId, subContainerId, slotId, button)
				end
				UpdateItemButton(button, subContainerId, slotId)
			end

			local original_ItemSlot_Updated = AddOnTable.ItemSlot_Updated
			function AddOnTable:ItemSlot_Updated(bagSet, containerId, subContainerId, slotId, button)
				if original_ItemSlot_Updated then
					original_ItemSlot_Updated(self, bagSet, containerId, subContainerId, slotId, button)
				end
				UpdateItemButton(button, subContainerId, slotId)
			end
		end)
	end
end)
