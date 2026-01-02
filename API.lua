-----------------------------------
-- Transmog Loot Helper: API.lua --
-----------------------------------

-- Toggle the window
TransmogLootHelper:ToggleWindow()

-- Update TLH's item overlay
TransmogLootHelper:UpdateOverlay()

-- Check if an item's appearance is collected; returns true or false
TransmogLootHelper:IsAppearanceCollected(itemLink)

-- Check if an item's source is collected; returns true or false
TransmogLootHelper:IsSourceCollected(itemLink)

-- Remove this character from the addon cache, marking things (namely recipes) only known by this character as unlearned
-- @param characterName Character-Realm
TransmogLootHelper:DeleteCharacter(characterName)
