--------------------------------------
-- Equip Recommended Gear: ruRU.lua --
--------------------------------------
-- Russian (Russia) localisation
-- Translator(s): ZamestoTV

-- Initialisation
if GetLocale() ~= "ruRU" then return end
local appName, app = ...
local L = app.locales

-- Slash commands
L.INVALID_COMMAND =						"Неверная команда."
-- L.DELETED_ENTRIES =						"Deleted entries:"
-- L.DELETED_REMOVED =						"Unique collectibles removed:"

-- Version comms
L.NEW_VERSION_AVAILABLE =				"Доступна новая версия " .. app.NameLong .. ":"

-- Item overlay
L.BINDTEXT_WUE =						"WuE"
L.BINDTEXT_BOP =						"BoP"
L.BINDTEXT_BOE =						"BoE"
L.BINDTEXT_BOA =						"BoA"
L.RECIPE_UNCACHED =						"Пожалуйста, откройте эту профессию, чтобы обновить статус коллекции рецепта."

-- Loot tracker
L.DEFAULT_MESSAGE = 					"Нужен ли вам предмет %item, который вы добыли? Если нет, я хотел бы взять его для трансмога. :)"
L.CLEAR_CONFIRM =						"Хотите очистить весь лут?"

L.WINDOW_BUTTON_CLOSE =					"Закрыть окно"
L.WINDOW_BUTTON_LOCK =					"Заблокировать окно"
L.WINDOW_BUTTON_UNLOCK =				"Разблокировать окно"
L.WINDOW_BUTTON_SETTINGS =				"Открыть настройки"
L.WINDOW_BUTTON_CLEAR =					"Очистить все предметы\nУдерживайте Shift, чтобы пропустить подтверждение"
L.WINDOW_BUTTON_SORT1 =					"Сортировать по новизне\nТекущая сортировка:|cffFFFFFF по алфавиту|R"
L.WINDOW_BUTTON_SORT2 =					"Сортировать по алфавиту\nТекущая сортировка:|cffFFFFFF по новизне|R"
L.WINDOW_BUTTON_CORNER =				"Двойное " .. app.IconLMB .. "|cffFFFFFF: Автоматический размер окна"

L.WINDOW_HEADER_LOOT_DESC =				"|R" .. app.IconLMB .. "|cffFFFFFF: Шепот и запрос предмета\n|RShift " .. app.IconLMB .. "|cffFFFFFF: Ссылка на предмет\n|RShift " .. app.IconRMB .. "|cffFFFFFF: Удалить предмет"
L.WINDOW_HEADER_FILTERED =				"Отфильтровано"
L.WINDOW_HEADER_FILTERED_DESC =			"|R" .. app.IconRMB .. "|cffFFFFFF: Отладка этого предмета\n|RShift " .. app.IconLMB .. "|cffFFFFFF: Ссылка на предмет\n|RShift " .. app.IconRMB .. "|cffFFFFFF: Удалить предмет"

L.PLAYER_COLLECTED_APPEARANCE =			"собрал внешний вид этого предмета"	-- Preceded by a character name
L.PLAYER_WHISPERED =					"получил сообщение от игрока " .. app.NameShort
L.WHISPERED_TIME =						"раз"
L.WHISPERED_TIMES =						"раза"
L.WHISPER_COOLDOWN =					"Вы можете шептать игроку только раз в 30 секунд для каждого предмета."

L.FILTER_REASON_UNTRADEABLE =			"Нельзя передать"
L.FILTER_REASON_RARITY =				"Слишком низкая редкость"
L.FILTER_REASON_KNOWN =					"Известный внешний вид"

-- Tweaks
L.INSTANT_BUTTON =						"Получить сейчас!"
L.INSTANT_TOOLTIP =						"Удерживайте Shift, чтобы мгновенно получить предмет, пропуская 5-секундный таймер."

-- Settings
L.SETTINGS_TOOLTIP =					app.NameLong .. "\n|cffFFFFFF" .. app.IconLMB .. ": Переключить окно\n" .. app.IconRMB .. ": " .. L.WINDOW_BUTTON_SETTINGS

-- L.SETTINGS_VERSION =					GAME_VERSION_LABEL .. ":"	-- "Version"
L.SETTINGS_SUPPORT_TEXTLONG =			"Разработка этого аддона требует значительного времени и усилий.\nПожалуйста, рассмотрите возможность финансовой поддержки разработчика."
L.SETTINGS_SUPPORT_TEXT =				"Поддержать"
L.SETTINGS_SUPPORT_BUTTON =				"Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =				"Спасибо!"
L.SETTINGS_HELP_TEXT =					"Обратная связь и помощь"
L.SETTINGS_HELP_BUTTON =				"Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =					"Присоединиться к серверу Discord."
L.SETTINGS_ISSUES_TEXT =				"Отслеживание ошибок"
L.SETTINGS_ISSUES_BUTTON =				"GitHub" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_ISSUES_DESC =				"Просмотреть трекер ошибок на GitHub."
L.SETTINGS_URL_COPY =					"Ctrl+C — скопировать:"
L.SETTINGS_URL_COPIED =					"Ссылка скопирована в буфер обмена"

L.SETTINGS_KEYSLASH_TITLE =				SETTINGS_KEYBINDINGS_LABEL .. " & Слэш-команды"	-- "Keybindings"
-- _G["BINDING_NAME_TLH_TOGGLEWINDOW"] =	"Toggle Window"
-- L.SETTINGS_SLASH_TOGGLE =				"Toggle the tracking window"
-- L.SETTINGS_SLASH_RESETPOS =				"Reset the tracking window position"
-- L.SETTINGS_SLASH_WHISPER_DEFAULT =		"Set the whisper message to its default"
-- L.SETTINGS_SLASH_DELETE_DESC =			"Mark a character's unique recipes etc. as unlearned"
-- L.SETTINGS_SLASH_CHARREALM =			"Character-Realm"

-- L.GENERAL =								GENERAL	-- "General"
L.SETTINGS_ITEM_OVERLAY	=				"Накладка на предметы"
L.SETTINGS_BAGANATOR =					"Для пользователей Baganator это управляется собственными настройками Baganator."
L.SETTINGS_ITEM_OVERLAY_DESC =			"Показывать иконку и текст на предметах, чтобы указать статус коллекции и прочее.\n\n|cffFF0000" .. REQUIRES_RELOAD .. ".|r Используйте |cffFFFFFF/reload|r или перезайдите.\n\n" .. L.SETTINGS_BAGANATOR
L.SETTINGS_ICONPOS =					"Позиция иконки"
L.SETTINGS_ICONPOS_DESC =				"Местоположение иконки на предмете."
L.SETTINGS_ICONPOS_TL =					"Верхний левый"
L.SETTINGS_ICONPOS_TR =					"Верхний правый"
L.SETTINGS_ICONPOS_BL =					"Нижний левый"
L.SETTINGS_ICONPOS_BR =					"Нижний правый"
L.SETTINGS_ICONPOS_OVERLAP0 =			"Нет известных проблем с наложением."
L.SETTINGS_ICONPOS_OVERLAP1 =			"Это может пересекаться с качеством созданного предмета."
L.SETTINGS_ICON_SIMPLE =				"Простые иконки"
L.SETTINGS_ICON_SIMPLE_DESC =			"Использовать простые иконки с высоким контрастом, разработанные для помощи при дальтонизме."
L.SETTINGS_ICON_ANIMATE =				"Анимация иконок"
L.SETTINGS_ICON_ANIMATE_DESC =			"Показывать красивую анимированную спираль на иконках для доступных и используемых предметов."

L.SETTINGS_HEADER_COLLECTION =			"Информация о коллекции"
L.SETTINGS_ICON_NEW_MOG =				"Внешние виды"
L.SETTINGS_ICON_NEW_MOG_DESC =			"Показывать иконку, если внешний вид предмета не изучен."
L.SETTINGS_ICON_NEW_SOURCE =			"Источники"
L.SETTINGS_ICON_NEW_SOURCE_DESC =		"Показывать иконку, если источник внешнего вида предмета не изучен."
L.SETTINGS_ICON_NEW_CATALYST =			"От катализации"
L.SETTINGS_ICON_NEW_CATALYST_DESC =		"Показывать иконку, если катализация предмета дает новый внешний вид."
L.SETTINGS_ICON_NEW_UPGRADE =			"От улучшения"
L.SETTINGS_ICON_NEW_UPGRADE_DESC =		"Показывать иконку, если улучшение предмета дает новый внешний вид."
L.SETTINGS_ICON_NEW_ILLUSION =			"Иллюзии"
L.SETTINGS_ICON_NEW_ILLUSION_DESC =		"Показывать иконку, если иллюзия не изучена."
L.SETTINGS_ICON_NEW_MOUNT =				"Маунты"
L.SETTINGS_ICON_NEW_MOUNT_DESC =		"Показывать иконку, если маунт не изучен."
L.SETTINGS_ICON_NEW_PET =				"Питомцы"
L.SETTINGS_ICON_NEW_PET_DESC =			"Показывать иконку, если питомец не изучен."
L.SETTINGS_ICON_NEW_PET_MAX =			"Собрать 3/3"
L.SETTINGS_ICON_NEW_PET_MAX_DESC =		"Также учитывать максимальное количество питомцев, которое можно иметь (обычно 3)."
L.SETTINGS_ICON_NEW_TOY =				"Игрушки"
L.SETTINGS_ICON_NEW_TOY_DESC =			"Показывать иконку, если игрушка не изучена."
L.SETTINGS_ICON_NEW_RECIPE =			"Рецепты"
L.SETTINGS_ICON_NEW_RECIPE_DESC =		"Показывать иконку, если рецепт не изучен."
L.SETTINGS_ICON_NEW_DECOR =				"Декор"
L.SETTINGS_ICON_NEW_DECOR_DESC =		"Отобразить значок, указывающий на то, что у вас нет декора для дома."
L.SETTINGS_ICON_NEW_DECORXP =			"Только с Опытом для Дома"
L.SETTINGS_ICON_NEW_DECORXP_DESC =		"Показывать значок только для того декора дома, который дает опыт для дома."
L.SETTINGS_ICON_LEARNED =				"Изучено"
L.SETTINGS_ICON_LEARNED_DESC =			"Показывать иконку, если вышеуказанные коллекционные предметы изучены."

L.SETTINGS_HEADER_OTHER_INFO =			"Другая информация"
L.SETTINGS_ICON_QUEST_GOLD =			"Ценность награды за квест"
L.SETTINGS_ICON_QUEST_GOLD_DESC =		"Показывать иконку, указывающую, какая награда за квест имеет наибольшую стоимость у торговца, если их несколько."
L.SETTINGS_ICON_USABLE =				"Используемые предметы"
L.SETTINGS_ICON_USABLE_DESC =			"Показывать иконку, если предмет можно использовать (знания профессии, открываемые настройки, книги заклинаний)."
L.SETTINGS_ICON_OPENABLE =				"Открываемые предметы"
L.SETTINGS_ICON_OPENABLE_DESC =			"Показывать иконку, если предмет можно открыть, например, сундуки или сумки с боссов праздников."
L.SETTINGS_BINDTEXT =					"Текст привязки"
L.SETTINGS_BINDTEXT_DESC =				"Показывать текстовый индикатор для предметов с привязкой при экипировке (ПпЭ), предметов, привязанных к учетной записи (ПпУ), и предметов, привязанных до экипировки (ВнЭ).\n\n" .. L.SETTINGS_BAGANATOR

L.SETTINGS_HEADER_LOOT_TRACKER =		"Отслеживание лута"
L.SETTINGS_MINIMAP =					"Показывать иконку на миникарте"
L.SETTINGS_MINIMAP_DESC =				"Показывать иконку на миникарте. Если вы отключите это, " .. app.NameShort .. " все еще доступен из отсека аддонов."
L.SETTINGS_AUTO_OPEN =					"Автооткрытие окна"
L.SETTINGS_AUTO_OPEN_DESC =				"Автоматически показывать окно " .. app.NameShort .. ", когда добыт подходящий предмет."
L.SETTINGS_COLLECTION_MODE =			"Режим коллекции"
L.SETTINGS_COLLECTION_MODE_DESC =		"Установить, когда " .. app.NameShort .. " должен показывать новый трансмог, добытый другими."
L.SETTINGS_MODE_APPEARANCES =			"Внешние виды"
L.SETTINGS_MODE_APPEARANCES_DESC =		"Показывать предметы, только если у них есть новый внешний вид."
L.SETTINGS_MODE_SOURCES =				"Источники"
L.SETTINGS_MODE_SOURCES_DESC =			"Показывать предметы, если они являются новым источником, включая известные внешние виды."
L.SETTINGS_RARITY =						"Редкость"
L.SETTINGS_RARITY_DESC =				"Установить, начиная с какого качества " .. app.NameShort .. " должен показывать лут."
L.SETTINGS_WHISPER =					"Сообщение шепотом"
L.SETTINGS_WHISPER_CUSTOMIZE =			"Настроить"
L.SETTINGS_WHISPER_CUSTOMIZE_DESC =		"Настроить сообщение шепотом"
L.WHISPER_POPUP_CUSTOMIZE = 			"Настройте ваше сообщение шепотом:"
L.WHISPER_POPUP_ERROR = 				"Сообщение не содержит |cff3FC7EB%item|r. Сообщение не обновлено."
L.WHISPER_POPUP_SUCCESS =				"Сообщение обновлено."

L.SETTINGS_HEADER_TWEAKS =				"Хитрости"
L.SETTINGS_CATALYST =					"Мгновенная катализация"
L.SETTINGS_CATALYST_DESC =				"Удерживайте Shift, чтобы мгновенно катализировать предмет, пропуская 5-секундный таймер."
L.SETTINGS_VAULT =						"Мгновенное Великое Хранилище"
L.SETTINGS_VAULT_DESC =					"Удерживайте Shift, чтобы мгновенно получить награду из Великого Хранилища, пропуская 5-секундный таймер."
L.SETTINGS_INSTANT_TOOLTIP =			"Показывать подсказку"
L.SETTINGS_INSTANT_TOOLTIP_DESC =		"Показывать подсказку, объясняющую, как работает эта функция. Текст кнопки все равно меняется, если это отключено."
L.SETTINGS_VENDOR_ALL =					"Отключить фильтр торговца"
L.SETTINGS_VENDOR_ALL_DESC =			"Автоматически устанавливать все фильтры торговца на |cffFFFFFFВсе|r, чтобы отображать предметы, обычно не показываемые для вашего класса."
L.SETTINGS_HIDE_LOOT_ROLL_WINDOW =		"Скрыть окно бросков лута"
L.SETTINGS_HIDE_LOOT_ROLL_WINDOW_DESC =	"Скрыть окно, показывающее броски лута и их результаты. Вы можете снова показать окно с помощью |cff00ccff/loot|r."
