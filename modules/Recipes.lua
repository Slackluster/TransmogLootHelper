---------------------------------------
-- Transmog Loot Helper: Recipes.lua --
---------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

---------------------------------
-- RECIPE (AND SPELL) TRACKING --
---------------------------------

function app:CacheRecipe(spellID, isSpell, isLearned)
	app.CharacterName = app.CharacterName or UnitName("player") .. "-" .. GetNormalizedRealmName()

	if not app.Cache.Recipes[spellID] or type(app.Cache.Recipes[spellID]) == "boolean" then
		app.Cache.Recipes[spellID] = { learned = false, knownBy = {} }
	end

	local recipeInfo = C_TradeSkillUI.GetRecipeInfo(spellID)
	local categoryID = recipeInfo and recipeInfo.categoryID
	if not categoryID then return end

	if isLearned or (isSpell and categoryID == 0 and C_SpellBook.IsSpellKnown(spellID)) or (categoryID ~= 0 and recipeInfo.learned) then
		app.Cache.Recipes[spellID].learned = true

		local exists = false
		for i, character in ipairs(app.Cache.Recipes[spellID].knownBy) do
			if character == app.CharacterName then
				exists = true
				break
			end
		end

		if not exists then
			table.insert(app.Cache.Recipes[spellID].knownBy, app.CharacterName)
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
	for recipeID, recipeInfo in pairs(app.Cache.Recipes) do
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
	app:Print(L.DELETED_ENTRIES, removed .. " | " .. L.DELETED_REMOVED, unlearned)
	api:UpdateOverlay()
end
