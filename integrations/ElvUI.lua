local appName, app = ...

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName and app.Settings["overlay"] then
		EventUtil.ContinueOnAddOnLoaded("ElvUI", function()
			function app:UpdateElvUIOverlay()
				local container = "ElvUI"
				if not app.BagThrottle then app.BagThrottle = {} end
				if not app.BagThrottle[container] then
					app.BagThrottle[container] = 0
					C_Timer.After(0.1, function()
						if app.BagThrottle[container] >= 1 then
							app.BagThrottle[container] = nil
							app:UpdateElvUIOverlay()
						else
							app.BagThrottle[container] = nil
						end
					end)
				else
					app.BagThrottle[container] = 1
					return
				end

				for bag = 0, 5 do
					local slots = C_Container.GetContainerNumSlots(bag)
					if slots > 0 then
						for bagSlot = 1, slots do
							local itemButton = _G["ElvUI_ContainerFrameBag"..bag.."Slot"..bagSlot]
							if itemButton and not itemButton.TLHOverlay then
								itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
								itemButton.TLHOverlay:SetAllPoints()
							end

							local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, bagSlot)
							if C_Item.DoesItemExist(itemLocation) then
								local itemLink = C_Item.GetItemLink(itemLocation)
								local containerInfo = C_Container.GetContainerItemInfo(bag, bagSlot)
								app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
							else
								itemButton.TLHOverlay:Hide()
							end
						end
					end
				end

				-- C_Timer.After(1, function()
				-- 	if ElvUI_BankContainerFrame and ElvUI_BankContainerFrame:IsVisible() then
				-- 		for tab = 1, 6 do
				-- 			for i = 1, 98 do
				-- 				local itemButton = _G["ElvUIBankTabs"..tab.."Item"..i]
				-- 				if itemButton and not itemButton.TLHOverlay then
				-- 					itemButton.TLHOverlay = CreateFrame("Frame", "TLHOverlay"..tab..i, _G["ElvUIBankTabs"..tab])
				-- 					-- itemButton.TLHOverlay = CreateFrame("Frame", "TLHOverlay"..tab..i, itemButton)
				-- 					itemButton.TLHOverlay:SetAllPoints(itemButton)

				-- 					-- itemButton.TLHOverlay.tex = itemButton.TLHOverlay:CreateTexture(nil, "OVERLAY")
				-- 					-- itemButton.TLHOverlay.tex:SetAllPoints()
				-- 					-- itemButton.TLHOverlay.tex:SetColorTexture(1, 0, 0, 0.5)
				-- 				end

				-- 				if itemButton and itemButton.TLHOverlay then
				-- 					local itemLocation = ItemLocation:CreateFromBagAndSlot(itemButton.BagID, itemButton.SlotID)
				-- 					if C_Item.DoesItemExist(itemLocation) then
				-- 						local itemLink = C_Item.GetItemLink(itemLocation)
				-- 						local containerInfo = C_Container.GetContainerItemInfo(itemButton.BagID, itemButton.SlotID)
				-- 						app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
				-- 						itemButton.TLHOverlay:Show()
				-- 					else
				-- 						itemButton.TLHOverlay:Hide()
				-- 					end
				-- 				end
				-- 			end
				-- 		end

				-- 		-- if not app.Flag.ElvUIBankHook then
				-- 		-- 	for i = 1, 6 do
				-- 		-- 		local button = _G["ElvUIBankBag"..i]
				-- 		-- 		if button then
				-- 		-- 			button:HookScript("OnClick", function() app:UpdateElvUIOverlay() end)
				-- 		-- 			print("hooking")
				-- 		-- 		end
				-- 		-- 	end
				-- 		-- 	app.Flag.ElvUIBankHook = true
				-- 		-- end
				-- 	end
				-- end)
			end

			app.Event:Register("BAG_UPDATE_DELAYED", function() app:UpdateElvUIOverlay() end)
			app.Event:Register("BANKFRAME_OPENED", function() app:UpdateElvUIOverlay() end)
			app.Event:Register("GUILDBANKBAGSLOTS_CHANGED", function() app:UpdateElvUIOverlay() end)
		end)
	end
end)
