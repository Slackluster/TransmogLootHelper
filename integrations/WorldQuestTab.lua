local appName, app = ...

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		EventUtil.ContinueOnAddOnLoaded("WorldQuestTab", function()
			WQT_ListContainer:GetQuestScrollBox():RegisterCallback("OnInitializedFrame", function(_, frame, data)
				local rewardsFrame = frame:GetRewardsFrame()

				if not rewardsFrame.TLHOverlay then
					rewardsFrame.TLHOverlay = CreateFrame("Frame", nil, rewardsFrame)
					rewardsFrame.TLHOverlay:SetAllPoints(rewardsFrame)
				end
				rewardsFrame.TLHOverlay:Hide()	-- Hide our overlay initially, updating doesn't work like for regular itemButtons

				if data.questInfo.questID then
					local bestIndex, bestType = QuestUtils_GetBestQualityItemRewardIndex(data.questInfo.questID)
					if bestIndex and bestType then
						local itemLink = GetQuestLogItemLink(bestType, bestIndex, data.questInfo.questID)
						if itemLink then
							app:CreateItemOverlay(rewardsFrame.TLHOverlay, itemLink)
							rewardsFrame.TLHOverlay.icon:SetScale(0.9)
							rewardsFrame.TLHOverlay.text:SetText("")
						end
					end
				end
			end, self)

			WQT_CallbackRegistry:RegisterCallback("WQT.MapPinProvider.PinInitialized", function(_, pin)
				if not pin.TLHOverlay then
					pin.TLHOverlay = CreateFrame("Frame", nil, pin)
					pin.TLHOverlay:SetAllPoints(pin:GetButton())
					pin.TLHOverlay:SetScale(0.8)
				end
				pin.TLHOverlay:Hide()	-- Hide our overlay initially, updating doesn't work like for regular itemButtons

				if pin.questID then
					local bestIndex, bestType = QuestUtils_GetBestQualityItemRewardIndex(pin.questID)
					if bestIndex and bestType then
						local itemLink = GetQuestLogItemLink(bestType, bestIndex, pin.questID)
						if itemLink then
							app:CreateItemOverlay(pin.TLHOverlay, itemLink)
							pin.TLHOverlay.text:SetText("")
						end
					end
				end
			end, self)
		end)
	end
end)
