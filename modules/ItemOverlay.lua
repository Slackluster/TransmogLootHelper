--------------------------------------------
-- Transmoog Loot Helper: ItemOverlay.lua --
--------------------------------------------
-- Item Overlay module

-- Initialisation
local appName, app =  ...	-- Returns the AddOn name and a unique table

------------------
-- INITIAL LOAD --
------------------

function app.InitialiseCoreItemOverlay()
	-- Declare SavedVariables
	if not TransmogLootHelper_Cache then TransmogLootHelper_Cache = {} end
	if not TransmogLootHelper_Cache.Recipes then TransmogLootHelper_Cache.Recipes = {} end
end

-- When the AddOn is fully loaded, actually run the components
app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.InitialiseCoreItemOverlay()
		app.ItemOverlayHooks()
		app.SettingsItemOverlay()
	end
end)

----------------
-- ITEM ICONS --
----------------

-- TODO:
-- AH rows
-- Prof rows
-- Icon for openable containers (goodie bags, lockboxes, etc.)
-- Learn how to cache stuff so we don't have to wait an extra 0.1 second for the backpack to open
-- AH pricing (Auctionator, Auctioneer, TSM, Oribos Exchange)
-- Baganator
-- ArkInventory
-- World Quest Tab

function app.ItemOverlay(overlay, itemLink)
	-- Create our overlay
	local function createOverlay(icon, itemLink)
		-- Text
		if not overlay.text then
			overlay.text = overlay:CreateFontString("OVERLAY", nil, "GameFontNormalOutline")
			overlay.text:SetPoint("CENTER", overlay, 2, 1)
			overlay.text:SetScale(0.85)
		end

		-- The holding frame
		if not overlay.icon then
			overlay.icon = CreateFrame("Frame", nil, overlay)
			overlay.icon:SetSize(16, 16)

			-- Our icon texture (which is set after initial creation)
			overlay.texture = overlay.icon:CreateTexture(nil, "ARTWORK")
			overlay.texture:SetAllPoints(overlay.icon)

			-- Round mask
			local mask = overlay.icon:CreateMaskTexture()
			mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
			mask:SetAllPoints(overlay.icon)
			overlay.texture:AddMaskTexture(mask)

			-- Colour overlay
			local colorOverlay = CreateFrame("Frame", nil, overlay.icon)
			colorOverlay:SetAllPoints(overlay.icon)

			overlay.color = colorOverlay:CreateTexture(nil, "ARTWORK")
			overlay.color:SetAllPoints(colorOverlay)
			
			-- Round mask
			overlay.color:AddMaskTexture(mask)

			-- Border
			overlay.border = colorOverlay:CreateTexture(nil, "OVERLAY")
			overlay.border:SetPoint("CENTER", overlay.icon)
			overlay.border:SetSize(24, 24)

			-- Create a frame to hold the texture
			local frame = CreateFrame("Frame", nil, overlay.icon)
			frame:SetSize(20, 20)
			frame:SetPoint("CENTER")

			-- Add the texture to the frame
			local texture = frame:CreateTexture(nil, "ARTWORK")
			texture:SetAllPoints(frame)
			texture:SetTexture("interface\\artifacts\\relicforge")
			texture:SetAtlas("ArtifactsFX-SpinningGlowys-Purple", true)

			-- Create an AnimationGroup for the texture
			overlay.animation = texture:CreateAnimationGroup()

			-- Add a rotation animation to the group
			local spin = overlay.animation:CreateAnimation("Rotation")
			spin:SetDuration(2) -- Duration of one full spin (in seconds)
			spin:SetDegrees(-360) -- Full rotation (360 degrees)
			spin:SetOrder(1) -- Execution order of the animation

			-- Add a scaling animation to the group
			local scaleUp = overlay.animation:CreateAnimation("Scale")
			scaleUp:SetDuration(1) -- First half of the rotation
			scaleUp:SetScale(1.5, 1.5) -- Grow to 150% size
			scaleUp:SetOrder(1) -- Same order as the rotation

			-- Add a rotation animation to the group
			local spin2 = overlay.animation:CreateAnimation("Rotation")
			spin2:SetDuration(2) -- Duration of one full spin (in seconds)
			spin2:SetDegrees(-360) -- Full rotation (360 degrees)
			spin2:SetOrder(2) -- Execution order of the animation

			local scaleDown = overlay.animation:CreateAnimation("Scale")
			scaleDown:SetDuration(1) -- Second half of the rotation
			scaleDown:SetScale(0.6667, 0.6667) -- Shrink back to 100% size
			scaleDown:SetOrder(2)

			-- Add a pause at the end of the animation group
			overlay.animation:SetLooping("REPEAT")
		end

		-- Set the icon's position
		if TransmogLootHelper_Settings["iconPosition"] == 0 then
			overlay.icon:SetPoint("CENTER", overlay, "TOPLEFT", 4, -4)
		elseif TransmogLootHelper_Settings["iconPosition"] == 1 then
			overlay.icon:SetPoint("CENTER", overlay, "TOPRIGHT", -4, -4)
		elseif TransmogLootHelper_Settings["iconPosition"] == 2 then
			overlay.icon:SetPoint("CENTER", overlay, "BOTTOMRIGHT", -4, 4)
		elseif TransmogLootHelper_Settings["iconPosition"] == 3 then
			overlay.icon:SetPoint("CENTER", overlay, "BOTTOMLEFT", 4, 4)
		end
	end

	-- Cache the item by asking the server to give us the info
	local itemID = C_Item.GetItemInfoInstant(itemLink)
	C_Item.RequestLoadItemDataByID(itemID)
	local item = Item:CreateFromItemID(itemID)
	
	-- And when the item is cached
	item:ContinueOnItemLoad(function()
		-- Grab our item info, which is enough for appearances
		local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID, bindType, _, _, _ = C_Item.GetItemInfo(itemID)

		-- Mounts
		if classID == 15 and subclassID == 5 then
			itemEquipLoc = "Mount"
		-- Toys
		elseif app.GetTooltipText(itemLink, ITEM_TOY_ONUSE) then
			itemEquipLoc = "Toy"
		-- Pets
		elseif classID == 17 or (classID == 15 and subclassID == 2) then
			itemEquipLoc = "Pet"
		-- Recipes
		elseif classID == 9 and subclassID ~= 0 then
			itemEquipLoc = "Recipe"
		-- Illusions & Ensembles
		elseif classID == 0 and subclassID == 8 then
			local itemName = C_Item.GetItemInfo(itemLink)

			-- Check if it's an illusion
			local localeIllusion = {
				"Illusion:",
				"Illusion :",
				"Ilusión:",
				"Illusione:",
				"Ilusão:",
				"Иллюзия",
				"환영:",
				"幻象：",
			}
			for k, v in pairs(localeIllusion) do
				if itemName:find("^" .. v) then
					itemEquipLoc = "Illusion"
					break
				end
			end

			-- Check if it's an ensemble
			local localeEnsemble = {
				"Ensemble:",
				"Ensemble :",
				"Indumentaria:",
				"Set:",
				"Indumentária:",
				"Комплект:",
				"복장:",
				"套装：",
			}
			for k, v in pairs(localeEnsemble) do
				if itemName:find("^" .. v) then
					itemEquipLoc = "Ensemble"
					break
				end
			end
		end

		-- Set which icon we're going to be using
		local icon = app.Icon[itemEquipLoc] or "Interface\\Icons\\INV_Misc_QuestionMark"

		-- Create the overlay
		createOverlay(icon, itemLink)
		-- Set the icon's texture
		overlay.texture:SetTexture(icon)
		-- Show the overlay
		overlay:Show()

		local function showOverlay(color)
			if color == "purple" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_purple.blp")
				overlay.color:SetColorTexture(0.761, 0, 1, 0.2)
				overlay.animation:Play()
			elseif color == "yellow" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_yellow.blp")
				overlay.color:SetColorTexture(1, 0.984, 0, 0.2)
				overlay.animation:Play()
			elseif color == "green" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_green.blp")
				overlay.color:SetColorTexture(0.12, 1, 0, 0.2)
				overlay.animation:Stop()
			elseif color == "red" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_red.blp")
				overlay.color:SetColorTexture(1, 0, 0, 0.2)
				overlay.animation:Stop()
			end
			overlay.icon:Show()
		end

		local function hideOverlay()
			overlay.icon:Hide()
			overlay.animation:Stop()
		end

		-- Appearances
		if TransmogLootHelper_Settings["iconNewMog"] and app.Icon[itemEquipLoc] and itemEquipLoc:find("INVTYPE") then
			-- New appearance
			if app.GetTooltipText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) then
				showOverlay("purple")
			-- New source
			elseif TransmogLootHelper_Settings["iconNewSource"] and app.GetTooltipText(itemLink, TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) then
				showOverlay("yellow")
			elseif TransmogLootHelper_Settings["iconLearned"] and not (classID == 15 and subclassID == 0) then
				showOverlay("green")
			else
				overlay.icon:Hide()
				overlay.animation:Stop()
			end
		-- Ensembles
		elseif TransmogLootHelper_Settings["iconNewMog"] and itemEquipLoc == "Ensemble" then
			if app.GetTooltipText(itemLink, ITEM_SPELL_KNOWN) then
				if TransmogLootHelper_Settings["iconLearned"] then
					showOverlay("green")
				else
					hideOverlay()
				end
			else
				showOverlay("purple")
			end
		-- Illusions
		elseif TransmogLootHelper_Settings["iconNewIllusion"] and itemEquipLoc == "Illusion" then
			if app.GetTooltipText(itemLink, ITEM_SPELL_KNOWN) then
				if TransmogLootHelper_Settings["iconLearned"] then
					showOverlay("green")
				else
					hideOverlay()
				end
			else
				showOverlay("purple")
			end
		-- Mounts
		elseif TransmogLootHelper_Settings["iconNewMount"] and itemEquipLoc == "Mount" then
			if app.GetTooltipText(itemLink, ITEM_SPELL_KNOWN) then
				if TransmogLootHelper_Settings["iconLearned"] then
					showOverlay("green")
				else
					hideOverlay()
				end
			else
				showOverlay("purple")
			end
		-- Pets
		elseif TransmogLootHelper_Settings["iconNewPet"] and itemEquipLoc == "Pet" then
			local _, _, _, _, _, _, _, _, _, _, _, _, speciesID = C_PetJournal.GetPetInfoByItemID(itemID)
			if C_PetJournal.GetOwnedBattlePetString(speciesID) then
				if TransmogLootHelper_Settings["iconLearned"] then
					showOverlay("green")
				else
					hideOverlay()
				end
			else
				showOverlay("purple")
			end				
		-- Toys
		elseif TransmogLootHelper_Settings["iconNewToy"] and itemEquipLoc == "Toy" then
			if app.GetTooltipText(itemLink, ITEM_SPELL_KNOWN) then
				if TransmogLootHelper_Settings["iconLearned"] then
					showOverlay("green")
				else
					hideOverlay()
				end
			else
				showOverlay("purple")
			end
		-- Recipes
		elseif TransmogLootHelper_Settings["iconNewRecipe"] and itemEquipLoc == "Recipe" then
			if app.RecipeItem[itemID] then
				local recipeID = app.RecipeItem[itemID]
				
				if TransmogLootHelper_Cache.Recipes[recipeID] then
					if TransmogLootHelper_Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				elseif C_TradeSkillUI.IsRecipeProfessionLearned(recipeID) then
					showOverlay("purple")
				else
					showOverlay("red")
				end
			else
				hideOverlay()
			end
		-- Otherwise
		else
			hideOverlay()
		end

		-- Set the bind text
		if TransmogLootHelper_Settings["textBind"] then
			if bindType == 9 or app.GetTooltipText(itemLink, ITEM_ACCOUNTBOUND_UNTIL_EQUIP) or app.GetTooltipText(itemLink, ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP) then
				overlay.text:SetText("|cff00CCFFWuE|r")
			elseif bindType == 7 or bindType == 8 or app.GetTooltipText(itemLink, ITEM_ACCOUNTBOUND) or app.GetTooltipText(itemLink, ITEM_BNETACCOUNTBOUND) or app.GetTooltipText(itemLink, ITEM_BIND_TO_ACCOUNT) or app.GetTooltipText(itemLink, ITEM_BIND_TO_BNETACCOUNT) then
				overlay.text:SetText("|cff00CCFFBoA|r")
			elseif bindType == 2 or bindType == 3 then
				overlay.text:SetText("BoE")
			else
				overlay.text:SetText("")
			end
		end
	end)
end

-- Hook our overlay onto items in various places
function app.ItemOverlayHooks()
	if TransmogLootHelper_Settings["overlay"] then
		-- Hook our overlay onto all bag slots (thank you Plusmouse!)
		local function bagsOverlay(container)
			for _, itemButton in ipairs(container.Items) do
				if not itemButton.TLHOverlay then
					itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
					itemButton.TLHOverlay:SetAllPoints(itemButton)
				end
		
				local location = ItemLocation:CreateFromBagAndSlot(itemButton:GetBagID(), itemButton:GetID())
				local exists = C_Item.DoesItemExist(location)
				if exists then
					local itemLink = C_Item.GetItemLink(location)
					app.ItemOverlay(itemButton.TLHOverlay, itemLink)
				else
					itemButton.TLHOverlay:Hide()
				end
			end
		end

		for i = 1, 13 do
			hooksecurefunc(_G["ContainerFrame" .. i], "UpdateItems", bagsOverlay)
		end
		hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", bagsOverlay)

		-- Hook our overlay onto all bank slots
		local function bankOverlay()
			if BankFrame then
				for i = 1, NUM_BANKGENERIC_SLOTS do
					local itemButton = _G["BankFrameItem"..i]
					if not itemButton.TLHOverlay then
						itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
						itemButton.TLHOverlay:SetAllPoints(itemButton)
					end
			
					local itemLink = C_Container.GetContainerItemLink(-1, i)
					if itemLink then
						app.ItemOverlay(itemButton.TLHOverlay, itemLink)
					else
						itemButton.TLHOverlay:Hide()
					end
				end
			end
		end
		
		app.Event:Register("BANKFRAME_OPENED", bankOverlay)
		app.Event:Register("PLAYERBANKSLOTS_CHANGED", bankOverlay)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", bankOverlay)

		-- Hook our overlay onto all reagent bank slots
		local function reagentBankOverlay()
			if ReagentBankFrame and ReagentBankFrame:IsShown() then
				for i = 1, 98 do
					local itemButton = _G["ReagentBankFrameItem"..i]
					if not itemButton.TLHOverlay then
						itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
						itemButton.TLHOverlay:SetAllPoints(itemButton)
					end
			
					local itemLink = C_Container.GetContainerItemLink(-3, i)
					if itemLink then
						app.ItemOverlay(itemButton.TLHOverlay, itemLink)
					else
						itemButton.TLHOverlay:Hide()
					end
				end
			end
		end

		BankFrameTab2:HookScript("OnClick", reagentBankOverlay)
		app.Event:Register("PLAYERREAGENTBANKSLOTS_CHANGED", reagentBankOverlay)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", reagentBankOverlay)

		-- Hook our overlay onto all warbank slots
		local function warbankOverlay()
			if AccountBankPanel and AccountBankPanel:IsShown() and BankFrame:IsShown() then
				local function warbank()
					for i = 1, 98 do
						local itemButton = AccountBankPanel:FindItemButtonByContainerSlotID(i)
						if not itemButton.TLHOverlay then
							itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
							itemButton.TLHOverlay:SetAllPoints(itemButton)
						end
		
						local location = ItemLocation:CreateFromBagAndSlot(AccountBankPanel.selectedTabID, i)
						local exists = C_Item.DoesItemExist(location)
						if exists then
							local itemLink = C_Item.GetItemLink(location)
							app.ItemOverlay(itemButton.TLHOverlay, itemLink)
						else
							itemButton.TLHOverlay:Hide()
						end
					end
				end

				-- Delay a bit if we're checking the Warbank for the first time
				if not app.WarbankHook then
					C_Timer.After(0.2, warbank)
					app.WarbankHook = true
				else
					warbank()
				end
			end
		end

		hooksecurefunc(AccountBankPanel, "RefreshBankPanel", warbankOverlay)
		app.Event:Register("BAG_UPDATE_DELAYED", warbankOverlay)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", warbankOverlay)

		-- Hook our overlay onto all guild bank slots
		local function guildBankOverlay()
			if GuildBankFrame and GuildBankFrame:IsShown() then
				local guildBankFrame = _G["GuildBankFrame"]
				for i = 1, 7 do
					for j = 1, 14 do
						local itemButton = guildBankFrame.Columns[i].Buttons[j]
						if not itemButton.TLHOverlay then
							itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
							itemButton.TLHOverlay:SetAllPoints(itemButton)
						end
				
						local tab = GetCurrentGuildBankTab()
						local slot = itemButton:GetID()
						local itemLink = GetGuildBankItemLink(tab, slot)
						if itemLink then
							app.ItemOverlay(itemButton.TLHOverlay, itemLink)
						else
							itemButton.TLHOverlay:Hide()
						end
					end
				end
			end
		end

		app.Event:Register("GUILDBANKBAGSLOTS_CHANGED", guildBankOverlay)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", guildBankOverlay)

		-- Hook our overlay onto all void bank slots
		local function voidBankOverlay()
			if VoidStorageFrame and VoidStorageFrame:IsShown() then
				if not app.VoidBankHook then
					VoidStorageFrame.Page1:HookScript("OnClick", voidBankOverlay)
					VoidStorageFrame.Page2:HookScript("OnClick", voidBankOverlay)
					app.VoidBankHook = true
				end

				for i = 1, 80 do
					local itemButton = _G["VoidStorageStorageButton"..i]
					if not itemButton.TLHOverlay then
						itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
						itemButton.TLHOverlay:SetAllPoints(itemButton)
					end
			
					local slot = itemButton.slot + (80 * (_G["VoidStorageFrame"].page - 1))
					local itemLink = GetVoidItemHyperlinkString(slot)
					if itemLink then
						app.ItemOverlay(itemButton.TLHOverlay, itemLink)
					else
						itemButton.TLHOverlay:Hide()
					end
				end
			end
		end

		app.Event:Register("VOID_STORAGE_UPDATE", voidBankOverlay)
		app.Event:Register("VOID_STORAGE_CONTENTS_UPDATE", voidBankOverlay)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", voidBankOverlay)

		-- Hook our overlay onto all merchant slots
		local function merchantOverlay()
			if not app.MerchantHook then
				MerchantPrevPageButton:HookScript("OnClick", merchantOverlay)
				MerchantNextPageButton:HookScript("OnClick", merchantOverlay)
				app.MerchantHook = true
			end

			for i = 1, 99 do	-- Works for AddOns that expand the vendor frame up to 99 slots
				local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
				if itemButton then
					if not itemButton.TLHOverlay then
						itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
						itemButton.TLHOverlay:SetAllPoints(itemButton)
					end

					-- These take a little moment to load, so check the first slot and assume the rest is also loaded when this one is
					if i == 1 and itemButton.hasItem == nil then
						RunNextFrame(merchantOverlay)
						return
					end

					local t = itemButton.TLHOverlay
					local itemLink = itemButton.link
					if itemLink then
						app.ItemOverlay(itemButton.TLHOverlay, itemLink)
					else
						itemButton.TLHOverlay:Hide()
					end
				end
			end
		end

		app.Event:Register("MERCHANT_SHOW", function() C_Timer.After(0.1, merchantOverlay) end)

		-- Hook our overlay onto all quest rewards
		local function questOverlay()
			local function rewardOverlay(rewardsFrame)
				local sellPrice = {}

				for k, v in pairs(rewardsFrame.RewardButtons) do
					local itemButton = QuestInfo_GetRewardButton(rewardsFrame, k)
					if not itemButton.TLHOverlay then
						itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
						itemButton.TLHOverlay:SetAllPoints(itemButton)
					end
					itemButton.TLHOverlay:Hide()	-- Hide our overlay initially, updating doesn't work like for regular itemButtons
					if itemButton.TLHOverlay.gold then itemButton.TLHOverlay.gold:Hide() end

					local itemLink = GetQuestLogItemLink("choice", k) or GetQuestLogItemLink("reward", k) or GetQuestItemLink("choice", k) or GetQuestItemLink("reward", k)
					if itemLink then
						table.insert(sellPrice, { price = select(11, GetItemInfo(itemLink)), itemButton = itemButton})
						app.ItemOverlay(itemButton.TLHOverlay, itemLink)
						itemButton.TLHOverlay:SetAllPoints(itemButton.IconBorder)
					else
						itemButton.TLHOverlay:Hide()
					end
				end

				if TransmogLootHelper_Settings["iconQuestGold"] and #sellPrice > 1 then
					local highestPrice = 0
					local highestItem = nil
				
					for k, v in ipairs(sellPrice) do
						if v.price > highestPrice then
							highestPrice = v.price
							highestItem = v.itemButton
						end
					end

					if highestPrice then
						local overlay = highestItem.TLHOverlay

						if not overlay.gold then
							overlay.gold = CreateFrame("Frame", nil, overlay)
							overlay.gold:SetSize(16, 16)

							local goldIcon = overlay.gold:CreateTexture(nil, "ARTWORK")
							goldIcon:SetAllPoints(overlay.gold)
							goldIcon:SetTexture("interface\\buttons\\ui-grouploot-coin-up")
						end

						overlay.gold:Show()
						-- Set the icon's position
						if TransmogLootHelper_Settings["iconPosition"] == 0 then
							overlay.gold:SetPoint("CENTER", overlay, "TOPRIGHT", -4, -4)
						elseif TransmogLootHelper_Settings["iconPosition"] == 1 then
							overlay.gold:SetPoint("CENTER", overlay, "TOPLEFT", 4, -4)
						elseif TransmogLootHelper_Settings["iconPosition"] == 2 then
							overlay.gold:SetPoint("CENTER", overlay, "BOTTOMLEFT", 4, 4)
						elseif TransmogLootHelper_Settings["iconPosition"] == 3 then
							overlay.gold:SetPoint("CENTER", overlay, "BOTTOMRIGHT", -4, 4)
						end
					end
				end
			end

			if QuestInfoRewardsFrame then
				rewardOverlay(QuestInfoRewardsFrame)
			end

			if MapQuestInfoRewardsFrame then
				rewardOverlay(MapQuestInfoRewardsFrame)
			end

			
		end

		app.Event:Register("QUEST_DETAIL", questOverlay)
		hooksecurefunc("QuestMapFrame_ShowQuestDetails", questOverlay)
	end
end

-- Register a recipe's information
function app.RegisterRecipe(recipeID)
	-- Register if the recipe is known
	local recipeLearned = C_TradeSkillUI.GetRecipeInfo(recipeID).learned

	-- Create the table entry
	if not TransmogLootHelper_Cache.Recipes[recipeID] then
		TransmogLootHelper_Cache.Recipes[recipeID] = recipeLearned
	end

	-- But only update the recipe learned info if it's our own profession window, and it's true (to avoid the recipe marking as unlearned from viewing the same profession on alts)
	if not C_TradeSkillUI.IsTradeSkillLinked() and not C_TradeSkillUI.IsTradeSkillGuild() and recipeLearned then
		TransmogLootHelper_Cache.Recipes[recipeID] = recipeLearned
	end
end

-- When a tradeskill window is opened
app.Event:Register("TRADE_SKILL_SHOW", function()
	if not UnitAffectingCombat("player") then
		-- Register all recipes for this profession, on a delay so we give all this info time to load.
		C_Timer.After(2, function()
			for _, recipeID in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do
				app.RegisterRecipe(recipeID)
			end
		end)
	end
end)

--------------
-- SETTINGS --
--------------

function app.SettingsItemOverlay()
	local category, layout = Settings.RegisterVerticalLayoutSubcategory(app.Category, "Item Overlay")
	Settings.RegisterAddOnCategory(category)

	local cbVariable, cbName, cbTooltip = "overlay", "Item Overlay", "Show an icon and text on items, to indicate collection status and more.\n\n|cffFF0000" .. REQUIRES_RELOAD .. ".|r Use |cffFFFFFF/reload|r or relog."
	local cbSetting = Settings.RegisterAddOnSetting(category, appName.."_"..cbVariable, cbVariable, TransmogLootHelper_Settings, Settings.VarType.Boolean, cbName, true)

	local ddVariable, ddName, ddTooltip = "iconPosition", "Icon Position", "The location of the icon on the item."
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, "Top Left", "This may overlap with a crafted item's quality.")
		container:Add(1, "Top Right", "No known overlap issues.")
		container:Add(2, "Bottom Left", "No known overlap issues.")
		container:Add(3, "Bottom Right", "No known overlap issues.")
		return container:GetData()
	end
	local ddSetting = Settings.RegisterAddOnSetting(category, appName.."_"..ddVariable, ddVariable, TransmogLootHelper_Settings, Settings.VarType.Number, ddName, 1)

	local initializer = CreateSettingsCheckboxDropdownInitializer(
		cbSetting, cbName, cbTooltip,
		ddSetting, GetOptions, ddName, ddTooltip)
	layout:AddInitializer(initializer)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Icon"))

	local variable, name, tooltip = "iconNewMog", "Appearances", "Show an icon to indicate an item's appearance is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewSource", "Sources", "Show an icon to indicate an item's appearance source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewMog"] end)

	local variable, name, tooltip = "iconNewIllusion", "Illusions", "Show an icon to indicate an item's source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewMount", "Mounts", "Show an icon to indicate an item's source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewPet", "Pets", "Show an icon to indicate an item's source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewToy", "Toys", "Show an icon to indicate an item's source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewRecipe", "Recipes", "Show an icon to indicate an item's source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconLearned", "Learned", "Show an icon to indicate the above tracked collectibles are learned.\n\n|cffFF0000This may show items that cannot be learned at all, as being learned.|r"
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconQuestGold", "Quest reward sell value", "Show an icon to indicate which quest reward has the highest vendor sell value, if there are multiple."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Text"))

	local variable, name, tooltip = "textBind", "Binding Status", "Show a text indicator for Bind-on-Equip items (BoE), Warbound items (BoA), and Warbound-until-Equipped (WuE) items."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
end