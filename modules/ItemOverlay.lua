--------------------------------------------
-- Transmoog Loot Helper: ItemOverlay.lua --
--------------------------------------------

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
					.. "Please log your profession characters\n"
					.. "again to cache your recipes!",
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

function app:ApplyItemOverlay(overlay, itemLink, itemLocation, containerInfo, bagAddon, additionalInfo)
	local function createOverlay()
		if not overlay.text then
			overlay.text = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormalOutline")
			overlay.text:SetPoint("CENTER", overlay, 2, 1)
			overlay.text:SetScale(0.85)
		end

		if not overlay.icon then
			overlay.icon = CreateFrame("Frame", nil, overlay)
			overlay.icon:SetSize(16, 16)

			overlay.texture = overlay.icon:CreateTexture(nil, "ARTWORK")
			overlay.texture:SetAllPoints(overlay.icon)

			overlay.mask = overlay.icon:CreateMaskTexture()
			overlay.mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
			overlay.mask:SetAllPoints(overlay.texture)

			local frame = CreateFrame("Frame", nil, overlay.icon)
			frame:SetAllPoints(overlay.texture)
			overlay.border = frame:CreateTexture(nil, "OVERLAY")
			overlay.border:SetPoint("CENTER", overlay.texture)

			local frame = CreateFrame("Frame", nil, overlay.icon)
			frame:SetSize(10, 10)
			frame:SetPoint("CENTER", overlay.texture)
			frame:SetFrameLevel(overlay.icon:GetFrameLevel() - 1)
			overlay.animationTexture = frame:CreateTexture(nil, "ARTWORK")
			overlay.animationTexture:SetAllPoints(frame)
			overlay.animationTexture:SetAtlas("ArtifactsFX-SpinningGlowys-Purple", true)

			overlay.animation = overlay.animationTexture:CreateAnimationGroup()

			local spin = overlay.animation:CreateAnimation("Rotation")
			spin:SetDuration(2.5)
			spin:SetDegrees(-360)
			spin:SetOrder(1)

			local scale = 2.5
			local scaleUp = overlay.animation:CreateAnimation("Scale")
			scaleUp:SetDuration(1)
			scaleUp:SetScale(scale, scale)
			scaleUp:SetOrder(1)

			local spin2 = overlay.animation:CreateAnimation("Rotation")
			spin2:SetDuration(2.5)
			spin2:SetDegrees(-360)
			spin2:SetOrder(2)

			local scaleDown = overlay.animation:CreateAnimation("Scale")
			scaleDown:SetDuration(1)
			scaleDown:SetScale(1/scale, 1/scale)
			scaleDown:SetOrder(2)

			overlay.animation:SetLooping("REPEAT")
		end
	end
	createOverlay()

	local function processOverlay(itemID)
		local hasItemLocation = false
		if itemLocation or bagAddon then
			hasItemLocation = true
		end

		if itemID and itemID <= 4 then -- Fake preview items
			app.OverlayCache["item:1"] = { itemEquipLoc = "Mount", bindType = 1, itemQuality = 4, hasItemLocation = false, color = "purple" }
			app.OverlayCache["item:2"] = { itemEquipLoc = "INVTYPE_WEAPON", bindType = 2, itemQuality = 4, hasItemLocation = false, color = "yellow" }
			app.OverlayCache["item:3"] = { itemEquipLoc = "Recipe", bindType = 8, itemQuality = 4, hasItemLocation = false, color = "green" }
			app.OverlayCache["item:4"] = { itemEquipLoc = "Container", bindType = 0, itemQuality = 4, hasItemLocation = false, color = "red" }
		elseif not app.OverlayCache[itemLink] or (hasItemLocation and app.OverlayCache[itemLink].hasItemLocation == false) then
			local _, _, itemQuality, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID, bindType, _, _, _ = C_Item.GetItemInfo(itemLink)

			if containerInfo and containerInfo.hasLoot then
				itemEquipLoc = "Container"
			elseif C_Item.IsDecorItem(itemLink) or app.Decor[itemID] then
				itemEquipLoc = "Decor"
			elseif classID == Enum.ItemClass.Miscellaneous and subclassID == Enum.ItemMiscellaneousSubclass.Mount then
				itemEquipLoc = "Mount"
			elseif classID == Enum.ItemClass.Recipe and subclassID ~= Enum.ItemRecipeSubclass.Book then
				itemEquipLoc = "Recipe"
			elseif C_ToyBox.GetToyInfo(itemID) then
				itemEquipLoc = "Toy"
			elseif C_PetJournal.GetPetInfoByItemID(itemID) then
				itemEquipLoc = "Pet"
			elseif app.QuestItem[itemID] or app:GetLearnedSpell(itemLink) then
				itemEquipLoc = "Customisation"

				local spellID = app:GetLearnedSpell(itemLink)
				if spellID then
					local _, _, tradeskill = C_TradeSkillUI.GetTradeSkillLineForRecipe(spellID)
					if app.Texture[tradeskill] then itemEquipLoc = "Recipe" end
				end
			elseif classID == Enum.ItemClass.Consumable and subclassID == Enum.ItemConsumableSubclass.Other then
				local itemName = C_Item.GetItemInfo(itemLink)

				local localeIllusion = {
					"Illusion:",
					"Illusion :",
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

				local localeEnsemble = {
					"Ensemble:",
					"Ensemble :",
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

				local localeArsenal = {
					"Arsenal:",
					"Arsenal :",
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
					if app:GetTooltipText(itemLink, v) then
						itemEquipLoc = "ProfessionKnowledge"
						break
					end
				end

				local localeOtherContainers = {
					ITEM_OPENABLE, -- <Right Click to Open>
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

			app.OverlayCache[itemLink] = { itemEquipLoc = itemEquipLoc, bindType = bindType, itemQuality = itemQuality, hasItemLocation = hasItemLocation }
		end

		local itemEquipLoc = app.OverlayCache[itemLink].itemEquipLoc
		local icon = app.Texture[itemEquipLoc]
		local bindType = app.OverlayCache[itemLink].bindType

		overlay.texture:SetTexture(icon)
		overlay:Show()

		local function showOverlay(color)
			local function setCorner(style)
				overlay.texture:ClearAllPoints()
				if style == 1 then
					overlay.texture:SetAllPoints(overlay.icon)
					overlay.texture:AddMaskTexture(overlay.mask)
					overlay.border:SetSize(22, 22)
				elseif style == 2 then
					overlay.texture:SetPoint("TOPLEFT", overlay.icon, -1, 1)
					overlay.texture:SetPoint("BOTTOMRIGHT", overlay.icon, 1, -1)
				else
					overlay.texture:SetAllPoints(overlay.icon)
					overlay.border:SetSize(18, 18)
				end

				if style == 1 then
					overlay.mask:Show()
				else
					overlay.mask:Hide()
				end

				if not (bagAddon and C_AddOns.IsAddOnLoaded("Baganator")) then
					overlay.icon:ClearAllPoints()
					if style <= 2 then
						if app.Settings["iconPosition"] == 0 then
							overlay.icon:SetPoint("CENTER", overlay, "TOPLEFT", 4, -4)
						elseif app.Settings["iconPosition"] == 1 then
							overlay.icon:SetPoint("CENTER", overlay, "TOPRIGHT", -4, -4)
						elseif app.Settings["iconPosition"] == 2 then
							overlay.icon:SetPoint("CENTER", overlay, "BOTTOMLEFT", 4, 4)
						elseif app.Settings["iconPosition"] == 3 then
							overlay.icon:SetPoint("CENTER", overlay, "BOTTOMRIGHT", -4, 4)
						end
					else
						if app.Settings["iconPosition"] == 0 then
							overlay.icon:SetPoint("TOPLEFT", overlay, -1, 1)
						elseif app.Settings["iconPosition"] == 1 then
							overlay.icon:SetPoint("TOPRIGHT", overlay, 1, 1)
						elseif app.Settings["iconPosition"] == 2 then
							overlay.icon:SetPoint("BOTTOMLEFT", overlay, -1, -1)
						elseif app.Settings["iconPosition"] == 3 then
							overlay.icon:SetPoint("BOTTOMRIGHT", overlay, 1, -1)
						end
					end

					if style == 4 then
						if app.Settings["iconPosition"] == 0 then
							overlay.texture:SetRotation(math.pi/2)
						elseif app.Settings["iconPosition"] == 1 then
							overlay.texture:SetRotation(0)
						elseif app.Settings["iconPosition"] == 2 then
							overlay.texture:SetRotation(math.pi)
						elseif app.Settings["iconPosition"] == 3 then
							overlay.texture:SetRotation(-math.pi/2)
						end
					else
						overlay.texture:SetRotation(0)
					end
				elseif bagAddon and C_AddOns.IsAddOnLoaded("Baganator") and Baganator.API.GetCurrentCornerForWidget then
					if style > 2 then
						overlay.texture:ClearAllPoints()
						overlay.texture:SetSize(14, 14)
						if Baganator.API.GetCurrentCornerForWidget("transmogloothelper") == "top_left" then
							overlay.texture:SetPoint("CENTER", overlay.icon, 3, -3)
						elseif Baganator.API.GetCurrentCornerForWidget("transmogloothelper") == "top_right" then
							overlay.texture:SetPoint("CENTER", overlay.icon, -3, -3)
						elseif Baganator.API.GetCurrentCornerForWidget("transmogloothelper") == "bottom_left" then
							overlay.texture:SetPoint("CENTER", overlay.icon, 3, 3)
						elseif Baganator.API.GetCurrentCornerForWidget("transmogloothelper") == "bottom_right" then
							overlay.texture:SetPoint("CENTER", overlay.icon, -3, 3)
						end
					end

					if style == 4 then
						if Baganator.API.GetCurrentCornerForWidget("transmogloothelper") == "top_left" then
							overlay.texture:SetRotation(math.pi/2)
						elseif Baganator.API.GetCurrentCornerForWidget("transmogloothelper") == "top_right" then
							overlay.texture:SetRotation(0)
						elseif Baganator.API.GetCurrentCornerForWidget("transmogloothelper") == "bottom_left" then
							overlay.texture:SetRotation(math.pi)
						elseif Baganator.API.GetCurrentCornerForWidget("transmogloothelper") == "bottom_right" then
							overlay.texture:SetRotation(-math.pi/2)
						end
					else
						overlay.texture:SetRotation(0)
					end
				end
			end
			if color == "green" and app.Settings["learnedStyle"] > 0 then
				setCorner(app.Settings["learnedStyle"])
			else
				setCorner(app.Settings["iconStyle"])
			end

			overlay.border:SetTexture(nil)
			overlay.animationTexture:Show()
			if color == "purple" then
				overlay.animation:Stop()
				overlay.animationTexture:Hide()
				if app.Settings["animateIcon"] then
					overlay.animation:Play()
					overlay.animationTexture:Show()
				end

				if app.Settings["iconStyle"] == 1 then
					overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border-circle-purple.png")
				elseif app.Settings["iconStyle"] == 2 then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\simple-circle-purple.png")
				elseif app.Settings["iconStyle"] == 3 then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\simple-icon-purple.png")
				elseif app.Settings["iconStyle"] == 4 then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\cosmetic-icon-purple.png")
				end
			elseif color == "yellow" then
				overlay.animation:Stop()
				overlay.animationTexture:Hide()
				if app.Settings["animateIcon"] then
					overlay.animation:Play()
					overlay.animationTexture:Show()
				end

				if app.Settings["iconStyle"] == 1 then
					overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border-circle-yellow.png")
				elseif app.Settings["iconStyle"] == 2 then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\simple-circle-yellow.png")
				elseif app.Settings["iconStyle"] == 3 then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\simple-icon-yellow.png")
				elseif app.Settings["iconStyle"] == 4 then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\cosmetic-icon-yellow.png")
				end
			elseif color == "green" then
				overlay.animation:Stop()
				overlay.animationTexture:Hide()

				local function setStyle(style)
					if style == 1 then
						overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border-circle-green.png")
					elseif style == 2 then
						overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\simple-circle-green.png")
					elseif style == 3 then
						overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\simple-icon-green.png")
					elseif style == 4 then
						overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\cosmetic-icon-green.png")
					end
				end
				if app.Settings["learnedStyle"] > 0 then
					setStyle(app.Settings["learnedStyle"])
				else
					setStyle(app.Settings["iconStyle"])
				end
			elseif color == "red" then
				overlay.animation:Stop()
				overlay.animationTexture:Hide()

				if app.Settings["iconStyle"] == 1 then
					overlay.border:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\border-circle-red.png")
				elseif app.Settings["iconStyle"] == 2 then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\simple-circle-red.png")
				elseif app.Settings["iconStyle"] == 3 then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\simple-icon-red.png")
				elseif app.Settings["iconStyle"] == 4 then
					overlay.texture:SetTexture("Interface\\AddOns\\TransmogLootHelper\\assets\\cosmetic-icon-red.png")
				end
			end

			if app.Settings["iconStyle"] == 4 then
				overlay.animation:Stop()
				overlay.animationTexture:Hide()
			end

			overlay.icon:Show()
		end

		local function hideOverlay()
			overlay.icon:Hide()
			overlay.animation:Stop()
			overlay.animationTexture:Hide()
		end

		if app.Texture[itemEquipLoc] then
			if itemID and itemID <= 4 then -- Fake preview items
				if itemID == 3 then overlay.texture:SetTexture(app.Texture[171]) end
				if not (not app.Settings["iconLearned"] and app.OverlayCache[itemLink].color == "green") then
					showOverlay(app.OverlayCache[itemLink].color)
				else
					hideOverlay()
				end
			elseif app.Settings["iconNewMog"] and itemEquipLoc:find("INVTYPE") then
				local attInfo
				if C_AddOns.IsAddOnLoaded("AllTheThings") then
					attInfo = AllTheThings.GetLinkReference(itemLink)
				end
				local tumInfo
				if C_AddOns.IsAddOnLoaded("TransmogUpgradeMaster") then
					tumInfo = TransmogUpgradeMaster_API.GetAppearanceMissingData(itemLink)
				end

				if not api:IsAppearanceCollected(itemLink) then
					showOverlay("purple")
				elseif app.Settings["iconNewSource"] and not api:IsSourceCollected(itemLink) then
					showOverlay("yellow")
				elseif app.Settings["iconNewCatalyst"] and ((tumInfo and tumInfo.catalystAppearanceMissing) or (attInfo and attInfo.filledCatalyst)) then
					overlay.texture:SetAtlas("CreationCatalyst-32x32")
					showOverlay("yellow")
				elseif app.Settings["iconNewUpgrade"] and ((tumInfo and tumInfo.upgradeAppearanceMissing) or (attInfo and attInfo.filledUpgrade)) then
					overlay.texture:SetAtlas("CovenantSanctum-Upgrade-Icon-Available")
					showOverlay("yellow")
				elseif app.Settings["iconLearned"] and not (classID == 15 and subclassID == 0) then
					showOverlay("green")
				else
					hideOverlay()
				end
			elseif app.Settings["iconNewMog"] and (itemEquipLoc == "Ensemble" or itemEquipLoc == "Arsenal") then
				local setID = C_Item.GetItemLearnTransmogSet(itemLink)
				local appearances = C_Transmog.GetAllSetAppearancesByID(setID)

				local sourceMissing = false
				local appearanceMissing = false
				for k, v in pairs(appearances) do
					if not sourceMissing and not api:IsSourceCollected(v.itemID, v.itemModifiedAppearanceID) then
						sourceMissing = true
					end

					if not appearanceMissing and not api:IsAppearanceCollected(v.itemID, v.itemModifiedAppearanceID) then
						appearanceMissing = true
					end

					if sourceMissing and appearanceMissing then
						break
					end
				end

				if (app.Settings["iconNewSource"] and not sourceMissing) or not appearanceMissing then
					if app.Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				elseif app:HasRedTooltipText(itemLink) then
					showOverlay("red")
				elseif app.Settings["iconNewSource"] and sourceMissing and not appearanceMissing then
					showOverlay("yellow")
				else
					showOverlay("purple")
				end
			elseif app.Settings["iconNewIllusion"] and itemEquipLoc == "Illusion" then
				if app:IsLearned(itemLink) then
					if app.Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				elseif app:HasRedTooltipText(itemLink) then
					showOverlay("red")
				else
					showOverlay("purple")
				end
			elseif app.Settings["iconNewMount"] and itemEquipLoc == "Mount" then
				local mountID = C_MountJournal.GetMountFromItem(itemID)
				local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)
				if isCollected then
					if app.Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				elseif app:HasRedTooltipText(itemLink) then
					showOverlay("red")
				else
					showOverlay("purple")
				end
			elseif app.Settings["iconNewPet"] and itemEquipLoc == "Pet" then
				if not app.OverlayCache[itemLink].speciesID then
					app.OverlayCache[itemLink].speciesID = select(13, C_PetJournal.GetPetInfoByItemID(itemID))
				end

				-- Account for a Blizz API bug that is apparently present, this is why we can't have nice things
				local numPets, maxAllowed = 0, 0
				if app.OverlayCache[itemLink].speciesID then
					numPets, maxAllowed = C_PetJournal.GetNumCollectedInfo(app.OverlayCache[itemLink].speciesID)
				end

				if (maxAllowed == numPets and numPets ~= 0) or (not app.Settings["iconNewPetMax"] and numPets >= 1) then
					if app.Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				elseif app.Settings["iconNewPetMax"] and maxAllowed > numPets and numPets >= 1 then
					showOverlay("yellow")
				else
					showOverlay("purple")
				end
			elseif app.Settings["iconNewPet"] and itemEquipLoc == "Unknown" then -- Unknown Pet Cages
				showOverlay("yellow")
				overlay.animation:Stop()
				overlay.animationTexture:Hide()
			elseif app.Settings["iconNewToy"] and itemEquipLoc == "Toy" then
				if PlayerHasToy(itemID) then
					if app.Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				else
					showOverlay("purple")
				end
			elseif app.Settings["iconNewRecipe"] and itemEquipLoc == "Recipe" then
				local recipeID = app:GetLearnedSpell(itemLink)

				if recipeID then
					local _, _, tradeskill = C_TradeSkillUI.GetTradeSkillLineForRecipe(recipeID)
					if app.Texture[tradeskill] then overlay.texture:SetTexture(app.Texture[tradeskill]) end

					if TransmogLootHelper_Cache.Recipes[recipeID] then
						if TransmogLootHelper_Cache.Recipes[recipeID].learned then
							if app.Settings["iconLearned"] then
								showOverlay("green")
							else
								hideOverlay()
							end
						else
							if C_TradeSkillUI.IsRecipeProfessionLearned(recipeID) then
								showOverlay("purple")
							else
								showOverlay("red")
							end
						end
					else
						if C_TradeSkillUI.IsRecipeProfessionLearned(recipeID) then
							showOverlay("yellow")
							overlay.animation:Stop()
							overlay.animationTexture:Hide()
						else
							showOverlay("red")
						end
					end
				else
					hideOverlay()
				end
			elseif app.Settings["iconNewDecor"] and itemEquipLoc == "Decor" then
				local decorInfo, recordID
				if app.Decor[itemID] then
					decorInfo = C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, app.Decor[itemID], true)
				else
					decorInfo = C_HousingCatalog.GetCatalogEntryInfoByItem(itemID, true)
				end

				if decorInfo then
					recordID = decorInfo.entryID.recordID or app.Decor[itemID]
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

					if app.Settings["iconNewDecorXP"] then
						if TransmogLootHelper_Cache.Decor[recordID].grantsXP then
							showOverlay("purple")
						elseif app.Settings["iconLearned"] and TransmogLootHelper_Cache.Decor[recordID].xp > 0 then
							showOverlay("green")
						else
							hideOverlay()
						end
					elseif TransmogLootHelper_Cache.Decor[recordID].owned > 0 then
						if app.Settings["iconLearned"] then
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
			elseif app.Settings["iconUsable"] and itemEquipLoc == "ProfessionKnowledge" then
				if app:HasRedTooltipText(itemLink) then
					hideOverlay()
				else
					showOverlay("yellow")
				end
			elseif app.Settings["iconUsable"] and itemEquipLoc == "Customisation" then
				local spellID = app:GetLearnedSpell(itemLink)
				if (TransmogLootHelper_Cache.Recipes[spellID] and TransmogLootHelper_Cache.Recipes[spellID].learned) or (app.QuestItem[itemID] and C_QuestLog.IsQuestFlaggedCompletedOnAccount(app.QuestItem[itemID])) or app:IsLearned(itemLink) then
					if app.Settings["iconLearned"] then
						showOverlay("green")
					else
						hideOverlay()
					end
				elseif app:HasRedTooltipText(itemLink) then
					showOverlay("red")
				else
					showOverlay("purple")
				end
			elseif app.Settings["iconContainer"] and itemEquipLoc == "Container" then
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

		if app.Settings["textBind"] then
			if itemID == 3 then -- Fake preview item
				overlay.text:SetText("|cff00CCFF" .. L.BINDTEXT_BOA .. "|r")
			elseif not (bagAddon and C_AddOns.IsAddOnLoaded("Baganator")) then
				if itemLocation and C_Item.IsBoundToAccountUntilEquip(itemLocation) then
					if C_Item.IsBound(itemLocation) then
						overlay.text:SetText("")
					else
						overlay.text:SetText("|cff00CCFF" .. L.BINDTEXT_WUE .. "|r")
					end
				elseif not itemLocation and app:GetBonding(itemLink) == "WuE" then -- Vendor WuE
					overlay.text:SetText("|cff00CCFF" .. L.BINDTEXT_WUE .. "|r")
				elseif itemLocation and C_Item.IsBound(itemLocation) then
					if app:GetBonding(itemLink) == "BoA" then
						overlay.text:SetText("|cff00CCFF" .. L.BINDTEXT_BOA .. "|r")
					else
						overlay.text:SetText("")
					end
				elseif bindType == 2 or bindType == 3 then
					overlay.text:SetText(L.BINDTEXT_BOE)
				else
					overlay.text:SetText("")
				end
			end
		else
			overlay.text:SetText("")
		end
	end

	local ignore = {
		[37011] = true, -- Magic Broom
	}
	local itemID = C_Item.GetItemInfoInstant(itemLink)
	-- Caged pets don't return this info, except this one magical pet cage
	if not itemID or itemID == 82800 then
		local speciesID = string.match(itemLink, "battlepet:(%d+):")
		if additionalInfo and type(additionalInfo) == "number" then speciesID = additionalInfo end
		if speciesID then
			app.OverlayCache[itemLink] = { itemEquipLoc = "Pet", bindType = 2, speciesID = speciesID }
			processOverlay()
		elseif itemID == 82800 then
			app.OverlayCache[itemLink] = { itemEquipLoc = "Unknown" }
			processOverlay()
		elseif itemLink == "item:1" or itemLink == "item:2" or itemLink == "item:3" or itemLink == "item:4" then
			processOverlay(tonumber(itemLink:match(":(%d+)")))
		else
			return
		end
	elseif ignore[itemID] then
		return
	else
		C_Item.RequestLoadItemDataByID(itemID)
		local item = Item:CreateFromItemID(itemID)

		item:ContinueOnItemLoad(function()
			-- Cache item spell for tooltip scanning
			local spellID = select(2, C_Item.GetItemSpell(itemLink)) or 61304
			local spell = Spell:CreateFromSpellID(spellID)
			spell:ContinueOnSpellLoad(function()
				processOverlay(itemID)
			end)
		end)
	end
end

function app:HookItemOverlay()
	if app.Settings["overlay"] then
		local function bagsOverlay(container) -- Thank you Plusmouse!
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
					app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
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

		function app:BankOverlay()
			if not app.BankThrottle then
				app.BankThrottle = 0
				C_Timer.After(0.1, function()
					if app.BankThrottle >= 1 then
						app.BankThrottle = nil
						app:BankOverlay()
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
								app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink, itemLocation, containerInfo)
							else
								itemButton.TLHOverlay:Hide()
							end
						end
					end
				end

				if not app.BankHook then
					C_Timer.After(1, bank)
					app.BankHook = true
				else
					bank()
				end
			end
		end

		hooksecurefunc(BankPanel, "RefreshBankPanel", function() app:BankOverlay() end)
		hooksecurefunc(BankPanel, "OnUpdate", function() app:BankOverlay() end)
		app.Event:Register("BANKFRAME_OPENED", function() app:BankOverlay() end)
		app.Event:Register("BAG_UPDATE_DELAYED", function() app:BankOverlay() end)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", function() C_Timer.After(0.1, function() app:BankOverlay() end) end)
		app.Event:Register("NEW_RECIPE_LEARNED", function() C_Timer.After(0.1, function() app:BankOverlay() end) end)

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
							app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink)
						else
							itemButton.TLHOverlay:Hide()
						end
					end
				end
			end
		end

		app.Event:Register("GUILDBANKBAGSLOTS_CHANGED", guildBankOverlay)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", guildBankOverlay)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", function() C_Timer.After(0.1, guildBankOverlay) end)
		app.Event:Register("NEW_RECIPE_LEARNED", function() C_Timer.After(0.1, guildBankOverlay) end)

		local function blackMarketOverlay()
			if BlackMarketFrame and BlackMarketFrame:IsShown() then
				if not app.BlackMarketFrameHook then
					BlackMarketFrame.ScrollBox:RegisterCallback("OnAcquiredFrame", function(_, v, data) -- Thank you Plusmouse!
						C_Timer.After(0.1, function()
							if not v.TLHOverlay then
								v.TLHOverlay = CreateFrame("Frame", nil, v)
								v.TLHOverlay:SetAllPoints(v.Item)
							end
							v.TLHOverlay:Hide()

							local itemLink = v.itemLink
							if itemLink then
								app:ApplyItemOverlay(v.TLHOverlay, itemLink)
								v.TLHOverlay.text:SetText("")
							end
						end)
					end)
					app.BlackMarketFrameHook = true
				end
			end
		end

		app.Event:Register("BLACK_MARKET_OPEN", function() C_Timer.After(0.1, blackMarketOverlay) end)

		local function mailboxOverlay()
			if not app.MailboxHook then
				InboxPrevPageButton:HookScript("OnClick", function() mailboxOverlay() C_Timer.After(0.1, mailboxOverlay) end)
				InboxNextPageButton:HookScript("OnClick", function() mailboxOverlay() C_Timer.After(0.1, mailboxOverlay) end)

				for i = 1, 7 do
					local itemButton = _G["MailItem"..i.."Button"]
					if itemButton then
						itemButton:HookScript("OnClick", function()
							app.SelectedMail = itemButton.index
							mailboxOverlay()
						end)
					end
				end

				app.MailboxHook = true
			end

			for i = 1, 7 do
				local itemButton = _G["MailItem"..i.."Button"]
				if itemButton then
					if not itemButton.TLHOverlay then
						itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
						itemButton.TLHOverlay:SetAllPoints(itemButton)
					end

					if itemButton.hasItem == 1 then
						local _, itemID = GetInboxItem(i, 1)
						if itemID then
							local _, itemLink = C_Item.GetItemInfo(itemID)

							if itemLink then
								app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink)
							else
								itemButton.TLHOverlay:Hide()
							end
						else
							itemButton.TLHOverlay:Hide()
						end
					else
						itemButton.TLHOverlay:Hide()
					end
				end
			end

			for i = 1, ATTACHMENTS_MAX_RECEIVE do
				local itemButton = _G["OpenMailAttachmentButton"..i]
				if itemButton and app.SelectedMail then
					if not itemButton.TLHOverlay then
						itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
						itemButton.TLHOverlay:SetAllPoints(itemButton)
					end

					local itemLink = GetInboxItemLink(app.SelectedMail, i)
					if itemLink then
						app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink)
					else
						itemButton.TLHOverlay:Hide()
					end
				end
			end
		end

		app.Event:Register("MAIL_SHOW", function() C_Timer.After(0.1, mailboxOverlay) end)
		app.Event:Register("MAIL_INBOX_UPDATE", function() C_Timer.After(0.1, mailboxOverlay) end)

		LootFrame:HookScript("OnShow", function() -- Thank you LS!
			for _, frame in next, LootFrame.ScrollBox.view.frames do
				if frame.Item then
					if not frame.TLHOverlay then
						frame.TLHOverlay = CreateFrame("Frame", nil, frame.Item)
						frame.TLHOverlay:SetAllPoints(frame.Item)
					end

					local itemLink = GetLootSlotLink(frame:GetSlotIndex())
					if itemLink then
						app:ApplyItemOverlay(frame.TLHOverlay, itemLink)
					end
				end
			end
		end)

		local function lootOverlay()
			local function applyToLootFrame(frame)
				if not frame.TLHOverlay then
					frame.TLHOverlay = CreateFrame("Frame", nil, frame)
					frame.TLHOverlay:SetAllPoints(frame.IconFrame)
				end

				if not frame.rollID then return end
				local itemLink = GetLootRollItemLink(frame.rollID)
				if itemLink then
					app:ApplyItemOverlay(frame.TLHOverlay, itemLink)
				end
			end

			if GroupLootFrame1 then applyToLootFrame(GroupLootFrame1) end
			if GroupLootFrame2 then applyToLootFrame(GroupLootFrame2) end
			if GroupLootFrame3 then applyToLootFrame(GroupLootFrame3) end
			if GroupLootFrame4 then applyToLootFrame(GroupLootFrame4) end
		end

		app.Event:Register("START_LOOT_ROLL", function() RunNextFrame(lootOverlay) end)
		app.Event:Register("MAIN_SPEC_NEED_ROLL", function() RunNextFrame(lootOverlay) end)
		app.Event:Register("CANCEL_LOOT_ROLL", function() RunNextFrame(lootOverlay) end)
		app.Event:Register("CONFIRM_LOOT_ROLL", function() RunNextFrame(lootOverlay) end)

		function app:MerchantOverlay()
			if not app.MerchantHook then
				MerchantPrevPageButton:HookScript("OnClick", function() app:MerchantOverlay() C_Timer.After(0.1, function() app:MerchantOverlay() end) end)
				MerchantNextPageButton:HookScript("OnClick", function() app:MerchantOverlay() C_Timer.After(0.1, function() app:MerchantOverlay() end) end)
				MerchantFrame:HookScript("OnMouseWheel", function() app:MerchantOverlay() C_Timer.After(0.1, function() app:MerchantOverlay() end) end)
				MerchantFrame.FilterDropdown:RegisterCallback("OnMenuClose", function() app:MerchantOverlay() C_Timer.After(0.1, function() app:MerchantOverlay() end) end)
				app.MerchantHook = true
			end

			for i = 1, 99 do -- Works for addons that expand the vendor frame up to 99 slots
				local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
				if itemButton then
					if not itemButton.TLHOverlay then
						itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
						itemButton.TLHOverlay:SetAllPoints(itemButton)
					end

					if i == 1 and itemButton.hasItem == nil then
						RunNextFrame(function() app:MerchantOverlay() end)
						return
					end

					local itemLink = itemButton.link
					if itemLink then
						app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink)
					else
						itemButton.TLHOverlay:Hide()
					end
				end
			end
		end

		app.Event:Register("MERCHANT_SHOW", function() C_Timer.After(0.1, function() app:MerchantOverlay() end) end)
		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", function() C_Timer.After(0.1, function() app:MerchantOverlay() end) end)
		app.Event:Register("NEW_RECIPE_LEARNED", function() C_Timer.After(0.1, function() app:MerchantOverlay() end) end)

		function app:QuestOverlay(mode)
			local function rewardOverlay(rewardsFrame)
				local sellPrice = {}

				for k, v in pairs(rewardsFrame.RewardButtons) do
					local itemButton = QuestInfo_GetRewardButton(rewardsFrame, k)
					if not itemButton.TLHOverlay then
						itemButton.TLHOverlay = CreateFrame("Frame", nil, itemButton)
						itemButton.TLHOverlay:SetAllPoints(itemButton)
					end
					itemButton.TLHOverlay:Hide() -- Hide our overlay initially, updating doesn't work like for regular itemButtons
					if itemButton.TLHOverlay.gold then itemButton.TLHOverlay.gold:Hide() end

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
							app:ApplyItemOverlay(itemButton.TLHOverlay, itemLink)
							itemButton.TLHOverlay:SetAllPoints(itemButton.IconBorder)
						else
							itemButton.TLHOverlay:Hide()
						end
					else
						itemButton.TLHOverlay:Hide()
					end
				end

				if app.Settings["iconQuestGold"] and #sellPrice > 1 then
					local highestPrice = 0
					local highestItem = nil
					local diff = -1

					for k, v in ipairs(sellPrice) do
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
						if app.Settings["iconPosition"] == 0 then
							overlay.gold:SetPoint("CENTER", overlay, "TOPRIGHT", -4, -4)
						elseif app.Settings["iconPosition"] == 1 then
							overlay.gold:SetPoint("CENTER", overlay, "TOPLEFT", 4, -4)
						elseif app.Settings["iconPosition"] == 2 then
							overlay.gold:SetPoint("CENTER", overlay, "BOTTOMLEFT", 4, 4)
						elseif app.Settings["iconPosition"] == 3 then
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

		app.Event:Register("QUEST_DETAIL", function() app:QuestOverlay() end)
		app.Event:Register("QUEST_COMPLETE", function() app:QuestOverlay("turnin") end)
		hooksecurefunc("QuestMapFrame_ShowQuestDetails", function() app:QuestOverlay() C_Timer.After(0.1, function() app:QuestOverlay() end) end)

		function app:WorldQuestOverlay()
			C_Timer.After(0.1, function()
				for pin in WorldMapFrame:EnumeratePinsByTemplate("WorldMap_WorldQuestPinTemplate") do
					if not pin.TLHOverlay then
						pin.TLHOverlay = CreateFrame("Frame", nil, pin)
						pin.TLHOverlay:SetAllPoints(pin)
						pin.TLHOverlay:SetScale(0.8)
					end
					pin.TLHOverlay:Hide() -- Hide our overlay initially, updating doesn't work like for regular itemButtons

					local bestIndex, bestType = QuestUtils_GetBestQualityItemRewardIndex(pin.questID)
					if bestIndex and bestType then
						local itemLink = GetQuestLogItemLink(bestType, bestIndex, pin.questID)
						if itemLink then
							app:ApplyItemOverlay(pin.TLHOverlay, itemLink)
							pin.TLHOverlay.text:SetText("")
						else
							pin.TLHOverlay:Hide()
						end
					else
						pin.TLHOverlay:Hide()
					end
				end
			end)
		end

		WorldMapFrame:HookScript("OnShow", function() app:WorldQuestOverlay() end)
		EventRegistry:RegisterCallback("MapCanvas.MapSet", function() app:WorldQuestOverlay() end)

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
								app:ApplyItemOverlay(v.TLHOverlay, v.link)
								v.TLHOverlay.text:SetText("")
								v.TLHOverlay.animation:Stop()
								v.TLHOverlay.animationTexture:Hide()
							end
						end
					end)
				end)
				app.Flag.EncounterJournalHook = true
			end
		end

		app.Event:Register("UPDATE_INSTANCE_INFO", encounterJournalOverlay)

		function app:TradeskillOverlay()
			if ProfessionsFrame and ProfessionsFrame:IsShown() then
				if not app.TradeskillHook then
					ProfessionsFrame.CraftingPage.RecipeList.ScrollBox:RegisterCallback("OnAcquiredFrame", function(_, v, data) -- Thank you Plusmouse!
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
									app:ApplyItemOverlay(v.TLHOverlay, itemLink)
									v.TLHOverlay.text:SetText("")

									v.TLHOverlay.icon:ClearAllPoints()
									v.TLHOverlay.icon:SetPoint("RIGHT", v)

									C_Timer.After(0.2, function()
										v.TLHOverlay.animation:Stop()
										v.TLHOverlay.animationTexture:Hide()
									end)
								end
							end
						end
					end)
					app.TradeskillHook = true
				end
			end
		end

		app.Event:Register("TRADE_SKILL_SHOW", function() app:TradeskillOverlay() end)

		function app:AuctionHouseOverlay()
			if AuctionHouseFrame and AuctionHouseFrame:IsShown() and not app.Flag.AuctionHouseHook then
				AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBox:RegisterCallback("OnAcquiredFrame", function(_, v) -- Thank you Plusmouse!
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
									if itemID == 82800 and rowData.itemKey.battlePetSpeciesID then -- Can't extract pet info from this preview cage
										app:ApplyItemOverlay(v.TLHOverlay, itemLink, nil, nil, nil, rowData.itemKey.battlePetSpeciesID)
									else
										app:ApplyItemOverlay(v.TLHOverlay, itemLink)
									end
									v.TLHOverlay.text:SetText("")

									v.TLHOverlay.icon:ClearAllPoints()
									v.TLHOverlay.icon:SetPoint("LEFT", v, 134, 0)
									v.TLHOverlay.animation:Stop()
									v.TLHOverlay.animationTexture:Hide()
								end
							end
						end
					end)
				end)
				app.Flag.AuctionHouseHook = true
			end
		end

		app.Event:Register("AUCTION_HOUSE_THROTTLED_SYSTEM_READY", function() app:AuctionHouseOverlay() end)

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

								local itemLink
								if v.info.rewards[2] and v.info.rewards[2].itemDBID then
									itemLink = C_WeeklyRewards.GetItemHyperlink(v.info.rewards[2].itemDBID)
								elseif v.info.rewards[1].itemDBID then
									itemLink = C_WeeklyRewards.GetItemHyperlink(v.info.rewards[1].itemDBID)
								end
								app:ApplyItemOverlay(v.TLHOverlay, itemLink)
							end
						end
					end
				end
			end
			doTheThing()
			C_Timer.After(2, doTheThing)
		end

		app.Event:Register("WEEKLY_REWARDS_UPDATE", greatVaultOverlay)

		app.Event:Register("TRANSMOG_COLLECTION_UPDATED", function()
			api:UpdateOverlay()
		end)

		app.Event:Register("NEW_RECIPE_LEARNED", function(recipeID, recipeLevel, baseRecipeID)
			app:CacheRecipe(recipeID, true)
			api:UpdateOverlay()
		end)

		app.Event:Register("LEARNED_SPELL_IN_SKILL_LINE", function(spellID, skillLineIndex, isGuildPerkSpell)
			app:CacheRecipe(spellID, true)
			api:UpdateOverlay()
		end)
	end
end

function api:UpdateOverlay()
	assert(self == api, "Call TransmogLootHelper:UpdateOverlay(), not TransmogLootHelper.UpdateOverlay()")

	if app.Settings["overlay"] then
		RunNextFrame(function()
			app.RefreshTimer = app.RefreshTimer or 0
			if GetServerTime() > app.RefreshTimer + 1 then
				app:BankOverlay()
				app:MerchantOverlay()
				app:QuestOverlay()
				app:WorldQuestOverlay()
				app:TradeskillOverlay()
				app:AuctionHouseOverlay()
				if C_AddOns.IsAddOnLoaded("Baganator") then Baganator.API.RequestItemButtonsRefresh() end

				app.RefreshTimer = GetServerTime()
			end
		end)
	end
end

------------------
-- TOOLTIP INFO --
------------------

function app:AddTooltipInfo()
	local function OnTooltipSetItem(tooltip, itemData)
		if app.Settings["iconNewRecipe"] then
			local _, itemLink, itemID
			if itemData and itemData.id then
				itemID = itemData.id
				_, itemLink = C_Item.GetItemInfo(itemID)
			elseif tooltip.GetItem then
				_, itemLink, itemID = tooltip:GetItem()
			else
				_, itemLink, itemID = TooltipUtil.GetDisplayedItem(GameTooltip)
			end

			if not itemLink and itemID then return end

			local recipeID = app:GetLearnedSpell(itemLink)
			if recipeID and TransmogLootHelper_Cache.Recipes[recipeID] == nil then
				tooltip:AddLine(" ")
				tooltip:AddLine(app.IconTLH .. " " .. L.RECIPE_UNCACHED)
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

	if not TransmogLootHelper_Cache.Recipes[spellID] or type(TransmogLootHelper_Cache.Recipes[spellID]) == "boolean" then
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
		C_Timer.After(2, function()
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
	C_HousingCatalog.CreateCatalogSearcher() -- Cache Decor
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
