----------------------------------------
-- Transmog Loot Helper: Database.lua --
----------------------------------------

local appName, app = ...

-- Strings
app.Name = "Transmog Loot Helper"
app.NameLong = app:Colour("Transmog Loot Helper")
app.NameShort = app:Colour("TLH")
app.NamePrefix = "TransmogLootHelp"
_G["BINDING_NAME_TRANSMOGLOOTHELPER"] = app.Name
_G["BINDING_NAME_SLACKWARE"] = "Slackware"

-- Textures
app.Icon = "Interface\\Icons\\ui_itemupgrade"
app.IconReady = CreateSimpleTextureMarkup("Interface\\RaidFrame\\ReadyCheck-Ready")
app.IconNotReady = CreateSimpleTextureMarkup("Interface\\RaidFrame\\ReadyCheck-NotReady")
app.IconMaybeReady = "Interface\\AddOns\\TransmogLootHelper\\assets\\readycheck-ready-orange.blp"
app.IconLMB = CreateAtlasMarkup("housing-hotkey-icon-leftclick")
app.IconRMB = CreateAtlasMarkup("housing-hotkey-icon-rightclick")
app.IconNew = CreateAtlasMarkup("UI-Journeys-GreatVault-Tag-new", 40, 30)

-- ItemEquipLoc to key
app.Slot = {
	["INVTYPE_HEAD"] = 1,
	["INVTYPE_NECK"] = 2,
	["INVTYPE_SHOULDER"] = 3,
	["INVTYPE_CLOAK"] = 15,
	["INVTYPE_CHEST"] = 5,
	["INVTYPE_ROBE"] = 5,
	["INVTYPE_WRIST"] = 9,
	["INVTYPE_HAND"] = 10,
	["INVTYPE_WAIST"] = 6,
	["INVTYPE_LEGS"] = 7,
	["INVTYPE_FEET"] = 8,
	-- Custom code for rings and trinkets
	["INVTYPE_FINGER"] = 11, -- Also 12
	["INVTYPE_TRINKET"] = 13, -- Also 14
	-- Custom code for weapons
	["INVTYPE_RANGED"] = 16, -- Main hand, no off hand
	["INVTYPE_RANGEDRIGHT"] = 16, -- Main hand, no off hand (but also Wands, goddammit Blizzard)
	["INVTYPE_2HWEAPON"] = 16, -- Main hand, no off hand
	["INVTYPE_WEAPONMAINHAND"] = 16, -- Main hand
	["INVTYPE_WEAPONOFFHAND"] = 16, -- Off hand
	["INVTYPE_HOLDABLE"] = 16, -- Off hand
	["INVTYPE_SHIELD"] = 16, -- Off hand
	["INVTYPE_WEAPON"] = 16, -- Can be main hand or off hand, if char can Dual Wield
}

-- Type.Subtype -> item type
app.Type = {
	["General"] = "4.0", -- Neck, Ring, Trinket, Off-Hand (and shirts and tabards, yay)
	["Cloth"] = "4.1",
	["Leather"] = "4.2",
	["Mail"] = "4.3",
	["Plate"] = "4.4",
	["Shield"] = "4.6",
	["Axe1H"] = "2.0",
	["Axe2H"] = "2.1",
	["Bow"] = "2.2",
	["Gun"] = "2.3",
	["Mace1H"] = "2.4",
	["Mace2H"] = "2.5",
	["Polearm"] = "2.6",
	["Sword1H"] = "2.7",
	["Sword2H"] = "2.8",
	["Warglaive"] = "2.9",
	["Staff"] = "2.10",
	["Fist"] = "2.13",
	["Dagger"] = "2.15",
	["Crossbow"] = "2.18",
	["Wand"] = "2.19",
}

-- Armor -> Class
app.Armor = {
	["Cloth"] = { 5, 8, 9 }, -- Priest, Mage, Warlock
	["Leather"] = { 4, 10, 11, 12 }, -- Rogue, Monk, Druid, Demon Hunter
	["Mail"] = { 3, 7, 13 }, -- Hunter, Shaman, Evoker
	["Plate"] = { 1, 2, 6 }, -- Warrior, Paladin, Death Knight
}

-- Weapon -> Class
app.Weapon = {
	["General"] = { 5, 8, 9, 4, 10, 11, 12, 3, 7, 13, 1, 2, 6 }, -- Priest, Mage, Warlock, Rogue, Monk, Druid, Demon Hunter, Hunter, Shaman, Evoker, Warrior, Paladin, Death Knight
	["Shield"] = { 7, 1, 2, 1, 2 }, -- Shaman, Warrior, Paladin, Warrior, Paladin
	["Axe1H"] = { 4, 10, 12, 3, 7, 13, 1, 2 , 6}, -- Rogue, Monk, Demon Hunter, Hunter, Shaman, Evoker, Warrior, Paladin, Death Knight
	["Axe2H"] = { 3, 7, 13, 1, 2, 6 }, -- Hunter, Shaman, Evoker, Warrior, Paladin, Death Knight
	["Bow"] = { 4, 3, 1 }, -- Rogue, Hunter, Warrior
	["Gun"] = { 4, 3, 1 }, -- Rogue, Hunter, Warrior
	["Mace1H"] = { 5, 4, 10, 11, 7, 13, 1, 2, 6 }, -- Priest, Rogue, Monk, Druid, Shaman, Evoker, Warrior, Paladin, Death Knight
	["Mace2H"] = { 11, 7, 13, 1, 2, 6 }, -- Druid, Shaman, Evoker, Warrior, Paladin, Death Knight
	["Polearm"] = { 10, 11, 3 , 1, 2, 6 }, -- Monk, Druid, Hunter, Warrior, Paladin, Death Knight
	["Sword1H"] = { 8, 9, 4, 10, 12, 3, 13, 1, 2, 6 }, -- Mage, Warlock, Rogue, Monk, Hunter, Evoker, Warrior, Paladin, Death Knight
	["Sword2H"] = { 3, 13, 1, 2, 6 }, -- Hunter, Evoker, Warrior, Paladin, Death Knight
	["Warglaive"] = { 12 }, -- Demon Hunter
	["Staff"] = { 5, 8, 9, 10, 11, 3, 7, 13, 1 }, -- Priest, Mage, Warlock, Monk, Druid, Hunter, Shaman, Evoker, Warrior
	["Fist"] = { 4, 10, 11, 12, 3, 7, 13, 1 }, -- Rogue, Monk, Druid, Demon Hunter, Hunter, Shaman, Evoker, Warrior
	["Dagger"] = { 5, 8, 9, 4, 11, 3, 7, 13, 1 }, -- Priest, Mage, Warlock, Rogue, Druid, Hunter, Shaman, Evoker, Warrior
	["Crossbow"] = { 4, 3, 1 }, -- Rogue, Hunter, Warrior
	["Wand"] = { 5, 8, 9 }, -- Priest, Mage, Warlock
}

-- Item type -> Icon
app.Texture = {
	["INVTYPE_HEAD"] = "Interface\\Icons\\inv_helmet_03",
	["INVTYPE_SHOULDER"] = "Interface\\Icons\\inv_shoulder_09",
	["INVTYPE_CLOAK"] = "Interface\\Icons\\inv_misc_cape_11",
	["INVTYPE_CHEST"] = "Interface\\Icons\\inv_chest_chain",
	["INVTYPE_ROBE"] = "Interface\\Icons\\inv_chest_chain",
	["INVTYPE_BODY"] = "Interface\\Icons\\inv_shirt_white_01",
	["INVTYPE_TABARD"] = "Interface\\Icons\\inv_misc_tournaments_tabard_gnome",
	["INVTYPE_WRIST"] = "Interface\\Icons\\inv_bracer_07",
	["INVTYPE_HAND"] = "Interface\\Icons\\inv_gauntlets_24",
	["INVTYPE_WAIST"] = "Interface\\Icons\\inv_belt_26",
	["INVTYPE_LEGS"] = "Interface\\Icons\\inv_pants_09",
	["INVTYPE_FEET"] = "Interface\\Icons\\inv_boots_05",
	["INVTYPE_RANGED"] = "Interface\\Icons\\inv_sword_04",
	["INVTYPE_RANGEDRIGHT"] = "Interface\\Icons\\inv_sword_04",
	["INVTYPE_2HWEAPON"] = "Interface\\Icons\\inv_sword_04",
	["INVTYPE_WEAPONMAINHAND"] = "Interface\\Icons\\inv_sword_04",
	["INVTYPE_WEAPONOFFHAND"] = "Interface\\Icons\\inv_sword_04",
	["INVTYPE_WEAPON"] = "Interface\\Icons\\inv_sword_04",
	["INVTYPE_SHIELD"] = "Interface\\Icons\\inv_shield_06",
	["INVTYPE_HOLDABLE"] = "Interface\\Icons\\inv_shield_06",
	["INVTYPE_QUANTUM"] = "Interface\\Icons\\inv_misc_questionMark",

	["Ensemble"] = "Interface\\Icons\\inv_chest_cloth_17",
	["Arsenal"] = "Interface\\Icons\\achievement_arena_3v3_4",
	["Illusion"] = "Interface\\Icons\\inv_misc_scrollrolled03",
	["Mount"] = "Interface\\Icons\\ability_mount_ridinghorse",
	["Pet"] = "Interface\\Icons\\inv_arfuspet_classic",
	["Toy"] = "Interface\\Icons\\trade_archaeology_chestoftinyglassanimals",
	["Recipe"] = "Interface\\Icons\\inv_misc_note_01",
	["Decor"] = "Interface\\Icons\\ui_homestone-64",

	[164] = "Interface\\Icons\\ui_profession_blacksmithing",
	[165] = "Interface\\Icons\\ui_profession_leatherworking",
	[171] = "Interface\\Icons\\ui_profession_alchemy",
	[182] = "Interface\\Icons\\ui_profession_herbalism",
	[185] = "Interface\\Icons\\ui_profession_cooking",
	[186] = "Interface\\Icons\\ui_profession_mining",
	[197] = "Interface\\Icons\\ui_profession_tailoring",
	[202] = "Interface\\Icons\\ui_profession_engineering",
	[333] = "Interface\\Icons\\ui_profession_enchanting",
	[356] = "Interface\\Icons\\ui_profession_fishing",
	[393] = "Interface\\Icons\\ui_profession_skinning",
	[755] = "Interface\\Icons\\ui_profession_jewelcrafting",
	[773] = "Interface\\Icons\\ui_profession_inscription",

	["ProfessionKnowledge"] = "Interface\\Icons\\inv_cosmicvoid_orb",
	["Customisation"] = "Interface\\Icons\\inv_10_jewelcrafting_gem1leveling_uncut_transparent",
	["Container"] = "Interface\\Icons\\inv_misc_bag_16",
	["Unknown"] = "Interface\\Icons\\inv_misc_questionMark",
}

app.Quantum = {
	[208061] = { -- Quantum Headpiece
		["Cloth"] = 77629,
		["Leather"] = 77628,
		["Mail"] = 77627,
		["Plate"] = 77626,
		["icon"] = app.Texture["INVTYPE_HEAD"],
	},
	[208062] = { -- Quantum Shoulders
		["Cloth"] = 77641,
		["Leather"] = 77640,
		["Mail"] = 77639,
		["Plate"] = 77638,
		["icon"] = app.Texture["INVTYPE_SHOULDER"],
	},
	[208064] = { -- Quantum Chestpiece
		["Cloth"] = 77637,
		["Leather"] = 77636,
		["Mail"] = 77635,
		["Plate"] = 77634,
		["icon"] = app.Texture["INVTYPE_CHEST"],
	},
	[208063] = { -- Quantum Gloves
		["Cloth"] = 77633,
		["Leather"] = 77632,
		["Mail"] = 77631,
		["Plate"] = 77630,
		["icon"] = app.Texture["INVTYPE_HAND"],
	},
	[208065] = { -- Quantum Legs
		["Cloth"] = 77625,
		["Leather"] = 77624,
		["Mail"] = 77623,
		["Plate"] = 77622,
		["icon"] = app.Texture["INVTYPE_LEGS"],
	},
	[208111] = 77597, -- Quantum Axe
	[208117] = 77603, -- Quantum Bow
	[208118] = 77604, -- Quantum Crossbow
	[208119] = 77605, -- Quantum Firearm
	[208125] = 77609, -- Quantum Focus
	[208113] = 77599, -- Quantum Greataxe
	[208114] = 77600, -- Quantum Greathammer
	[208112] = 77598, -- Quantum Greatsword
	[208120] = 77606, -- Quantum Knife
	[208121] = 77607, -- Quantum Knuckles
	[208110] = 77596, -- Quantum Mace
	[208116] = 77602, -- Quantum Polearm
	[208126] = 77611, -- Quantum Shield
	[208115] = 77601, -- Quantum Staff
	[208109] = 77595, -- Quantum Sword
	[208123] = 77610, -- Quantum Wand
	[208122] = 77608, -- Quantum Warglaives
}

app.QuantumMount = {
	69, -- Deathcharger's Reins
	185, -- Reins of the Raven Lord
	213, -- Swift White Hawkstrider
	264, -- Reins of the Blue Proto-Drake
	395, -- Reins of the Drake of the North Wind
	397, -- Reins of the Vitreous Stone Drake
	410, -- Armored Razzashi Raptor
	411, -- Swift Zulian Panther
	875, -- Midnight's Eternal Reins
	995, -- Sharkbait's Favorite Crackers
	1040, -- Mummified Raptor Skull
	1053, -- Underrot Crawg Harness
	1252, -- Mechagon Peacekeeper
	1406, -- Marrowfang's Reins
	1481, -- Cartel Master's Gearglider
}

-- ItemID -> QuestID (sourced from ATT's "Mount Mods.lua" and "CharacterItemDB.lua" among others)
app.QuestItem = {
	-- Class books
	[264895] = 87421, -- Trials of the Florafaun Hunter

	-- Vulpera Bag of Tricks
	[175158] = 59029, -- Flames of Fury
	[175159] = 59032, -- Sinister Shadows
	[175160] = 59035, -- Holy Relic

	-- Season Unlocks
	[236852] = 87353, -- Gallagio Highroller's Boomstone
	[242623] = 90710, -- Enchanted Warbound Purifying Kit
	[242622] = 90709, -- Warbound Purifying Kit
	[246737] = 91521, -- K'areshi Voidstone
	[265071] = 94482, -- Gleaming Sunmote

	-- Campsites
	[235608] = 86878, -- Nightfall Sanctum Campsite

	-- Housing
	[253802] = 92710, -- Deed of Patronage

	-- Dastardly Duos
	[240200] = 90460, -- Podium Upgrade: Longest Survival Run
	[240201] = 90461, -- Podium Upgrade: Longest Time in Spotlights
	[240202] = 90462, -- Podium Upgrade: Most Yards Traveled
	[240199] = 90459, -- Podium Upgrade: Scrappiest
	[240203] = 90463, -- Podium Upgrade: Scrappy
	[240204] = 90464, -- Podium Upgrade: Survival Run
	[240205] = 90465, -- Podium Upgrade: Time in Spotlights
	[240206] = 90466, -- Podium Upgrade: Yards Traveled

	-- Decor Duel
	[262746] = 93808, -- "Clockwork Sentinel" Kit
	[262741] = 93804, -- "Dispelling Leap" Kit
	[262755] = 93839, -- "Eccentro-Magic Pulse" Enhancement
	[262756] = 93838, -- "Make Decoy" Enhancement
	[262743] = 93806, -- "Nullification Field" Kit
	[262744] = 93807, -- "Riftwalk" Kit
	[262745] = 93809, -- "Stealth" Kit
	[262742] = 93805, -- "Swift" Kit

	-- Pepe
	[127865] = 39265, -- A Tiny Viking Helmet
	[127867] = 39267, -- A Tiny Ninja Shroud
	[127869] = 39266, -- A Tiny Plated Helm
	[127870] = 39268, -- A Tiny Pirate Hat
	[128874] = 39865, -- A Tiny Scarecrow Costume
	[139632] = 43695, -- A Tiny Pair of Goggles
	[161443] = 52269, -- A Tiny Voodoo Mask
	[161451] = 52277, -- A Tiny Diving Helmet
	[170151] = 56911, -- A Tiny Clockwork Key
	[174865] = 58901, -- A Tiny Winter Hat
	[186473] = 64078, -- A Tiny Winter Staff
	[186524] = 64098, -- A Tiny Vial of Slime
	[186580] = 64132, -- A Tiny Sinstone
	[186593] = 64136, -- A Tiny Pair of Wings
	[213181] = 79547, -- A Tiny Dragon Goblet
	[213202] = 79550, -- A Tiny Explorer's Hat
	[213207] = 79551, -- A Tiny Ear Warmer
	[216907] = 80093, -- A Tiny Plumed Tricorne

	-- Duck Disguiser
	[216890] = 80083, -- Black Duck Disguise
	[216897] = 80084, -- Brown Duck Disguise
	[216898] = 80085, -- Mallard Duck Disguise
	[216900] = 80087, -- Pink Duck Disguise
	[216901] = 80088, -- White Duck Disguise
	[216902] = 80089, -- Yellow Duck Disguise

	-- Box of Puntables
	[219291] = 81619, -- Puntable Baby Greench
	[219286] = 81617, -- Puntable Globe Yeti
	[234127] = 86423, -- Puntable Grumpling
	[219255] = 81616, -- Puntable Rotten Little Helper
	[219289] = 81618, -- Puntable Tiny Snowman

	-- Pocopoc
	[187833] = 65528, -- Dapper Pocopoc
	[189451] = 65524, -- Chef Pocopoc
	[189707] = 65471, -- Pocopoc's Bronze and Gold Body
	[189708] = 65472, -- Pocopoc's Beryllium and Silver Body
	[189709] = 65473, -- Pocopoc's Cobalt and Copper Body
	[189710] = 65474, -- Pocopoc's Ruby and Platinum Body
	[189711] = 65476, -- Pocopoc's Gold and Ruby Components
	[189712] = 65477, -- Pocopoc's Silver and Beryllium Components
	[189713] = 65478, -- Pocopoc's Copper and Cobalt Components
	[189714] = 65479, -- Pocopoc's Platinum and Emerald Components
	[189715] = 65481, -- Pocopoc's Diamond Vambraces
	[189716] = 65482, -- Pocopoc's Face Decoration
	[189717] = 65483, -- Pocopoc's Shielded Core
	[189718] = 65484, -- Pocopoc's Upgraded Core
	[190058] = 65525, -- Peaceful Pocopoc
	[190059] = 65526, -- Pirate Pocopoc
	[190060] = 65527, -- Adventurous Pocopoc
	[190061] = 65529, -- Admiral Pocopoc
	[190062] = 65530, -- Wicked Pocopoc
	[190096] = 65534, -- Pocobold
	[190098] = 65538, -- Pepepec
	[190182] = 65600, -- Lovely Regal Pocopoc

	-- Drakewatcher Manuscript
	[196961] = 69161, -- Cliffside Wylderdrake: Armor
	[196962] = 69162, -- Cliffside Wylderdrake: Silver and Purple Armor
	[196963] = 69163, -- Cliffside Wylderdrake: Silver and Blue Armor
	[196964] = 69164, -- Cliffside Wylderdrake: Gold and Black Armor
	[196965] = 69165, -- Cliffside Wylderdrake: Bronze and Teal Armor
	[196966] = 69166, -- Cliffside Wylderdrake: Gold and Orange Armor
	[196967] = 69167, -- Cliffside Wylderdrake: Gold and White Armor
	[196968] = 69168, -- Cliffside Wylderdrake: Steel and Yellow Armor
	[196969] = 69169, -- Cliffside Wylderdrake: Finned Back
	[196970] = 69170, -- Cliffside Wylderdrake: Spiked Back
	[196971] = 69171, -- Cliffside Wylderdrake: Spiked Brow
	[196972] = 69172, -- Cliffside Wylderdrake: Plated Brow
	[196973] = 69173, -- Cliffside Wylderdrake: Dual Horned Chin
	[196974] = 69174, -- Cliffside Wylderdrake: Four-Horned Chin
	[196975] = 69175, -- Cliffside Wylderdrake: Head Fin
	[196976] = 69176, -- Cliffside Wylderdrake: Head Mane
	[196977] = 69177, -- Cliffside Wylderdrake: Split Head Horns
	[196978] = 69178, -- Cliffside Wylderdrake: Small Head Spikes
	[196979] = 69179, -- Cliffside Wylderdrake: Curled Head Horns
	[196980] = 69180, -- Cliffside Wylderdrake: Triple Head Horns
	[196981] = 69181, -- Cliffside Wylderdrake: Conical Head
	[196982] = 69182, -- Cliffside Wylderdrake: Ears
	[196983] = 69183, -- Cliffside Wylderdrake: Maned Jaw
	[196985] = 69185, -- Cliffside Wylderdrake: Horned Jaw
	[196986] = 69186, -- Cliffside Wylderdrake: Black Hair
	[196987] = 69187, -- Cliffside Wylderdrake: Blonde Hair
	[196988] = 69188, -- Cliffside Wylderdrake: Red Hair
	[196989] = 69189, -- Cliffside Wylderdrake: White Hair
	[196990] = 69190, -- Cliffside Wylderdrake: Helm
	[196991] = 69191, -- Cliffside Wylderdrake: Black Horns
	[196992] = 69192, -- Cliffside Wylderdrake: Heavy Horns
	[196993] = 69193, -- Cliffside Wylderdrake: Sleek Horns
	[196994] = 69194, -- Cliffside Wylderdrake: Short Horns
	[196995] = 69195, -- Cliffside Wylderdrake: Spiked Horns
	[196996] = 69196, -- Cliffside Wylderdrake: Branched Horns
	[196997] = 69197, -- Cliffside Wylderdrake: Split Horns
	[196998] = 69198, -- Cliffside Wylderdrake: Hook Horns
	[196999] = 69199, -- Cliffside Wylderdrake: Swept Horns
	[197000] = 69200, -- Cliffside Wylderdrake: Coiled Horns
	[197001] = 69201, -- Cliffside Wylderdrake: Finned Cheek
	[197002] = 69202, -- Cliffside Wylderdrake: Flared Cheek
	[197003] = 69203, -- Cliffside Wylderdrake: Spiked Cheek
	[197004] = 69204, -- Cliffside Wylderdrake: Spiked Legs
	[197005] = 69205, -- Cliffside Wylderdrake: Horned Nose
	[197006] = 69206, -- Cliffside Wylderdrake: Plated Nose
	[197007] = 69207, -- Cliffside Wylderdrake: Wide Stripes Pattern
	[197008] = 69208, -- Cliffside Wylderdrake: Narrow Stripes Pattern
	[197009] = 69209, -- Cliffside Wylderdrake: Scaled Pattern
	[197010] = 69210, -- Cliffside Wylderdrake: Red Scales
	[197011] = 69211, -- Cliffside Wylderdrake: Green Scales
	[197012] = 69212, -- Cliffside Wylderdrake: Blue Scales
	[197013] = 69213, -- Cliffside Wylderdrake: Black Scales
	[197014] = 69214, -- Cliffside Wylderdrake: White Scales
	[197015] = 69215, -- Cliffside Wylderdrake: Dark Skin Variation
	[197016] = 69216, -- Cliffside Wylderdrake: Maned Tail
	[197017] = 69217, -- Cliffside Wylderdrake: Large Tail Spikes
	[197018] = 69218, -- Cliffside Wylderdrake: Finned Tail
	[197019] = 69219, -- Cliffside Wylderdrake: Blunt Spiked Tail
	[197020] = 69220, -- Cliffside Wylderdrake: Spear Tail
	[197021] = 69221, -- Cliffside Wylderdrake: Spiked Club Tail
	[197022] = 69222, -- Cliffside Wylderdrake: Finned Neck
	[197023] = 69223, -- Cliffside Wylderdrake: Maned Neck
	[197090] = 69290, -- Highland Drake: Gold and Black Armor
	[197091] = 69291, -- Highland Drake: Silver and Blue Armor
	[197093] = 69294, -- Highland Drake: Silver and Purple Armor
	[197094] = 69295, -- Highland Drake: Gold and Red Armor
	[197095] = 69296, -- Highland Drake: Gold and White Armor
	[197096] = 69297, -- Highland Drake: Steel and Yellow Armor
	[197097] = 69298, -- Highland Drake: Spined Back
	[197098] = 69299, -- Highland Drake: Finned Back
	[197099] = 69300, -- Highland Drake: Armor
	[197100] = 69301, -- Highland Drake: Crested Brow
	[197101] = 69302, -- Highland Drake: Bushy Brow
	[197102] = 69303, -- Highland Drake: Horned Chin
	[197103] = 69304, -- Highland Drake: Maned Chin
	[197104] = 69305, -- Highland Drake: Tapered Chin
	[197105] = 69306, -- Highland Drake: Spined Chin
	[197106] = 69307, -- Highland Drake: Finned Head
	[197107] = 69308, -- Highland Drake: Triple Finned Head
	[197108] = 69309, -- Highland Drake: Spined Head
	[197109] = 69310, -- Highland Drake: Spiked Head
	[197110] = 69311, -- Highland Drake: Plated Head
	[197111] = 69312, -- Highland Drake: Maned Head
	[197112] = 69313, -- Highland Drake: Single Horned Head
	[197113] = 69314, -- Highland Drake: Swept Spiked Head
	[197114] = 69315, -- Highland Drake: Multi-Horned Head
	[197115] = 69316, -- Highland Drake: Thorned Jaw
	[197116] = 69317, -- Highland Drake: Ears
	[197117] = 69318, -- Highland Drake: Black Hair
	[197118] = 69319, -- Highland Drake: Brown Hair
	[197119] = 69320, -- Highland Drake: Helm
	[197120] = 69321, -- Highland Drake: Ornate Helm
	[197121] = 69322, -- Highland Drake: Tan Horns
	[197122] = 69323, -- Highland Drake: Heavy Horns
	[197123] = 69324, -- Highland Drake: Thorn Horns
	[197124] = 69325, -- Highland Drake: Swept Horns
	[197125] = 69326, -- Highland Drake: Coiled Horns
	[197126] = 69327, -- Highland Drake: Hooked Horns
	[197127] = 69328, -- Highland Drake: Grand Thorn Horns
	[197128] = 69329, -- Highland Drake: Curled Back Horns
	[197129] = 69330, -- Highland Drake: Sleek Horns
	[197130] = 69331, -- Highland Drake: Stag Horns
	[197131] = 69332, -- Highland Drake: Hairy Cheek
	[197132] = 69333, -- Highland Drake: Spiked Cheek
	[197133] = 69334, -- Highland Drake: Spined Cheek
	[197134] = 69335, -- Highland Drake: Spiked Legs
	[197135] = 69336, -- Highland Drake: Toothy Mouth
	[197136] = 69337, -- Highland Drake: Tapered Nose
	[197137] = 69338, -- Highland Drake: Spined Nose
	[197138] = 69339, -- Highland Drake: Striped Pattern
	[197139] = 69340, -- Highland Drake: Large Spotted Pattern
	[197140] = 69341, -- Highland Drake: Small Spotted Pattern
	[197141] = 69342, -- Highland Drake: Scaled Pattern
	[197142] = 69343, -- Highland Drake: Black Scales
	[197143] = 69344, -- Highland Drake: Green Scales
	[197144] = 69345, -- Highland Drake: Red Scales
	[197145] = 69346, -- Highland Drake: Bronze Scales
	[197146] = 69347, -- Highland Drake: White Scales
	[197147] = 69348, -- Highland Drake: Heavy Scales
	[197148] = 69349, -- Highland Drake: Vertical Finned Tail
	[197149] = 69350, -- Highland Drake: Club Tail
	[197150] = 69351, -- Highland Drake: Spiked Club Tail
	[197151] = 69352, -- Highland Drake: Spiked Tail
	[197152] = 69353, -- Highland Drake: Hooked Tail
	[197153] = 69354, -- Highland Drake: Bladed Tail
	[197154] = 69355, -- Highland Drake: Spined Neck
	[197155] = 69356, -- Highland Drake: Finned Neck
	[197156] = 69357, -- Highland Drake: Bronze and Green Armor
	[197346] = 69547, -- Renewed Proto-Drake: Gold and Black Armor
	[197347] = 69548, -- Renewed Proto-Drake: Silver and Blue Armor
	[197348] = 69549, -- Renewed Proto-Drake: Black and Red Armor
	[197349] = 69550, -- Renewed Proto-Drake: Gold and White Armor
	[197350] = 69551, -- Renewed Proto-Drake: Silver and Purple Armor
	[197351] = 69552, -- Renewed Proto-Drake: Gold and Red Armor
	[197352] = 69553, -- Renewed Proto-Drake: Steel and Yellow Armor
	[197353] = 69554, -- Renewed Proto-Drake: Bronze and Pink Armor
	[197355] = 69585, -- Renewed Proto-Drake: Thick Spined Jaw
	[197357] = 69558, -- Renewed Proto-Drake: Armor
	[197358] = 69559, -- Renewed Proto-Drake: Curved Spiked Brow
	[197359] = 69560, -- Renewed Proto-Drake: Hairy Brow
	[197360] = 69561, -- Renewed Proto-Drake: Spined Brow
	[197361] = 69562, -- Renewed Proto-Drake: Spiked Crest
	[197362] = 69563, -- Renewed Proto-Drake: Spined Crest
	[197363] = 69564, -- Renewed Proto-Drake: Maned Crest
	[197364] = 69565, -- Renewed Proto-Drake: Short Spiked Crest
	[197365] = 69566, -- Renewed Proto-Drake: Finned Crest
	[197366] = 69567, -- Renewed Proto-Drake: Dual Horned Crest
	[197367] = 69568, -- Renewed Proto-Drake: Gray Hair
	[197368] = 69569, -- Renewed Proto-Drake: Blue Hair
	[197369] = 69570, -- Renewed Proto-Drake: Brown Hair
	[197370] = 69571, -- Renewed Proto-Drake: Red Hair
	[197371] = 69572, -- Renewed Proto-Drake: Green Hair
	[197372] = 69573, -- Renewed Proto-Drake: Purple Hair
	[197373] = 69574, -- Renewed Proto-Drake: Helm
	[197374] = 69575, -- Renewed Proto-Drake: Swept Horns
	[197375] = 69576, -- Renewed Proto-Drake: Curled Horns
	[197376] = 69577, -- Renewed Proto-Drake: Ears
	[197377] = 69578, -- Renewed Proto-Drake: Bovine Horns
	[197378] = 69579, -- Renewed Proto-Drake: Subtle Horns
	[197379] = 69580, -- Renewed Proto-Drake: Impaler Horns
	[197380] = 69581, -- Renewed Proto-Drake: Curved Horns
	[197381] = 69582, -- Renewed Proto-Drake: Gradient Horns
	[197382] = 69583, -- Renewed Proto-Drake: White Horns
	[197383] = 69584, -- Renewed Proto-Drake: Heavy Horns
	[197385] = 69586, -- Renewed Proto-Drake: Horned Jaw
	[197386] = 69587, -- Renewed Proto-Drake: Spiked Jaw
	[197387] = 69588, -- Renewed Proto-Drake: Thin Spined Jaw
	[197388] = 69589, -- Renewed Proto-Drake: Finned Jaw
	[197389] = 66720, -- Renewed Proto-Drake: Green Scales
	[197390] = 69591, -- Renewed Proto-Drake: Blue Scales
	[197391] = 69592, -- Renewed Proto-Drake: Bronze Scales
	[197392] = 69593, -- Renewed Proto-Drake: Black Scales
	[197393] = 69594, -- Renewed Proto-Drake: White Scales
	[197394] = 69595, -- Renewed Proto-Drake: Predator Pattern
	[197395] = 69596, -- Renewed Proto-Drake: Harrier Pattern
	[197396] = 69597, -- Renewed Proto-Drake: Skyterror Pattern
	[197397] = 69598, -- Renewed Proto-Drake: Heavy Scales
	[197398] = 69599, -- Renewed Proto-Drake: Snub Snout
	[197399] = 69600, -- Renewed Proto-Drake: Razor Snout
	[197400] = 69601, -- Renewed Proto-Drake: Shark Snout
	[197401] = 69602, -- Renewed Proto-Drake: Beaked Snout
	[197402] = 69603, -- Renewed Proto-Drake: Spiked Club Tail
	[197403] = 69604, -- Renewed Proto-Drake: Club Tail
	[197404] = 69605, -- Renewed Proto-Drake: Finned Tail
	[197405] = 69606, -- Renewed Proto-Drake: Maned Tail
	[197406] = 69607, -- Renewed Proto-Drake: Spined Tail
	[197407] = 69608, -- Renewed Proto-Drake: Spiked Throat
	[197408] = 69609, -- Renewed Proto-Drake: Finned Throat
	[197577] = 69781, -- Windborne Velocidrake: Bronze and Green Armor
	[197578] = 69782, -- Windborne Velocidrake: Silver and Blue Armor
	[197579] = 69783, -- Windborne Velocidrake: Steel and Orange Armor
	[197580] = 69784, -- Windborne Velocidrake: Gold and Red Armor
	[197581] = 69785, -- Windborne Velocidrake: Silver and Purple Armor
	[197582] = 69786, -- Windborne Velocidrake: White and Pink Armor
	[197583] = 69787, -- Windborne Velocidrake: Exposed Finned Back
	[197584] = 69788, -- Windborne Velocidrake: Finned Back
	[197585] = 69789, -- Windborne Velocidrake: Maned Back
	[197586] = 69790, -- Windborne Velocidrake: Spiked Back
	[197587] = 69791, -- Windborne Velocidrake: Feathered Back
	[197588] = 69792, -- Windborne Velocidrake: Armor
	[197589] = 69793, -- Windborne Velocidrake: Large Head Fin
	[197590] = 69794, -- Windborne Velocidrake: Small Head Fin
	[197591] = 69795, -- Windborne Velocidrake: Hairy Head
	[197592] = 69796, -- Windborne Velocidrake: Spined Head
	[197593] = 69797, -- Windborne Velocidrake: Feathery Head
	[197594] = 69798, -- Windborne Velocidrake: Small Ears
	[197595] = 69799, -- Windborne Velocidrake: Finned Ears
	[197596] = 69800, -- Windborne Velocidrake: Horned Jaw
	[197597] = 69801, -- Windborne Velocidrake: Black Fur
	[197598] = 69802, -- Windborne Velocidrake: Gray Hair
	[197599] = 69803, -- Windborne Velocidrake: Red Hair
	[197600] = 69804, -- Windborne Velocidrake: Helm
	[197601] = 69805, -- Windborne Velocidrake: Wavy Horns
	[197602] = 69806, -- Windborne Velocidrake: Cluster Horns
	[197603] = 69807, -- Windborne Velocidrake: Curved Horns
	[197604] = 69808, -- Windborne Velocidrake: Ox Horns
	[197605] = 69809, -- Windborne Velocidrake: Curled Horns
	[197606] = 69810, -- Windborne Velocidrake: Swept Horns
	[197607] = 69811, -- Windborne Velocidrake: Split Horns
	[197608] = 69812, -- Windborne Velocidrake: Gray Horns
	[197609] = 69813, -- Windborne Velocidrake: White Horns
	[197610] = 69814, -- Windborne Velocidrake: Yellow Horns
	[197611] = 69815, -- Windborne Velocidrake: Black Scales
	[197612] = 69816, -- Windborne Velocidrake: Blue Scales
	[197613] = 69817, -- Windborne Velocidrake: Bronze Scales
	[197614] = 69818, -- Windborne Velocidrake: Red Scales
	[197615] = 69819, -- Windborne Velocidrake: Teal Scales
	[197616] = 69820, -- Windborne Velocidrake: White Scales
	[197617] = 69821, -- Windborne Velocidrake: Heavy Scales
	[197618] = 69822, -- Windborne Velocidrake: Long Snout
	[197619] = 69823, -- Windborne Velocidrake: Hooked Snout
	[197620] = 69824, -- Windborne Velocidrake: Beaked Snout
	[197622] = 69826, -- Windborne Velocidrake: Finned Tail
	[197623] = 69827, -- Windborne Velocidrake: Spiked Tail
	[197624] = 69828, -- Windborne Velocidrake: Club Tail
	[197625] = 69829, -- Windborne Velocidrake: Feathery Tail
	[197626] = 69831, -- Windborne Velocidrake: Exposed Finned Neck
	[197627] = 69832, -- Windborne Velocidrake: Finned Neck
	[197628] = 69834, -- Windborne Velocidrake: Plated Neck
	[197629] = 69835, -- Windborne Velocidrake: Spiked Neck
	[197630] = 69836, -- Windborne Velocidrake: Feathered Neck
	[197634] = 69845, -- Windborne Velocidrake: Windswept Pattern
	[197635] = 69846, -- Windborne Velocidrake: Reaver Pattern
	[197636] = 69847, -- Windborne Velocidrake: Shrieker Pattern
	[201790] = 72367, -- Renewed Proto-Drake: Embodiment of the Storm-Eater
	[201792] = 72371, -- Highland Drake: Embodiment of the Crimson Gladiator [REMOVED: 10.1.0]
	[202273] = 73054, -- Renewed Proto-Drake: Stubby Snout
	[202274] = 73055, -- Renewed Proto-Drake: Plated Brow
	[202275] = 73059, -- Renewed Proto-Drake: Plated Jaw
	[202277] = 73057, -- Renewed Proto-Drake: Bruiser Horns
	[202278] = 73058, -- Renewed Proto-Drake: Antlers
	[202279] = 73056, -- Renewed Proto-Drake: Malevolent Horns
	[202280] = 73060, -- Renewed Proto-Drake: Pronged Tail
	[203298] = 73786, -- Winding Slitherdrake: White and Gold Armor
	[203299] = 73787, -- Winding Slitherdrake: Green and Bronze Armor
	[203300] = 73788, -- Winding Slitherdrake: Blue and Silver Armor
	[203303] = 73791, -- Winding Slitherdrake: Red and Gold Armor
	[203304] = 73792, -- Winding Slitherdrake: Yellow and Silver Armor
	[203305] = 73793, -- Winding Slitherdrake: Armor
	[203306] = 73794, -- Winding Slitherdrake: Horned Brow
	[203307] = 73795, -- Winding Slitherdrake: Plated Brow
	[203308] = 73796, -- Winding Slitherdrake: Hairy Brow
	[203309] = 73797, -- Winding Slitherdrake: Long Chin Horn
	[203310] = 73798, -- Winding Slitherdrake: Grand Chin Thorn
	[203311] = 73799, -- Winding Slitherdrake: Hairy Chin
	[203312] = 73800, -- Winding Slitherdrake: Cluster Chin Horn
	[203313] = 73801, -- Winding Slitherdrake: Spiked Chin
	[203314] = 73802, -- Winding Slitherdrake: Curved Chin Horn
	[203315] = 73803, -- Winding Slitherdrake: Small Spiked Crest
	[203316] = 73804, -- Winding Slitherdrake: Large Finned Crest
	[203317] = 73805, -- Winding Slitherdrake: Small Finned Crest
	[203318] = 73806, -- Winding Slitherdrake: Hairy Crest
	[203320] = 73808, -- Winding Slitherdrake: Ears
	[203321] = 73809, -- Winding Slitherdrake: Curled Cheek Horn
	[203322] = 73810, -- Winding Slitherdrake: Blonde Hair
	[203323] = 73811, -- Winding Slitherdrake: Brown Hair
	[203324] = 73812, -- Winding Slitherdrake: White Hair
	[203325] = 73813, -- Winding Slitherdrake: Red Hair
	[203326] = 73814, -- Winding Slitherdrake: Helm
	[203327] = 73815, -- Winding Slitherdrake: Tan Horns
	[203328] = 73816, -- Winding Slitherdrake: White Horns
	[203329] = 73817, -- Winding Slitherdrake: Heavy Horns
	[203330] = 73818, -- Winding Slitherdrake: Swept Horns
	[203331] = 73820, -- Winding Slitherdrake: Cluster Horns
	[203332] = 73821, -- Winding Slitherdrake: Spiked Horns
	[203333] = 73822, -- Winding Slitherdrake: Short Horns
	[203334] = 73824, -- Winding Slitherdrake: Curled Horns
	[203335] = 73825, -- Winding Slitherdrake: Curved Horns
	[203336] = 73826, -- Winding Slitherdrake: Paired Horns
	[203337] = 73827, -- Winding Slitherdrake: Thorn Horns
	[203338] = 73829, -- Winding Slitherdrake: Antler Horns
	[203339] = 73830, -- Winding Slitherdrake: Impaler Horns
	[203340] = 73831, -- Winding Slitherdrake: Cluster Jaw Horns
	[203341] = 73832, -- Winding Slitherdrake: Long Jaw Horns
	[203342] = 73833, -- Winding Slitherdrake: Triple Jaw Horns
	[203343] = 73834, -- Winding Slitherdrake: Hairy Jaw
	[203344] = 73835, -- Winding Slitherdrake: Single Jaw Horn
	[203345] = 73836, -- Winding Slitherdrake: Split Jaw Horns
	[203346] = 73837, -- Winding Slitherdrake: Curled Nose
	[203347] = 73838, -- Winding Slitherdrake: Large Spiked Nose
	[203348] = 73839, -- Winding Slitherdrake: Pointed Nose
	[203349] = 73840, -- Winding Slitherdrake: Curved Nose Horn
	[203350] = 73841, -- Winding Slitherdrake: Blue Scales
	[203351] = 73842, -- Winding Slitherdrake: Bronze Scales
	[203352] = 73843, -- Winding Slitherdrake: Green Scales
	[203353] = 73844, -- Winding Slitherdrake: Red Scales
	[203354] = 73845, -- Winding Slitherdrake: White Scales
	[203355] = 73846, -- Winding Slitherdrake: Yellow Scales
	[203357] = 73849, -- Winding Slitherdrake: Spiked Tail
	[203358] = 73850, -- Winding Slitherdrake: Small Finned Tail
	[203359] = 73851, -- Winding Slitherdrake: Shark Finned Tail
	[203360] = 73852, -- Winding Slitherdrake: Large Finned Tail
	[203361] = 73853, -- Winding Slitherdrake: Finned Tip Tail
	[203362] = 73854, -- Winding Slitherdrake: Hairy Tail
	[203363] = 73855, -- Winding Slitherdrake: Large Finned Throat
	[203364] = 73856, -- Winding Slitherdrake: Small Finned Throat
	[203365] = 73857, -- Winding Slitherdrake: Hairy Throat
	[205341] = 75743, -- Winding Slitherdrake: Heavy Scales
	[205865] = 75941, -- Winding Slitherdrake: Embodiment of the Obsidian Gladiator
	[205876] = 75967, -- Highland Drake: Embodiment of the Hellforged [Mythic]
	[206955] = 75967, -- Highland Drake: Embodiment of the Hellforged [LFR] = Normal] = Heroic]
	[207757] = 77128, -- Grotto Netherwing Drake: Purple and Silver Armor
	[207758] = 77129, -- Grotto Netherwing Drake: Spiked Back
	[207759] = 77130, -- Grotto Netherwing Drake: Cluster Spiked Back
	[207760] = 77131, -- Grotto Netherwing Drake: Armor (might be already 10.2.0)
	[207761] = 77132, -- Grotto Netherwing Drake: Chin Tendrils
	[207762] = 77133, -- Grotto Netherwing Drake: Chin Spike
	[207763] = 77134, -- Grotto Netherwing Drake: Single Horned Crest
	[207764] = 77135, -- Grotto Netherwing Drake: Head Spike
	[207765] = 77136, -- Grotto Netherwing Drake: Cluster Spiked Crest
	[207766] = 77137, -- Grotto Netherwing Drake: Triple Spiked Crest
	[207767] = 77138, -- Grotto Netherwing Drake: Tempestuous Pattern
	[207768] = 77139, -- Grotto Netherwing Drake: Volatile Pattern
	[207769] = 77140, -- Grotto Netherwing Drake: Outcast Pattern
	[207770] = 77141, -- Grotto Netherwing Drake: Helm
	[207771] = 77142, -- Grotto Netherwing Drake: Short Horns
	[207772] = 77143, -- Grotto Netherwing Drake: Long Horns
	[207773] = 77144, -- Grotto Netherwing Drake: Spiked Jaw
	[207774] = 77145, -- Grotto Netherwing Drake: Finned Jaw
	[207775] = 77146, -- Grotto Netherwing Drake: Teal Scales
	[207776] = 77147, -- Grotto Netherwing Drake: Black Scales
	[207777] = 77148, -- Grotto Netherwing Drake: Yellow Scales
	[207778] = 77149, -- Grotto Netherwing Drake: Double Finned Tail
	[207779] = 77150, -- Grotto Netherwing Drake: Barbed Tail
	[208102] = 77258, -- Cliffside Wylderdrake: Visage of the Infinite
	[208103] = 77257, -- Highland Drake: Visage of the Infinite
	[208104] = 77255, -- Renewed Proto-Drake: Visage of the Infinite
	[208105] = 77256, -- Windborne Velocidrake: Visage of the Infinite
	[208106] = 77259, -- Winding Slitherdrake: Visage of the Infinite
	[208200] = 69167, -- Dragon Isles Drakes: Gilded Armor
	[208550] = 69214, -- Dragon Isles Drakes: White Scales [Tyr Part 4]
	[208680] = 77725, -- Windborne Velocidrake: Hallow's End Armor
	[208742] = 77774, -- Renewed Proto-Drake: Brewfest Armor
	[208858] = 77875, -- Highland Drake: Pirates' Day Armor
	[208859] = 77876, -- Cliffside Wylderdrake: Day of the Dead Armor
	[210064] = 78216, -- Winding Slitherdrake: Embodiment of the Verdant Gladiator
	[210432] = 78371, -- Highland Drake: Winter Veil Armor
	[210471] = 78401, -- Flourishing Whimsydrake: Body Armor (might be already 10.2.0)
	[210476] = 78402, -- Flourishing Whimsydrake: Helmet
	[210478] = 78399, -- Flourishing Whimsydrake: Gold and Pink Armor
	[210479] = 78408, -- Flourishing Whimsydrake: Night Scales
	[210480] = 78409, -- Flourishing Whimsydrake: Sunrise Scales
	[210481] = 78410, -- Flourishing Whimsydrake: Sunset Scales
	[210482] = 78400, -- Flourishing Whimsydrake: Back Fins
	[210483] = 78403, -- Flourishing Whimsydrake: Ridged Brow
	[210484] = 78404, -- Flourishing Whimsydrake: Underbite Snout
	[210485] = 78405, -- Flourishing Whimsydrake: Long Snout
	[210486] = 78406, -- Flourishing Whimsydrake: Horns
	[210487] = 78407, -- Flourishing Whimsydrake: Neck Fins
	[210536] = 78451, -- Renewed Proto-Drake: Embodiment of the Blazing
	[210537] = 78453, -- Renewed Proto-Drake: Embodiment of Shadowflame
	[211812] = 79088, -- Renewed Proto-Drake: Love Armor
	[211868] = 79112, -- Winding Slitherdrake: Lunar Festival Armor
	[213561] = 79690, -- Winding Slitherdrake: Void Scales
	[216710] = 80014, -- Highland Drake: Embodiment of the Draconic Gladiator
	[224163] = 82741, -- Cliffside Wylderdrake: Midsummer Fire Festival Armor

	-- D.R.I.V.E. Customisations
	[232982] = 85775, -- Engine: The Pozzik Standard
	[232985] = 85782, -- 22H Slicks
	[232986] = 85781, -- GE86 Advance
	[232981] = 85776, -- GNZ Airmaster 9000
	[232984] = 85784, -- Handcrank
	[236670] = 85787, -- Maniacal Melodies
	[235390] = 86771, -- Paint: Body Roll Blue
	[235389] = 86772, -- Paint: Goblin Green
	[235388] = 86773, -- Paint: Redlining Red
	[235391] = 86774, -- Paint: Yellow Cake Yellow
	[232983] = 85783, -- Steamboil
	[236671] = 85786, -- The Buzzer
	[236672] = 85785, -- The Ol' Low-and-Slow
	[236669] = 85788, -- The Whole Brass Band

	-- Dirigible Schematic
	[224768] = 82171, -- Delver's Dirigible Schematic: Wing-Mounted Propeller
	[224769] = 82183, -- Delver's Dirigible Schematic: Rotor Blades
	[224770] = 82167, -- Delver's Dirigible Schematic: Front-Mounted Propeller
	[224771] = 82181, -- Delver's Dirigible Schematic: Empennage
	[224960] = 82176, -- Delver's Dirigible Schematic: Lantern Wing
	[224979] = 82185, -- Delver's Dirigible Schematic: Zeppelin
	[224980] = 82170, -- Delver's Dirigible Schematic: Front-Mounted Lantern
	[224981] = 82187, -- Delver's Dirigible Schematic: Brown Paint
	[224982] = 82179, -- Delver's Dirigible Schematic: Exhaust
	[225542] = 83308, -- Delver's Dirigible Schematic: Void
	[235685] = 82168, -- Delver's Dirigible Schematic: Drill
	[235684] = 82182, -- Delver's Dirigible Schematic: Glider
	[235687] = 82180, -- Delver's Dirigible Schematic: Spoiler
	[235683] = 82173, -- Delver's Dirigible Schematic: Turbine
	[235686] = 82190, -- Delver's Dirigible Schematic: White Paint
	[230219] = 85181, -- Delver's Gob-Trotter Schematic: Balloon
	[230217] = 85177, -- Delver's Gob-Trotter Schematic: Flamethrower
	[233196] = 86296, -- Delver's Gob-Trotter Schematic: Gold
	[230220] = 85183, -- Delver's Gob-Trotter Schematic: Green
	[230216] = 85175, -- Delver's Gob-Trotter Schematic: Harpoon
	[230218] = 85179, -- Delver's Gob-Trotter Schematic: Pipes
	[238839] = 86199, -- Delver's Dirigible Schematic: Arathi Decal
	[238837] = 86198, -- Delver's Dirigible Schematic: Pale Paint
	[235697] = 82192, -- Delver's Dirigible Schematic: Alliance Decal
	[235694] = 82117, -- Delver's Dirigible Schematic: Blue Paint
	[235696] = 82193, -- Delver's Dirigible Schematic: Explorer Decal
	[235688] = 82174, -- Delver's Dirigible Schematic: Fan
	[235690] = 82169, -- Delver's Dirigible Schematic: Harpoon
	[235698] = 82194, -- Delver's Dirigible Schematic: Horde Decal
	[235689] = 82186, -- Delver's Dirigible Schematic: Kite
	[235695] = 82189, -- Delver's Dirigible Schematic: Red Paint
	[235693] = 82175, -- Delver's Dirigible Schematic: Rocket
	[235692] = 82177, -- Delver's Dirigible Schematic: Thrusters
	[235691] = 82191, -- Delver's Dirigible Schematic: Yellow Paint
	[235694] = 82117, -- Delver's Dirigible Schematic: Blue Paint
	[235688] = 82174, -- Delver's Dirigible Schematic: Fan
	[235690] = 82169, -- Delver's Dirigible Schematic: Harpoon
	[235698] = 82194, -- Delver's Dirigible Schematic: Horde Decal
	[235689] = 82186, -- Delver's Dirigible Schematic: Kite
	[235695] = 82189, -- Delver's Dirigible Schematic: Red Paint
	[235692] = 82177, -- Delver's Dirigible Schematic: Thrusters
	[235691] = 82191, -- Delver's Dirigible Schematic: Yellow Paint
	[238178] = 88814, -- Delver's Mana-Skimmer Schematic: Canister
	[238177] = 88816, -- Delver's Mana-Skimmer Schematic: Emitter
	[238181] = 88820, -- Delver's Mana-Skimmer Schematic: Energy Thrusters
	[238179] = 88815, -- Delver's Mana-Skimmer Schematic: Quad Glider
	[238180] = 88817, -- Delver's Mana-Skimmer Schematic: Void Paint
	[238182] = 88819, -- Delver's Mana-Skimmer Schematic: Hyperdrive

	-- D.I.S.C.
	[244905] = 90953, -- Miniature Titan Disc: Charged Crystal
	[244903] = 90951, -- Miniature Titan Disc: Charged Touch
	[244899] = 90947, -- Miniature Titan Disc: Critical Chain
	[244902] = 90950, -- Miniature Titan Disc: Electric Current
	[244900] = 90948, -- Miniature Titan Disc: Spark Burst
	[244901] = 90949, -- Miniature Titan Disc: Statically Charged

	-- Gravestone Cosmetic
	[262966] = 93866, -- Budget Friendly
	[262964] = 93868, -- Death's Hope
	[262965] = 93867, -- Delver's Delight
	[262963] = 93869, -- Pious Memorial
	[262951] = 93859, -- Sin'dorei Gravestone

	-- Music Rolls
	[122195] = 38063,
	[122196] = 38064,
	[122197] = 38065,
	[122198] = 38066,
	[122199] = 38067,
	[122200] = 38068,
	[122201] = 38069,
	[122202] = 38071,
	[122203] = 38073,
	[122204] = 38075,
	[122205] = 38077,
	[122206] = 38079,
	[122207] = 38081,
	[122208] = 38083,
	[122209] = 38085,
	[122210] = 38070,
	[122211] = 38072,
	[122212] = 38078,
	[122213] = 38074,
	[122214] = 38076,
	[122215] = 38080,
	[122216] = 38082,
	[122217] = 38084,
	[122218] = 38086,
	[122219] = 38101,
	[122221] = 38102,
	[122222] = 38087,
	[122223] = 38088,
	[122224] = 38089,
	[122226] = 38090,
	[122228] = 38091,
	[122229] = 38092,
	[122231] = 38093,
	[122232] = 38094,
	[122233] = 38095,
	[122234] = 38096,
	[122236] = 38097,
	[122237] = 38098,
	[122238] = 38099,
	[122239] = 38100,

	-----------------
	-- PATCH 6.0.2 --
	-----------------
	[139003] = 43016, -- Broken Pet Portal
	[118727] = 34557, -- Frostfire Treasure Map
	[118729] = 36465, -- Gorgrond Treasure Map
	[118732] = 36468, -- Nagrand Treasure Map
	[118730] = 36466, -- Talador Treasure Map
	[118728] = 36464, -- Shadowmoon Valley Treasure Map
	[118731] = 36467, -- Spires of Arak Treasure Map

	-----------------
	-- PATCH 6.2.0 --
	-----------------
	[128444] = 39561, -- Blueprint: Oil Rig [A]
	[128490] = 39561, -- Blueprint: Oil Rig [H]
	[128251] = 39359, -- Equipment Blueprint: Tuskarr Fishing Net
	[128250] = 39358, -- Equipment Blueprint: Unsinkable
	[128446] = 39564, -- Saberstalker Teachings: Trailblazer
	[128294] = 37485, -- Trade Agreement: Arakkoa Outcasts
	[128474] = 39463, -- Treasure Map: Tanaan Jungle [A]
	[113212] = 39463, -- Treasure Map: Tanaan Jungle [H]

	-----------------
	-- PATCH 6.2.2 --
	-----------------
	-- Hallow's End --
	[128664] = 39759, -- Creepy Crawlers
	[128660] = 39758, -- Ghoulish Guises
	[128661] = 39612, -- Hallow's Glow
	[128662] = 39613, -- Seer's Invitation
	[128663] = 39611, -- Witch's Brew
	-- Feast of Winter Veil --
	[128665] = 39615, -- Ball of Tangled Lights
	[128666] = 39616, -- Imported Trees
	[128667] = 39767, -- Little Helpers
	[128669] = 39712, -- Old Box of Decorations

	-----------------
	-- PATCH 7.0.3 --
	-----------------
	-- Classes --
	[141409] = 44455, -- Candrael's Charm
	-- Ancient Mana --
	[140326] = 43986, -- Enchanted Burial Urn
	[140329] = 43989, -- Infinite Stone
	[136269] = 42842, -- Kel'danath's Manaflask
	[140327] = 43987, -- Kyrtos's Research Notes
	[140328] = 43988, -- Volatile Leyline Crystal
	-- Reaves Module --
	[132528] = 40734, -- Reaves Module: Fireworks Display Mode
	[132526] = 40733, -- Reaves Module: Failure Detection Mode
	[132529] = 40735, -- Reaves Module: Snack Distribution Mode
	[132525] = 40732, -- Reaves Module: Repair Mode
	[132531] = 40737, -- Reaves Module: Piloted Combat Mode
	[132530] = 40736, -- Reaves Module: Bling Mode
	[132524] = 40738, -- Reaves Module: Wormhole Generator Mode
	-- The Underbelly Portals --
	[138031] = 42531, -- Portal Key: Abandoned Shack
	[138030] = 42530, -- Portal Key: Alchemists' Lair
	[138028] = 42528, -- Portal Key: Black Market
	[138029] = 42529, -- Portal Key: Inn Entrance
	[138032] = 42532, -- Portal Key: Rear Entrance
	[138027] = 42527, -- Portal Key: Sewer Guard Station

	-----------------
	-- PATCH 7.3.0 --
	-----------------
	[152964] = 49006, -- Krokul Flute
	[152583] = 48546, -- Underlight Emerald

	-----------------
	-- PATCH 8.0.1 --
	-----------------
	-- Flight Path Maps --
	[166445] = 54705, -- 7th Legion Scouting Map
	[166444] = 54704, -- Honorbound Scouting Map

	-----------------
	-- PATCH 8.1.0 --
	-----------------
	[166502] = 54753, -- Blood-Soaked Tome of Dark Whispers
	[166749] = 54859, -- Lyrics: Song of the Sea

	-----------------
	-- PATCH 9.0.1 --
	-----------------
	[183123] = 62254, -- How to School Your Serpent
	[89868] = 62677, -- Mark of the Cheetah
	[140630] = 62678, -- Mark of the Doe
	[162022] = 62674, -- Mark of the Dolphin
	[162029] = 62676, -- Mark of the Humble Flyer
	[40919] = 62673, -- Mark of the Orca
	[129021] = 62675, -- Mark of the Sentinel
	[162027] = 62672, -- Mark of the Tideskipper
	[165840] = 54264, -- Shattered Pet Portal

	-----------------
	-- PATCH 9.0.2 --
	-----------------
	[187923] = 65039, -- Aurelid Lure
	[184220] = 62821, -- Encyclopedia of Sinstone Fragment Recovery
	[180705] = 61160, -- Gargon Training Manual
	[184222] = 62822, -- Lemet's Requisition Orders
	[183517] = 62372, -- Page 76 of the Necronom-i-nom
	[183124] = 62255, -- Simple Tome of Bone-Binding
	[184219] = 62821, -- Treatise on Sinstone Fragment Acquisition
	-- Ve'nari --
	[180949] = 61600, -- Animaflow Stabilizer
	[184653] = 63217, -- Animated Levitating Chain
	[184617] = 63193, -- Bangle of Seniority
	[184901] = 63523, -- Broker Traversal Enhancer
	[184613] = 63177, -- Encased Riftwalker Essence
	[184615] = 63183, -- Extradimensional Pockets
	[184619] = 63201, -- Loupe of Unusual Charm
	[180952] = 61144, -- Possibility Matrix
	[184618] = 63200, -- Rank Insignia: Acquisitionist
	[184621] = 63204, -- Ritual Prism of Fortune
	[184605] = 63092, -- Sigil of the Unseen
	[184588] = 63091, -- Soul-Stabilizing Talisman
	[184620] = 63202, -- Vessel of Unfortunate Spirits
	-- Ember Court --
	[181441] = 61457, -- Altar of Accomplishment
	[177230] = 59681, -- Anima-Infused Water
	[177232] = 59683, -- Bewitched Wardrobe
	[177233] = 59684, -- Bounding Shroom Seeds
	[181517] = 61493, -- Building: Dredger Pool
	[181518] = 61494, -- Building: Guardhouse
	[176130] = 59494, -- Contract: Atoning Rituals
	[176135] = 59503, -- Contract: Divine Desserts
	[176131] = 59491, -- Contract: Glimpse of the Wilds
	[176132] = 59488, -- Contract: Lost Chalice Band
	[176140] = 59512, -- Contract: Maldraxxian Army
	[176128] = 59476, -- Contract: Mortal Reminders
	[176136] = 59500, -- Contract: Mushroom Surprise!
	[176127] = 59479, -- Contract: Mystery Mirrors
	[176139] = 59515, -- Contract: Stoneborn Reserves
	[176126] = 59473, -- Contract: Traditional Theme
	[176134] = 59506, -- Contract: Tubbins's Tea Party
	[176138] = 59518, -- Contract: Venthyr Volunteers
	[177231] = 59682, -- Crown of Honor
	[177236] = 59687, -- Dog Bone's Bone
	[177237] = 59688, -- Dredger Party Supplies
	[181521] = 61501, -- Ember Court Ambassador
	[177238] = 59689, -- Generous Gift
	[181536] = 61504, -- Guest List Page
	[181537] = 61505, -- Guest List Page
	[181538] = 61506, -- Guest List Page
	[183956] = 62656, -- Invitation: Choofa
	[183957] = 62657, -- Invitation: Grandmaster Vole
	[177243] = 59693, -- Kyrian Arsenal
	[177245] = 59695, -- Maldraxxi Challenge Banner
	[177241] = 59691, -- Necrolord Arsenal
	[177244] = 59694, -- Night Fae Arsenal
	[181439] = 61455, -- Protective Braziers
	[177239] = 59690, -- Racing Permit
	[177234] = 59685, -- Rally Bell
	[181440] = 61456, -- Slippery Muck
	[181524] = 61502, -- Staff: Ambassador
	[182343] = 61888, -- Staff: Bastion Ambassador
	[181523] = 59437, -- Staff: Bouncers
	[181519] = 59435, -- Staff: Dredger Decorators
	[182342] = 61887, -- Staff: Maldraxxus Ambassador
	[181520] = 59436, -- Staff: Stage Crew
	[181522] = 59433, -- Staff: Waiters
	[181533] = 61499, -- Stock: Anima Samples
	[181532] = 61498, -- Stock: Appetizers
	[181535] = 61500, -- Stock: Comfy Chairs
	[181530] = 61497, -- Stock: Greeting Kits
	[181443] = 61459, -- The Party Herald's Party Hat
	[181438] = 61454, -- The Wild Drum
	[181437] = 61453, -- Training Dummies
	[177235] = 59686, -- Tubbins's Lucky Teapot
	[181436] = 61452, -- Vanity Mirror
	[177242] = 59692, -- Venthyr Arsenal
	[181442] = 61458, -- Visions of Sire Denathrius

	-----------------
	-- PATCH 9.0.5 --
	-----------------
	[185632] = 63668, -- Intact Rune Codex
	[185351] = 63641, -- Rune Codex Page: Forging
	[185352] = 63642, -- Rune Codex Page: Souls
	[185353] = 63643, -- Rune Codex Page: Binding
	[185473] = 63667, -- Soulforger's Tools

	-----------------
	-- PATCH 9.1.0 --
	-----------------
	[186970] = 62683, -- Feeder's Hand and Key
	[185965] = 63893, -- Memories of Sunless Skies
	[187138] = 64303, -- Research Report: First Alloys
	[187136] = 64367, -- Research Report: Relic Examination Techniques
	[186716] = 64348, -- Research Report: Ancient Shrines
	[186714] = 64339, -- Research Report: All-Seeing Crystal
	[186717] = 64300, -- Research Report: Adaptive Alloys
	[186722] = 64027, -- Treatise: The Study of Anima and Harnessing Every Drop
	[186721] = 64366, -- Treatise: Relics Abound in the Shadowlands
	[187145] = 64307, -- Treatise: Recognizing Stygia and its Uses
	[187706] = 64828, -- Treatise: Bonds of Stygia in Mortals
	[186453] = 64061, -- Vault Anima Tracker

	-----------------
	-- PATCH 9.1.5 --
	-----------------
	[187933] = 65058, -- Mark of the Duskwing Raven
	[187887] = 65048, -- Mark of the Gloomstalker Dredbat
	[187934] = 65061, -- Mark of the Midnight Runestag
	[187931] = 65059, -- Mark of the Regal Dredbat
	[187936] = 65062, -- Mark of the Sable Ardenmoth
	[187888] = 64987, -- Mark of the Shimmering Ardenmoth
	[187884] = 64986, -- Mark of the Twilight Runestag
	[190184] = 65623, -- Incense of Infinity
	[187560] = 64628, -- Rockin' Rollin' Racer Pack

	-----------------
	-- PATCH 9.2.0 --
	-----------------
	[190640] = 65694, -- Font of Ephemeral Power
	[190956] = 70705, -- Decanter of Untapped Potential
	[190234] = 65617, -- Enlightened Portal Research
	[188793] = 65282, -- Improvised Cypher Analysis Tool
	[183693] = 62409, -- Plague Doctor's Mask
	[190644] = 70704, -- Vessel of Profound Possibilities

	------------------
	-- PATCH 10.0.2 --
	------------------
	-- Grand Hunt --
	[194095] = 71052, -- Ohuna Companion Color: Sepia
	[194088] = 71049, -- Ohuna Companion Color: Dark
	[194087] = 71051, -- Ohuna Companion Color: Red
	[193205] = 71050, -- Ohuna Companion Color: Brown
	[194090] = 71047, -- Bakar Companion Color: White
	[194089] = 71046, -- Bakar Companion Color: Orange
	[194091] = 71048, -- Bakar Companion Color: Golden Brown
	[194093] = 71045, -- Bakar Companion Color: Brown
	[194094] = 71044, -- Bakar Companion Color: Black
	-- Iskaara Fishing --
	[199847] = 70799, -- Braided Seavine Harpoon Rope
	[199849] = 70801, -- Dense Draconium Net Weight
	[199851] = 70803, -- Double Imbu Knot
	[199848] = 70800, -- Draconium Net Weights
	[199694] = 75642, -- Flying Fish Bone Charm
	[199850] = 70802, -- Imbu Knot
	[199698] = 70794, -- Irontree Harpoon Handle
	[199695] = 70793, -- Iskaaran Fishing Net
	[194510] = 70792, -- Iskaaran Harpoon
	[199696] = 67141, -- Iskaaran Ice Axe
	[199845] = 70797, -- Jagged Serevite Harpoon Head
	[199697] = 67140, -- Polished Basalt Bracelet
	[199641] = 70795, -- Reinforced Irontree Harpoon Handle
	[199846] = 70798, -- Seavine Harpoon Rope
	[199844] = 70796, -- Serevite Harpoon Head
	-- Various --
	[202047] = 72248, -- Gleaming Incarnate Thunderstone
	[201791] = 72094, -- How to Train a Dragonkin

	------------------
	-- PATCH 10.1.0 --
	------------------
	[205878] = 75968, -- Obsidian Aspectral Earthstone
	[205954] = 76017, -- Three-Dimensional Compass

	------------------
	-- PATCH 10.1.5 --
	------------------
	[206473] = 76307, -- Makeshift Grappling Hook
	-- Imp --
	[207178] = 76743, -- Grimoire of the Darkfire Imp
	[207295] = 76744, -- Grimoire of the Dreadfire Imp
	[129018] = 76369, -- Grimoire of the Fel Imp
	[207297] = 76746, -- Grimoire of the Felblaze Imp
	[207294] = 76747, -- Grimoire of the Felfrost Imp
	[207114] = 76742, -- Grimoire of the Fiendish Imp
	[207111] = 76737, -- Grimoire of the Hellfire Fel Imp
	[207296] = 76745, -- Grimoire of the Netherbound Imp
	[207113] = 76741, -- Grimoire of the Trickster Fel Imp
	[207112] = 76740, -- Grimoire of the Void-Touched Fel Imp
	-- Voidwalker --
	[139311] = 76375, -- Grimoire of the Voidlord
	-- Succubus --
	[147117] = 76377, -- Orb of the Fel Temptress
	[147119] = 76372, -- Grimoire of the Shadow Succubus
	[139310] = 76373, -- Grimoire of the Shivarra
	-- Felhunter --
	[208051] = 77180, -- Grimoire of the Antoran Felhunter
	[208052] = 77181, -- Grimoire of the Voracious Felmaw
	[208050] = 77183, -- Grimoire of the Xorothian Felhunter
	[208048] = 77182, -- Ritual of the Voidmaw Felhunter
	-- Felguard --
	[139315] = 76376, -- Grimoire of the Wrathguard
	-- Infernal --
	[139314] = 76370, -- Grimoire of the Abyssal

	------------------
	-- PATCH 10.1.7 --
	------------------
	[208551] = 77678, -- Ambrosial Sporestone

	------------------
	-- PATCH 10.2.0 --
	------------------
	[210645] = 78479, -- Feather of Friends
	[210754] = 78527, -- Feather of the Blazing Somnowl
	[211280] = 78525, -- Feather of the Smoke Red Moon
	[210735] = 78523, -- Mark of the Auric Dreamstag
	[211081] = 78514, -- Mark of the Auroral Dreamtalon
	[211080] = 78512, -- Mark of the Boreal Dreamtalon
	[210683] = 78513, -- Mark of the Dreamtalon Matriarch
	[210669] = 78507, -- Mark of the Evergreen Dreamsaber
	[210751] = 78528, -- Mark of the Hibernating Runebear
	[210650] = 78503, -- Mark of the Keen-Eyed Dreamsaber
	[210738] = 78519, -- Mark of the Loamy Umbraclaw
	[210731] = 78522, -- Mark of the Lush Dreamstag
	[210674] = 78511, -- Mark of the Sable Dreamtalon
	[210535] = 78448, -- Mark of the Slumbering Somnowl
	[210736] = 78524, -- Mark of the Smoldering Dreamstag
	[210739] = 78520, -- Mark of the Snowy Umbraclaw
	[210684] = 78515, -- Mark of the Thriving Dreamtalon
	[210647] = 78481, -- Mark of the Umbramane
	[210729] = 78517, -- Mark of the Verdant Bristlebruin
	[210728] = 78521, -- Moon-Blessed Claw
	[210727] = 78518, -- Pollenfused Bristlebruin Fur Sample
	[210753] = 78516, -- Scale of the Prismatic Whiskerfish
	[211314] = 78842, -- Cinder of Companionship
	[210468] = 78422, -- Emerald Blossom Dreamstone

	------------------
	-- PATCH 10.2.5 --
	------------------
	[213016] = 79457, -- Grimoire of the Abyssal Darkglare
	[212750] = 79359, -- Grimoire of the Ancient Observer
	[212983] = 79443, -- Grimoire of the Blasted Observer
	[212779] = 79374, -- Grimoire of the Bloodrage Tyrant
	[212991] = 79447, -- Grimoire of the Dire Observer
	[213015] = 79456, -- Grimoire of the Eredathian Darkglare
	[212780] = 79375, -- Grimoire of the Felbrute Tyrant
	[212989] = 79446, -- Grimoire of the Mana-Gorged Observer
	[212783] = 79376, -- Grimoire of the Netherwalk Tyrant
	[212993] = 79449, -- Grimoire of the Plagued Observer
	[213017] = 79458, -- Grimoire of the Riftsmolder Darkglare
	[212778] = 79373, -- Grimoire of the Vile Tyrant
	[212995] = 79450, -- Grimoire of the Whispering Observer
	[213014] = 79455, -- Grimoire of the Xorothian Darkglare
	[212984] = 79444, -- Grimoire of the Zealous Observer
	[212925] = 79392, -- Hearthstone Card: Abomination
	[212922] = 79390, -- Hearthstone Card: Alley Cat
	[212927] = 79394, -- Hearthstone Card: Ancient of Lore
	[212932] = 79399, -- Hearthstone Card: Arcane Explosion
	[212926] = 79393, -- Hearthstone Card: Arcane Golem
	[212933] = 79401, -- Hearthstone Card: Arcane Shot
	[212929] = 79396, -- Hearthstone Card: Baron Geddon
	[212930] = 79397, -- Hearthstone Card: Blessing of Kings
	[213019] = 79460, -- Hearthstone Card: Cairne Bloodhoof
	[212938] = 79406, -- Hearthstone Card: Charged Devilsaur
	[212921] = 79389, -- Hearthstone Card: Chillwind Yeti
	[212931] = 79398, -- Hearthstone Card: Forbidden Words
	[212923] = 79391, -- Hearthstone Card: Grove Tender
	[213224] = 79582, -- Hearthstone Card: Hand of Protection
	[212928] = 79395, -- Hearthstone Card: Hogger
	[212939] = 79403, -- Hearthstone Card: Jive, Insect!
	[212937] = 79402, -- Hearthstone Card: Preparation
	[212934] = 79400, -- Hearthstone Card: Pyroblast
	[212936] = 79405, -- Hearthstone Card: Righteousness
	[212871] = 79384, -- Hearthstone Card: Scarlet Crusader
	[212872] = 79385, -- Hearthstone Card: Shadow Word: Ruin

	------------------
	-- PATCH 11.0.2 --
	------------------
	[224553] = 82998, -- Beledar's Attunement
	[228944] = 84690, -- Crypt Lord's Severed Thread
	[228945] = 84691, -- Executor's Severed Thread
	[210826] = 76996, -- Harvestbot Repair Kit
	[229195] = 84006, -- Queen's Pheromone
	[228943] = 84689, -- Spymaster's Severed Thread

	-- Titles
	[230264] = 85224, -- Bronze Celebration Titles: Broken Isles Enthusiast
	[230261] = 85221, -- Bronze Celebration Titles: Cataclysm Enthusiast
	[230258] = 85218, -- Bronze Celebration Titles: Classic Enthusiast
	[230263] = 85223, -- Bronze Celebration Titles: Draenor Enthusiast
	[230268] = 85228, -- Bronze Celebration Titles: Dragon Isles Enthusiast
	[229826] = 85015, -- Bronze Celebration Titles: Grizzly Hills Hiker
	[231833] = 85517, -- Bronze Celebration Titles: Karazhan Graduate
	[230266] = 85226, -- Bronze Celebration Titles: Kul Tiras Enthusiast
	[231832] = 85516, -- Bronze Celebration Titles: Molten Core Prospector
	[230260] = 85220, -- Bronze Celebration Titles: Northrend Enthusiast
	[230259] = 85219, -- Bronze Celebration Titles: Outland Enthusiast
	[230262] = 85222, -- Bronze Celebration Titles: Pandaria Enthusiast
	[229827] = 85014, -- Bronze Celebration Titles: Plaguelands Survivor
	[230267] = 85227, -- Bronze Celebration Titles: Shadowlands Enthusiast
	[230265] = 85225, -- Bronze Celebration Titles: Zuldazar Enthusiast
	[249242] = 91961, -- Bronze Celebration Titles: Khaz Algar Enthusiast

	-- Professions
	[235037] = 86630, -- Crumpled Schematic: Wormhole Generator: Undermine
}

app.Container = {
	[206568] = true, -- Dented Raider's Helmet
	[206569] = true, -- Dented Raider's Spaulders
	[206575] = true, -- Dented Raider's Boots
	[206570] = true, -- Dented Raider's Chestpiece
	[206573] = true, -- Dented Raider's Belt
	[206574] = true, -- Dented Raider's Leggings
	[206571] = true, -- Dented Raider's Bracers
	[206572] = true, -- Dented Raider's Gauntlets
}
