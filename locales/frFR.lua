------------------------------------
-- Transmog Loot Helper: frFR.lua --
------------------------------------
-- French (France) localisation
-- Translator(s): Klep-Ysondre

if GetLocale() ~= "frFR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Une nouvelle version de %s est disponible :" -- %s becomes the addon name

L.INVALID_COMMAND =                      "Commande invalide."

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Le développement de cette extension demande beaucoup de temps et d’efforts."
L.SUPPORT_TEXTLONG2 =                    "Veuillez envisager de soutenir financièrement le développeur."
L.SUPPORT =                              "Soutien"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Merci !"
L.FEEDBACK_AND_HELP =                    "Commentaires et aide"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Rejoignez le serveur Discord."
L.CTRL_C_COPY =                          "Ctrl + C pour copier :"
L.LINK_COPIED =                          "Lien copié dans le presse-papiers"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & Commandes « Slash »" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. " : afficher / masquer la fenêtre"
L.TOGGLE_TRACKING_WINDOW =               "Afficher / masquer la fenêtre de suivi"
L.RESET_WINDOW_POSITION =                "Réinitialiser la position de la fenêtre"
L.OPEN_SETTINGS =                        "Ouvrir les paramètres"
L.CHARACTER_REALM =                      "Personnage-Royaume"
L.DELETE_CHAR_RECIPES =                  "Marquer les recettes uniques d'un personnage comme non apprises"
L.WHISPER_SET_DEFAULT =                  "Réinitialiser le message chuchoté"

L.GENERAL =                              GENERAL -- "General"
L.ITEM_OVERLAY =                         "Overlay sur les objets"
L.ITEM_OVERLAY_DESC =                    "Afficher une icône et du texte sur les objets pour indiquer leur statut."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.ICON_POSITION =                        "Position de l'icône"
L.ICON_POSITION_DESC =                   "Choisir le coin d'affichage de l'icône."
L.BAGANATOR_SETTINGS =                   "Pour les utilisateurs de Baganator, ceci est géré dans ses paramètres."
L.TOP_LEFT =                             "Haut gauche"
L.TOP_RIGHT =                            "Haut droite"
L.BOTTOM_LEFT =                          "Bas gauche"
L.BOTTOM_RIGHT =                         "Bas droite"
L.OVERLAP_ISSUES_NONE =                  "Aucun problème de chevauchement connu."
L.OVERLAP_ISSUES_QUALITY =               "Cela peut recouper la qualité d'un objet artisanal."
L.ICON_STYLE =                           "Style de l'icône"
L.ICON_STYLE_DESC =                      "Style de l'icône de statut."
L.ICON_STYLE_FANCYCIRCLE =               "Cercle décoratif"
L.ICON_STYLE_FANCYCIRCLE_DESC =          "Icône de type avec bordure d'état arrondie dans le coin"
L.ICON_STYLE_SIMPLECIRCLE =              "Cercle simple"
L.ICON_STYLE_SIMPLECIRCLE_DESC =         "Icône d'état avec fond rond uni dans un coin"
L.ICON_STYLE_SIMPLEICON =                "Icône simple"
L.ICON_STYLE_SIMPLEICON_DESC =           "Icône d'état dans le coin"
L.ICON_STYLE_COSMETICICON =              "Icône cosmétique"
L.ICON_STYLE_COSMETICICON_DESC =         "Bordure d'état dans le coin (sans animation)"
L.ICON_ANIMATION =                       "Animation de l'icône"
L.ICON_ANIMATION_DESC =                  "Afficher une animation tourbillonnante sur les objets utilisables / apprenables."
L.ICON_LEARNED =                         "Icône appris"
L.ICON_LEARNED_DESC =                    "Afficher une icône pour indiquer que les objets à collectionner ci-dessous ont été appris."
L.DEFAULT =                              CHAT_DEFAULT -- Default
L.ICON_LEARNED_DESC2 =                   "Vous pouvez définir un style distinct pour les icônes apprises."
L.BINDING_TEXT =                         "Texte de liaison"
L.BINDING_TEXT_DESC =                    "Afficher un indicateur de texte pour les objets liés quand équipé (LqÉ), les objets liés au bataillon (LaB) et les objets liés au batailloin jusqu'à l'équipement (LaB)."

L.PREVIEW =                              "Aperçu :"
L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- Unlearned
L.USABLE =                               "Utilisable"
L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- Learned
L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- Unusable
L.PREVIEW_TOOLTIP = {}
L.PREVIEW_TOOLTIP[1] =                   "Les objets non appris sont entièrement nouveaux pour votre collection."
L.PREVIEW_TOOLTIP[2] =                   "Les objets utilisables incluent, par exemple, les conteneurs, de nouvelles sources pour des apparences déjà connues, etc."
L.PREVIEW_TOOLTIP[3] =                   "Les objets appris sont déjà présents dans votre collection."
L.PREVIEW_TOOLTIP[4] =                   "Les objets non utilisables incluent, par exemple, les conteneurs verrouillés, les recettes pour un métier que vous ne possédez pas, etc."

L.COLLECTION_INFO =                      "Informations de collection"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_ICON_DESC =                "Afficher une icône pour indiquer qu'une apparence n'est pas apprise."
L.APPEARANCE_SOURCES =                   "Sources"
L.APPEARANCE_SOURCES_ICON_DESC =         "Afficher une icône pour indiquer qu'une source d'apparence d'objet n'est pas apprise."
-- L.CATALYST =                             "Catalyst"
L.CATALYST_ICON_DESC =                   "Afficher une icône lorsqu'un objet à catalysé confère une nouvelle apparence."
-- L.UPGRADE =                              "Upgrade"
L.UPGRADE_ICON_DESC =                    "Afficher une icône lorsqu'une amélioration d'objet confère une nouvelle apparence."
L.ILLUSIONS =                            "Illusions"
L.ILLUSIONS_ICON_DESC =                  "Afficher une icône pour indiquer qu'une illusion n'est pas apprise."
-- L.MOUNTS =                               MOUNTS -- "Mounts"
L.MOUNTS_ICON_DESC =                     "Afficher une icône pour indiquer qu'une monture n'est pas apprise."
-- L.PETS =                                 PETS -- "Pets"
L.PETS_ICON_DESC =                       "Afficher une icône pour indiquer qu'une mascotte n'est pas apprise."
L.PETS_COLLECT_MAX =                     "Collecter 3/3"
L.PETS_COLLECT_MAX_ICON_DESC =           "Tenir compte du nombre maximum de mascottes que vous pouvez posséder (généralement 3)."
L.TOYS =                                 "Jouets"
L.TOYS_ICON_DESC =                       "Afficher une icône pour indiquer qu'un jouet n'est pas appris."
-- L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.RECIPES_ICON_DESC =                    "Afficher une icône pour indiquer qu'une recette n'est pas apprise."
-- L.TRACK_PER_CHARACTER =                  "Track per Character"
-- L.TRACK_PER_CHARACTER_ICON_DESC =        "Show learned recipes as learnable for alts."
-- L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
L.DECOR_ICON_DESC =                      "Afficher une icône pour indiquer qu'un objet de décoration pour votre logis n'est pas appris."
L.ONLY_HOUSE_XP =                        "Seulement avec l'XP du logis"
L.ONLY_HOUSE_XP_ICON_DESC =              "Afficher une icône pour les décorations de logement qui confèrent de l'expérience pour le logis."

L.OTHER_INFORMATION =                    "Autres informations"
L.QUEST_REWARD_SELL_VALUE =              "Valeur de revente des récompenses de quête"
L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "Afficher une icône indiquant quelle récompense de quête a la plus grande valeur de revente auprès des vendeurs, s'il y en a plusieurs."
L.USABLE_ITEMS =                         "Objets utilisables"
L.USABLE_ITEMS_ICON_DESC =               "Afficher une icône pour indiquer qu'un objet peut être utilisé (connaissances de métier, personnalisations déverrouillables et grimoires)."
-- L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
L.CONTAINERS_ICON_DESC =                 "Afficher une icône pour indiquer qu'un objet peut être ouvert, comme les coffrets verrouillés et les sacs de boss d'événements."

L.LOOT_TRACKER =                         "Suivi du butin"
L.SHOW_MINIMAP_ICON =                    "Afficher l'icône de la mini-carte"
L.SHOW_MINIMAP_ICON_DESC =               "Afficher l'icône sur la mini-carte. Si vous la désactivez, %s reste accessible via le compartiment des addons." -- %s becomes the addon name
L.AUTO_OPEN_WINDOW =                     "Ouverture automatique de la fenêtre"
L.AUTO_OPEN_WINDOW_DESC =                "Afficher automatiquement la fenêtre %s lorsqu'un objet éligible est récupéré." -- %s becomes the addon name
L.COLLECTION_MODE =                      "Mode de collection"
L.COLLECTION_MODE_DESC =                 "Définit quand %s doit afficher les nouvelles transmogrifications obtenues par d'autres." -- %s becomes the addon name
L.COLLECTION_MODE_APPEARANCES_DESC =     "Afficher les objets uniquement s'ils ont une nouvelle apparence."
L.COLLECTION_MODE_SOURCES_DESC =         "Afficher les objets s'il s'agit d'une nouvelle source, y compris pour les apparences connues."
-- L.RARITY =                               RARITY -- "Rarity"
L.RARITY_SETTING_DESC =                  "Définit à partir de quelle qualité %s doit afficher le butin." -- %s becomes the addon name
L.WHISPER_MESSAGE =                      "Message chuchoté"
L.CUSTOMIZE =                            "Personnaliser"
L.WHISPER_CUSTOMIZE_DESC1 =              "Personnaliser le message chuchoté"
L.WHISPER_CUSTOMIZE_DESC2 =              "Personnalisez votre message chuchoté :"
L.WHISPER_POPUP_ERROR =                  "Le message ne contient pas %s" -- %s becomes "%item"
L.WHISPER_POPUP_SUCCESS =                "Le message a été mis à jour :"

L.TWEAKS =                               "Ajustements"
L.INSTANT_CATALYST =                     "Catalyseur instantané"
L.INSTANT_CATALYST_DESC =                "Maintenez Maj enfoncée pour catalyser instantanément un objet, sans attendre les 5 secondes."
L.INSTANT_VAULT =                        "Coffre hebdomadaire instantané"
L.INSTANT_VAULT_DESC =                   "Maintenez Maj enfoncée pour recevoir instantanément votre récompense du Coffre hebdomadaire, sans attendre les 5 secondes."
L.SHOW_TOOLTIP =                         "Afficher l'infobulle"
L.SHOW_TOOLTIP_SETTING_DESC =            "Afficher l'infobulle expliquant le fonctionnement de cette fonctionnalité. Le texte du bouton change toujours même si cette option est désactivée."
L.DISABLE_VENDOR_FILTER =                "Désactiver le filtre des vendeurs"
L.DISABLE_VENDOR_FILTER_DESC =           "Définit automatiquement les filtres des vendeurs sur |cffFFFFFFTous|r afin d'afficher les objets normalement non visibles pour votre classe."
L.HIDE_LOOT_ROLL_WINDOW =                "Masquer la fenêtre de jet de butin"
L.HIDE_LOOT_ROLL_WINDOW_DESC =           "Masquer la fenêtre des jets de butin et leurs résultats. Vous pouvez la réafficher avec %s." -- %s becomes "/loot"

-- Item overlay
L.BINDTEXT_WUE =                         "LaB" -- Lié au Bataillon
L.BINDTEXT_BOP =                         "LqR" -- Lié quand Ramassé
L.BINDTEXT_BOE =                         "LqÉ" -- Lié quand équipé
L.BINDTEXT_BOA =                         "LaC" -- Lié au Compte
L.RECIPE_UNCACHED =                      "Veuillez ouvrir ce métier pour mettre à jour le statut de la recette."

-- Loot tracker
L.DEFAULT_MESSAGE =                      "As-tu besoin de %item que tu as récupéré ? Sinon, je le veux bien pour transmogrification. :)"

L.CLOSE_WINDOW =                         "Fermer la fenêtre"
L.LOCK_WINDOW =                          "Verrouiller la fenêtre"
L.UNLOCK_WINDOW =                        "Déverrouiller la fenêtre"
L.CLEAR_ALL_ITEMS =                      "Effacer tous les objets"
L.HOLD_SHIFT_TO_SKIP =                   "Maintenir Maj pour ignorer la confirmation"
L.SORT_NEW =                             "Trier du plus récent au plus ancien"
L.SORT_ALPHABETICAL =                    "Trier par ordre alphabétique"
L.SORTED_CURRENT =                       "Tri actuel :"
L.SORTED_ALPHABETICAL =                  "alphabétique"
L.SORTED_NEW =                           "plus récent d'abord"
L.CLEAR_CONFIRM =                        "Souhaitez-vous effacer tout le butin ?"
L.DOUBLE =                               "Double" -- Followed by RMB or LMB
-- L.CTRL =                                 "Ctrl" -- Followed by RMB or LMB
L.ALT =                                  "Alt" -- Followed by RMB or LMB
L.SHIFT =                                "Maj" -- Followed by RMB or LMB
L.AUTOSIZE_WINDOW =                      "ajuster automatiquement la taille de la fenêtre"
L.WHISPER_AND_REQUEST_ITEM =             "chuchoter et demander l'objet"
L.LINK_ITEM =                            "lier l'objet"
L.REMOVE_ITEM =                          "supprimer l'objet"
L.DEBUG_ITEM =                           "déboguer cet objet"

-- L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
-- L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
L.FILTERED =                             "Filtré"
L.PLAYER_COLLECTED_APPEARANCE =          "a obtenu une apparence avec cet objet"
L.PLAYER_WHISPERED =                     "a été contacté par des utilisateurs de %s" -- %s becomes the addon name
L.WHISPERED_TIME =                       "fois"
L.WHISPERED_TIMES =                      "fois"
L.WHISPER_COOLDOWN =                     "Vous ne pouvez chuchoter à un joueur qu'une fois toutes les 30 secondes par objet."
L.FILTER_REASON_UNTRADEABLE =            "Non échangeable"
L.FILTER_REASON_RARITY =                 "Rareté trop faible"
L.FILTER_REASON_KNOWN =                  "Apparence déjà connue"

-- Recipes
L.DELETED_ENTRIES =                      "Entrées supprimées :"
L.DELETED_REMOVED =                      "Objets uniques supprimés :"

-- Tweaks
L.GET_IT_NOW =                           "Obtenir maintenant !"
L.HOLD_SHIFT_TOOLTIP =                   "Maintenir Maj pour recevoir instantanément l'objet et ignorer les 5 secondes."
