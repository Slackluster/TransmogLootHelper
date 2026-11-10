---------------------------------------
-- Transmog Loot Helper: Tooltip.lua --
---------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName ~= appName then return end

	app:AddTooltipInfo()
end)

-------------
-- TOOLTIP --
-------------

function app:AddTooltipInfo()
	local function OnTooltipSetItem(tooltip, itemData)
		local _, itemLink = app:GetTooltipItem(tooltip, itemData)
		if not itemLink then return end
		local itemID = C_Item.GetItemInfoInstant(itemLink)

		local previousLine = tooltip:GetLeftLine(tooltip:NumLines())
		local previousText = previousLine and previousLine:GetText()
		local emptyLine = previousText and previousText:find("inv_enchant_formulasuperior_01", 1, true) -- Detect PSL tooltip line

		if app.Settings.iconNewRecipe then
			local recipeID = app:GetLearnedSpell(itemLink)
			if recipeID and C_TradeSkillUI.GetProfessionInfoByRecipeID(recipeID).professionID ~= 0 and not app.Cache.Recipes[recipeID] then
				emptyline = true
				tooltip:AddLine(" ")
				tooltip:AddLine(CreateSimpleTextureMarkup(app.Icon) .. " " .. L.RECIPE_UNCACHED)
			end
		end
		if app.Forever and app.Tooltip[itemID] and app.Tooltip[itemID] == "unlearnedMog" then
			local bindType = select(14, C_Item.GetItemInfo(itemLink))
			if bindType and bindType == Enum.ItemBind.None and C_Item.GetItemCount(itemLink) >= 1 then
				if not emptyLine then
					emptyLine = true
					tooltip:AddLine(" ")
				end
				tooltip:AddLine(CreateSimpleTextureMarkup(app.Icon) .. " " .. L.LEARN_UNBOUND)
			end
		end
	end
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
end
