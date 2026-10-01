------------------------------------
-- Transmog Loot Helper: ruRU.lua --
------------------------------------
-- Russian (Russia) localisation
-- Translator(s): ZamestoTV

if GetLocale() ~= "ruRU" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Доступна новая версия %s:" -- %s becomes the addon name

L.INVALID_COMMAND =                      "Неверная команда"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Разработка этого аддона требует значительного времени и усилий."
L.SUPPORT_TEXTLONG2 =                    "Пожалуйста, рассмотрите возможность финансовой поддержки разработчика."
L.SUPPORT =                              "Поддержать"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Спасибо!"
L.FEEDBACK_AND_HELP =                    "Обратная связь и помощь"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Присоединиться к серверу Discord."
L.CTRL_C_COPY =                          "Ctrl+C — скопировать:"
L.LINK_COPIED =                          "Ссылка скопирована в буфер обмена"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " и слэш-команды" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. ": Включить окно"
L.TOGGLE_TRACKING_WINDOW =               "Включить окно отслеживания"
L.RESET_WINDOW_POSITION =                "Сбросить положение окна слежения"
L.OPEN_SETTINGS =                        "Открыть настройки"
L.CHARACTER_REALM =                      "Персонаж-Сервер"
L.DELETE_CHAR_RECIPES =                  "Отметьте уникальные рецепты персонажа и т.д. как неизученные"
L.WHISPER_SET_DEFAULT =                  "Установите для личных сообщений значение по умолчанию"

L.GENERAL =                              GENERAL -- "General"
L.ITEM_OVERLAY =                         "Накладка на предметы"
L.ITEM_OVERLAY_DESC =                    "Показывать иконку и текст на предметах, чтобы указать статус коллекции и прочее."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.ICON_POSITION =                        "Положение иконки"
L.ICON_POSITION_DESC =                   "В каком углу появляется иконка?"
L.BAGANATOR_SETTINGS =                   "Для пользователей Baganator это управляется собственными настройками Baganator."
L.TOP_LEFT =                             "Верхний левый"
L.TOP_RIGHT =                            "Верхний правый"
L.BOTTOM_LEFT =                          "Нижний левый"
L.BOTTOM_RIGHT =                         "Нижний правый"
L.OVERLAP_ISSUES_NONE =                  "Нет известных проблем с наложением."
L.OVERLAP_ISSUES_QUALITY =               "Это может пересекаться с качеством созданного предмета."
L.ICON_STYLE =                           "Стиль иконки"
L.ICON_STYLE_DESC =                      "Стиль иконки статуса."
L.ICON_STYLE_FANCYCIRCLE =               "Причудливый круг"
L.ICON_STYLE_FANCYCIRCLE_DESC =          "Иконка с круглой рамкой статуса в углу"
L.ICON_STYLE_SIMPLECIRCLE =              "Простой круг"
L.ICON_STYLE_SIMPLECIRCLE_DESC =         "Иконка статуса с простым круглым фоном в углу"
L.ICON_STYLE_SIMPLEICON =                "Простая иконка"
L.ICON_STYLE_SIMPLEICON_DESC =           "Иконка статуса в углу"
L.ICON_STYLE_COSMETICICON =              "Иконка косметики"
L.ICON_STYLE_COSMETICICON_DESC =         "Граница статуса в углу (без анимации)"
L.ICON_ANIMATION =                       "Анимация иконок"
L.ICON_ANIMATION_DESC =                  "Добавьте красивый анимированный вихрь на иконки для предметов, которые можно изучать и использовать."
L.SETTINGS_ICON_LEARNED =                "Изучено"
L.SETTINGS_ICON_LEARNED_DESC =           "Показывать иконку, если вышеуказанные коллекционные предметы изучены."
L.DEFAULT =                              CHAT_DEFAULT -- "Default"
L.ICON_LEARNED_DESC2 =                   "Вы можете установить отдельный стиль иконок для изученных."
L.BINDING_TEXT =                         "Текст привязки"
L.BINDING_TEXT_DESC =                    "Показывать текстовый индикатор для предметов с привязкой при экипировке (ПпЭ), предметов, привязанных к учетной записи (ПпУ), и предметов, привязанных до экипировки (ВнЭ)."

L.PREVIEW =                              "Предварительный просмотр:"
L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- "Unlearned"
L.USABLE =                               "Пригодный"
L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- "Learned"
L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- "Unusable"
L.PREVIEW_TOOLTIP = {}
L.PREVIEW_TOOLTIP[1] =                   "Неизученные предметы - это совершенно новые предметы для вашей коллекции."
L.PREVIEW_TOOLTIP[2] =                   "К полезным предметам относятся, например, контейнеры, новые источники известных вариантов внешнего вида и т.д."
L.PREVIEW_TOOLTIP[3] =                   "Изученные предметы уже есть в вашей коллекции."
L.PREVIEW_TOOLTIP[4] =                   "К непригодным для использования предметам относятся, например, сейфы, рецепты для профессии, о которой вы не знаете, и т.д."

L.COLLECTION_INFO =                      "Информация о коллекции"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_ICON_DESC =                "Показывать иконку, если внешний вид предмета не изучен."
L.APPEARANCE_SOURCES =                   "Источники"
L.APPEARANCE_SOURCES_ICON_DESC =         "Показывать иконку, если источник внешнего вида предмета не изучен."
L.CATALYST =                             "Катализатор"
L.CATALYST_ICON_DESC =                   "Показывать иконку, если катализация предмета дает новый внешний вид."
L.UPGRADE =                              "Улучшение"
L.UPGRADE_ICON_DESC =                    "Показывать иконку, если улучшение предмета дает новый внешний вид."
L.ILLUSIONS =                            "Иллюзии"
L.ILLUSIONS_ICON_DESC =                  "Показывать иконку, если иллюзия не изучена."
L.MOUNTS =                               MOUNTS -- "Mounts"
L.MOUNTS_ICON_DESC =                     "Показывать иконку, если маунт не изучен."
L.PETS =                                 PETS -- "Pets"
L.PETS_ICON_DESC =                       "Показывать иконку, если питомец не изучен."
L.PETS_COLLECT_MAX =                     "Собрать 3/3"
L.PETS_COLLECT_MAX_ICON_DESC =           "Также учитывать максимальное количество питомцев, которое можно иметь (обычно 3)."
L.TOYS =                                 "Игрушки"
L.TOYS_ICON_DESC =                       "Показывать иконку, если игрушка не изучена."
L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.RECIPES_ICON_DESC =                    "Показывать иконку, если рецепт не изучен."
L.TRACK_PER_CHARACTER =                  "Отслеживать для каждого персонажа"
L.TRACK_PER_CHARACTER_ICON_DESC =        "Показывать уже изученные рецепты как доступные для изучения альтами."
L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
L.DECOR_ICON_DESC =                      "Отобразить значок, указывающий на то, что у вас нет декора для дома."
L.ONLY_HOUSE_XP =                        "Только с Опытом для Дома"
L.ONLY_HOUSE_XP_ICON_DESC =              "Показывать значок только для того декора дома, который дает опыт для дома."

L.OTHER_INFORMATION =                    "Другая информация"
L.QUEST_REWARD_SELL_VALUE =              "Ценность награды за квест"
L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "Показывать иконку, указывающую, какая награда за квест имеет наибольшую стоимость у торговца, если их несколько."
L.USABLE_ITEMS =                         "Используемые предметы"
L.USABLE_ITEMS_ICON_DESC =               "Показывать иконку, если предмет можно использовать (знания профессии, открываемые настройки, книги заклинаний)."
L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
L.CONTAINERS_ICON_DESC =                 "Показывать иконку, если предмет можно открыть, например, сундуки или сумки с боссов праздников."

L.LOOT_TRACKER =                         "Отслеживание лута"
L.SHOW_MINIMAP_ICON =                    "Показывать иконку на миникарте"
L.SHOW_MINIMAP_ICON_DESC =               "Показывать иконку на миникарте. Если вы отключите это, %s все еще доступен из отсека аддонов." -- %s becomes the addon name
L.AUTO_OPEN_WINDOW =                     "Автооткрытие окна"
L.AUTO_OPEN_WINDOW_DESC =                "Автоматически показывать окно %s, когда добыт подходящий предмет." -- %s becomes the addon name
L.COLLECTION_MODE =                      "Режим коллекции"
L.COLLECTION_MODE_DESC =                 "Установить, когда %s должен показывать новый трансмог, добытый другими." -- %s becomes the addon name
L.COLLECTION_MODE_APPEARANCES_DESC =     "Показывать предметы, только если у них есть новый внешний вид."
L.COLLECTION_MODE_SOURCES_DESC =         "Показывать предметы, если они являются новым источником, включая известные внешние виды."
L.RARITY =                               RARITY -- "Rarity"
L.RARITY_SETTING_DESC =                  "Установить, начиная с какого качества %s должен показывать лут." -- %s becomes the addon name
L.WHISPER_MESSAGE =                      "Сообщение шепотом"
L.CUSTOMIZE =                            "Настроить"
L.WHISPER_CUSTOMIZE_DESC1 =              "Настроить сообщение шепотом"
L.WHISPER_CUSTOMIZE_DESC2 =              "Настройте ваше сообщение шепотом:"
L.WHISPER_POPUP_ERROR =                  "Сообщение не содержит %s" -- %s becomes "%item"
L.WHISPER_POPUP_SUCCESS =                "Сообщение обновлено:"

L.TWEAKS =                               "Хитрости"
L.INSTANT_CATALYST =                     "Мгновенная катализация"
L.INSTANT_CATALYST_DESC =                "Удерживайте Shift, чтобы мгновенно катализировать предмет, пропуская 5-секундный таймер."
L.INSTANT_VAULT =                        "Мгновенное Великое Хранилище"
L.INSTANT_VAULT_DESC =                   "Удерживайте Shift, чтобы мгновенно получить награду из Великого Хранилища, пропуская 5-секундный таймер."
L.SHOW_TOOLTIP =                         "Показывать подсказку"
L.SHOW_TOOLTIP_SETTING_DESC =            "Показывать подсказку, объясняющую, как работает эта функция. Текст кнопки все равно меняется, если это отключено."
L.DISABLE_VENDOR_FILTER =                "Отключить фильтр торговца"
L.DISABLE_VENDOR_FILTER_DESC =           "Автоматически устанавливать все фильтры торговца на |cffFFFFFFВсе|r, чтобы отображать предметы, обычно не показываемые для вашего класса."
L.HIDE_LOOT_ROLL_WINDOW =                "Скрыть окно бросков лута"
L.HIDE_LOOT_ROLL_WINDOW_DESC =           "Скрыть окно, показывающее броски лута и их результаты. Вы можете снова показать окно с помощью %s." -- %s becomes "/loot"

-- Item overlay
L.BINDTEXT_WUE =                         "WuE" -- Abbreviation for "Warbound until Equipped"
L.BINDTEXT_BOP =                         "BoP" -- Abbreviation for "Binds on Pickup"
L.BINDTEXT_BOE =                         "BoE" -- Abbreviation for "Binds on Equip"
L.BINDTEXT_BOA =                         "BoA" -- Abbreviation for "Binds to Account" (Warbound)
L.RECIPE_UNCACHED =                      "Пожалуйста, откройте эту профессию, чтобы обновить статус коллекции рецепта."

-- Loot tracker
L.DEFAULT_MESSAGE =                      "Нужен ли вам предмет %item, который вы добыли? Если нет, я хотел бы взять его для трансмога. :)"

L.CLOSE_WINDOW =                         "Закрыть окно"
L.LOCK_WINDOW =                          "Заблокировать окно"
L.UNLOCK_WINDOW =                        "Разблокировать окно"
L.CLEAR_ALL_ITEMS =                      "Очистить все предметы"
L.HOLD_SHIFT_TO_SKIP =                   "Удерживайте Shift, чтобы пропустить подтверждение"
L.SORT_NEW =                             "Сортировать по новизне"
L.SORT_ALPHABETICAL =                    "Сортировать по алфавиту"
L.SORTED_CURRENT =                       "Текущая сортировка:"
L.SORTED_ALPHABETICAL =                  "по алфавиту"
L.SORTED_NEW =                           "по новизне"
L.CLEAR_CONFIRM =                        "Хотите очистить весь лут?"
L.DOUBLE =                               "Двойное" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "Автоматический размер окна"
L.WHISPER_AND_REQUEST_ITEM =             "Шепот и запрос предмета"
L.LINK_ITEM =                            "Ссылка на предмет"
L.REMOVE_ITEM =                          "Удалить предмет"
L.DEBUG_ITEM =                           "Отладка этого предмета"

L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
L.FILTERED =                             "Отфильтровано"
L.PLAYER_COLLECTED_APPEARANCE =          "собрал внешний вид этого предмета" -- Preceded by a character name
L.PLAYER_WHISPERED =                     "получил сообщение от игрока %s" -- %s becomes the addon name
L.WHISPERED_TIME =                       "раз"
L.WHISPERED_TIMES =                      "раза"
L.WHISPER_COOLDOWN =                     "Вы можете шептать игроку только раз в 30 секунд для каждого предмета."
L.FILTER_REASON_UNTRADEABLE =            "Нельзя передать"
L.FILTER_REASON_RARITY =                 "Слишком низкая редкость"
L.FILTER_REASON_KNOWN =                  "Известный внешний вид"

-- Recipes
L.DELETED_ENTRIES =                      "Удаленные записи:"
L.DELETED_REMOVED =                      "Уникальные коллекционные предметы удалены:"

-- Tweaks
L.GET_IT_NOW =                           "Получить сейчас!"
L.HOLD_SHIFT_TOOLTIP =                   "Удерживайте Shift, чтобы мгновенно получить предмет, пропуская 5-секундный таймер."
