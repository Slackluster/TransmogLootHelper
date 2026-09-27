------------------------------------
-- Transmog Loot Helper: zhCN.lua --
------------------------------------
-- Chinese (Simplified, PRC) localisation
-- Translator(s): XingDVD

if GetLocale() ~= "zhCN" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "现在 %s 有新版本可用：" -- %s becomes the addon name

L.INVALID_COMMAND =                      "无效命令。"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. "：" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "开发这个插件需要大量的时间和精力。"
L.SUPPORT_TEXTLONG2 =                    "请考虑在经济上支持开发者。"
L.SUPPORT =                              "支持"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "感谢您！"
L.FEEDBACK_AND_HELP =                    "反馈与帮助"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "加入Discord社区。"
L.CTRL_C_COPY =                          "Ctrl+C 复制："
L.LINK_COPIED =                          "链接已复制到剪贴板"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & 斜杠命令" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. "：切换窗口"
L.TOGGLE_TRACKING_WINDOW =               "切换追踪窗口"
L.RESET_WINDOW_POSITION =                "重置追踪窗口位置"
L.OPEN_SETTINGS =                        "打开设置"
L.CHARACTER_REALM =                      "角色-服务器"
L.DELETE_CHAR_RECIPES =                  "标记角色的独特配方等为未学习"
L.WHISPER_SET_DEFAULT =                  "将密语消息重置为默认"

L.GENERAL =                              GENERAL -- "General"
L.ITEM_OVERLAY =                         "物品覆盖层"
L.ITEM_OVERLAY_DESC =                    "在物品上显示图标和文本，以指示收集状态等。"
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.ICON_POSITION =                        "图标位置"
L.ICON_POSITION_DESC =                   "图标显示在哪个角落。"
L.BAGANATOR_SETTINGS =                   "Baganator用户请在Baganator设置中管理此选项。"
L.TOP_LEFT =                             "左上"
L.TOP_RIGHT =                            "右上"
L.BOTTOM_LEFT =                          "左下"
L.BOTTOM_RIGHT =                         "右下"
L.OVERLAP_ISSUES_NONE =                  "已知无重叠问题。"
L.OVERLAP_ISSUES_QUALITY =               "可能会与制作物品的品质标识重叠。"
L.ICON_STYLE =                           "图标样式"
L.ICON_STYLE_DESC =                      "状态图标的样式。"
L.ICON_STYLE_FANCYCIRCLE =               "精美圆形"
L.ICON_STYLE_FANCYCIRCLE_DESC =          "类型图标带圆形状态边框显示在角落"
L.ICON_STYLE_SIMPLECIRCLE =              "简约圆形"
L.ICON_STYLE_SIMPLECIRCLE_DESC =         "状态图标带简单圆形背景显示在角落"
L.ICON_STYLE_SIMPLEICON =                "简约图标"
L.ICON_STYLE_SIMPLEICON_DESC =           "状态图标显示在角落"
L.ICON_STYLE_COSMETICICON =              "装饰图标"
L.ICON_STYLE_COSMETICICON_DESC =         "状态边框显示在角落（无动画）"
L.ICON_ANIMATION =                       "图标动画"
L.ICON_ANIMATION_DESC =                  "为可学习和可用物品的状态图标显示精美的动画漩涡。"
L.ICON_LEARNED =                         "已学习图标"
L.ICON_LEARNED_DESC =                    "显示图标以指示以下追踪的可收集物品已学习。"
L.DEFAULT =                              CHAT_DEFAULT -- Default
L.ICON_LEARNED_DESC2 =                   "您可以为已学习的图标设置单独的样式。"
L.BINDING_TEXT =                         "绑定文本"
L.BINDING_TEXT_DESC =                    "为装备后绑定(BoE)、战团绑定(BoA)和装备前绑定(WuE)物品显示文本标识。"

L.PREVIEW =                              "预览："
L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- Unlearned
L.USABLE =                               "可用"
L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- Learned
L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- Unusable
L.PREVIEW_TOOLTIP = {}
L.PREVIEW_TOOLTIP[1] =                   "未学习物品对您的收藏来说是全新的。"
L.PREVIEW_TOOLTIP[2] =                   "可用物品包括容器、已知外观的新来源等。"
L.PREVIEW_TOOLTIP[3] =                   "已学习物品已在您的收藏中。"
L.PREVIEW_TOOLTIP[4] =                   "不可用物品包括锁定的容器、您未学习专业的配方等。"

L.COLLECTION_INFO =                      "收藏信息"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_ICON_DESC =                "显示图标以指示物品的外观未学习。"
L.APPEARANCE_SOURCES =                   "来源"
L.APPEARANCE_SOURCES_ICON_DESC =         "显示图标以指示物品的外观来源未学习。"
-- L.CATALYST =                             "Catalyst"
L.CATALYST_ICON_DESC =                   "当使用化生台转换物品可获得新外观时显示图标。"
-- L.UPGRADE =                              "Upgrade"
L.UPGRADE_ICON_DESC =                    "当升级物品可获取新外观时显示图标。"
L.ILLUSIONS =                            "幻象"
L.ILLUSIONS_ICON_DESC =                  "显示图标以指示幻象未学习。"
-- L.MOUNTS =                               MOUNTS -- "Mounts"
L.MOUNTS_ICON_DESC =                     "显示图标以指示坐骑未收集。"
-- L.PETS =                                 PETS -- "Pets"
L.PETS_ICON_DESC =                       "显示图标以指示宠物未收集。"
L.PETS_COLLECT_MAX =                     "收集 3/3"
L.PETS_COLLECT_MAX_ICON_DESC =           "同时考虑您可拥有的宠物最大数量（通常为3）。"
L.TOYS =                                 "玩具"
L.TOYS_ICON_DESC =                       "显示图标以指示玩具未收集。"
-- L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.RECIPES_ICON_DESC =                    "显示图标以指示配方未学习。"
L.TRACK_PER_CHARACTER =                  "按角色追踪"
L.TRACK_PER_CHARACTER_ICON_DESC =        "将已学会的配方在小号上显示为可学习。"
-- L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
L.DECOR_ICON_DESC =                      "显示图标以指示您未拥有此住宅装饰。"
L.ONLY_HOUSE_XP =                        "仅首次收集奖励"
L.ONLY_HOUSE_XP_ICON_DESC =              "仅对能获得住宅经验值的装饰显示图标。"

L.OTHER_INFORMATION =                    "其他信息"
L.QUEST_REWARD_SELL_VALUE =              "任务奖励售价"
L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "当有多个任务奖励时，显示图标以指示哪个奖励的商人售价最高。"
L.USABLE_ITEMS =                         "可用物品"
L.USABLE_ITEMS_ICON_DESC =               "显示图标以指示物品可使用（专业知识、可解锁的自定义选项和法术书）。"
-- L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
L.CONTAINERS_ICON_DESC =                 "显示图标以指示物品可开启，如锁箱和节日首领宝箱。"

L.LOOT_TRACKER =                         "战利品追踪器"
L.SHOW_MINIMAP_ICON =                    "显示小地图图标"
L.SHOW_MINIMAP_ICON_DESC =               "显示小地图图标。如果您禁用此选项，仍可通过插件目录访问 %s。" -- %s becomes the addon name
L.AUTO_OPEN_WINDOW =                     "自动打开窗口"
L.AUTO_OPEN_WINDOW_DESC =                "当拾取符合条件的物品时，自动显示 %s 窗口。" -- %s becomes the addon name
L.COLLECTION_MODE =                      "收集模式"
L.COLLECTION_MODE_DESC =                 "设置 %s 何时显示他人拾取的新幻化物品。" -- %s becomes the addon name
L.COLLECTION_MODE_APPEARANCES_DESC =     "仅当物品有新外观时显示。"
L.COLLECTION_MODE_SOURCES_DESC =         "当物品是新来源时显示，包括已知外观的新来源。"
-- L.RARITY =                               RARITY -- "Rarity"
L.RARITY_SETTING_DESC =                  "设置 %s 应显示什么品质及以上的战利品。" -- %s becomes the addon name
L.WHISPER_MESSAGE =                      "密语消息"
L.CUSTOMIZE =                            "自定义"
L.WHISPER_CUSTOMIZE_DESC1 =              "自定义密语消息"
L.WHISPER_CUSTOMIZE_DESC2 =              "自定义您的密语消息："
L.WHISPER_POPUP_ERROR =                  "消息未包含 %s" -- %s becomes "%item"
L.WHISPER_POPUP_SUCCESS =                "消息已更新："

L.TWEAKS =                               "调整功能"
L.INSTANT_CATALYST =                     "即时化生台"
L.INSTANT_CATALYST_DESC =                "按住Shift立即使用化生台转换物品，跳过5秒等待时间。"
L.INSTANT_VAULT =                        "即时宏伟宝库"
L.INSTANT_VAULT_DESC =                   "按住Shift立即从宏伟宝库领取奖励，跳过5秒等待时间。"
L.SHOW_TOOLTIP =                         "显示提示"
L.SHOW_TOOLTIP_SETTING_DESC =            "显示解释此功能如何工作的提示。禁用此选项时，按钮文本仍会变化。"
L.DISABLE_VENDOR_FILTER =                "禁用商人过滤"
L.DISABLE_VENDOR_FILTER_DESC =           "自动将所有商人过滤器设置为|cffFFFFFF全部|r，以显示通常不对您职业显示的物品。"
L.HIDE_LOOT_ROLL_WINDOW =                "隐藏掷骰窗口"
L.HIDE_LOOT_ROLL_WINDOW_DESC =           "隐藏显示掷骰及其结果的窗口。您可以使用%s再次显示窗口。" -- %s becomes "/loot"

-- Item overlay
L.BINDTEXT_WUE =                         "WuE"
L.BINDTEXT_BOP =                         "BoP"
L.BINDTEXT_BOE =                         "BoE"
L.BINDTEXT_BOA =                         "BoA"
L.RECIPE_UNCACHED =                      "请打开此专业以更新配方的收集状态。"

-- Loot tracker
L.DEFAULT_MESSAGE =                      "需要追踪拾取列表里的%item吗？如果不需要，但仍希望能获取它用于幻化。:)"

L.CLOSE_WINDOW =                         "关闭窗口"
L.LOCK_WINDOW =                          "锁定窗口"
L.UNLOCK_WINDOW =                        "解锁窗口"
L.CLEAR_ALL_ITEMS =                      "清除所有物品"
L.HOLD_SHIFT_TO_SKIP =                   "按住Shift跳过确认"
L.SORT_NEW =                             "按最新优先排序"
L.SORT_ALPHABETICAL =                    "按字母顺序排序"
L.SORTED_CURRENT =                       "当前排序："
L.SORTED_ALPHABETICAL =                  "字母顺序"
L.SORTED_NEW =                           "最新优先"
L.CLEAR_CONFIRM =                        "确定要清除所有战利品记录吗？"
L.DOUBLE =                               "双击" -- Followed by RMB or LMB
-- L.CTRL =                                 "Ctrl" -- Followed by RMB or LMB
L.ALT =                                  "Alt" -- Followed by RMB or LMB
L.SHIFT =                                "Shift" -- Followed by RMB or LMB
L.AUTOSIZE_WINDOW =                      "自动调整窗口大小"
L.WHISPER_AND_REQUEST_ITEM =             "密语并请求获取此物品"
L.LINK_ITEM =                            "链接此物品"
L.REMOVE_ITEM =                          "移除此物品"
L.DEBUG_ITEM =                           "调试此物品"

-- L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
-- L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
L.FILTERED =                             "已过滤"
L.PLAYER_COLLECTED_APPEARANCE =          "已从该物品收集了外观" -- Preceded by a character name
L.PLAYER_WHISPERED =                     "已被 %s 用户密语" -- %s becomes the addon name
L.WHISPERED_TIME =                       "次"
L.WHISPERED_TIMES =                      "次"
L.WHISPER_COOLDOWN =                     "每件物品对同一玩家只能每30秒密语一次。"
L.FILTER_REASON_UNTRADEABLE =            "不可交易"
L.FILTER_REASON_RARITY =                 "品质过低"
L.FILTER_REASON_KNOWN =                  "已知外观"

-- Recipes
L.DELETED_ENTRIES =                      "已删除条目："
L.DELETED_REMOVED =                      "已移除的独特可收集物品："

-- Tweaks
L.GET_IT_NOW =                           "立即获取！"
L.HOLD_SHIFT_TOOLTIP =                   "按住Shift立即获取物品，跳过5秒等待时间。"
