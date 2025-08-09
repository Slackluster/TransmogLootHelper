--------------------------------------
-- Transmog Loot Helper: Tweaks.lua --
--------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales

------------------------
-- INSTANTLY CATALYSE --
------------------------

app.Event:Register("PLAYER_INTERACTION_MANAGER_FRAME_SHOW", function(type)
	if TransmogLootHelper_Settings["catalystButton"] then
		if type == 44 then
			if not app.CatalystSkipButton then
				app.CatalystSkipButton = app.Button(ItemInteractionFrame, L.CATALYSTBUTTON_LABEL)
				app.CatalystSkipButton:SetPoint("CENTER", ItemInteractionFrameTitleText, 0, -30)
				app.CatalystSkipButton:SetScript("OnClick", function()
					ItemInteractionFrame:CompleteItemInteraction()
				end)
			end
			app.CatalystSkipButton:Show()
		end
	end
end)

app.Event:Register("PLAYER_INTERACTION_MANAGER_FRAME_HIDE", function(type)
	if app.CatalystSkipButton then
		app.CatalystSkipButton:Hide()
	end
end)

---------------------------------
-- INSTANT GREAT VAULT REWARDS --
---------------------------------

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
					WeeklyRewardsFrame.SelectRewardButton:SetText(app.IconReady .. " " .. L.VAULT_REWARD_BUTTON)
				else
					WeeklyRewardsFrame.SelectRewardButton:SetText(WEEKLY_REWARDS_SELECT_REWARD)
				end
				GameTooltip:Show()
			end
		end)

		WeeklyRewardsFrame.SelectRewardButton:HookScript("OnEnter", function(self)
			if IsShiftKeyDown() then
				WeeklyRewardsFrame.SelectRewardButton:SetText(app.IconReady .. " " .. L.VAULT_REWARD_BUTTON)
			end
			if TransmogLootHelper_Settings["instantVaultTooltip"] then
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L.VAULT_REWARD_TOOLTIP)
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
