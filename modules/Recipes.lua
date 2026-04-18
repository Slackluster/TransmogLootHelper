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

function app:CacheRecipe(spellID, isSpell)
	app.CharacterName = app.CharacterName or UnitName("player") .. "-" .. GetNormalizedRealmName()

	if not TransmogLootHelper_Cache.Recipes[spellID] or type(TransmogLootHelper_Cache.Recipes[spellID]) == "boolean" then
		TransmogLootHelper_Cache.Recipes[spellID] = { learned = false, knownBy = {} }
	end

	local categoryID = C_TradeSkillUI.GetRecipeInfo(spellID).categoryID
	if (isSpell and categoryID == 0 and C_SpellBook.IsSpellKnown(spellID)) or (categoryID ~= 0 and C_TradeSkillUI.GetRecipeInfo(spellID).learned) then
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
					app:CacheRecipe(recipeID)
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
	frame:AddLine((prefixText or "") .. "  " .. GetCoinTextureString(money) .. " " .. (suffixText or ""), 1, 1, 1)
end
