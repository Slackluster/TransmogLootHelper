----------------------------------------
-- Transmoog Loot Helper: Recipes.lua --
----------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app:RecipeTooltipInfo()
	end
end)

---------------------------------
-- RECIPE (AND SPELL) TRACKING --
---------------------------------

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

-------------
-- TOOLTIP --
-------------

function app:RecipeTooltipInfo()
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
			if recipeID and C_TradeSkillUI.GetProfessionInfoByRecipeID(recipeID).professionID ~= 0 and not TransmogLootHelper_Cache.Recipes[recipeID] then
				tooltip:AddLine(" ")
				tooltip:AddLine(app.IconTLH .. " " .. L.RECIPE_UNCACHED)
			end
		end
	end
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
end

-- MoneyFrame taint fix, courtesy of Galehad's MoneyFrameFix
function SetTooltipMoney(frame, money, type, prefixText, suffixText)
	frame:AddLine((prefixText or "") .. "  " .. GetCoinTextureString(money) .. " " .. (suffixText or ""), 0, 1, 1)
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
