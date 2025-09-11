local appName, app = ...

-- World Quest Tab integration
app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == "WorldQuestTab" then
		-- Put our icon on the rewards list
		local function wqtRewardsList()
			if WQT_QuestScrollFrame then
				local wqtRewards = { WQT_QuestScrollFrame.Contents:GetChildren() }
				for k, v in pairs(wqtRewards) do
					if not v.TLHOverlay then
						v.TLHOverlay = CreateFrame("Frame", nil, v)
						v.TLHOverlay:SetAllPoints(v)
					end
					v.TLHOverlay:Hide()	-- Hide our overlay initially, updating doesn't work like for regular itemButtons

					if v.questID then
						local bestIndex, bestType = QuestUtils_GetBestQualityItemRewardIndex(v.questID)
						if bestIndex and bestType then
							local itemLink = GetQuestLogItemLink(bestType, bestIndex, v.questID)
							if itemLink then
								app.ItemOverlay(v.TLHOverlay, itemLink)
								v.TLHOverlay.icon:SetPoint("TOPRIGHT", v, -22, 0)	-- Set the icon to the topleft of the item icon
								v.TLHOverlay.text:SetText("")	-- No bind text for these
							else
								v.TLHOverlay:Hide()
							end
						else
							v.TLHOverlay:Hide()
						end
					end
				end
			end
		end

		-- Check if this exists, so this is compatible with both versions of World Quest Tab
		if WQT_WorldQuestFrame and WQT_WorldQuestFrame.RegisterCallback then
			WQT_WorldQuestFrame:RegisterCallback("UpdateQuestList", wqtRewardsList, appName)
		end

		-- Hook our overlay onto the world quest pins
		local function wqtMapPins()
			C_Timer.After(0.1, function()
				for k, v in pairs({ WorldMapFrame.ScrollContainer.Child:GetChildren() }) do
					if v.RingBG then
						local pin = v
						if not pin.TLHOverlay then
							pin.TLHOverlay = CreateFrame("Frame", nil, pin)
							pin.TLHOverlay:SetAllPoints(pin)
							pin.TLHOverlay:SetScale(0.8)	-- Make it a little smaller
						end
						pin.TLHOverlay:Hide()	-- Hide our overlay initially, updating doesn't work like for regular itemButtons

						if pin.questID then
							local bestIndex, bestType = QuestUtils_GetBestQualityItemRewardIndex(pin.questID)
							if bestIndex and bestType then
								local itemLink = GetQuestLogItemLink(bestType, bestIndex, pin.questID)
								if itemLink then
									app.ItemOverlay(pin.TLHOverlay, itemLink)
									pin.TLHOverlay.text:SetText("")	-- No bind text for these
								else
									pin.TLHOverlay:Hide()
								end
							else
								pin.TLHOverlay:Hide()
							end
						end
					end
				end
			end)
		end

		WorldMapFrame:HookScript("OnShow", wqtMapPins)
		EventRegistry:RegisterCallback("MapCanvas.MapSet", wqtMapPins)
		-- Check if this exists, so this is compatible with both versions of World Quest Tab
		if WQT_WorldQuestFrame and WQT_WorldQuestFrame.RegisterCallback then
			WQT_WorldQuestFrame:RegisterCallback("UpdateQuestList", wqtMapPins, appName)
		end
	end
end)
