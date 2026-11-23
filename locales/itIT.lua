------------------------------------
-- Transmog Loot Helper: itIT.lua --
------------------------------------
-- Italian (Italy) localisation
-- Translator(s):

if GetLocale() ~= "itIT" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "È disponibile una nuova versione di %s:" -- %s becomes the addon name

L.INVALID_COMMAND =                      "Comando non valido"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Lo sviluppo di questo addon richiede molto tempo e impegno."
L.SUPPORT_TEXTLONG2 =                    "Ti invitiamo a sostenere economicamente lo sviluppatore."
L.SUPPORT =                              "Supporto"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Grazie!"
L.FEEDBACK_AND_HELP =                    "Feedback e aiuto"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Entra nel server Discord."
L.CTRL_C_COPY =                          "Ctrl+C per copiare:"
L.LINK_COPIED =                          "Collegamento copiato negli appunti"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " e comandi slash" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. ": Mostra/nascondi finestra"
L.TOGGLE_TRACKING_WINDOW =               "Mostra/nascondi finestra di tracciamento"
L.RESET_WINDOW_POSITION =                "Ripristina posizione finestra di tracciamento"
L.OPEN_SETTINGS =                        "Apri le impostazioni"
L.CHARACTER_REALM =                      "Personaggio-Reame"
L.DELETE_CHAR_RECIPES =                  "Segna le ricette esclusive e altro di un personaggio come non apprese"
L.WHISPER_SET_DEFAULT =                  "Ripristina messaggio sussurrato predefinito"

L.GENERAL =                              GENERAL -- "General"
L.ITEM_OVERLAY =                         "Sovrimpressione oggetti"
L.ITEM_OVERLAY_DESC =                    "Mostra un'icona e un testo sugli oggetti per indicare lo stato della collezione e altro."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.ICON_POSITION =                        "Posizione icona"
L.ICON_POSITION_DESC =                   "In quale angolo appare l'icona."
L.BAGANATOR_SETTINGS =                   "Per gli utenti di Baganator, questa opzione è gestita dalle impostazioni di Baganator."
L.TOP_LEFT =                             "In alto a sinistra"
L.TOP_RIGHT =                            "In alto a destra"
L.BOTTOM_LEFT =                          "In basso a sinistra"
L.BOTTOM_RIGHT =                         "In basso a destra"
L.OVERLAP_ISSUES_NONE =                  "Nessun problema di sovrapposizione noto."
L.OVERLAP_ISSUES_QUALITY =               "Questo potrebbe sovrapporsi all'indicatore di qualità degli oggetti creati."
L.ICON_STYLE =                           "Stile icona"
L.ICON_STYLE_DESC =                      "Lo stile dell'icona di stato."
L.ICON_STYLE_FANCYCIRCLE =               "Cerchio elaborato"
L.ICON_STYLE_FANCYCIRCLE_DESC =          "Icona tipo con bordo di stato rotondo nell'angolo"
L.ICON_STYLE_SIMPLECIRCLE =              "Cerchio semplice"
L.ICON_STYLE_SIMPLECIRCLE_DESC =         "Icona di stato con sfondo circolare semplice nell'angolo"
L.ICON_STYLE_SIMPLEICON =                "Icona semplice"
L.ICON_STYLE_SIMPLEICON_DESC =           "Icona di stato nell'angolo"
L.ICON_STYLE_COSMETICICON =              "Icona cosmetica"
L.ICON_STYLE_COSMETICICON_DESC =         "Bordo di stato nell'angolo (senza animazione)"
L.ICON_ANIMATION =                       "Animazione icona"
L.ICON_ANIMATION_DESC =                  "Mostra un vortice animato sulle icone degli oggetti apprendibili e utilizzabili."
L.ICON_LEARNED =                         "Icona degli elementi appresi"
L.ICON_LEARNED_DESC =                    "Mostra un'icona per indicare quali collezionabili tracciati qui sotto sono già appresi."
L.DEFAULT =                              CHAT_DEFAULT -- "Default"
L.ICON_LEARNED_DESC2 =                   "Puoi impostare uno stile separato per le icone degli elementi appresi."
L.BINDING_TEXT =                         "Testo dell'assegnazione tasti"
L.BINDING_TEXT_DESC =                    "Mostra un indicatore testuale per oggetti vincolati all'equipaggiamento (BoE), alla Brigata (BoA) e alla Brigata fino all'equipaggiamento (WuE)."

L.PREVIEW =                              "Anteprima:"
L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- "Unlearned"
L.USABLE =                               "Utilizzabile"
L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- "Learned"
L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- "Unusable"
L.PREVIEW_TOOLTIP = {}
L.PREVIEW_TOOLTIP[1] =                   "Gli oggetti non appresi sono completamente nuovi per la tua collezione."
L.PREVIEW_TOOLTIP[2] =                   "Gli oggetti utilizzabili comprendono contenitori, nuove fonti di aspetti già conosciuti e altro."
L.PREVIEW_TOOLTIP[3] =                   "Gli oggetti appresi sono già nella tua collezione."
L.PREVIEW_TOOLTIP[4] =                   "Gli oggetti inutilizzabili includono contenitori chiusi, ricette per professioni che non conosci e simili."

L.COLLECTION_INFO =                      "Informazioni sulla collezione"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_ICON_DESC =                "Mostra un'icona se l'aspetto di un oggetto non è stato appreso."
L.APPEARANCES_SOURCES =                  "Fonti"
L.APPEARANCES_SOURCES_ICON_DESC =        "Mostra un'icona se la fonte dell'aspetto di un oggetto non è stata appresa."
L.CATALYST =                             "Catalizzatore"
L.CATALYST_ICON_DESC =                   "Mostra un'icona se catalizzare un oggetto sblocca un nuovo aspetto."
L.UPGRADE =                              "Potenziamento"
L.UPGRADE_ICON_DESC =                    "Mostra un'icona se potenziare un oggetto sblocca un nuovo aspetto."
L.ILLUSIONS =                            "Illusioni"
L.ILLUSIONS_ICON_DESC =                  "Mostra un'icona per un'illusione non appresa."
L.MOUNTS =                               MOUNTS -- "Mounts"
L.MOUNTS_ICON_DESC =                     "Mostra un'icona per una cavalcatura non appresa."
L.PETS =                                 PETS -- "Pets"
L.PETS_ICON_DESC =                       "Mostra un'icona per una mascotte non appresa."
L.PETS_COLLECT_MAX =                     "Raccogli 3/3"
L.PETS_COLLECT_MAX_ICON_DESC =           "Tiene conto anche del numero massimo di mascotte che puoi possedere (di solito 3)."
L.TOYS =                                 "Giocattoli"
L.TOYS_ICON_DESC =                       "Mostra un'icona per un giocattolo non appreso."
L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.RECIPES_ICON_DESC =                    "Mostra un'icona per una ricetta non appresa."
L.TRACK_PER_CHARACTER =                  "Traccia per personaggio"
L.TRACK_PER_CHARACTER_ICON_DESC =        "Mostra le ricette già apprese come apprendibili per i personaggi secondari."
L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
L.DECOR_ICON_DESC =                      "Mostra un'icona per le decorazioni della casa che non possiedi."
L.ONLY_HOUSE_XP =                        "Solo con PE casa"
L.ONLY_HOUSE_XP_ICON_DESC =              "Mostra l'icona solo per gli arredi che forniscono PE della casa."

L.OTHER_INFORMATION =                    "Altre informazioni"
L.QUEST_REWARD_SELL_VALUE =              "Valore di vendita ricompense missioni"
L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "Mostra un'icona sulla ricompensa di missione con il maggiore valore di vendita, se ce ne sono più d'una."
L.USABLE_ITEMS =                         "Oggetti utilizzabili"
L.USABLE_ITEMS_ICON_DESC =               "Mostra un'icona per oggetti utilizzabili (conoscenza professionale, personalizzazioni sbloccabili e libri degli incantesimi)."
L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
L.CONTAINERS_ICON_DESC =                 "Mostra un'icona per oggetti apribili, come forzieri chiusi e sacche dei boss degli eventi."

L.LOOT_TRACKER =                         "Tracciamento bottino"
L.SHOW_MINIMAP_ICON =                    "Mostra icona minimappa"
L.SHOW_MINIMAP_ICON_DESC =               "Mostra l'icona sulla minimappa. Se disattivata, %s rimane disponibile dal Comparto addon." -- %s becomes the addon name
L.AUTO_OPEN_WINDOW =                     "Apri automaticamente la finestra"
L.AUTO_OPEN_WINDOW_DESC =                "Mostra automaticamente la finestra di %s quando ottieni un oggetto idoneo." -- %s becomes the addon name
L.COLLECTION_MODE =                      "Modalità collezione"
L.COLLECTION_MODE_DESC =                 "Imposta quando %s deve mostrare le nuove trasmogrificazioni ottenute dagli altri." -- %s becomes the addon name
L.COLLECTION_MODE_APPEARANCES_DESC =     "Mostra solo oggetti con un nuovo aspetto."
L.COLLECTION_MODE_SOURCES_DESC =         "Mostra gli oggetti con una nuova fonte, anche per aspetti già conosciuti."
L.RARITY =                               RARITY -- "Rarity"
L.RARITY_SETTING_DESC =                  "Imposta da quale qualità in poi %s deve mostrare il bottino." -- %s becomes the addon name
L.WHISPER_MESSAGE =                      "Messaggio sussurrato"
L.CUSTOMIZE =                            "Personalizza"
L.WHISPER_CUSTOMIZE_DESC1 =              "Personalizza il messaggio sussurrato"
L.WHISPER_CUSTOMIZE_DESC2 =              "Personalizza il tuo messaggio sussurrato:"
L.WHISPER_POPUP_ERROR =                  "Il messaggio non include %s" -- %s becomes "%item"
L.WHISPER_POPUP_SUCCESS =                "Messaggio aggiornato:"

L.TWEAKS =                               "Ottimizzazioni"
L.INSTANT_CATALYST =                     "Catalizzatore istantaneo"
L.INSTANT_CATALYST_DESC =                "Tieni premuto Maiusc per catalizzare subito un oggetto, saltando il timer di 5 secondi."
L.INSTANT_VAULT =                        "Gran Banca istantanea"
L.INSTANT_VAULT_DESC =                   "Tieni premuto Maiusc per ricevere subito la ricompensa della Gran Banca, saltando il timer di 5 secondi."
L.SHOW_TOOLTIP =                         "Mostra tooltip"
L.SHOW_TOOLTIP_SETTING_DESC =            "Mostra il tooltip che spiega come funziona questa opzione. Il testo del pulsante cambia comunque quando è disattivata."
L.DISABLE_VENDOR_FILTER =                "Disattiva filtro venditore"
L.DISABLE_VENDOR_FILTER_DESC =           "Imposta automaticamente tutti i filtri dei venditori su \"Tutti\" per mostrare gli oggetti normalmente nascosti alla tua classe."
L.HIDE_LOOT_ROLL_WINDOW =                "Nascondi la finestra dei tiri del bottino"
L.HIDE_LOOT_ROLL_WINDOW_DESC =           "Nasconde la finestra dei tiri del bottino e dei risultati. Puoi mostrarla di nuovo con %s." -- %s becomes "/loot"

-- Item overlay
L.BINDTEXT_WUE =                         "Vincolato alla Brigata fino all'equipaggiamento" -- Abbreviation for "Warbound until Equipped"
L.BINDTEXT_BOP =                         "Vincolato alla raccolta" -- Abbreviation for "Binds on Pickup"
L.BINDTEXT_BOE =                         "Vincolato all'equipaggiamento" -- Abbreviation for "Binds on Equip"
L.BINDTEXT_BOA =                         "Vincolato all'account" -- Abbreviation for "Binds to Account" (Warbound)
L.RECIPE_UNCACHED =                      "Apri questa professione per aggiornare lo stato della ricetta nella collezione."
L.LEARN_UNBOUND =                        "Vendi, distruggi o disincanta questo oggetto per apprenderne l'aspetto."
L.BUGGED_ITEM =                          "Questo oggetto è difettoso e il suo aspetto potrebbe non essere apprendibile."

-- Loot tracker
L.DEFAULT_MESSAGE =                      "Ti serve l'oggetto %item che hai ottenuto? Se no, mi piacerebbe averlo per la trasmogrificazione. :)"

L.CLOSE_WINDOW =                         "Chiudi finestra"
L.LOCK_WINDOW =                          "Blocca finestra"
L.UNLOCK_WINDOW =                        "Sblocca finestra"
L.CLEAR_ALL_ITEMS =                      "Rimuovi tutti gli oggetti"
L.HOLD_SHIFT_TO_SKIP =                   "Tieni premuto Maiusc per saltare la conferma"
L.SORT_NEW =                             "Ordina dal più recente"
L.SORT_ALPHABETICAL =                    "Ordina alfabeticamente"
L.SORTED_CURRENT =                       "Ordinamento attuale:"
L.SORTED_ALPHABETICAL =                  "alfabetico"
L.SORTED_NEW =                           "più recenti prima"
L.CLEAR_CONFIRM =                        "Vuoi cancellare tutto il bottino?"
L.DOUBLE =                               "Doppio" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Maiusc" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "Ridimensiona automaticamente alla finestra"
L.WHISPER_AND_REQUEST_ITEM =             "Sussurra e richiedi l'oggetto"
L.LINK_ITEM =                            "Collega l'oggetto"
L.REMOVE_ITEM =                          "Rimuovi l'oggetto"
L.DEBUG_ITEM =                           "Esegui debug di questo oggetto"

L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
L.FILTERED =                             "Filtrato"
L.PLAYER_COLLECTED_APPEARANCE =          "aspetto di questo oggetto collezionato" -- Preceded by a character name
L.PLAYER_WHISPERED =                     "è stato contattato da utenti di %s" -- %s becomes the addon name
L.WHISPERED_TIME =                       "tempo"
L.WHISPERED_TIMES =                      "volte"
L.WHISPER_COOLDOWN =                     "Puoi sussurrare a un giocatore solo una volta ogni 30 secondi per oggetto."
L.FILTER_REASON_UNTRADEABLE =            "Non commerciabile"
L.FILTER_REASON_RARITY =                 "Rarità troppo bassa"
L.FILTER_REASON_KNOWN =                  "Aspetto conosciuto"

-- Recipes
L.DELETED_ENTRIES =                      "Voci eliminate:"
L.DELETED_REMOVED =                      "Collezionabili unici rimossi:"

-- Tweaks
L.GET_IT_NOW =                           "Ottienilo ora!"
L.HOLD_SHIFT_TOOLTIP =                   "Tieni premuto Maiusc per ricevere subito il tuo oggetto, saltando il timer di 5 secondi."
