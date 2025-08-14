--------------------------------------
-- Transmog Loot Helper: Tweaks.lua --
--------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales

----------------------
-- INSTANT CATALYST --
----------------------

app.Event:Register("PLAYER_INTERACTION_MANAGER_FRAME_SHOW", function(type)
	if TransmogLootHelper_Settings["instantCatalyst"] and type == 44 then
		ItemInteractionFrame.ButtonFrame.ActionButton:HookScript("OnClick", function()
			if IsShiftKeyDown() then
				ItemInteractionFrame:CompleteItemInteraction()
			end
		end)

		local buttonText = ItemInteractionFrame.ButtonFrame.ActionButton:GetText()
		ItemInteractionFrame.ButtonFrame.ActionButton:HookScript("OnEvent", function(self, event, key, state)
			if key == "LSHIFT" or key == "RSHIFT" then
				if IsShiftKeyDown() then
					ItemInteractionFrame.ButtonFrame.ActionButton:SetText(app.IconReady .. " " .. L.INSTANT_BUTTON)
				else
					ItemInteractionFrame.ButtonFrame.ActionButton:SetText(buttonText)
				end
				GameTooltip:Show()
			end
		end)
		ItemInteractionFrame.ButtonFrame.ActionButton:HookScript("OnEnter", function(self)
			if IsShiftKeyDown() then
				ItemInteractionFrame.ButtonFrame.ActionButton:SetText(app.IconReady .. " " .. L.INSTANT_BUTTON)
			end
			if TransmogLootHelper_Settings["instantCatalystTooltip"] then
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L.INSTANT_TOOLTIP)
				GameTooltip:Show()
			end
			self:RegisterEvent("MODIFIER_STATE_CHANGED")
		end)
		ItemInteractionFrame.ButtonFrame.ActionButton:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			ItemInteractionFrame.ButtonFrame.ActionButton:SetText(buttonText)
			self:UnregisterEvent("MODIFIER_STATE_CHANGED")
		end)
	end
end)

-------------------------
-- INSTANT GREAT VAULT --
-------------------------

app.Event:Register("WEEKLY_REWARDS_UPDATE", function()
	if TransmogLootHelper_Settings["instantVault"] and WeeklyRewardsFrame and WeeklyRewardsFrame:IsShown() then
		WeeklyRewardsFrame.SelectRewardButton:HookScript("OnClick", function()
			if IsShiftKeyDown() then
				StaticPopupDialogs["CONFIRM_SELECT_WEEKLY_REWARD"].OnAccept(StaticPopup1, StaticPopup1.data)
			end
		end)

		WeeklyRewardsFrame.SelectRewardButton:HookScript("OnEvent", function(self, event, key, state)
			if key == "LSHIFT" or key == "RSHIFT" then
				if IsShiftKeyDown() then
					WeeklyRewardsFrame.SelectRewardButton:SetText(app.IconReady .. " " .. L.INSTANT_BUTTON)
				else
					WeeklyRewardsFrame.SelectRewardButton:SetText(WEEKLY_REWARDS_SELECT_REWARD)
				end
				GameTooltip:Show()
			end
		end)
		WeeklyRewardsFrame.SelectRewardButton:HookScript("OnEnter", function(self)
			if IsShiftKeyDown() then
				WeeklyRewardsFrame.SelectRewardButton:SetText(app.IconReady .. " " .. L.INSTANT_BUTTON)
			end
			if TransmogLootHelper_Settings["instantVaultTooltip"] then
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L.INSTANT_TOOLTIP)
				GameTooltip:Show()
			end
			self:RegisterEvent("MODIFIER_STATE_CHANGED")
		end)
		WeeklyRewardsFrame.SelectRewardButton:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			WeeklyRewardsFrame.SelectRewardButton:SetText(WEEKLY_REWARDS_SELECT_REWARD)
			self:UnregisterEvent("MODIFIER_STATE_CHANGED")
		end)
	end
end)

---------------------
-- MERCHANT FILTER --
---------------------

app.Event:Register("MERCHANT_SHOW", function()
	if TransmogLootHelper_Settings["vendorAll"] then
		RunNextFrame(function()
			SetMerchantFilter(1)
			MerchantFrame_Update()
		end)
	end
end)

---------------------------
-- GROUP LOOT ROLL FRAME --
---------------------------

app.Event:Register("START_LOOT_ROLL", function(rollID, rollTime, lootHandle)
	if TransmogLootHelper_Settings["hideGroupRolls"] and GroupLootHistoryFrame then
		local hidden = false
		GroupLootHistoryFrame:HookScript("OnShow", function()
			if hidden == false then
				GroupLootHistoryFrame:Hide()
				hidden = true
			end
		end)
	end
end)
