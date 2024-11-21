--------------------------------------------
-- Transmoog Loot Helper: ItemOverlay.lua --
--------------------------------------------
-- Item Overlay module

-- Initialisation
local appName, app =  ...	-- Returns the AddOn name and a unique table
local api = app.api	-- Our "API" prefix

------------------
-- INITIAL LOAD --
------------------

function app.InitialiseCoreItemOverlay()
	-- Declare SavedVariables
	if not TransmogLootHelper_Cache then TransmogLootHelper_Cache = {} end
	if not TransmogLootHelper_Cache.Recipes then TransmogLootHelper_Cache.Recipes = {} end

	-- Declare session variables
	app.OverlayCache = {}
end

-- When the AddOn is fully loaded, actually run the components
app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.InitialiseCoreItemOverlay()
		app.TooltipInfo()
		app.ItemOverlayHooks()
		app.SettingsItemOverlay()
	end
end)

----------------
-- ITEM ICONS --
----------------

-- Tooltip information (to tell the user a recipe is not cached)
function app.TooltipInfo()
	-- Only run any of this is the relevant setting is enabled
	if TransmogLootHelper_Settings["iconNewRecipe"] then
		local function OnTooltipSetItem(tooltip)
			-- Get item info from the last processed tooltip and the primary tooltip
			local _, _, itemID = TooltipUtil.GetDisplayedItem(tooltip)
			local _, _, primaryItemID = TooltipUtil.GetDisplayedItem(GameTooltip)

			-- Stop if error, it will try again on its own REAL soon
			if itemID == nil then
				return
			end

			-- If the last processed tooltip isn't the same as the primary tooltip (aka, a compare tooltip), don't do anything
			if itemID ~= primaryItemID then
				return
			end

			-- Only run this if the item is known to be a recipe
			if app.RecipeItem[itemID] then
				local recipeID = app.RecipeItem[itemID]
				if TransmogLootHelper_Cache.Recipes[recipeID] == nil then
					tooltip:AddLine(" ")
					tooltip:AddLine(app.IconTLH .. " " .. "Please open this profession to update the recipe's collection status.")
				end
			end
		end
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
	end
end

function app.ItemOverlay(overlay, itemLink, itemLocation, containerInfo)
	-- Create our overlay
	local function createOverlay()
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

			-- Border
			local frame = CreateFrame("Frame", nil, overlay.icon)
			frame:SetAllPoints(overlay.icon)
			overlay.border = frame:CreateTexture(nil, "OVERLAY")
			overlay.border:SetPoint("CENTER", overlay.icon)
			overlay.border:SetSize(24, 24)

			-- Animation texture
			local frame = CreateFrame("Frame", nil, overlay.icon)
			frame:SetSize(20, 20)
			frame:SetPoint("CENTER")
			local texture = frame:CreateTexture(nil, "ARTWORK")
			texture:SetAllPoints(frame)
			texture:SetTexture("interface\\artifacts\\relicforge")
			texture:SetAtlas("ArtifactsFX-SpinningGlowys-Purple", true)

			-- Animation group
			overlay.animation = texture:CreateAnimationGroup()

			-- Rotation first half
			local spin = overlay.animation:CreateAnimation("Rotation")
			spin:SetDuration(2)
			spin:SetDegrees(-360)
			spin:SetOrder(1)

			-- Scale first half
			local scaleUp = overlay.animation:CreateAnimation("Scale")
			scaleUp:SetDuration(1)
			scaleUp:SetScale(1.5, 1.5)
			scaleUp:SetOrder(1)

			-- Rotation second half
			local spin2 = overlay.animation:CreateAnimation("Rotation")
			spin2:SetDuration(2)
			spin2:SetDegrees(-360)
			spin2:SetOrder(2)

			-- Scale second half
			local scaleDown = overlay.animation:CreateAnimation("Scale")
			scaleDown:SetDuration(1)
			scaleDown:SetScale(0.6667, 0.6667)
			scaleDown:SetOrder(2)

			-- Repeat the animation
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
	createOverlay()

	-- Process our overlay
	local function processOverlay(itemID)
		-- Cache our info, if we haven't yet.
		if not app.OverlayCache[itemLink] then
			-- Grab our item info, which is enough for appearances
			local _, _, itemQuality, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID, bindType, _, _, _ = C_Item.GetItemInfo(itemLink)

			-- Containers
			if containerInfo and containerInfo.hasLoot then
				itemEquipLoc = "Container"
			-- Mounts
			elseif classID == 15 and subclassID == 5 then
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
			-- Check for profession knowledge items
			else
				local localeProfessionKnowledge = {
					"Use: Study to increase your",
					"Benutzen: Studieren, um Euer",
					"Uso: Estudia para aumentar",
					"Utilise: Vous étudiez afin",
					"Usa: Da studiare per aumentare",
					"Uso: Estuda para aumentar",
					"Использование: Изучить, повышая ваше",
					"사용 효과: 연구합니다. 카즈 알가르",
					"使用: 研究以使你的卡兹阿加",
				}
				for k, v in pairs(localeProfessionKnowledge) do
					if app.GetTooltipText(itemLink, v) then
						itemEquipLoc = "ProfessionKnowledge"
						break
					end
				end
			end

			-- Cache this info, so we don't need to check it again
			app.OverlayCache[itemLink] = { itemEquipLoc = itemEquipLoc, bindType = bindType, itemQuality = itemQuality }
		end

		local itemEquipLoc = app.OverlayCache[itemLink].itemEquipLoc
		local icon = app.Icon[itemEquipLoc]
		local bindType = app.OverlayCache[itemLink].bindType

		-- Set the icon's texture
		overlay.texture:SetTexture(icon)
		-- Show the overlay
		overlay:Show()

		local function showOverlay(color)
			if color == "purple" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_purple.blp")
				overlay.animation:Play()
			elseif color == "yellow" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_yellow.blp")
				overlay.animation:Play()
			elseif color == "green" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_green.blp")
				overlay.animation:Stop()
			elseif color == "red" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_red.blp")
				overlay.animation:Stop()
			end
			overlay.icon:Show()
		end

		local function hideOverlay()
			overlay.icon:Hide()
			overlay.animation:Stop()
		end

		if app.Icon[itemEquipLoc] then
			-- Appearances
			if TransmogLootHelper_Settings["iconNewMog"] and itemEquipLoc:find("INVTYPE") then
				-- Legendaries and Artifacts can be a little weird
				if (app.OverlayCache[itemLink].itemQuality == 5 or app.OverlayCache[itemLink].itemQuality == 6) and bindType == 1 then
					if TransmogLootHelper_Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				-- New appearance
				elseif not api.IsAppearanceCollected(itemLink) then
					showOverlay("purple")
				-- New source
				elseif TransmogLootHelper_Settings["iconNewSource"] and not api.IsSourceCollected(itemLink) then
					showOverlay("yellow")
				elseif TransmogLootHelper_Settings["iconLearned"] and not (classID == 15 and subclassID == 0) then
					showOverlay("green")
				else
					hideOverlay()
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
				-- Learned
				if app.GetTooltipText(itemLink, ITEM_SPELL_KNOWN) then
					if TransmogLootHelper_Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				-- Unlearned
				else
					-- Look for red text, which should only be when on the wrong class for this item
					local red = false
					local tooltip = C_TooltipInfo.GetHyperlink(itemLink)
					if tooltip["lines"] then
						for k, v in ipairs(tooltip["lines"]) do
							if v.leftColor["r"] ~= 1 and v.leftColor["g"] ~= 1 and v.leftColor["b"] ~= 1 then
								red = true
								break
							end
						end
					end

					if red then
						showOverlay("red")
					else
						showOverlay("purple")
					end
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
				-- If we haven't grabbed this info from a pet cage, grab it now
				if not app.OverlayCache[itemLink].speciesID then
					app.OverlayCache[itemLink].speciesID = select(13, C_PetJournal.GetPetInfoByItemID(itemID))
				end
				
				numPets, maxAllowed = C_PetJournal.GetNumCollectedInfo(app.OverlayCache[itemLink].speciesID)
				
				if (maxAllowed == numPets and numPets ~= 0) or (not TransmogLootHelper_Settings["iconNewPetMax"] and numPets >= 1) then
					if TransmogLootHelper_Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				elseif TransmogLootHelper_Settings["iconNewPetMax"] and maxAllowed > numPets and numPets >= 1 then
					showOverlay("yellow")
				else
					showOverlay("purple")
				end
			-- Unknown Pet Cages
			elseif TransmogLootHelper_Settings["iconNewPet"] and itemEquipLoc == "Unknown" then
				showOverlay("yellow")
				overlay.animation:Stop()
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
					
					if TransmogLootHelper_Cache.Recipes[recipeID] ~= nil then
						-- Learned
						if TransmogLootHelper_Cache.Recipes[recipeID] then
							if TransmogLootHelper_Settings["iconLearned"] then
								showOverlay("green")
							else
								hideOverlay()
							end
						-- Unlearned
						elseif not TransmogLootHelper_Cache.Recipes[recipeID] then
							if C_TradeSkillUI.IsRecipeProfessionLearned(recipeID) then
								showOverlay("purple")
							else
								showOverlay("red")
							end
						end
					-- Uncached
					else
						overlay.texture:SetTexture(app.Icon["Unknown"])
						showOverlay("yellow")
						overlay.animation:Stop()
					end
				else
					hideOverlay()
				end
			-- Profession Knowledge
			elseif TransmogLootHelper_Settings["iconUsable"] and itemEquipLoc == "ProfessionKnowledge" then
				showOverlay("yellow")
			-- Containers
			elseif TransmogLootHelper_Settings["iconContainer"] and itemEquipLoc == "Container" then
				if not containerInfo then
					hideOverlay()
				else
					showOverlay("yellow")
				end
			end
		else
			hideOverlay()
		end

		-- Set the bind text
		if TransmogLootHelper_Settings["textBind"] then
			-- WuE
			if itemLocation and C_Item.IsBoundToAccountUntilEquip(itemLocation) then
				if C_Item.IsBound(itemLocation) then
					overlay.text:SetText("")
				else
					overlay.text:SetText("|cff00CCFFWuE|r")
				end
			-- Soulbound + BoA
			elseif itemLocation and C_Item.IsBound(itemLocation) then
				-- BoA (ITEM_ACCOUNTBOUND and ITEM_BNETACCOUNTBOUND is the actual text, but it always returns the other two anyway)
				if app.GetTooltipText(itemLink, ITEM_BIND_TO_ACCOUNT) or app.GetTooltipText(itemLink, ITEM_BIND_TO_BNETACCOUNT) then
					overlay.text:SetText("|cff00CCFFBoA|r")
				-- Soulbound
				else
					overlay.text:SetText("")
				end
			elseif bindType == 2 or bindType == 3 then
				overlay.text:SetText("BoE")
			else
				overlay.text:SetText("")
			end
		else
			overlay.text:SetText("")
		end
	end

	local itemID = C_Item.GetItemInfoInstant(itemLink)
	-- Caged pets don't return this info, except this one magical pet cage
	if not itemID or itemID == 82800 then
		local speciesID = string.match(itemLink, "battlepet:(%d+):")
		if speciesID then
			app.OverlayCache[itemLink] = { itemEquipLoc = "Pet", bindType = 2, speciesID = speciesID }
			processOverlay()
		-- If this magical pet cage can't return the above info, in that case mark it as unknown
		elseif itemID == 82800 then
			app.OverlayCache[itemLink] = { itemEquipLoc = "Unknown" }
			processOverlay()
		else
			return
		end
	-- But everything else does (that I know of so far)
	else
		-- Cache the item by asking the server to give us the info
		C_Item.RequestLoadItemDataByID(itemID)
		local item = Item:CreateFromItemID(itemID)

		-- And when the item is cached
		item:ContinueOnItemLoad(function()
			processOverlay(itemID)
		end)
	end
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
		
				local itemLocation = ItemLocation:CreateFromBagAndSlot(itemButton:GetBagID(), itemButton:GetID())
				local exists = C_Item.DoesItemExist(itemLocation)
				if exists then
					local itemLink = C_Item.GetItemLink(itemLocation)
					local containerInfo = C_Container.GetContainerItemInfo(itemButton:GetBagID(), itemButton:GetID())
					app.ItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
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

					local itemLocation = ItemLocation:CreateFromBagAndSlot(-1, i)
					local exists = C_Item.DoesItemExist(itemLocation)
					if exists then
						local itemLink = C_Item.GetItemLink(itemLocation)
						local containerInfo = C_Container.GetContainerItemInfo(-1, i)
						app.ItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
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
			
					local itemLocation = ItemLocation:CreateFromBagAndSlot(-3, i)
					local exists = C_Item.DoesItemExist(itemLocation)
					if exists then
						local itemLink = C_Item.GetItemLink(itemLocation)
						local containerInfo = C_Container.GetContainerItemInfo(-3, i)
						app.ItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
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
		
						local itemLocation = ItemLocation:CreateFromBagAndSlot(AccountBankPanel.selectedTabID, i)
						local exists = C_Item.DoesItemExist(itemLocation)
						if exists then
							local itemLink = C_Item.GetItemLink(itemLocation)
							local containerInfo = C_Container.GetContainerItemInfo(AccountBankPanel.selectedTabID, i)
							app.ItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
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
				for i = 1, 7 do
					for j = 1, 14 do
						local itemButton = GuildBankFrame.Columns[i].Buttons[j]
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
						itemButton.TLHOverlay.text:SetText("")	-- No bind text for these
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
				MerchantPrevPageButton:HookScript("OnClick", function() merchantOverlay() C_Timer.After(0.1, merchantOverlay) end)	-- Previous page button
				MerchantNextPageButton:HookScript("OnClick", function() merchantOverlay() C_Timer.After(0.1, merchantOverlay) end)	-- Next page button
				MerchantFrame:HookScript("OnMouseWheel", function() merchantOverlay() C_Timer.After(0.1, merchantOverlay) end)	-- Scrolling, which also changes the page

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

					-- Get our quest rewards
					local itemLink
					if rewardsFrame == QuestInfoRewardsFrame then
						itemLink = GetQuestItemLink("choice", k) or GetQuestItemLink("reward", k)
					elseif rewardsFrame == MapQuestInfoRewardsFrame then
						itemLink = GetQuestLogItemLink("choice", k) or GetQuestLogItemLink("reward", k)
					end

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

					if highestPrice and highestItem then
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

			if QuestInfoRewardsFrame and not WorldMapFrame:IsShown() then
				rewardOverlay(QuestInfoRewardsFrame)
			end

			if MapQuestInfoRewardsFrame and WorldMapFrame:IsShown() then
				rewardOverlay(MapQuestInfoRewardsFrame)
			end
		end

		app.Event:Register("QUEST_DETAIL", questOverlay)
		hooksecurefunc("QuestMapFrame_ShowQuestDetails", function() questOverlay() C_Timer.After(0.1, questOverlay) end)

		-- Hook our overlay onto all world quest pins
		local function worldQuests()
			C_Timer.After(0.1, function()
				for pin in WorldMapFrame:EnumeratePinsByTemplate("WorldMap_WorldQuestPinTemplate") do
					if not pin.TLHOverlay then
						pin.TLHOverlay = CreateFrame("Frame", nil, pin)
						pin.TLHOverlay:SetAllPoints(pin)
					end
					pin.TLHOverlay:Hide()	-- Hide our overlay initially, updating doesn't work like for regular itemButtons

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
			end)
		end

		WorldMapFrame:HookScript("OnShow", worldQuests)
		EventRegistry:RegisterCallback("MapCanvas.MapSet", worldQuests)

		-- Hook our overlay onto all recipe rows
		local function recipeRows()
			-- Thank you AGAIN Plusmouse, for this callback
			ProfessionsFrame.CraftingPage.RecipeList.ScrollBox:RegisterCallback("OnAcquiredFrame", function(_, v, data)
				if not v.TLHOverlay then
					v.TLHOverlay = CreateFrame("Frame", nil, v)
				end
				v.TLHOverlay:Hide()

				local recipeInfo = data.data.recipeInfo
				if recipeInfo then
					local recipeID = recipeInfo.recipeID
					if recipeID then
						local itemLink = C_TradeSkillUI.GetRecipeItemLink(recipeID)
						if itemLink then
							app.ItemOverlay(v.TLHOverlay, itemLink)
							v.TLHOverlay.text:SetText("")	-- No bind text for these

							v.TLHOverlay.icon:ClearAllPoints()
							v.TLHOverlay.icon:SetPoint("RIGHT", v)	-- Set the icon to the right of the row
							-- Delay this bit, sometimes it doesn't quite trigger right
							C_Timer.After(0.2, function()
								v.TLHOverlay.animation:Stop()	-- And don't animate, that's a little obnoxious in these close quarters
							end)
						end
					end
				end
			end)
		end

		app.Event:Register("TRADE_SKILL_SHOW", recipeRows)
		EventRegistry:RegisterCallback("Professions.ProfessionSelected", recipeRows)

		app.Count = 0
		-- Hook our overlay onto all recipe rows
		local function auctionHouseRows()
			-- Thank you AGAIN Plusmouse, for this callback
			AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBox:RegisterCallback("OnAcquiredFrame", function(_, v, data)
				C_Timer.After(0.1, function()
					if not v.TLHOverlay then
						v.TLHOverlay = CreateFrame("Frame", nil, v)
					end
					v.TLHOverlay:Hide()

					local rowData = v.rowData
					if rowData then
						local itemID = rowData.itemKey.itemID
						if itemID then
							local _, itemLink = C_Item.GetItemInfo(itemID)
							if itemLink then
								app.ItemOverlay(v.TLHOverlay, itemLink)
								v.TLHOverlay.text:SetText("")	-- No bind text for these

								v.TLHOverlay.icon:ClearAllPoints()
								v.TLHOverlay.icon:SetPoint("LEFT", v, 134, 0)	-- Set the icon to the left of the row
								v.TLHOverlay.animation:Stop()	-- And don't animate, that's a little obnoxious in these close quarters
							end
						end
					end
				end)
			end)
		end

		app.Event:Register("AUCTION_HOUSE_THROTTLED_SYSTEM_READY", auctionHouseRows)
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

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Collection Info"))

	local variable, name, tooltip = "iconNewMog", "Appearances", "Show an icon to indicate an item's appearance is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewSource", "Sources", "Show an icon to indicate an item's appearance source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewMog"] end)

	local variable, name, tooltip = "iconNewIllusion", "Illusions", "Show an icon to indicate an illusion is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewMount", "Mounts", "Show an icon to indicate a mount is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewPet", "Pets", "Show an icon to indicate a pet is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewPetMax", "Collect 3/3", "Also take the maximum number of pets you can own into account (usually 3)."
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return TransmogLootHelper_Settings["iconNewPet"] end)

	local variable, name, tooltip = "iconNewToy", "Toys", "Show an icon to indicate an item's source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconNewRecipe", "Recipes", "Show an icon to indicate an item's source is unlearned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconLearned", "Learned", "Show an icon to indicate the above tracked collectibles are learned."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, false)
	Settings.CreateCheckbox(category, setting, tooltip)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Other Info"))

	local variable, name, tooltip = "iconQuestGold", "Quest Reward Sell Value", "Show an icon to indicate which quest reward has the highest vendor sell value, if there are multiple."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconUsable", "Usable Items", "Show an icon to indicate an item can be used (currently only Profession Knowledge items)."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "iconContainer", "Openable Containers", "Show an icon to indicate an item can be opened, such as lockboxes and holiday boss bags."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "textBind", "Binding Status", "Show a text indicator for Bind-on-Equip items (BoE), Warbound items (BoA), and Warbound-until-Equipped (WuE) items."
	local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, TransmogLootHelper_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
end