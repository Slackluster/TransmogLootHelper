--------------------------------------------
-- Transmoog Loot Helper: ItemOverlay.lua --
--------------------------------------------

-- Initialisation
local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not TransmogLootHelper_Cache then TransmogLootHelper_Cache = {} end
		if not TransmogLootHelper_Cache.Recipes then TransmogLootHelper_Cache.Recipes = {} end
		if not TransmogLootHelper_Cache.Decor then TransmogLootHelper_Cache.Decor = {} end

		app.OverlayCache = {}

		app:HookItemOverlay()
		app:AddTooltipInfo()

		-- Midnight cleanup
		if not TransmogLootHelper_Cache.Midnight then
			StaticPopupDialogs["TRANSMOGLOOTHELPER_MIDNIGHT"] = {
				text = app.NameLong .. "\n\n"
					.. "Cached recipes have been reset\n"
					.. "to allow cleanup of specific characters.\n\n"
					.. "Please open your professions again\n"
					.. "to cache your recipes!",
				button1 = OKAY,
				whileDead = true,
			}
			StaticPopup_Show("TRANSMOGLOOTHELPER_MIDNIGHT")
			TransmogLootHelper_Cache.Recipes = {}
			TransmogLootHelper_Cache.Midnight = true
		end
	end
end)

------------------
-- ITEM OVERLAY --
------------------

-- Create and set our icon and text overlay
function app:CreateItemOverlay(overlay, itemLink, itemLocation, containerInfo, bagAddon, additionalInfo)
	-- Create our overlay
	local function createOverlay()
		-- Text
		if not overlay.text then
			overlay.text = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormalOutline")
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
		if not (bagAddon and C_AddOns.IsAddOnLoaded("Baganator")) then
			if TransmogLootHelper_Settings["iconPosition"] == 0 then
				overlay.icon:SetPoint("CENTER", overlay, "TOPLEFT", 4, -4)
			elseif TransmogLootHelper_Settings["iconPosition"] == 1 then
				overlay.icon:SetPoint("CENTER", overlay, "TOPRIGHT", -4, -4)
			elseif TransmogLootHelper_Settings["iconPosition"] == 2 then
				overlay.icon:SetPoint("CENTER", overlay, "BOTTOMLEFT", 4, 4)
			elseif TransmogLootHelper_Settings["iconPosition"] == 3 then
				overlay.icon:SetPoint("CENTER", overlay, "BOTTOMRIGHT", -4, 4)
			end
		end
	end
	createOverlay()

	-- Process our overlay
	local function processOverlay(itemID)
		local hasItemLocation = false
		if itemLocation or bagAddon then
			hasItemLocation = true
		end

		-- Cache our info, if we haven't yet.
		if not app.OverlayCache[itemLink] or hasItemLocation and app.OverlayCache[itemLink].hasItemLocation == false then
			-- Grab our item info, which is enough for appearances
			local _, _, itemQuality, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID, bindType, _, _, _ = C_Item.GetItemInfo(itemLink)

			-- Containers
			if containerInfo and containerInfo.hasLoot then
				itemEquipLoc = "Container"
			-- Decor
			elseif C_Item.IsDecorItem(itemLink) or app.Decor[itemID] then
				itemEquipLoc = "Decor"
			-- Mounts
			elseif classID == Enum.ItemClass.Miscellaneous and subclassID == Enum.ItemMiscellaneousSubclass.Mount then
				itemEquipLoc = "Mount"
			-- Recipes
			elseif classID == Enum.ItemClass.Recipe and subclassID ~= Enum.ItemRecipeSubclass.Book then
				itemEquipLoc = "Recipe"
			-- Toys
			elseif C_ToyBox.GetToyInfo(itemID) then
				itemEquipLoc = "Toy"
			-- Pets
			elseif C_PetJournal.GetPetInfoByItemID(itemID) then
				itemEquipLoc = "Pet"
			-- Customisations and spellbooks
			elseif app.QuestItem[itemID] or app.SpellItem[itemID] then
				itemEquipLoc = "Customisation"

				-- Check for profession books
				if app.SpellItem[itemID] then
					local _, _, tradeskill = C_TradeSkillUI.GetTradeSkillLineForRecipe(app.SpellItem[itemID])

					if app.Icon[tradeskill] then
						itemEquipLoc = "Recipe"
					end
				end
			-- Illusions, Ensembles, and Arsenals
			elseif classID == Enum.ItemClass.Consumable and subclassID == Enum.ItemConsumableSubclass.Other then
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

				-- Check if it's an arsenal
				local localeArsenal = {
					"Arsenal:",
					"Arsenal :",
					"Arsenale:",
					"Арсенал:",
					"병기:",
					"军械：",
					"武器庫：",
				}
				for k, v in pairs(localeArsenal) do
					if itemName:find("^" .. v) then
						itemEquipLoc = "Arsenal"
						break
					end
				end
			-- Check for other item types
			else
				-- Profession Knowledge
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
					if app:GetTooltipText(itemLink, v) then
						itemEquipLoc = "ProfessionKnowledge"
						break
					end
				end

				-- Other containers
				local localeOtherContainers = {
					ITEM_OPENABLE,	-- <Right Click to Open>
					"Use: Collect",
					"Use: Open the container",
					"Benutzen: Sammelt",
					"Benutzen: Öffnet den Behälter",
					"Uso: Recoges",
					"Uso: Abre el contenedor",
					"Uso: Recolecta",
					"Uso: Abrir el contenedor",
					"Utilise: Récupère",
					"Utilise: Ouvre le conteneur",
					"Usa: Fornisce",
					"Usa: Apri il contenitore",
					"Uso: Coleta",
					"Uso: Abre o recipiente",
					"Использование: Получить",
					"Использование: Открыть контейнер",
					"사용 효과:",
					"사용 효과: 상자를 엽니다",
					"使用: 收集",
					"使用: 打开箱子",
					"使用: 開啟容器",
				}
				for k, v in pairs(localeOtherContainers) do
					-- Exception for the Korean string, as it contains two parts that aren't directly concatenated
					if app:GetTooltipText(itemLink, v) and (v ~= "사용 효과:" or app:GetTooltipText(itemLink, "획득합니다")) then
						itemEquipLoc = "Container"
						break
					end
				end
			end

			-- Cache this info, so we don't need to check it again
			app.OverlayCache[itemLink] = { itemEquipLoc = itemEquipLoc, bindType = bindType, itemQuality = itemQuality, hasItemLocation = hasItemLocation }
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
				if TransmogLootHelper_Settings["animateIcon"] then
					overlay.animation:Play()
				else
					overlay.animation:Stop()
				end

				-- Simple icon
				if TransmogLootHelper_Settings["simpleIcon"] then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\icon_purple.blp")
				end
			elseif color == "yellow" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_yellow.blp")
				if TransmogLootHelper_Settings["animateIcon"] then
					overlay.animation:Play()
				else
					overlay.animation:Stop()
				end

				-- Simple icon
				if TransmogLootHelper_Settings["simpleIcon"] then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\icon_yellow.blp")
				end
			elseif color == "green" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_green.blp")
				overlay.animation:Stop()

				-- Simple icon
				if TransmogLootHelper_Settings["simpleIcon"] then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\icon_green.blp")
				end
			elseif color == "red" then
				overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border_red.blp")
				overlay.animation:Stop()

				-- Simple icon
				if TransmogLootHelper_Settings["simpleIcon"] then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\icon_red.blp")
				end
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
				local attInfo
				if C_AddOns.IsAddOnLoaded("AllTheThings") then
					attInfo = AllTheThings.GetLinkReference(itemLink)
				end
				local tumInfo
				if C_AddOns.IsAddOnLoaded("TransmogUpgradeMaster") then
					tumInfo = TransmogUpgradeMaster_API.GetAppearanceMissingData(itemLink)
				end

				-- New appearance
				if not api:IsAppearanceCollected(itemLink) then
					showOverlay("purple")
				-- New source
				elseif TransmogLootHelper_Settings["iconNewSource"] and not api:IsSourceCollected(itemLink) then
					showOverlay("yellow")
				-- Catalyst mog
				elseif TransmogLootHelper_Settings["iconNewCatalyst"] and ((tumInfo and tumInfo.catalystAppearanceMissing) or (attInfo and attInfo.filledCatalyst)) then
					overlay.texture:SetAtlas("CreationCatalyst-32x32")
					showOverlay("yellow")
				-- Upgrade mog
				elseif TransmogLootHelper_Settings["iconNewUpgrade"] and ((tumInfo and tumInfo.upgradeAppearanceMissing) or (attInfo and attInfo.filledUpgrade)) then
					overlay.texture:SetAtlas("CovenantSanctum-Upgrade-Icon-Available")
					showOverlay("yellow")
				-- Learned
				elseif TransmogLootHelper_Settings["iconLearned"] and not (classID == 15 and subclassID == 0) then
					showOverlay("green")
				else
					hideOverlay()
				end
			-- Ensembles & Arsenals
			elseif TransmogLootHelper_Settings["iconNewMog"] and (itemEquipLoc == "Ensemble" or itemEquipLoc == "Arsenal") then
				-- Learned
				if app:IsLearned(itemLink) then
					if TransmogLootHelper_Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				-- Unusable
				elseif app:HasRedTooltipText(itemLink) then
					showOverlay("red")
				-- Unlearned
				else
					showOverlay("purple")
				end
			-- Illusions
			elseif TransmogLootHelper_Settings["iconNewIllusion"] and itemEquipLoc == "Illusion" then
				-- Learned
				if app:IsLearned(itemLink) then
					if TransmogLootHelper_Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				-- Unusable
				elseif app:HasRedTooltipText(itemLink) then
					showOverlay("red")
				-- Unlearned
				else
					showOverlay("purple")
				end
			-- Mounts
			elseif TransmogLootHelper_Settings["iconNewMount"] and itemEquipLoc == "Mount" then
				-- Learned
				if app:IsLearned(itemLink) then
					if TransmogLootHelper_Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				-- Unusable
				elseif app:HasRedTooltipText(itemLink) then
					showOverlay("red")
				-- Unlearned
				else
					showOverlay("purple")
				end
			-- Pets
			elseif TransmogLootHelper_Settings["iconNewPet"] and itemEquipLoc == "Pet" then
				-- If we haven't grabbed this info from a pet cage, grab it now
				if not app.OverlayCache[itemLink].speciesID then
					app.OverlayCache[itemLink].speciesID = select(13, C_PetJournal.GetPetInfoByItemID(itemID))
				end

				-- Account for a Blizz API bug that is apparently present, this is why we can't have nice things
				local numPets, maxAllowed = 0, 0
				if app.OverlayCache[itemLink].speciesID then
					numPets, maxAllowed = C_PetJournal.GetNumCollectedInfo(app.OverlayCache[itemLink].speciesID)
				end

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
				if PlayerHasToy(itemID) then
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
				if app.SpellItem[itemID] then
					local recipeID = app.SpellItem[itemID]

					if TransmogLootHelper_Cache.Recipes[recipeID] then
						-- Set profession icon
						local _, _, tradeskill = C_TradeSkillUI.GetTradeSkillLineForRecipe(recipeID)
						if app.Icon[tradeskill] then
							overlay.texture:SetTexture(app.Icon[tradeskill])
						end

						-- Learned
						if TransmogLootHelper_Cache.Recipes[recipeID].learned then
							if TransmogLootHelper_Settings["iconLearned"] then
								showOverlay("green")
							else
								hideOverlay()
							end
						-- Unlearned
						else
							if C_TradeSkillUI.IsRecipeProfessionLearned(recipeID) then
								showOverlay("purple")
							else
								showOverlay("red")
							end
						end
					-- Uncached
					else
						overlay.texture:SetTexture(app.Icon["Recipe"])
						showOverlay("yellow")
						overlay.animation:Stop()
					end
				else
					hideOverlay()
				end
			-- Decor
			elseif TransmogLootHelper_Settings["iconNewDecor"] and itemEquipLoc == "Decor" then
				local decorInfo, recordID
				if app.Decor[itemID] then
					decorInfo = C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, app.Decor[itemID], true)
					recordID = decorInfo.entryID.recordID or app.Decor[itemID]
				else
					decorInfo = C_HousingCatalog.GetCatalogEntryInfoByItem(itemID, true)
					recordID = decorInfo.entryID.recordID
				end

				if recordID then
					if not TransmogLootHelper_Cache.Decor[recordID] and decorInfo then
						TransmogLootHelper_Cache.Decor[recordID] = { owned = 0 }
						TransmogLootHelper_Cache.Decor[recordID].grantsXP = false
						TransmogLootHelper_Cache.Decor[recordID].xp = decorInfo.firstAcquisitionBonus
						if decorInfo.firstAcquisitionBonus > 0 then
							TransmogLootHelper_Cache.Decor[recordID].grantsXP = true
						end
					end

					if TransmogLootHelper_Cache.Decor[recordID].xp and TransmogLootHelper_Cache.Decor[recordID].xp > 0 then
						overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\ui_homestone-64-blue.blp")
					end

					-- Double-check quantity if zero, because decor placed in your other house doesn't return via API
					if TransmogLootHelper_Cache.Decor[recordID].owned == 0 then
						local tooltip = C_TooltipInfo.GetHyperlink(itemLink)
						if tooltip and tooltip["lines"] then
							for k, v in ipairs(tooltip["lines"]) do
								if v.type == 0 and v.leftText then
									local compareText = v.leftText:gsub("%d+", "%%d")
									if compareText == HOUSING_DECOR_OWNED_COUNT_FORMAT then
										TransmogLootHelper_Cache.Decor[recordID].owned = tonumber(v.leftText:match("%d+")) or 0
										break
									end
								end
							end
						end
					end

					if TransmogLootHelper_Settings["iconNewDecorXP"] then
						if TransmogLootHelper_Cache.Decor[recordID].grantsXP then
							showOverlay("purple")
						elseif TransmogLootHelper_Settings["iconLearned"] and TransmogLootHelper_Cache.Decor[recordID].xp > 0 then
							showOverlay("green")
						else
							hideOverlay()
						end
					elseif TransmogLootHelper_Cache.Decor[recordID].owned > 0 then
						if TransmogLootHelper_Settings["iconLearned"] then
							showOverlay("green")
						else
							hideOverlay()
						end
					else
						showOverlay("purple")
					end
				else
					showOverlay("yellow")
					overlay.animation:Stop()
				end
			-- Profession Knowledge
			elseif TransmogLootHelper_Settings["iconUsable"] and itemEquipLoc == "ProfessionKnowledge" then
				-- Unusable
				if app:HasRedTooltipText(itemLink) then
					hideOverlay()
				-- Usable
				else
					showOverlay("yellow")
				end
			-- Customisations (includes spellbooks)
			elseif TransmogLootHelper_Settings["iconUsable"] and itemEquipLoc == "Customisation" then
				-- Learned
				if (TransmogLootHelper_Cache.Recipes[app.SpellItem[itemID]] and TransmogLootHelper_Cache.Recipes[app.SpellItem[itemID]].learned) or (app.QuestItem[itemID] and C_QuestLog.IsQuestFlaggedCompletedOnAccount(app.QuestItem[itemID])) or app:IsLearned(itemLink) then
					if TransmogLootHelper_Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				-- Unusable
				elseif app:HasRedTooltipText(itemLink) then
					showOverlay("red")
				-- Unlearned
				else
					showOverlay("purple")
				end
			-- Containers
			elseif TransmogLootHelper_Settings["iconContainer"] and itemEquipLoc == "Container" then
				if not containerInfo then
					hideOverlay()
				else
					if app:HasRedTooltipText(itemLink) then
						showOverlay("red")
					else
						showOverlay("yellow")
					end
				end
			else
				hideOverlay()
			end
		else
			hideOverlay()
		end

		-- Set the bind text
		if TransmogLootHelper_Settings["textBind"] and not C_AddOns.IsAddOnLoaded("Baganator") then
			-- WuE
			if itemLocation and C_Item.IsBoundToAccountUntilEquip(itemLocation) then
				if C_Item.IsBound(itemLocation) then
					overlay.text:SetText("")
				else
					overlay.text:SetText("|cff00CCFF" .. L.BINDTEXT_WUE .. "|r")
				end
			-- WuE on vendor
			elseif not itemLocation and app:GetBonding(itemLink) == "WuE" then
				overlay.text:SetText("|cff00CCFF" .. L.BINDTEXT_WUE .. "|r")
			-- Soulbound + BoA
			elseif itemLocation and C_Item.IsBound(itemLocation) then
				if app:GetBonding(itemLink) == "BoA" then
					overlay.text:SetText("|cff00CCFF" .. L.BINDTEXT_BOA .. "|r")
				-- Soulbound
				else
					overlay.text:SetText("")
				end
			-- BoE
			elseif bindType == 2 or bindType == 3 then
				overlay.text:SetText(L.BINDTEXT_BOE)
			else
				overlay.text:SetText("")
			end
		else
			overlay.text:SetText("")
		end
	end

	local ignore = {
		[37011] = true,	-- Magic Broom
	}
	local itemID = C_Item.GetItemInfoInstant(itemLink)
	-- Caged pets don't return this info, except this one magical pet cage
	if not itemID or itemID == 82800 then
		local speciesID = string.match(itemLink, "battlepet:(%d+):")
		if additionalInfo and type(additionalInfo) == "number" then speciesID = additionalInfo end
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
	elseif ignore[itemID] then
		return
	else
		-- Cache the item by asking the server to give us the info
		C_Item.RequestLoadItemDataByID(itemID)
		local item = Item:CreateFromItemID(itemID)

		-- And when the item is cached
		item:ContinueOnItemLoad(function()
			-- Also cache the spell associated with this item (or a dummy spell if none)
			-- We do this to make sure all tooltip lines (Use: lines especially) are loaded in by the time we scan the tooltip, if necessary
			local spellID = select(2, C_Item.GetItemSpell(itemLink)) or 61304
			local spell = Spell:CreateFromSpellID(spellID)
			spell:ContinueOnSpellLoad(function()
				processOverlay(itemID)
			end)
		end)
	end
end

-- Hook our overlay onto items in various places
function app:HookItemOverlay()
	if TransmogLootHelper_Settings["overlay"] then
		-- Hook our overlay onto all bag slots (thank you Plusmouse!)
		local function bagsOverlay(container)
			if not app.BagThrottle then app.BagThrottle = {} end
			if not app.BagThrottle[container] then
				app.BagThrottle[container] = 0
				C_Timer.After(0.1, function()
					if app.BagThrottle[container] >= 1 then
						app.BagThrottle[container] = nil
						bagsOverlay(container)
					else
						app.BagThrottle[container] = nil
					end
				end)
			else
				app.BagThrottle[container] = 1
				return
			end

			for _, itemButton in ipairs(container.Items) do
				if itemButton and not itemButton.TLHOverlay then
					itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
					itemButton.TLHOverlay:SetAllPoints(itemButton)
				end

				local itemLocation = ItemLocation:CreateFromBagAndSlot(itemButton:GetBagID(), itemButton:GetID())
				local exists = C_Item.DoesItemExist(itemLocation)
				if exists then
					local itemLink = C_Item.GetItemLink(itemLocation)
					local containerInfo = C_Container.GetContainerItemInfo(itemButton:GetBagID(), itemButton:GetID())
					app:CreateItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
				else
					itemButton.TLHOverlay:Hide()
				end
			end
		end

		for i = 1, 6 do
			if _G["ContainerFrame" .. i] then
				hooksecurefunc(_G["ContainerFrame" .. i], "UpdateItems", bagsOverlay)
			end
		end
		hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", bagsOverlay)

		-- Hook our overlay onto all (war)bank slots
		local function bankOverlay()
			if not app.BankThrottle then
				app.BankThrottle = 0
				C_Timer.After(0.1, function()
					if app.BankThrottle >= 1 then
						app.BankThrottle = nil
						bankOverlay()
					else
						app.BankThrottle = nil
					end
				end)
			else
				app.BankThrottle = 1
				return
			end

			if BankFrame and BankFrame:IsShown() then
				local function bank()
					for i = 1, 98 do
						local itemButton = BankPanel:FindItemButtonByContainerSlotID(i)
						if itemButton and not itemButton.TLHOverlay then
							itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
							itemButton.TLHOverlay:SetAllPoints(itemButton)
						end

						if itemButton and itemButton.TLHOverlay then
							local itemLocation = ItemLocation:CreateFromBagAndSlot(BankPanel.selectedTabID, i)
							local exists = false
							if BankPanel.selectedTabID then
								exists = C_Item.DoesItemExist(itemLocation)
							end
							if exists then
								local itemLink = C_Item.GetItemLink(itemLocation)
								local containerInfo = C_Container.GetContainerItemInfo(BankPanel.selectedTabID, i)
								app:CreateItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
							else
								itemButton.TLHOverlay:Hide()
							end
						end
					end
				end

				-- Delay a bit if we're checking the bank for the first time
				if not app.BankHook then
					C_Timer.After(1, bank)
					app.BankHook = true
				else
					bank()
				end
			end
		end

		hooksecurefunc(BankPanel, "RefreshBankPanel", bankOverlay)
		hooksecurefunc(BankPanel, "OnUpdate", bankOverlay)
		app.Event:Register("BANKFRAME_OPENED", bankOverlay)
		app.Event:Register("BAG_UPDATE_DELAYED", bankOverlay)
		-- Update if we learn a mog or recipe
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", function() C_Timer.After(0.1, bankOverlay) end)
		app.Event:Register("NEW_RECIPE_LEARNED", function() C_Timer.After(0.1, bankOverlay) end)

		-- Hook our overlay onto all guild bank slots
		local function guildBankOverlay()
			if not app.GuildBankThrottle then
				app.GuildBankThrottle = 0
				C_Timer.After(0.1, function()
					if app.GuildBankThrottle >= 1 then
						app.GuildBankThrottle = nil
						guildBankOverlay()
					else
						app.GuildBankThrottle = nil
					end
				end)
			else
				app.GuildBankThrottle = 1
				return
			end

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
							app:CreateItemOverlay(itemButton.TLHOverlay, itemLink)
						else
							itemButton.TLHOverlay:Hide()
						end
					end
				end
			end
		end

		app.Event:Register("GUILDBANKBAGSLOTS_CHANGED", guildBankOverlay)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", guildBankOverlay)
		-- Update if we learn a mog or recipe
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", function() C_Timer.After(0.1, guildBankOverlay) end)
		app.Event:Register("NEW_RECIPE_LEARNED", function() C_Timer.After(0.1, guildBankOverlay) end)

		-- Hook our overlay onto all black market items
		local function blackMarketOverlay()
			if BlackMarketFrame and BlackMarketFrame:IsShown() then
				if not app.BlackMarketFrameHook then
					-- Thank you AGAIN Plusmouse, for this callback
					BlackMarketFrame.ScrollBox:RegisterCallback("OnAcquiredFrame", function(_, v, data)
						C_Timer.After(0.1, function()
							if not v.TLHOverlay then
								v.TLHOverlay = CreateFrame("Frame", nil, v)
								v.TLHOverlay:SetAllPoints(v.Item)
							end
							v.TLHOverlay:Hide()

							local itemLink = v.itemLink
							if itemLink then
								app:CreateItemOverlay(v.TLHOverlay, itemLink)
								v.TLHOverlay.text:SetText("")	-- No bind text for these
							end
						end)
					end)
					app.BlackMarketFrameHook = true
				end
			end
		end

		app.Event:Register("BLACK_MARKET_OPEN", function() C_Timer.After(0.1, blackMarketOverlay) end)

		-- Hook our overlay onto all merchant slots
		local function merchantOverlay()
			if not app.MerchantHook then
				MerchantPrevPageButton:HookScript("OnClick", function() merchantOverlay() C_Timer.After(0.1, merchantOverlay) end)	-- Previous page button
				MerchantNextPageButton:HookScript("OnClick", function() merchantOverlay() C_Timer.After(0.1, merchantOverlay) end)	-- Next page button
				MerchantFrame:HookScript("OnMouseWheel", function() merchantOverlay() C_Timer.After(0.1, merchantOverlay) end)	-- Scrolling, which also changes the page
				MerchantFrame.FilterDropdown:RegisterCallback("OnMenuClose", function() merchantOverlay() C_Timer.After(0.1, merchantOverlay) end)	-- For when users change the filtering
				app.MerchantHook = true
			end

			for i = 1, 99 do	-- Works for addons that expand the vendor frame up to 99 slots
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
						app:CreateItemOverlay(itemButton.TLHOverlay, itemLink)
					else
						itemButton.TLHOverlay:Hide()
					end
				end
			end
		end

		app.Event:Register("MERCHANT_SHOW", function() C_Timer.After(0.1, merchantOverlay) end)
		-- Update if we learn a mog or recipe
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", function() C_Timer.After(0.1, merchantOverlay) end)
		app.Event:Register("NEW_RECIPE_LEARNED", function() C_Timer.After(0.1, merchantOverlay) end)

		-- Hook our overlay onto all quest rewards
		local function questOverlay(mode)
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

					if v.type then
						if mode == "turnin" then
							-- Set our map quest log to the currently displayed quest, stuff is being weird on quest turn-in
							if GetQuestID() then
								C_QuestLog.SetSelectedQuest(GetQuestID())
							end

							itemLink = GetQuestLogItemLink(v.type, k)
						elseif rewardsFrame == QuestInfoRewardsFrame then
							itemLink = GetQuestItemLink(v.type, k)
						elseif rewardsFrame == MapQuestInfoRewardsFrame then
							itemLink = GetQuestLogItemLink(v.type, k)
						end

						if v.objectType == "currency" then
							itemButton.TLHOverlay:Hide()
						elseif itemLink then
							table.insert(sellPrice, { price = select(11, C_Item.GetItemInfo(itemLink)), itemButton = itemButton})
							app:CreateItemOverlay(itemButton.TLHOverlay, itemLink)
							itemButton.TLHOverlay:SetAllPoints(itemButton.IconBorder)
						else
							itemButton.TLHOverlay:Hide()
						end
					else
						itemButton.TLHOverlay:Hide()
					end
				end

				if TransmogLootHelper_Settings["iconQuestGold"] and #sellPrice > 1 then
					local highestPrice = 0
					local highestItem = nil
					local diff = -1

					for k, v in ipairs(sellPrice) do
						-- If all items have the same value, we don't show an icon
						if v.price > 1 and v.price ~= highestPrice then
							diff = diff + 1
						end

						if v.price > 1 and v.price > highestPrice then
							highestPrice = v.price
							highestItem = v.itemButton
						end
					end

					if highestItem and diff > 0 then
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
				C_Timer.After(1, function()
					rewardOverlay(QuestInfoRewardsFrame)
				end)
			end

			if MapQuestInfoRewardsFrame and WorldMapFrame:IsShown() then
				rewardOverlay(MapQuestInfoRewardsFrame)
			end
		end

		app.Event:Register("QUEST_DETAIL", questOverlay)
		app.Event:Register("QUEST_COMPLETE", function() questOverlay("turnin") end)
		hooksecurefunc("QuestMapFrame_ShowQuestDetails", function() questOverlay() C_Timer.After(0.1, questOverlay) end)

		-- Hook our overlay onto all world quest pins
		local function worldQuestOverlay()
			C_Timer.After(0.1, function()
				for pin in WorldMapFrame:EnumeratePinsByTemplate("WorldMap_WorldQuestPinTemplate") do
					if not pin.TLHOverlay then
						pin.TLHOverlay = CreateFrame("Frame", nil, pin)
						pin.TLHOverlay:SetAllPoints(pin)
						pin.TLHOverlay:SetScale(0.8)	-- Make it a little smaller
					end
					pin.TLHOverlay:Hide()	-- Hide our overlay initially, updating doesn't work like for regular itemButtons

					local bestIndex, bestType = QuestUtils_GetBestQualityItemRewardIndex(pin.questID)
					if bestIndex and bestType then
						local itemLink = GetQuestLogItemLink(bestType, bestIndex, pin.questID)
						if itemLink then
							app:CreateItemOverlay(pin.TLHOverlay, itemLink)
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

		WorldMapFrame:HookScript("OnShow", worldQuestOverlay)
		EventRegistry:RegisterCallback("MapCanvas.MapSet", worldQuestOverlay)

		-- Hook our overlay onto all encounter journal loot items
		local function encounterJournalOverlay()
			if EncounterJournal and EncounterJournal:IsShown() and not app.Flag.EncounterJournalHook then
				EncounterJournalEncounterFrameInfo.LootContainer.ScrollBox:RegisterCallback("OnAcquiredFrame", function(_, v)
					RunNextFrame(function()
						if v then
							if not v.TLHOverlay then
								v.TLHOverlay = CreateFrame("Frame", nil, v)
								local inset = 4
								v.TLHOverlay:SetPoint("TOPLEFT", v.icon, "TOPLEFT", inset, -inset)
								v.TLHOverlay:SetPoint("BOTTOMRIGHT", v.icon, "BOTTOMRIGHT", -inset, inset)
							end
							v.TLHOverlay:Hide()

							if v.link then
								app:CreateItemOverlay(v.TLHOverlay, v.link)
								v.TLHOverlay.text:SetText("")
								v.TLHOverlay.animation:Stop()
							end
						end
					end)
				end)
				app.Flag.EncounterJournalHook = true
			end
		end

		app.Event:Register("UPDATE_INSTANCE_INFO", encounterJournalOverlay)

		-- Hook our overlay onto all recipe rows
		local function tradeskillOverlay()
			if ProfessionsFrame and ProfessionsFrame:IsShown() then
				if not app.TradeskillHook then
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
									app:CreateItemOverlay(v.TLHOverlay, itemLink)
									v.TLHOverlay.text:SetText("")	-- No bind text for these

									v.TLHOverlay.icon:ClearAllPoints()
									v.TLHOverlay.icon:SetPoint("RIGHT", v)	-- Set the icon to the right of the row

									-- Delay this bit, sometimes it doesn't quite trigger right
									C_Timer.After(0.2, function()
										v.TLHOverlay.animation:Stop()	-- Don't animate, that's a little obnoxious in these close quarters
									end)
								end
							end
						end
					end)
					app.TradeskillHook = true
				end
			end
		end

		app.Event:Register("TRADE_SKILL_SHOW", tradeskillOverlay)

		-- Hook our overlay onto all Auction House entries
		local function auctionHouseOverlay()
			if AuctionHouseFrame and AuctionHouseFrame:IsShown() and not app.Flag.AuctionHouseHook then
				-- Thank you AGAIN Plusmouse, for this callback
				AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBox:RegisterCallback("OnAcquiredFrame", function(_, v)
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
									if itemID == 82800 and rowData.itemKey.battlePetSpeciesID then	-- Can't extract pet info from this preview cage
										app:CreateItemOverlay(v.TLHOverlay, itemLink, nil, nil, nil, rowData.itemKey.battlePetSpeciesID)
									else
										app:CreateItemOverlay(v.TLHOverlay, itemLink)
									end
									v.TLHOverlay.text:SetText("")	-- No bind text for these

									v.TLHOverlay.icon:ClearAllPoints()
									v.TLHOverlay.icon:SetPoint("LEFT", v, 134, 0)	-- Set the icon to the left of the row
									v.TLHOverlay.animation:Stop()	-- And don't animate, that's a little obnoxious in these close quarters
								end
							end
						end
					end)
				end)
				app.Flag.AuctionHouseHook = true
			end
		end

		app.Event:Register("AUCTION_HOUSE_THROTTLED_SYSTEM_READY", auctionHouseOverlay)

		-- Hook our overlay onto Great Vault rewards
		local function greatVaultOverlay()
			local function doTheThing()
				if WeeklyRewardsFrame and WeeklyRewardsFrame:IsShown() then
					local children = { WeeklyRewardsFrame:GetChildren() }
					for k, v in pairs(children) do
						if type(v) == "table" and v.hasRewards and v.ItemFrame then
							if v.info and v.info.rewards then
								if not v.TLHOverlay then
									v.TLHOverlay = CreateFrame("Frame", nil, v.ItemFrame)
									v.TLHOverlay:SetAllPoints(v.ItemFrame.Icon)
								end

								local itemLink = C_WeeklyRewards.GetItemHyperlink(v.info.rewards[1].itemDBID)
								app:CreateItemOverlay(v.TLHOverlay, itemLink)
							end
						end
					end
				end
			end
			-- Do the thing, then do it again 1 second later because it doesn't show immediately when generating rewards
			doTheThing()
			C_Timer.After(1, doTheThing)
		end

		app.Event:Register("WEEKLY_REWARDS_UPDATE", greatVaultOverlay)

		-- Update our overlay if a mog, recipe, or spell is learned
		function api:UpdateOverlay()
			assert(self == api, "Call TransmogLootHelper:UpdateOverlay(), not TransmogLootHelper.UpdateOverlay()")

			C_Timer.After(1, function()
				-- bagsOverlay()
				bankOverlay()
				merchantOverlay()
				questOverlay()
				worldQuestOverlay()
				tradeskillOverlay()
				auctionHouseOverlay()
			end)
		end

		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", function()
			api:UpdateOverlay()
		end)

		app.Event:Register("NEW_RECIPE_LEARNED", function(recipeID, recipeLevel, baseRecipeID)
			app:CacheRecipe(recipeID, true)
			api:UpdateOverlay()
		end)

		-- Cache player spells, for books that teach these
		local function cacheSpells()
			C_Timer.After(1, function()
				for itemID, spellID in pairs(app.SpellItem) do
					if C_SpellBook.IsSpellKnown(spellID) or C_SpellBook.IsSpellInSpellBook(spellID) then
						app:CacheRecipe(spellID, true)
					end
				end
			end)
		end

		app.Event:Register("PLAYER_ENTERING_WORLD", function(isInitialLogin, isReloadingUi)
			if isInitialLogin or isReloadingUi then cacheSpells() end
		end)

		app.Event:Register("SPELLS_CHANGED", function()
			cacheSpells()
			api:UpdateOverlay()
		end)
	end
end

------------------
-- TOOLTIP INFO --
------------------

-- Tooltip information (to tell the user a recipe is not cached)
function app:AddTooltipInfo()
	local function OnTooltipSetItem(tooltip)
		-- Only run any of this is the relevant setting is enabled
		if TransmogLootHelper_Settings["iconNewRecipe"] then
			local itemLink, itemID, secondaryItemLink, secondaryItemID
			local _, primaryItemLink, primaryItemID = TooltipUtil.GetDisplayedItem(GameTooltip)
			if tooltip.GetItem then _, secondaryItemLink, secondaryItemID = tooltip:GetItem() end

			-- Get our most accurate itemLink and itemID
			itemID = primaryItemID or secondaryItemID
			if itemID then
				local _, _, _, _, _, _, _, _, _, _, _, classID, subclassID = C_Item.GetItemInfo(itemID)
				if classID == 9 and subclassID ~= 0 and app.SpellItem[itemID] then
					local recipeID = app.SpellItem[itemID]
					if TransmogLootHelper_Cache.Recipes[recipeID] == nil then
						tooltip:AddLine(" ")
						tooltip:AddLine(app.IconTLH .. " " .. L.RECIPE_UNCACHED)
					end
				end
			end
		end
	end
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
end

---------------------
-- RECIPE TRACKING --
---------------------

function app:CacheRecipe(spellID, learned)
	app.CharacterName = app.CharacterName or UnitName("player") .. "-" .. GetNormalizedRealmName()

	if not TransmogLootHelper_Cache.Recipes[spellID] then
		TransmogLootHelper_Cache.Recipes[spellID] = { learned = false, knownBy = {} }
	end
	if learned then
		TransmogLootHelper_Cache.Recipes[spellID].learned = true

		local exists = false
		for i, character in ipairs(TransmogLootHelper_Cache.Recipes[spellID].knownBy) do
			if character == app.CharacterName then
				exists = true
				break
			end
		end

		if not exists then
			table.insert(TransmogLootHelper_Cache.Recipes[spellID].knownBy, app.CharacterName)
		end
	end
end

app.Event:Register("TRADE_SKILL_SHOW", function()
	if not InCombatLockdown() then
		C_Timer.After(2, function()	-- Delay to ensure data is available
			if not C_TradeSkillUI.IsTradeSkillLinked() and not C_TradeSkillUI.IsTradeSkillGuild() then
				for _, recipeID in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do
					if C_TradeSkillUI.GetRecipeInfo(recipeID).learned then
						app:CacheRecipe(recipeID, true)
					else
						app:CacheRecipe(recipeID)
					end
				end
				api:UpdateOverlay()
			end
		end)
	end
end)

function api:DeleteCharacter(characterName)
	assert(self == api, "Call TransmogLootHelper:DeleteCharacter(), not TransmogLootHelper.DeleteCharacter()")

	local removed = 0
	local unlearned = 0
	for recipeID, recipeInfo in pairs(TransmogLootHelper_Cache.Recipes) do
		local oldRemoved = removed
		for i = #recipeInfo.knownBy, 1, -1 do
			if recipeInfo.knownBy[i]:lower() == characterName:lower() then
				table.remove(recipeInfo.knownBy, i)
				removed = removed + 1
			end
		end
		if oldRemoved ~= removed and #recipeInfo.knownBy == 0 then
			recipeInfo.learned = false
			unlearned = unlearned + 1
		end
	end
	app:Print(L.DELETED_ENTRIES .. " " .. removed .. " | " .. L.DELETED_REMOVED .. " " .. unlearned)
	api:UpdateOverlay()
end

--------------------
-- DECOR TRACKING --
--------------------

app.Event:Register("PLAYER_ENTERING_WORLD", function(isInitialLogin, isReloadingUi)
	C_HousingCatalog.CreateCatalogSearcher()	-- Cache Decor
end)

app.Event:Register("HOUSE_DECOR_ADDED_TO_CHEST", function(decorGUID, recordID)
	if not TransmogLootHelper_Cache.Decor[recordID] then
		TransmogLootHelper_Cache.Decor[recordID] = { owned = 0 }
	end

	TransmogLootHelper_Cache.Decor[recordID].owned = TransmogLootHelper_Cache.Decor[recordID].owned + 1
	TransmogLootHelper_Cache.Decor[recordID].grantsXP = false

	local decorInfo = C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, recordID, true)
	if decorInfo then
		TransmogLootHelper_Cache.Decor[recordID].xp = decorInfo.firstAcquisitionBonus
	end
	api:UpdateOverlay()
end)

-- This is also triggered when we run C_HousingCatalog.CreateCatalogSearcher()
app.Event:Register("HOUSING_STORAGE_UPDATED", function()
	for itemID, recordID in pairs(app.Decor) do
		local decorInfo = C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, recordID, true)
		if decorInfo then
			if not decorInfo.numStored then
				if decorInfo.quantity > 100000 then decorInfo.quantity = 0 end
				decorInfo.numStored = decorInfo.remainingRedeemable + decorInfo.quantity
			end
			if not TransmogLootHelper_Cache.Decor[recordID] then
				TransmogLootHelper_Cache.Decor[recordID] = { grantsXP = false, xp = decorInfo.firstAcquisitionBonus }
				if (decorInfo.numStored + decorInfo.numPlaced) == 0 and decorInfo.firstAcquisitionBonus > 0 then
					TransmogLootHelper_Cache.Decor[recordID].grantsXP = true
				end
			end
			TransmogLootHelper_Cache.Decor[recordID].owned = decorInfo.numStored + decorInfo.numPlaced
		end
	end
end)
