--------------------------------------
-- Equip Recommended Gear: zhCN.lua --
--------------------------------------
-- Chinese (Simplified, PRC) localisation
-- Translator(s):

-- Initialisation
if GetLocale() ~= "zhCN" then return end
local appName, app = ...
local L = app.locales

-- Slash commands
L.INVALID_COMMAND =						"无效命令。"
L.DELETED_ENTRIES =						"已删除条目："
L.DELETED_REMOVED =						"已移除的独特可收集物品："

-- Version comms
L.NEW_VERSION_AVAILABLE =				"现在 " .. app.NameLong .. " 有新版本可用："

-- Item overlay
L.BINDTEXT_WUE =						"WuE"
L.BINDTEXT_BOP =						"BoP"
L.BINDTEXT_BOE =						"BoE"
L.BINDTEXT_BOA =						"BoA"
L.RECIPE_UNCACHED =						"请打开此专业以更新配方的收集状态。"

-- Loot tracker
L.DEFAULT_MESSAGE = 					"需要追踪拾取列表里的%item吗？如果不需要，但仍希望能获取它用于幻化。:)"
L.CLEAR_CONFIRM =						"确定要清除所有战利品记录吗？"

L.WINDOW_BUTTON_CLOSE =					"关闭窗口"
L.WINDOW_BUTTON_LOCK =					"锁定窗口"
L.WINDOW_BUTTON_UNLOCK =				"解锁窗口"
L.WINDOW_BUTTON_SETTINGS =				"打开设置"
L.WINDOW_BUTTON_CLEAR =					"清除所有物品\n按住Shift跳过确认"
L.WINDOW_BUTTON_SORT1 =					"按最新优先排序\n当前排序：|cffFFFFFF字母顺序|r"
L.WINDOW_BUTTON_SORT2 =					"按字母顺序排序\n当前排序：|cffFFFFFF最新优先|r"
L.WINDOW_BUTTON_CORNER =				"双击 " .. app.IconLMB .. "|cffFFFFFF：自动调整窗口大小|r"

L.WINDOW_HEADER_LOOT_DESC =             "|rAlt " .. app.IconLMB .. "|cffFFFFFF：密语并请求获取此物品\n" ..
                                        "|rShift " .. app.IconLMB .. "|cffFFFFFF：链接此物品\n" ..
                                        "|rShift " .. app.IconRMB .. "|cffFFFFFF：移除此物品"
L.WINDOW_HEADER_FILTERED =              "已过滤"
L.WINDOW_HEADER_FILTERED_DESC =         "|r" .. app.IconRMB .. "|cffFFFFFF：调试此物品\n" ..
                                        "|rShift " .. app.IconLMB .. "|cffFFFFFF：链接此物品\n" ..
                                        "|rShift " .. app.IconRMB .. "|cffFFFFFF：移除此物品"

L.PLAYER_COLLECTED_APPEARANCE =			"已从该物品收集了外观"	-- Preceded by a character name
L.PLAYER_WHISPERED =					"已被 " .. app.NameShort .. " 用户密语"
L.WHISPERED_TIME =						"次"
L.WHISPERED_TIMES =						"次"
L.WHISPER_COOLDOWN =					"每件物品对同一玩家只能每30秒密语一次。"

L.FILTER_REASON_UNTRADEABLE =			"不可交易"
L.FILTER_REASON_RARITY =				"品质过低"
L.FILTER_REASON_KNOWN =					"已知外观"

-- Tweaks
L.INSTANT_BUTTON =						"立即获取！"
L.INSTANT_TOOLTIP =						"按住Shift立即获取物品，跳过5秒等待时间。"

-- Settings
L.SETTINGS_TOOLTIP =					app.NameLong .. "\n|cffFFFFFF" .. 
                                        app.IconLMB .. "：切换窗口\n" .. 
                                        app.IconRMB .. ": " .. L.WINDOW_BUTTON_SETTINGS

L.SETTINGS_VERSION =					GAME_VERSION_LABEL .. "："	-- "Version"
L.SETTINGS_SUPPORT_TEXTLONG =			"开发此插件需要大量时间和精力。\n请考虑在经济上支持开发者。"
L.SETTINGS_SUPPORT_TEXT =				"支持"
L.SETTINGS_SUPPORT_BUTTON =				"Buy Me a Coffee"	-- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =				"感谢您！"
L.SETTINGS_HELP_TEXT =					"反馈与帮助"
L.SETTINGS_HELP_BUTTON =				"Discord"	-- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =					"加入Discord社区。"
L.SETTINGS_URL_COPY =					"Ctrl+C 复制："
L.SETTINGS_URL_COPIED =					"链接已复制到剪贴板"

L.SETTINGS_KEYSLASH_TITLE =				SETTINGS_KEYBINDINGS_LABEL .. " & 斜杠命令"	-- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =	app.NameShort .. "：切换窗口"
L.SETTINGS_SLASH_TOGGLE =				"切换追踪窗口"
L.SETTINGS_SLASH_RESETPOS =				"重置追踪窗口位置"
L.SETTINGS_SLASH_WHISPER_DEFAULT =		"将密语消息重置为默认"
L.SETTINGS_SLASH_DELETE_DESC =			"标记角色的独特配方等为未学习"
L.SETTINGS_SLASH_CHARREALM =			"角色-服务器"

L.REQUIRES_RELOAD =                      "|cffFF0000" .. REQUIRES_RELOAD .. ".|r 使用 |cffFFFFFF/reload|r 或重新登录。" -- "Requires Reload"

L.GENERAL =								GENERAL	-- "General"
L.SETTINGS_ITEM_OVERLAY	=				"物品覆盖层"
L.SETTINGS_BAGANATOR =					"Baganator用户请在Baganator设置中管理此选项。"
L.SETTINGS_ITEM_OVERLAY_DESC =			"在物品上显示图标和文本，以指示收集状态等。\n\n" .. L.REQUIRES_RELOAD
L.SETTINGS_ICON_POSITION =				"图标位置"
L.SETTINGS_ICON_POSITION_DESC =			"图标显示在哪个角落。"
L.SETTINGS_ICONPOS_TL =					"左上"
L.SETTINGS_ICONPOS_TR =					"右上"
L.SETTINGS_ICONPOS_BL =					"左下"
L.SETTINGS_ICONPOS_BR =					"右下"
L.SETTINGS_ICONPOS_OVERLAP0 =			"已知无重叠问题。"
L.SETTINGS_ICONPOS_OVERLAP1 =			"可能会与制作物品的品质标识重叠。"
L.SETTINGS_ICON_STYLE =					"图标样式"
L.SETTINGS_ICON_STYLE_DESC =			"状态图标的样式。"
L.SETTINGS_ICON_STYLE1 =				"精美圆形"
L.SETTINGS_ICON_STYLE1_DESC =			"类型图标带圆形状态边框显示在角落"
L.SETTINGS_ICON_STYLE2 =				"简约圆形"
L.SETTINGS_ICON_STYLE2_DESC =			"状态图标带简单圆形背景显示在角落"
L.SETTINGS_ICON_STYLE3 =				"简约图标"
L.SETTINGS_ICON_STYLE3_DESC =			"状态图标显示在角落"
L.SETTINGS_ICON_STYLE4 =				"装饰图标"
L.SETTINGS_ICON_STYLE4_DESC =			"状态边框显示在角落（无动画）"
L.SETTINGS_ICON_ANIMATE =				"图标动画"
L.SETTINGS_ICON_ANIMATE_DESC =			"为可学习和可用物品的状态图标显示精美的动画漩涡。"
L.SETTINGS_ICONLEARNED =				"已学习图标"
L.SETTINGS_ICONLEARNED_DESC =			"显示图标以指示以下追踪的可收集物品已学习。"
L.DEFAULT =								CHAT_DEFAULT	-- Default
L.SETTINGS_ICONLEARNED_DESC2 =			"您可以为已学习的图标设置单独的样式。"
L.SETTINGS_BINDTEXT =					"绑定文本"
L.SETTINGS_BINDTEXT_DESC =				"为装备后绑定(BoE)、战团绑定(BoA)和装备前绑定(WuE)物品显示文本标识。\n\n" .. L.SETTINGS_BAGANATOR
L.SETTINGS_PREVIEW =					"预览："
L.SETTINGS_UNLEARNED =					PROFESSIONS_CATEGORY_UNLEARNED	-- Unlearned
L.SETTINGS_USABLE =						"可用"
L.SETTINGS_LEARNED =					PROFESSIONS_CATEGORY_LEARNED	-- Learned
L.SETTINGS_UNUSABLE =					MOUNT_JOURNAL_FILTER_UNUSABLE	-- Unusable
L.SETTINGS_PREVIEWTOOLTIP = {}
L.SETTINGS_PREVIEWTOOLTIP[1] =			"未学习物品对您的收藏来说是全新的。"
L.SETTINGS_PREVIEWTOOLTIP[2] =			"可用物品包括容器、已知外观的新来源等。"
L.SETTINGS_PREVIEWTOOLTIP[3] =			"已学习物品已在您的收藏中。"
L.SETTINGS_PREVIEWTOOLTIP[4] =			"不可用物品包括锁定的容器、您未学习专业的配方等。"

L.SETTINGS_HEADER_COLLECTION =			"收藏信息"
L.SETTINGS_ICON_NEW_MOG =				"外观"
L.SETTINGS_ICON_NEW_MOG_DESC =			"显示图标以指示物品的外观未学习。"
L.SETTINGS_ICON_NEW_SOURCE =			"来源"
L.SETTINGS_ICON_NEW_SOURCE_DESC =		"显示图标以指示物品的外观来源未学习。"
L.SETTINGS_ICON_NEW_CATALYST =			"化生台转换"
L.SETTINGS_ICON_NEW_CATALYST_DESC =		"当使用化生台转换物品可获得新外观时显示图标。"
L.SETTINGS_ICON_NEW_UPGRADE =			"升级获取"
L.SETTINGS_ICON_NEW_UPGRADE_DESC =		"当升级物品可获取新外观时显示图标。"
L.SETTINGS_ICON_NEW_ILLUSION =			"幻象"
L.SETTINGS_ICON_NEW_ILLUSION_DESC =		"显示图标以指示幻象未学习。"
L.SETTINGS_ICON_NEW_MOUNT =				"坐骑"
L.SETTINGS_ICON_NEW_MOUNT_DESC =		"显示图标以指示坐骑未收集。"
L.SETTINGS_ICON_NEW_PET =				"宠物"
L.SETTINGS_ICON_NEW_PET_DESC =			"显示图标以指示宠物未收集。"
L.SETTINGS_ICON_NEW_PET_MAX =			"收集 3/3"
L.SETTINGS_ICON_NEW_PET_MAX_DESC =		"同时考虑您可拥有的宠物最大数量（通常为3）。"
L.SETTINGS_ICON_NEW_TOY =				"玩具"
L.SETTINGS_ICON_NEW_TOY_DESC =			"显示图标以指示玩具未收集。"
L.SETTINGS_ICON_NEW_RECIPE =			"配方"
L.SETTINGS_ICON_NEW_RECIPE_DESC =		"显示图标以指示配方未学习。"
L.SETTINGS_ICON_NEW_DECOR =				"住宅装饰"
L.SETTINGS_ICON_NEW_DECOR_DESC =		"显示图标以指示您未拥有此住宅装饰。"
L.SETTINGS_ICON_NEW_DECORXP =			"仅首次收集奖励"
L.SETTINGS_ICON_NEW_DECORXP_DESC =		"仅对能获得住宅经验值的装饰显示图标。"

L.SETTINGS_HEADER_OTHER_INFO =			"其他信息"
L.SETTINGS_ICON_QUEST_GOLD =			"任务奖励售价"
L.SETTINGS_ICON_QUEST_GOLD_DESC =		"当有多个任务奖励时，显示图标以指示哪个奖励的商人售价最高。"
L.SETTINGS_ICON_USABLE =				"可用物品"
L.SETTINGS_ICON_USABLE_DESC =			"显示图标以指示物品可使用（专业知识、可解锁的自定义选项和法术书）。"
L.SETTINGS_ICON_OPENABLE =				"可开启物品"
L.SETTINGS_ICON_OPENABLE_DESC =			"显示图标以指示物品可开启，如锁箱和节日首领宝箱。"

L.SETTINGS_HEADER_LOOT_TRACKER =		"战利品追踪器"
L.SETTINGS_MINIMAP_TITLE =				"显示小地图图标"
L.SETTINGS_MINIMAP_DESC =				"显示小地图图标。如果您禁用此选项，仍可通过插件目录访问 " .. app.NameShort .. " 。"
L.SETTINGS_AUTO_OPEN =					"自动打开窗口"
L.SETTINGS_AUTO_OPEN_DESC =				"当拾取符合条件的物品时，自动显示 " .. app.NameShort .. " 窗口。"
L.SETTINGS_COLLECTION_MODE =			"收集模式"
L.SETTINGS_COLLECTION_MODE_DESC =		"设置 " .. app.NameShort .. " 何时显示他人拾取的新幻化物品。"
L.SETTINGS_MODE_APPEARANCES =			"外观"
L.SETTINGS_MODE_APPEARANCES_DESC =		"仅当物品有新外观时显示。"
L.SETTINGS_MODE_SOURCES =				"来源"
L.SETTINGS_MODE_SOURCES_DESC =			"当物品是新来源时显示，包括已知外观的新来源。"
L.SETTINGS_RARITY =						"品质"
L.SETTINGS_RARITY_DESC =				"设置 " .. app.NameShort .. " 应显示什么品质及以上的战利品。"
L.SETTINGS_WHISPER =					"密语消息"
L.SETTINGS_WHISPER_CUSTOMIZE =			"自定义"
L.SETTINGS_WHISPER_CUSTOMIZE_DESC =		"自定义密语消息"
L.WHISPER_POPUP_CUSTOMIZE = 			"自定义您的密语消息："
L.WHISPER_POPUP_ERROR = 				"消息未包含 |cff3FC7EB%item|r。消息未更新。"
L.WHISPER_POPUP_SUCCESS =				"消息已更新。"

L.SETTINGS_HEADER_TWEAKS =				"调整功能"
L.SETTINGS_CATALYST =					"即时化生台"
L.SETTINGS_CATALYST_DESC =				"按住Shift立即使用化生台转换物品，跳过5秒等待时间。"
L.SETTINGS_VAULT =						"即时宏伟宝库"
L.SETTINGS_VAULT_DESC =					"按住Shift立即从宏伟宝库领取奖励，跳过5秒等待时间。"
L.SETTINGS_INSTANT_TOOLTIP =			"显示提示"
L.SETTINGS_INSTANT_TOOLTIP_DESC =		"显示解释此功能如何工作的提示。禁用此选项时，按钮文本仍会变化。"
L.SETTINGS_VENDOR_ALL =					"禁用商人过滤"
L.SETTINGS_VENDOR_ALL_DESC =			"自动将所有商人过滤器设置为|cffFFFFFF全部|r，以显示通常不对您职业显示的物品。"
L.SETTINGS_HIDE_LOOT_ROLL_WINDOW =		"隐藏掷骰窗口"
L.SETTINGS_HIDE_LOOT_ROLL_WINDOW_DESC =	"隐藏显示掷骰及其结果的窗口。您可以使用|cff00ccff/loot|r再次显示窗口。"
