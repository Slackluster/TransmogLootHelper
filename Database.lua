----------------------------------------
-- Transmog Loot Helper: Database.lua --
----------------------------------------
-- Raw information to refer to

-- Initialisation
local appName, app = ...	-- Returns the addon name and a unique table

-- Used strings
app.Name = "Transmog Loot Helper"
app.NameLong = app.Colour("Transmog Loot Helper")
app.NameShort = app.Colour("TLH")

-- Used textures
app.iconMog = "Interface\\AddOns\\TransmogLootHelper\\assets\\newMog.blp"

-- Type.Subtype to item type
app.Type = {}
app.Type["General"] = "4.0"	-- Neck, Ring, Trinket, Off-Hand (and shirts and tabards, yay)
app.Type["Cloth"] = "4.1"
app.Type["Leather"] = "4.2"
app.Type["Mail"] = "4.3"
app.Type["Plate"] = "4.4"
app.Type["Shield"] = "4.6"
app.Type["Axe1H"] = "2.0"
app.Type["Axe2H"] = "2.1"
app.Type["Bow"] = "2.2"
app.Type["Gun"] = "2.3"
app.Type["Mace1H"] = "2.4"
app.Type["Mace2H"] = "2.5"
app.Type["Polearm"] = "2.6"
app.Type["Sword1H"] = "2.7"
app.Type["Sword2H"] = "2.8"
app.Type["Warglaive"] = "2.9"
app.Type["Staff"] = "2.10"
app.Type["Fist"] = "2.13"
app.Type["Dagger"] = "2.15"
app.Type["Crossbow"] = "2.18"
app.Type["Wand"] = "2.19"

-- Armor -> Class
app.Armor = {}
app.Armor["Cloth"] = { 5, 8, 9 }	-- Priest, Mage, Warlock
app.Armor["Leather"] = { 4, 10, 11, 12 }	-- Rogue, Monk, Druid, Demon Hunter
app.Armor["Mail"] = { 3, 7, 13 }	-- Hunter, Shaman, Evoker
app.Armor["Plate"] = { 1, 2, 6 }	-- Warrior, Paladin, Death Knight

-- Weapon -> Class
app.Weapon = {}
app.Weapon["General"] = { 5, 8, 9, 4, 10, 11, 12, 3, 7, 13, 1, 2, 6 }	-- Priest, Mage, Warlock, Rogue, Monk, Druid, Demon Hunter, Hunter, Shaman, Evoker, Warrior, Paladin, Death Knight
app.Weapon["Shield"] = { 7, 1, 2, 1, 2 }	-- Shaman, Warrior, Paladin, Warrior, Paladin
app.Weapon["Axe1H"] = { 4, 10, 12, 3, 7, 13, 1, 2 , 6}	-- Rogue, Monk, Demon Hunter, Hunter, Shaman, Evoker, Warrior, Paladin, Death Knight
app.Weapon["Axe2H"] = { 3, 7, 13, 1, 2, 6 }	-- Hunter, Shaman, Evoker, Warrior, Paladin, Death Knight
app.Weapon["Bow"] = { 4, 3, 1 }	-- Rogue, Hunter, Warrior
app.Weapon["Gun"] = { 4, 3, 1 }	-- Rogue, Hunter, Warrior
app.Weapon["Mace1H"] = { 5, 4, 10, 11, 7, 13, 1, 2, 6 }	-- Priest, Rogue, Monk, Druid, Shaman, Evoker, Warrior, Paladin, Death Knight
app.Weapon["Mace2H"] = { 11, 7, 13, 1, 2, 6 }	-- Druid, Shaman, Evoker, Warrior, Paladin, Death Knight
app.Weapon["Polearm"] = { 10, 11, 3 , 1, 2, 6 }	-- Monk, Druid, Hunter, Warrior, Paladin, Death Knight
app.Weapon["Sword1H"] = { 8, 9, 4, 10, 12, 3, 13, 1, 2, 6 }	-- Mage, Warlock, Rogue, Monk, Hunter, Evoker, Warrior, Paladin, Death Knight
app.Weapon["Sword2H"] = { 3, 13, 1, 2, 6 }	-- Hunter, Evoker, Warrior, Paladin, Death Knight
app.Weapon["Warglaive"] = { 12 }	-- Demon Hunter
app.Weapon["Staff"] = { 5, 8, 9, 10, 11, 3, 7, 13, 1 }	-- Priest, Mage, Warlock, Monk, Druid, Hunter, Shaman, Evoker, Warrior
app.Weapon["Fist"] = { 4, 10, 11, 12, 3, 7, 13, 1 }	-- Rogue, Monk, Druid, Demon Hunter, Hunter, Shaman, Evoker, Warrior
app.Weapon["Dagger"] = { 5, 8, 9, 4, 11, 3, 7, 13, 1 }	-- Priest, Mage, Warlock, Rogue, Druid, Hunter, Shaman, Evoker, Warrior
app.Weapon["Crossbow"] = { 4, 3, 1 }	-- Rogue, Hunter, Warrior
app.Weapon["Wand"] = { 5, 8, 9 }	-- Priest, Mage, Warlock