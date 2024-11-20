local appName, app =  ...	-- Returns the AddOn name and a unique table

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == "WorldQuestTab" then
		local function worldquesttabIntegration()
			-- Put our icon on the rewards list
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

			-- TODO: icon on world quest pins
		end

		WQT_WorldQuestFrame:RegisterCallback("UpdateQuestList", worldquesttabIntegration, appName)
	end
end)