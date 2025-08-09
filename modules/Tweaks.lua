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
