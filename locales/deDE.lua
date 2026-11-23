------------------------------------
-- Transmog Loot Helper: deDE.lua --
------------------------------------
-- German (Germany) localisation
-- Translator(s):

if GetLocale() ~= "deDE" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Eine neuere Version von %s ist verfügbar:" -- %s becomes the addon name

L.INVALID_COMMAND =                      "Ungültiger Befehl"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Die Entwicklung dieses Addons erfordert viel Zeit und Mühe."
L.SUPPORT_TEXTLONG2 =                    "Bitte erwäge, die Entwicklung finanziell zu unterstützen."
L.SUPPORT =                              "Unterstützen"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Vielen Dank!"
L.FEEDBACK_AND_HELP =                    "Feedback und Hilfe"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Discord-Server beitreten."
L.CTRL_C_COPY =                          "Strg+C zum Kopieren:"
L.LINK_COPIED =                          "Link in die Zwischenablage kopiert"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & Slash-Befehle" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. ": Fenster ein-/ausblenden"
L.TOGGLE_TRACKING_WINDOW =               "Verfolgungsfenster ein-/ausblenden"
L.RESET_WINDOW_POSITION =                "Position des Verfolgungsfensters zurücksetzen"
L.OPEN_SETTINGS =                        "Einstellungen öffnen"
L.CHARACTER_REALM =                      "Charakter-Realm"
L.DELETE_CHAR_RECIPES =                  "Einzigartige Rezepte usw. eines Charakters als ungelernt markieren"
L.WHISPER_SET_DEFAULT =                  "Flüsternachricht auf Standard zurücksetzen"

L.GENERAL =                              GENERAL -- "General"
L.ITEM_OVERLAY =                         "Gegenstandseinblendung"
L.ITEM_OVERLAY_DESC =                    "Zeigt Symbole und Text auf Gegenständen an, um Sammlungsstatus und weitere Informationen anzuzeigen."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.ICON_POSITION =                        "Symbolposition"
L.ICON_POSITION_DESC =                   "In welcher Ecke das Symbol angezeigt wird."
L.BAGANATOR_SETTINGS =                   "Für Baganator-Nutzer wird dies über die Baganator-Einstellungen verwaltet."
L.TOP_LEFT =                             "Oben links"
L.TOP_RIGHT =                            "Oben rechts"
L.BOTTOM_LEFT =                          "Unten links"
L.BOTTOM_RIGHT =                         "Unten rechts"
L.OVERLAP_ISSUES_NONE =                  "Keine bekannten Überschneidungsprobleme."
L.OVERLAP_ISSUES_QUALITY =               "Dies kann sich mit der Qualitätsanzeige eines hergestellten Gegenstands überschneiden."
L.ICON_STYLE =                           "Symbolstil"
L.ICON_STYLE_DESC =                      "Stil des Statussymbols."
L.ICON_STYLE_FANCYCIRCLE =               "Verzierter Kreis"
L.ICON_STYLE_FANCYCIRCLE_DESC =          "Typensymbol mit rundem Statusrahmen in der Ecke"
L.ICON_STYLE_SIMPLECIRCLE =              "Einfacher Kreis"
L.ICON_STYLE_SIMPLECIRCLE_DESC =         "Statussymbol mit schlichtem rundem Hintergrund in der Ecke"
L.ICON_STYLE_SIMPLEICON =                "Einfaches Symbol"
L.ICON_STYLE_SIMPLEICON_DESC =           "Statussymbol in der Ecke"
L.ICON_STYLE_COSMETICICON =              "Kosmetik-Symbol"
L.ICON_STYLE_COSMETICICON_DESC =         "Statusrahmen in der Ecke (ohne Animation)"
L.ICON_ANIMATION =                       "Symbolanimation"
L.ICON_ANIMATION_DESC =                  "Zeigt einen hübschen animierten Wirbel auf Symbolen erlernbarer und benutzbarer Gegenstände an."
L.ICON_LEARNED =                         "Symbol für bereits Erlerntes"
L.ICON_LEARNED_DESC =                    "Zeigt ein Symbol an, wenn die unten aufgeführten verfolgten Sammelgegenstände bereits erlernt sind."
L.DEFAULT =                              CHAT_DEFAULT -- "Default"
L.ICON_LEARNED_DESC2 =                   "Du kannst einen eigenen Stil für erlernte Symbole festlegen."
L.BINDING_TEXT =                         "Text der Tastenbelegung"
L.BINDING_TEXT_DESC =                    "Zeigt einen Texthinweis für beim Anlegen gebundene (BoE), kriegsmeutengebundene (BoA) und bis zum Anlegen kriegsmeutengebundene (WuE) Gegenstände an."

L.PREVIEW =                              "Vorschau:"
L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- "Unlearned"
L.USABLE =                               "Benutzbar"
L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- "Learned"
L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- "Unusable"
L.PREVIEW_TOOLTIP = {}
L.PREVIEW_TOOLTIP[1] =                   "Noch nicht erlernte Gegenstände sind völlig neu für deine Sammlung."
L.PREVIEW_TOOLTIP[2] =                   "Benutzbare Gegenstände sind z. B. Behälter oder neue Quellen für bereits bekannte Aussehen."
L.PREVIEW_TOOLTIP[3] =                   "Erlernte Gegenstände befinden sich bereits in deiner Sammlung."
L.PREVIEW_TOOLTIP[4] =                   "Nicht benutzbare Gegenstände sind z. B. verschlossene Behälter oder Rezepte für unbekannte Berufe."

L.COLLECTION_INFO =                      "Sammlungsinformationen"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_ICON_DESC =                "Zeigt ein Symbol an, wenn das Aussehen eines Gegenstands noch nicht erlernt wurde."
L.APPEARANCES_SOURCES =                  "Quellen"
L.APPEARANCES_SOURCES_ICON_DESC =        "Zeigt ein Symbol an, wenn eine Aussehensquelle eines Gegenstands noch nicht erlernt wurde."
L.CATALYST =                             "Katalysator"
L.CATALYST_ICON_DESC =                   "Zeigt ein Symbol an, wenn die Katalyse eines Gegenstands ein neues Aussehen gewährt."
L.UPGRADE =                              "Aufwertung"
L.UPGRADE_ICON_DESC =                    "Zeigt ein Symbol an, wenn die Aufwertung eines Gegenstands ein neues Aussehen gewährt."
L.ILLUSIONS =                            "Illusionen"
L.ILLUSIONS_ICON_DESC =                  "Zeigt ein Symbol für eine noch nicht erlernte Illusion an."
L.MOUNTS =                               MOUNTS -- "Mounts"
L.MOUNTS_ICON_DESC =                     "Zeigt ein Symbol für ein noch nicht erlerntes Reittier an."
L.PETS =                                 PETS -- "Pets"
L.PETS_ICON_DESC =                       "Zeigt ein Symbol für ein noch nicht erlerntes Haustier an."
L.PETS_COLLECT_MAX =                     "3/3 sammeln"
L.PETS_COLLECT_MAX_ICON_DESC =           "Berücksichtigt auch die maximale Anzahl an Haustieren, die du besitzen kannst (normalerweise 3)."
L.TOYS =                                 "Spielzeuge"
L.TOYS_ICON_DESC =                       "Zeigt ein Symbol für ein noch nicht erlerntes Spielzeug an."
L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.RECIPES_ICON_DESC =                    "Zeigt ein Symbol für ein noch nicht erlerntes Rezept an."
L.TRACK_PER_CHARACTER =                  "Pro Charakter verfolgen"
L.TRACK_PER_CHARACTER_ICON_DESC =        "Zeigt bereits erlernte Rezepte für Zweitcharaktere als erlernbar an."
L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
L.DECOR_ICON_DESC =                      "Zeigt ein Symbol an, wenn du eine Wohnungsdekoration noch nicht besitzt."
L.ONLY_HOUSE_XP =                        "Nur mit Haus-EP"
L.ONLY_HOUSE_XP_ICON_DESC =              "Symbol nur bei Wohnungsdeko anzeigen, die Haus-EP gewährt."

L.OTHER_INFORMATION =                    "Weitere Informationen"
L.QUEST_REWARD_SELL_VALUE =              "Verkaufswert von Questbelohnungen"
L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "Zeigt ein Symbol an, welche Questbelohnung bei mehreren Optionen den höchsten Händlerverkaufswert hat."
L.USABLE_ITEMS =                         "Benutzbare Gegenstände"
L.USABLE_ITEMS_ICON_DESC =               "Zeigt ein Symbol für benutzbare Gegenstände an (Berufswissen, freischaltbare Anpassungen und Zauberbücher)."
L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
L.CONTAINERS_ICON_DESC =                 "Zeigt ein Symbol für Gegenstände an, die geöffnet werden können, etwa Schließkassetten und Beutel von Feiertagsbossen."

L.LOOT_TRACKER =                         "Beuteverfolgung"
L.SHOW_MINIMAP_ICON =                    "Minikartensymbol anzeigen"
L.SHOW_MINIMAP_ICON_DESC =               "Zeigt das Minikartensymbol an. Wenn du dies deaktivierst, bleibt %s über das Addon-Fach erreichbar." -- %s becomes the addon name
L.AUTO_OPEN_WINDOW =                     "Fenster automatisch öffnen"
L.AUTO_OPEN_WINDOW_DESC =                "Öffnet das %s-Fenster automatisch, wenn ein geeigneter Gegenstand erbeutet wird." -- %s becomes the addon name
L.COLLECTION_MODE =                      "Sammlungsmodus"
L.COLLECTION_MODE_DESC =                 "Lege fest, wann %s neue von anderen erbeutete Transmogs anzeigen soll." -- %s becomes the addon name
L.COLLECTION_MODE_APPEARANCES_DESC =     "Zeigt nur Gegenstände mit einem neuen Aussehen an."
L.COLLECTION_MODE_SOURCES_DESC =         "Zeigt Gegenstände mit einer neuen Quelle an, auch wenn das Aussehen bereits bekannt ist."
L.RARITY =                               RARITY -- "Rarity"
L.RARITY_SETTING_DESC =                  "Lege fest, ab welcher Qualitätsstufe %s Beute anzeigen soll." -- %s becomes the addon name
L.WHISPER_MESSAGE =                      "Flüsternachricht"
L.CUSTOMIZE =                            "Anpassen"
L.WHISPER_CUSTOMIZE_DESC1 =              "Flüsternachricht anpassen"
L.WHISPER_CUSTOMIZE_DESC2 =              "Passe deine Flüsternachricht an:"
L.WHISPER_POPUP_ERROR =                  "Nachricht enthält kein %s" -- %s becomes "%item"
L.WHISPER_POPUP_SUCCESS =                "Nachricht aktualisiert:"

L.TWEAKS =                               "Optimierungen"
L.INSTANT_CATALYST =                     "Sofortiger Katalysator"
L.INSTANT_CATALYST_DESC =                "Halte Umschalt gedrückt, um einen Gegenstand sofort zu katalysieren und den 5-Sekunden-Timer zu überspringen."
L.INSTANT_VAULT =                        "Sofortige Große Schatzkammer"
L.INSTANT_VAULT_DESC =                   "Halte Umschalt gedrückt, um deine Belohnung aus der Großen Schatzkammer sofort zu erhalten und den 5-Sekunden-Timer zu überspringen."
L.SHOW_TOOLTIP =                         "Tooltip anzeigen"
L.SHOW_TOOLTIP_SETTING_DESC =            "Zeigt den Tooltip mit einer Erklärung dieser Funktion an. Der Schaltflächentext ändert sich auch bei deaktivierter Option."
L.DISABLE_VENDOR_FILTER =                "Verkäuferfilter deaktivieren"
L.DISABLE_VENDOR_FILTER_DESC =           "Setzt alle Verkäuferfilter automatisch auf \"Alle\", um Gegenstände anzuzeigen, die normalerweise nicht für deine Klasse sichtbar sind."
L.HIDE_LOOT_ROLL_WINDOW =                "Beutewurffenster ausblenden"
L.HIDE_LOOT_ROLL_WINDOW_DESC =           "Blendet das Fenster mit Beutewürfen und ihren Ergebnissen aus. Du kannst es mit %s wieder einblenden." -- %s becomes "/loot"

-- Item overlay
L.BINDTEXT_WUE =                         "Bis zum Anlegen kriegsmeutengebunden" -- Abbreviation for "Warbound until Equipped"
L.BINDTEXT_BOP =                         "Beim Aufheben gebunden" -- Abbreviation for "Binds on Pickup"
L.BINDTEXT_BOE =                         "Beim Anlegen gebunden" -- Abbreviation for "Binds on Equip"
L.BINDTEXT_BOA =                         "Accountgebunden" -- Abbreviation for "Binds to Account" (Warbound)
L.RECIPE_UNCACHED =                      "Bitte öffne diesen Beruf, um den Sammlungsstatus des Rezepts zu aktualisieren."
L.LEARN_UNBOUND =                        "Verkaufe, zerstöre oder entzaubere diesen Gegenstand, um sein Aussehen zu erlernen."
L.BUGGED_ITEM =                          "Dieser Gegenstand ist fehlerhaft und sein Aussehen kann möglicherweise nicht erlernt werden."

-- Loot tracker
L.DEFAULT_MESSAGE =                      "Brauchst du den Gegenstand %item, den du erbeutet hast? Falls nicht, würde ich ihn gern für die Transmogrifikation haben. :)"

L.CLOSE_WINDOW =                         "Fenster schließen"
L.LOCK_WINDOW =                          "Fenster sperren"
L.UNLOCK_WINDOW =                        "Fenster entsperren"
L.CLEAR_ALL_ITEMS =                      "Alle Gegenstände entfernen"
L.HOLD_SHIFT_TO_SKIP =                   "Umschalt gedrückt halten, um die Bestätigung zu überspringen"
L.SORT_NEW =                             "Neueste zuerst"
L.SORT_ALPHABETICAL =                    "Alphabetisch sortieren"
L.SORTED_CURRENT =                       "Aktuelle Sortierung:"
L.SORTED_ALPHABETICAL =                  "alphabetisch"
L.SORTED_NEW =                           "neueste zuerst"
L.CLEAR_CONFIRM =                        "Möchtest du die gesamte Beute entfernen?"
L.DOUBLE =                               "Doppelt" -- Followed by LMB or RMB
L.CTRL =                                 "Strg" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Umschalt" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "Größe automatisch an das Fenster anpassen"
L.WHISPER_AND_REQUEST_ITEM =             "Gegenstand per Flüstern anfordern"
L.LINK_ITEM =                            "Gegenstand verlinken"
L.REMOVE_ITEM =                          "Gegenstand entfernen"
L.DEBUG_ITEM =                           "Diesen Gegenstand debuggen"

L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
L.FILTERED =                             "Gefiltert"
L.PLAYER_COLLECTED_APPEARANCE =          "Aussehen dieses Gegenstands gesammelt" -- Preceded by a character name
L.PLAYER_WHISPERED =                     "wurde von %s-Nutzern angeflüstert" -- %s becomes the addon name
L.WHISPERED_TIME =                       "Zeit"
L.WHISPERED_TIMES =                      "-mal"
L.WHISPER_COOLDOWN =                     "Du kannst demselben Spieler für denselben Gegenstand nur einmal alle 30 Sekunden eine Flüsternachricht senden."
L.FILTER_REASON_UNTRADEABLE =            "Nicht handelbar"
L.FILTER_REASON_RARITY =                 "Seltenheitsstufe zu niedrig"
L.FILTER_REASON_KNOWN =                  "Bekanntes Aussehen"

-- Recipes
L.DELETED_ENTRIES =                      "Gelöschte Einträge:"
L.DELETED_REMOVED =                      "Einzigartige Sammelgegenstände entfernt:"

-- Tweaks
L.GET_IT_NOW =                           "Jetzt holen!"
L.HOLD_SHIFT_TOOLTIP =                   "Halte Umschalt gedrückt, um deinen Gegenstand sofort zu erhalten und den 5-Sekunden-Timer zu überspringen."
