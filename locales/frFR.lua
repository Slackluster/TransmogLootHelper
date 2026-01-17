--------------------------------------
-- Equip Recommended Gear: frFR.lua --
--------------------------------------
-- French (France) localisation
-- Translator(s): Klep-Ysondre

-- Initialisation
if GetLocale() ~= "frFR" then return end
local appName, app = ...
local L = app.locales

-- Slash commands
L.INVALID_COMMAND =						"Commande non valide."
-- L.DELETED_ENTRIES =						"Deleted entries:"
-- L.DELETED_REMOVED =						"Unique collectibles removed:"

-- Version comms
L.NEW_VERSION_AVAILABLE =				"Une nouvelle version de " .. app.NameLong .. " est disponible :"

-- Item overlay
-- L.BINDTEXT_WUE =						"WuE"
-- L.BINDTEXT_BOP =						"BoP"
-- L.BINDTEXT_BOE =						"BoE"
-- L.BINDTEXT_BOA =						"BoA"
-- L.RECIPE_UNCACHED =						"Please open this profession to update the recipe's collection status."

-- Loot tracker
-- L.DEFAULT_MESSAGE = 					"Do you need the %item you looted? If not, I'd like to have it for transmog. :)"
-- L.CLEAR_CONFIRM =						"Do you want to clear all loot?"

-- L.WINDOW_BUTTON_CLOSE =					"Close the window"
-- L.WINDOW_BUTTON_LOCK =					"Lock the window"
-- L.WINDOW_BUTTON_UNLOCK =				"Unlock the window"
L.WINDOW_BUTTON_SETTINGS =				"Ouvrir les paramètres"
-- L.WINDOW_BUTTON_CLEAR =					"Clear all items\nHold Shift to skip confirmation"
-- L.WINDOW_BUTTON_SORT1 =					"Sort by newest first\nCurrent sorting:|cffFFFFFF alphabetical|r"
-- L.WINDOW_BUTTON_SORT2 =					"Sort alphabetically\nCurrent sorting:|cffFFFFFF newest first|r"
-- L.WINDOW_BUTTON_CORNER =				"Double " .. app.IconLMB .. "|cffFFFFFF: Autosize to fit the window|r"

-- L.WINDOW_HEADER_LOOT_DESC =				"|r" .. app.IconLMB .. "|cffFFFFFF: Whisper and request the item\n|rShift " .. app.IconLMB .. "|cffFFFFFF: Link the item\n|rShift " .. app.IconRMB .. "|cffFFFFFF: Remove the item"
-- L.WINDOW_HEADER_FILTERED =				"Filtered"
-- L.WINDOW_HEADER_FILTERED_DESC =			"|r" .. app.IconRMB .. "|cffFFFFFF: Debug this item\n|rShift " .. app.IconLMB .. "|cffFFFFFF: Link the item\n|rShift " .. app.IconRMB .. "|cffFFFFFF: Remove the item"

-- L.PLAYER_COLLECTED_APPEARANCE =			"collected an appearance from this item"	-- Preceded by a character name
-- L.PLAYER_WHISPERED =					"has been whispered by " .. app.NameShort .. " users"
-- L.WHISPERED_TIME =						"time"
-- L.WHISPERED_TIMES =						"times"
-- L.WHISPER_COOLDOWN =					"You may only whisper a player once every 30 seconds per item."

-- L.FILTER_REASON_UNTRADEABLE =			"Untradeable"
-- L.FILTER_REASON_RARITY =				"Rarity too low"
-- L.FILTER_REASON_KNOWN =					"Known appearance"

-- Tweaks
-- L.INSTANT_BUTTON =						"Get it now!"
-- L.INSTANT_TOOLTIP =						"Hold Shift to instantly receive your item and skip the 5 second timer."

-- Settings
L.SETTINGS_TOOLTIP =					app.NameLong .. "\n|cffFFFFFF" .. app.IconLMB .. " : afficher / masquer la fenêtre\n" .. app.IconRMB .. " : " .. L.WINDOW_BUTTON_SETTINGS

-- L.SETTINGS_VERSION =					GAME_VERSION_LABEL .. ":"	-- "Version"
L.SETTINGS_SUPPORT_TEXTLONG =			"Le développement de cette extension demande beaucoup de temps et d’efforts.\nVeuillez envisager de soutenir financièrement le développeur."
L.SETTINGS_SUPPORT_TEXT =				"Soutien"
L.SETTINGS_SUPPORT_BUTTON =				"Buy Me a Coffee"	-- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =				"Merci !"
L.SETTINGS_HELP_TEXT =					"Commentaires et aide"
L.SETTINGS_HELP_BUTTON =				"Discord"	-- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =					"Rejoignez le serveur Discord."
L.SETTINGS_ISSUES_TEXT =				"Suivi des problèmes"
L.SETTINGS_ISSUES_BUTTON =				"GitHub"	-- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_ISSUES_DESC =				"Consultez le système de suivi des problèmes (« Issues ») sur GitHub."
L.SETTINGS_URL_COPY =					"Ctrl + C pour copier :"
L.SETTINGS_URL_COPIED =					"Lien copié dans le presse-papiers"

L.SETTINGS_KEYSLASH_TITLE =				SETTINGS_KEYBINDINGS_LABEL .. " & Commandes « Slash »"	-- "Keybindings"
-- _G["BINDING_NAME_TLH_TOGGLEWINDOW"] =	app.NameShort .. ": Toggle Window"
-- L.SETTINGS_SLASH_TOGGLE =				"Toggle the tracking window"
-- L.SETTINGS_SLASH_RESETPOS =				"Reset the tracking window position"
-- L.SETTINGS_SLASH_WHISPER_DEFAULT =		"Set the whisper message to its default"
-- L.SETTINGS_SLASH_DELETE_DESC =			"Mark a character's unique recipes etc. as unlearned"
-- L.SETTINGS_SLASH_CHARREALM =			"Character-Realm"

-- L.GENERAL =								GENERAL	-- "General"
-- L.SETTINGS_ITEM_OVERLAY	=				"Item Overlay"
-- L.SETTINGS_BAGANATOR =					"For Baganator users this is managed by Baganator's own settings."
-- L.SETTINGS_ITEM_OVERLAY_DESC =			"Show an icon and text on items, to indicate collection status and more.\n\n|cffFF0000" .. REQUIRES_RELOAD .. ".|r Use |cffFFFFFF/reload|r or relog.\n\n" .. L.SETTINGS_BAGANATOR
-- L.SETTINGS_ICONPOS =					"Icon Position"
-- L.SETTINGS_ICONPOS_DESC =				"The location of the icon on the item."
-- L.SETTINGS_ICONPOS_TL =					"Top Left"
-- L.SETTINGS_ICONPOS_TR =					"Top Right"
-- L.SETTINGS_ICONPOS_BL =					"Bottom Left"
-- L.SETTINGS_ICONPOS_BR =					"Bottom Right"
-- L.SETTINGS_ICONPOS_OVERLAP0 =			"No known overlap issues."
-- L.SETTINGS_ICONPOS_OVERLAP1 =			"This may overlap with a crafted item's quality."
-- L.SETTINGS_ICON_SIMPLE =				"Simple Icons"
-- L.SETTINGS_ICON_SIMPLE_DESC =			"Use simple, high contrast icons designed to aid with color blindness."
-- L.SETTINGS_ICON_ANIMATE =				"Icon Animation"
-- L.SETTINGS_ICON_ANIMATE_DESC =			"Show a pretty animated swirl on icons for learnable and usable icons."

-- L.SETTINGS_HEADER_COLLECTION =			"Collection Info"
-- L.SETTINGS_ICON_NEW_MOG =				"Appearances"
-- L.SETTINGS_ICON_NEW_MOG_DESC =			"Show an icon to indicate an item's appearance is unlearned."
-- L.SETTINGS_ICON_NEW_SOURCE =			"Sources"
-- L.SETTINGS_ICON_NEW_SOURCE_DESC =		"Show an icon to indicate an item's appearance source is unlearned."
-- L.SETTINGS_ICON_NEW_CATALYST =			"From Catalyzing"
-- L.SETTINGS_ICON_NEW_CATALYST_DESC =		"Show an icon when catalyzing an item grants a new appearance."
-- L.SETTINGS_ICON_NEW_UPGRADE =			"From Upgrading"
-- L.SETTINGS_ICON_NEW_UPGRADE_DESC =		"Show an icon when upgrading an item grants a new appearance."
-- L.SETTINGS_ICON_NEW_ILLUSION =			"Illusions"
-- L.SETTINGS_ICON_NEW_ILLUSION_DESC =		"Show an icon to indicate an illusion is unlearned."
-- L.SETTINGS_ICON_NEW_MOUNT =				"Mounts"
-- L.SETTINGS_ICON_NEW_MOUNT_DESC =		"Show an icon to indicate a mount is unlearned."
-- L.SETTINGS_ICON_NEW_PET =				"Pets"
-- L.SETTINGS_ICON_NEW_PET_DESC =			"Show an icon to indicate a pet is unlearned."
-- L.SETTINGS_ICON_NEW_PET_MAX =			"Collect 3/3"
-- L.SETTINGS_ICON_NEW_PET_MAX_DESC =		"Also take the maximum number of pets you can own into account (usually 3)."
-- L.SETTINGS_ICON_NEW_TOY =				"Toys"
-- L.SETTINGS_ICON_NEW_TOY_DESC =			"Show an icon to indicate a toy is unlearned."
-- L.SETTINGS_ICON_NEW_RECIPE =			"Recipes"
-- L.SETTINGS_ICON_NEW_RECIPE_DESC =		"Show an icon to indicate a recipe is unlearned."
-- L.SETTINGS_ICON_NEW_DECOR =				"Decor"
-- L.SETTINGS_ICON_NEW_DECOR_DESC =		"Show an icon to indicate you don't own a housing decor."
-- L.SETTINGS_ICON_NEW_DECORXP =			"Only with House XP"
-- L.SETTINGS_ICON_NEW_DECORXP_DESC =		"Only show the icon for housing decor that grants House XP."
-- L.SETTINGS_ICON_LEARNED =				"Learned"
-- L.SETTINGS_ICON_LEARNED_DESC =			"Show an icon to indicate the above tracked collectibles are learned."

-- L.SETTINGS_HEADER_OTHER_INFO =			"Other Information"
-- L.SETTINGS_ICON_QUEST_GOLD =			"Quest Reward Sell Value"
-- L.SETTINGS_ICON_QUEST_GOLD_DESC =		"Show an icon to indicate which quest reward has the highest vendor sell value, if there are multiple."
-- L.SETTINGS_ICON_USABLE =				"Usable Items"
-- L.SETTINGS_ICON_USABLE_DESC =			"Show an icon to indicate an item can be used (profession knowledge, unlockable customisations, and spellbooks)."
-- L.SETTINGS_ICON_OPENABLE =				"Openable Items"
-- L.SETTINGS_ICON_OPENABLE_DESC =			"Show an icon to indicate an item can be opened, such as lockboxes and holiday boss bags."
-- L.SETTINGS_BINDTEXT =					"Binding Text"
-- L.SETTINGS_BINDTEXT_DESC =				"Show a text indicator for Bind-on-Equip items (BoE), Warbound items (BoA), and Warbound-until-Equipped (WuE) items.\n\n" .. L.SETTINGS_BAGANATOR

-- L.SETTINGS_HEADER_LOOT_TRACKER =		"Loot Tracker"
-- L.SETTINGS_MINIMAP =					"Show Minimap Icon"
-- L.SETTINGS_MINIMAP_DESC =				"Show the minimap icon. If you disable this, " .. app.NameShort .. " is still available from the Addon Compartment."
-- L.SETTINGS_AUTO_OPEN =					"Auto Open Window"
-- L.SETTINGS_AUTO_OPEN_DESC =				"Automatically show the " .. app.NameShort .. " window when an eligible item is looted."
-- L.SETTINGS_COLLECTION_MODE =			"Collection Mode"
-- L.SETTINGS_COLLECTION_MODE_DESC =		"Set when " .. app.NameShort .. " should show new transmog looted by others."
-- L.SETTINGS_MODE_APPEARANCES =			"Appearances"
-- L.SETTINGS_MODE_APPEARANCES_DESC =		"Show items only if they have a new appearance."
-- L.SETTINGS_MODE_SOURCES =				"Sources"
-- L.SETTINGS_MODE_SOURCES_DESC =			"Show items if they are a new source, including for known appearances."
-- L.SETTINGS_RARITY =						"Rarity"
-- L.SETTINGS_RARITY_DESC =				"Set from what quality and up " .. app.NameShort .. " should show loot."
-- L.SETTINGS_WHISPER =					"Whisper Message"
-- L.SETTINGS_WHISPER_CUSTOMIZE =			"Customize"
-- L.SETTINGS_WHISPER_CUSTOMIZE_DESC =		"Customize the whisper message"
-- L.WHISPER_POPUP_CUSTOMIZE = 			"Customize your whisper message:"
-- L.WHISPER_POPUP_ERROR = 				"Message does not include |cff3FC7EB%item|r. Message is not updated."
-- L.WHISPER_POPUP_SUCCESS =				"Message is updated."

-- L.SETTINGS_HEADER_TWEAKS =				"Tweaks"
-- L.SETTINGS_CATALYST =					"Instant Catalyst"
-- L.SETTINGS_CATALYST_DESC =				"Hold Shift to instantly catalyze an item, skipping the 5 second timer."
-- L.SETTINGS_VAULT =						"Instant Great Vault"
-- L.SETTINGS_VAULT_DESC =					"Hold Shift to instantly receive your reward from the Great Vault and skip the 5 second timer."
-- L.SETTINGS_INSTANT_TOOLTIP =			"Show tooltip"
-- L.SETTINGS_INSTANT_TOOLTIP_DESC =		"Show the tooltip explaining how this feature works. The button text still changes when this is disabled."
-- L.SETTINGS_VENDOR_ALL =					"Disable Vendor Filter"
-- L.SETTINGS_VENDOR_ALL_DESC =			"Automatically set all vendor filters to |cffFFFFFFAll|r to display items normally not shown to your class."
-- L.SETTINGS_HIDE_LOOT_ROLL_WINDOW =		"Hide loot roll window"
-- L.SETTINGS_HIDE_LOOT_ROLL_WINDOW_DESC =	"Hide the window that shows loot rolls and their results. You can show the window again with |cff00ccff/loot|r."
