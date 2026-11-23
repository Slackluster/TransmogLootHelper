------------------------------------
-- Transmog Loot Helper: zhTW.lua --
------------------------------------
-- Chinese (Traditional, Taiwan) localisation
-- Translator(s):

if GetLocale() ~= "zhTW" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "%s 有新版本可用：" -- %s becomes the addon name

L.INVALID_COMMAND =                      "指令無效"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. "：" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "開發這個插件需要投入大量的時間與心力。"
L.SUPPORT_TEXTLONG2 =                    "歡迎考慮以金錢支持開發者。"
L.SUPPORT =                              "支持"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "謝謝！"
L.FEEDBACK_AND_HELP =                    "意見回饋與協助"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "加入 Discord 伺服器。"
L.CTRL_C_COPY =                          "按 Ctrl+C 複製："
L.LINK_COPIED =                          "連結已複製到剪貼簿"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & 斜線指令" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. "：切換視窗"
L.TOGGLE_TRACKING_WINDOW =               "切換追蹤視窗"
L.RESET_WINDOW_POSITION =                "重置追蹤視窗的位置"
L.OPEN_SETTINGS =                        "開啟設定"
-- L.CHARACTER_REALM =                      "Character-Realm"
-- L.DELETE_CHAR_RECIPES =                  "Mark a character's unique recipes etc. as unlearned"
-- L.WHISPER_SET_DEFAULT =                  "Set the whisper message to its default"

L.GENERAL =                              GENERAL -- "General"
-- L.ITEM_OVERLAY =                         "Item Overlay"
-- L.ITEM_OVERLAY_DESC =                    "Show an icon and text on items, to indicate collection status and more."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
-- L.ICON_POSITION =                        "Icon Position"
-- L.ICON_POSITION_DESC =                   "On which corner the icon appears."
-- L.BAGANATOR_SETTINGS =                   "For Baganator users this is managed by Baganator's own settings."
-- L.TOP_LEFT =                             "Top Left"
-- L.TOP_RIGHT =                            "Top Right"
-- L.BOTTOM_LEFT =                          "Bottom Left"
-- L.BOTTOM_RIGHT =                         "Bottom Right"
-- L.OVERLAP_ISSUES_NONE =                  "No known overlap issues."
-- L.OVERLAP_ISSUES_QUALITY =               "This may overlap with a crafted item's quality."
-- L.ICON_STYLE =                           "Icon Style"
-- L.ICON_STYLE_DESC =                      "The style of the status icon."
-- L.ICON_STYLE_FANCYCIRCLE =               "Fancy Circle"
-- L.ICON_STYLE_FANCYCIRCLE_DESC =          "Type icon with round status border on corner"
-- L.ICON_STYLE_SIMPLECIRCLE =              "Simple Circle"
-- L.ICON_STYLE_SIMPLECIRCLE_DESC =         "Status icon with plain round background on corner"
-- L.ICON_STYLE_SIMPLEICON =                "Simple Icon"
-- L.ICON_STYLE_SIMPLEICON_DESC =           "Status icon in corner"
-- L.ICON_STYLE_COSMETICICON =              "Cosmetic Icon"
-- L.ICON_STYLE_COSMETICICON_DESC =         "Status border in corner (no animation)"
-- L.ICON_ANIMATION =                       "Icon Animation"
-- L.ICON_ANIMATION_DESC =                  "Show a pretty animated swirl on icons for learnable and usable items."
-- L.ICON_LEARNED =                         "Learned Icon"
-- L.ICON_LEARNED_DESC =                    "Show an icon to indicate the below tracked collectibles are learned."
-- L.DEFAULT =                              CHAT_DEFAULT -- "Default"
-- L.ICON_LEARNED_DESC2 =                   "You can set a separate style for learned icons."
-- L.BINDING_TEXT =                         "Binding Text"
-- L.BINDING_TEXT_DESC =                    "Show a text indicator for Bind-on-Equip items (BoE), Warbound items (BoA), and Warbound-until-Equipped (WuE) items."

-- L.PREVIEW =                              "Preview:"
-- L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- "Unlearned"
-- L.USABLE =                               "Usable"
-- L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- "Learned"
-- L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- "Unusable"
-- L.PREVIEW_TOOLTIP = {}
-- L.PREVIEW_TOOLTIP[1] =                   "Unlearned items are completely new to your collection."
-- L.PREVIEW_TOOLTIP[2] =                   "Usable items are things like containers, new sources for known appearances, etc."
-- L.PREVIEW_TOOLTIP[3] =                   "Learned items are already in your collection."
-- L.PREVIEW_TOOLTIP[4] =                   "Unusable items are things like locked containers, recipes for a profession you don't know, etc."

-- L.COLLECTION_INFO =                      "Collection Info"
L.APPEARANCES =                          WARDROBE -- "Appearances"
-- L.APPEARANCES_ICON_DESC =                "Show an icon to indicate an item's appearance is unlearned."
L.APPEARANCES_SOURCES =                  "來源"
-- L.APPEARANCES_SOURCES_ICON_DESC =        "Show an icon to indicate an item's appearance source is unlearned."
-- L.CATALYST =                             "Catalyst"
-- L.CATALYST_ICON_DESC =                   "Show an icon when catalyzing an item grants a new appearance."
-- L.UPGRADE =                              "Upgrade"
-- L.UPGRADE_ICON_DESC =                    "Show an icon when upgrading an item grants a new appearance."
-- L.ILLUSIONS =                            "Illusions"
-- L.ILLUSIONS_ICON_DESC =                  "Show an icon to indicate an illusion is unlearned."
-- L.MOUNTS =                               MOUNTS -- "Mounts"
-- L.MOUNTS_ICON_DESC =                     "Show an icon to indicate a mount is unlearned."
-- L.PETS =                                 PETS -- "Pets"
-- L.PETS_ICON_DESC =                       "Show an icon to indicate a pet is unlearned."
-- L.PETS_COLLECT_MAX =                     "Collect 3/3"
-- L.PETS_COLLECT_MAX_ICON_DESC =           "Also take the maximum number of pets you can own into account (usually 3)."
-- L.TOYS =                                 "Toys"
-- L.TOYS_ICON_DESC =                       "Show an icon to indicate a toy is unlearned."
L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
-- L.RECIPES_ICON_DESC =                    "Show an icon to indicate a recipe is unlearned."
-- L.TRACK_PER_CHARACTER =                  "Track per Character"
-- L.TRACK_PER_CHARACTER_ICON_DESC =        "Show learned recipes as learnable for alts."
-- L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
-- L.DECOR_ICON_DESC =                      "Show an icon to indicate you don't own a housing decor."
-- L.ONLY_HOUSE_XP =                        "Only with House XP"
-- L.ONLY_HOUSE_XP_ICON_DESC =              "Only show the icon for housing decor that grants House XP."

-- L.OTHER_INFORMATION =                    "Other Information"
-- L.QUEST_REWARD_SELL_VALUE =              "Quest Reward Sell Value"
-- L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "Show an icon to indicate which quest reward has the highest vendor sell value, if there are multiple."
-- L.USABLE_ITEMS =                         "Usable Items"
-- L.USABLE_ITEMS_ICON_DESC =               "Show an icon to indicate an item can be used (profession knowledge, unlockable customisations, and spellbooks)."
-- L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
-- L.CONTAINERS_ICON_DESC =                 "Show an icon to indicate an item can be opened, such as lockboxes and holiday boss bags."

-- L.LOOT_TRACKER =                         "Loot Tracker"
L.SHOW_MINIMAP_ICON =                    "顯示小地圖圖示"
L.SHOW_MINIMAP_ICON_DESC =               "顯示小地圖圖示。即使停用，仍可從插件選單開啟 %s。" -- %s becomes the addon name
-- L.AUTO_OPEN_WINDOW =                     "Auto Open Window"
-- L.AUTO_OPEN_WINDOW_DESC =                "Automatically show the %s window when an eligible item is looted." -- %s becomes the addon name
L.COLLECTION_MODE =                      "收藏模式"
-- L.COLLECTION_MODE_DESC =                 "Set when %s should show new transmog looted by others." -- %s becomes the addon name
-- L.COLLECTION_MODE_APPEARANCES_DESC =     "Show items only if they have a new appearance."
-- L.COLLECTION_MODE_SOURCES_DESC =         "Show items if they are a new source, including for known appearances."
-- L.RARITY =                               RARITY -- "Rarity"
-- L.RARITY_SETTING_DESC =                  "Set from what quality and up %s should show loot." -- %s becomes the addon name
-- L.WHISPER_MESSAGE =                      "Whisper Message"
-- L.CUSTOMIZE =                            "Customize"
-- L.WHISPER_CUSTOMIZE_DESC1 =              "Customize the whisper message"
-- L.WHISPER_CUSTOMIZE_DESC2 =              "Customize your whisper message:"
-- L.WHISPER_POPUP_ERROR =                  "Message does not include %s" -- %s becomes "%item"
-- L.WHISPER_POPUP_SUCCESS =                "Message updated:"

-- L.TWEAKS =                               "Tweaks"
-- L.INSTANT_CATALYST =                     "Instant Catalyst"
-- L.INSTANT_CATALYST_DESC =                "Hold Shift to instantly catalyze an item, skipping the 5 second timer."
-- L.INSTANT_VAULT =                        "Instant Great Vault"
-- L.INSTANT_VAULT_DESC =                   "Hold Shift to instantly receive your reward from the Great Vault and skip the 5 second timer."
-- L.SHOW_TOOLTIP =                         "Show Tooltip"
-- L.SHOW_TOOLTIP_SETTING_DESC =            "Show the tooltip explaining how this feature works. The button text still changes when this is disabled."
-- L.DISABLE_VENDOR_FILTER =                "Disable Vendor Filter"
-- L.DISABLE_VENDOR_FILTER_DESC =           "Automatically set all vendor filters to \"All\" to display items normally not shown to your class."
-- L.HIDE_LOOT_ROLL_WINDOW =                "Hide Loot Roll Window"
-- L.HIDE_LOOT_ROLL_WINDOW_DESC =           "Hide the window that shows loot rolls and their results. You can show the window again with %s." -- %s becomes "/loot"

-- Item overlay
-- L.BINDTEXT_WUE =                         "WuE" -- Abbreviation for "Warbound until Equipped"
-- L.BINDTEXT_BOP =                         "BoP" -- Abbreviation for "Binds on Pickup"
-- L.BINDTEXT_BOE =                         "BoE" -- Abbreviation for "Binds on Equip"
-- L.BINDTEXT_BOA =                         "BoA" -- Abbreviation for "Binds to Account" (Warbound)
-- L.RECIPE_UNCACHED =                      "Please open this profession to update the recipe's collection status."
-- L.LEARN_UNBOUND =                        "Sell, destroy, or disenchant this item to learn its appearance."
-- L.BUGGED_ITEM =                          "This item is bugged and may not be learnable."

-- Loot tracker
-- L.DEFAULT_MESSAGE =                      "Do you need the %item you looted? If not, I'd like to have it for transmog. :)"

L.CLOSE_WINDOW =                         "關閉視窗"
L.LOCK_WINDOW =                          "鎖定視窗"
L.UNLOCK_WINDOW =                        "解除鎖定視窗"
-- L.CLEAR_ALL_ITEMS =                      "Clear all items"
-- L.HOLD_SHIFT_TO_SKIP =                   "Hold Shift to skip confirmation"
-- L.SORT_NEW =                             "Sort by newest first"
-- L.SORT_ALPHABETICAL =                    "Sort alphabetically"
-- L.SORTED_CURRENT =                       "Current sorting:"
-- L.SORTED_ALPHABETICAL =                  "alphabetical"
-- L.SORTED_NEW =                           "newest first"
-- L.CLEAR_CONFIRM =                        "Do you want to clear all loot?"
L.DOUBLE =                               "雙擊" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "自動調整視窗大小"
-- L.WHISPER_AND_REQUEST_ITEM =             "Whisper and request the item"
-- L.LINK_ITEM =                            "Link the item"
-- L.REMOVE_ITEM =                          "Remove the item"
-- L.DEBUG_ITEM =                           "Debug this item"

-- L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
-- L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
-- L.FILTERED =                             "Filtered"
-- L.PLAYER_COLLECTED_APPEARANCE =          "collected an appearance from this item" -- Preceded by a character name
-- L.PLAYER_WHISPERED =                     "has been whispered by %s users" -- %s becomes the addon name
-- L.WHISPERED_TIME =                       "time"
-- L.WHISPERED_TIMES =                      "times"
-- L.WHISPER_COOLDOWN =                     "You may only whisper a player once every 30 seconds per item."
-- L.FILTER_REASON_UNTRADEABLE =            "Untradeable"
-- L.FILTER_REASON_RARITY =                 "Rarity too low"
-- L.FILTER_REASON_KNOWN =                  "Known appearance"

-- Recipes
-- L.DELETED_ENTRIES =                      "Deleted entries:"
-- L.DELETED_REMOVED =                      "Unique collectibles removed:"

-- Tweaks
-- L.GET_IT_NOW =                           "Get it now!"
-- L.HOLD_SHIFT_TOOLTIP =                   "Hold Shift to instantly receive your item and skip the 5 second timer."
