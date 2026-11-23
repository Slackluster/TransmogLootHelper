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
L.CHARACTER_REALM =                      "角色－伺服器"
L.DELETE_CHAR_RECIPES =                  "將某個角色獨有的配方等項目標示為尚未學會"
L.WHISPER_SET_DEFAULT =                  "將密語訊息還原為預設內容"

L.GENERAL =                              GENERAL -- "General"
L.ITEM_OVERLAY =                         "物品覆蓋圖示"
L.ITEM_OVERLAY_DESC =                    "在物品上顯示圖示與文字，以標示收藏狀態等資訊。"
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.ICON_POSITION =                        "圖示位置"
L.ICON_POSITION_DESC =                   "圖示要顯示在哪個角落。"
L.BAGANATOR_SETTINGS =                   "Baganator 使用者可以透過 Baganator 自己的設定管理此功能。"
L.TOP_LEFT =                             "左上"
L.TOP_RIGHT =                            "右上"
L.BOTTOM_LEFT =                          "左下"
L.BOTTOM_RIGHT =                         "右下"
L.OVERLAP_ISSUES_NONE =                  "沒有已知的重疊問題。"
L.OVERLAP_ISSUES_QUALITY =               "這可能與製作物品的品質顯示重疊。"
L.ICON_STYLE =                           "圖示樣式"
L.ICON_STYLE_DESC =                      "狀態圖示的樣式。"
L.ICON_STYLE_FANCYCIRCLE =               "華麗圓形"
L.ICON_STYLE_FANCYCIRCLE_DESC =          "角落帶圓形狀態邊框的類型圖示"
L.ICON_STYLE_SIMPLECIRCLE =              "簡單圓形"
L.ICON_STYLE_SIMPLECIRCLE_DESC =         "角落帶簡單圓形背景的狀態圖示"
L.ICON_STYLE_SIMPLEICON =                "簡單圖示"
L.ICON_STYLE_SIMPLEICON_DESC =           "角落狀態圖示"
L.ICON_STYLE_COSMETICICON =              "外觀圖示"
L.ICON_STYLE_COSMETICICON_DESC =         "角落狀態邊框（無動畫）"
L.ICON_ANIMATION =                       "圖示動畫"
L.ICON_ANIMATION_DESC =                  "為可學習與可使用的物品圖示加上漂亮的旋轉動畫。"
L.ICON_LEARNED =                         "已收藏圖示"
L.ICON_LEARNED_DESC =                    "在下方追蹤的收藏品已學會時顯示圖示。"
L.DEFAULT =                              CHAT_DEFAULT -- "Default"
L.ICON_LEARNED_DESC2 =                   "可以為已學會的圖示設定不同的樣式。"
L.BINDING_TEXT =                         "按鍵綁定文字"
L.BINDING_TEXT_DESC =                    "在裝備後綁定（BoE）、戰隊綁定（BoA）及裝備前戰隊綁定（WuE）物品上顯示文字標記。"

L.PREVIEW =                              "預覽："
L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- "Unlearned"
L.USABLE =                               "可使用"
L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- "Learned"
L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- "Unusable"
L.PREVIEW_TOOLTIP = {}
L.PREVIEW_TOOLTIP[1] =                   "尚未學會的物品是你的收藏中全新的項目。"
L.PREVIEW_TOOLTIP[2] =                   "可使用的物品包括容器，以及已知外觀的新來源等。"
L.PREVIEW_TOOLTIP[3] =                   "已學會的物品已經在你的收藏中。"
L.PREVIEW_TOOLTIP[4] =                   "無法使用的物品包含上鎖容器、你未學習的專業技能配方等。"

L.COLLECTION_INFO =                      "收藏資訊"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_ICON_DESC =                "在物品的外觀尚未學會時顯示圖示。"
L.APPEARANCES_SOURCES =                  "來源"
L.APPEARANCES_SOURCES_ICON_DESC =        "在物品外觀的來源尚未收藏時顯示圖示。"
L.CATALYST =                             "催化器"
L.CATALYST_ICON_DESC =                   "催化物品可取得新外觀時顯示圖示。"
L.UPGRADE =                              "升級"
L.UPGRADE_ICON_DESC =                    "升級物品可取得新外觀時顯示圖示。"
L.ILLUSIONS =                            "幻象"
L.ILLUSIONS_ICON_DESC =                  "在尚未學會的幻象上顯示圖示。"
L.MOUNTS =                               MOUNTS -- "Mounts"
L.MOUNTS_ICON_DESC =                     "在尚未學會的坐騎上顯示圖示。"
L.PETS =                                 PETS -- "Pets"
L.PETS_ICON_DESC =                       "在尚未學會的寵物上顯示圖示。"
L.PETS_COLLECT_MAX =                     "收集 3/3"
L.PETS_COLLECT_MAX_ICON_DESC =           "也會考慮可擁有的寵物數量上限（通常為 3 隻）。"
L.TOYS =                                 "玩具"
L.TOYS_ICON_DESC =                       "在尚未學會的玩具上顯示圖示。"
L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.RECIPES_ICON_DESC =                    "在尚未學會的配方上顯示圖示。"
L.TRACK_PER_CHARACTER =                  "依角色追蹤"
L.TRACK_PER_CHARACTER_ICON_DESC =        "對分身角色將已學會的配方顯示為可學習。"
L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
L.DECOR_ICON_DESC =                      "在你尚未擁有的家居裝飾上顯示圖示。"
L.ONLY_HOUSE_XP =                        "僅限提供房屋經驗值"
L.ONLY_HOUSE_XP_ICON_DESC =              "僅顯示可獲得房屋經驗值的家居裝飾圖示。"

L.OTHER_INFORMATION =                    "其他資訊"
L.QUEST_REWARD_SELL_VALUE =              "任務獎勵出售價值"
L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "如果任務有多種獎勵，標示商人出售價值最高的獎勵。"
L.USABLE_ITEMS =                         "可使用的物品"
L.USABLE_ITEMS_ICON_DESC =               "在可使用的物品上顯示圖示，例如專業技能知識、可解鎖的自訂外觀以及法術書。"
L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
L.CONTAINERS_ICON_DESC =                 "在可開啟的物品上顯示圖示，例如上鎖的箱子和節慶首領的袋子。"

L.LOOT_TRACKER =                         "戰利品追蹤器"
L.SHOW_MINIMAP_ICON =                    "顯示小地圖圖示"
L.SHOW_MINIMAP_ICON_DESC =               "顯示小地圖圖示。即使停用，仍可從插件選單開啟 %s。" -- %s becomes the addon name
L.AUTO_OPEN_WINDOW =                     "自動開啟視窗"
L.AUTO_OPEN_WINDOW_DESC =                "拾取符合條件的物品時，自動顯示 %s 視窗。" -- %s becomes the addon name
L.COLLECTION_MODE =                      "收藏模式"
L.COLLECTION_MODE_DESC =                 "設定 %s 應在何時顯示其他玩家拾取的新塑形物品。" -- %s becomes the addon name
L.COLLECTION_MODE_APPEARANCES_DESC =     "只顯示具有新外觀的物品。"
L.COLLECTION_MODE_SOURCES_DESC =         "顯示具有新來源的物品，即使該外觀已經學會。"
L.RARITY =                               RARITY -- "Rarity"
L.RARITY_SETTING_DESC =                  "設定 %s 要顯示的戰利品最低品質。" -- %s becomes the addon name
L.WHISPER_MESSAGE =                      "密語訊息"
L.CUSTOMIZE =                            "自訂"
L.WHISPER_CUSTOMIZE_DESC1 =              "自訂密語訊息"
L.WHISPER_CUSTOMIZE_DESC2 =              "自訂你的密語訊息："
L.WHISPER_POPUP_ERROR =                  "訊息未包含 %s" -- %s becomes "%item"
L.WHISPER_POPUP_SUCCESS =                "訊息已更新："

L.TWEAKS =                               "調整功能"
L.INSTANT_CATALYST =                     "即時催化器"
L.INSTANT_CATALYST_DESC =                "按住 Shift 可立即催化物品，跳過 5 秒倒數。"
L.INSTANT_VAULT =                        "立即領取寶庫"
L.INSTANT_VAULT_DESC =                   "按住 Shift 可立即領取寶庫獎勵，跳過 5 秒倒數。"
L.SHOW_TOOLTIP =                         "顯示滑鼠提示"
L.SHOW_TOOLTIP_SETTING_DESC =            "顯示介紹此功能的滑鼠提示。即使停用，按鈕文字仍會變更。"
L.DISABLE_VENDOR_FILTER =                "停用商販篩選"
L.DISABLE_VENDOR_FILTER_DESC =           "自動將所有商販篩選條件設為「全部」，以顯示平常不會對你的職業顯示的物品。"
L.HIDE_LOOT_ROLL_WINDOW =                "隱藏戰利品擲骰視窗"
L.HIDE_LOOT_ROLL_WINDOW_DESC =           "隱藏顯示戰利品擲骰及結果的視窗。你可以使用 %s 再次顯示。" -- %s becomes "/loot"

-- Item overlay
L.BINDTEXT_WUE =                         "裝備前戰隊綁定" -- Abbreviation for "Warbound until Equipped"
L.BINDTEXT_BOP =                         "拾取後綁定" -- Abbreviation for "Binds on Pickup"
L.BINDTEXT_BOE =                         "裝備後綁定" -- Abbreviation for "Binds on Equip"
L.BINDTEXT_BOA =                         "帳號綁定" -- Abbreviation for "Binds to Account" (Warbound)
L.RECIPE_UNCACHED =                      "請開啟這個專業技能，以更新配方的收藏狀態。"
L.LEARN_UNBOUND =                        "出售、摧毀或分解此物品，以學會它的外觀。"
L.BUGGED_ITEM =                          "此物品可能有錯誤，導致無法學會外觀。"

-- Loot tracker
L.DEFAULT_MESSAGE =                      "你拾取的 %item 還需要嗎？如果不需要的話，我想拿來收集塑形外觀。:)"

L.CLOSE_WINDOW =                         "關閉視窗"
L.LOCK_WINDOW =                          "鎖定視窗"
L.UNLOCK_WINDOW =                        "解除鎖定視窗"
L.CLEAR_ALL_ITEMS =                      "清除所有物品"
L.HOLD_SHIFT_TO_SKIP =                   "按住 Shift 略過確認"
L.SORT_NEW =                             "最新的優先"
L.SORT_ALPHABETICAL =                    "按字母排序"
L.SORTED_CURRENT =                       "目前排序："
L.SORTED_ALPHABETICAL =                  "按字母順序"
L.SORTED_NEW =                           "最新的優先"
L.CLEAR_CONFIRM =                        "你想清除所有拾取紀錄嗎？"
L.DOUBLE =                               "雙擊" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "自動調整視窗大小"
L.WHISPER_AND_REQUEST_ITEM =             "傳送密語索取物品"
L.LINK_ITEM =                            "連結物品"
L.REMOVE_ITEM =                          "移除該物品"
L.DEBUG_ITEM =                           "對此物品進行除錯"

L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
L.FILTERED =                             "已篩選"
L.PLAYER_COLLECTED_APPEARANCE =          "已收藏此物品的外觀" -- Preceded by a character name
L.PLAYER_WHISPERED =                     "曾收到 %s 使用者的密語" -- %s becomes the addon name
L.WHISPERED_TIME =                       "時間"
L.WHISPERED_TIMES =                      "次"
L.WHISPER_COOLDOWN =                     "對每個物品，你每 30 秒只能密語同一位玩家一次。"
L.FILTER_REASON_UNTRADEABLE =            "無法交易"
L.FILTER_REASON_RARITY =                 "稀有度太低"
L.FILTER_REASON_KNOWN =                  "已知外觀"

-- Recipes
L.DELETED_ENTRIES =                      "已刪除項目："
L.DELETED_REMOVED =                      "已移除的獨特收藏品："

-- Tweaks
L.GET_IT_NOW =                           "立即取得！"
L.HOLD_SHIFT_TOOLTIP =                   "按住 Shift 可立即領取物品，跳過 5 秒倒數。"
