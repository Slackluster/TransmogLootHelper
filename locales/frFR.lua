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
L.INVALID_COMMAND =                      "Commande invalide."
L.DELETED_ENTRIES =                      "Entrées supprimées :"
L.DELETED_REMOVED =                      "Objets uniques supprimés :"

-- Version comms
L.NEW_VERSION_AVAILABLE =                "Une nouvelle version de " .. app.NameLong .. " est disponible :"

-- Item overlay
L.BINDTEXT_WUE =                         "LaB" -- Lié au Bataillon
L.BINDTEXT_BOP =                         "LqR" -- Lié quand Ramassé
L.BINDTEXT_BOE =                         "LqÉ" -- Lié quand équipé
L.BINDTEXT_BOA =                         "LaC" -- Lié au Compte
L.RECIPE_UNCACHED =                      "Veuillez ouvrir ce métier pour mettre à jour le statut de la recette."

-- Loot tracker
L.DEFAULT_MESSAGE =                      "As-tu besoin de %item que tu as récupéré ? Sinon, je le veux bien pour transmogrification. :)"
L.CLEAR_CONFIRM =                        "Souhaitez-vous effacer tout le butin ?"

L.WINDOW_BUTTON_CLOSE =                  "Fermer la fenêtre"
L.WINDOW_BUTTON_LOCK =                   "Verrouiller la fenêtre"
L.WINDOW_BUTTON_UNLOCK =                 "Déverrouiller la fenêtre"
L.WINDOW_BUTTON_SETTINGS =               "Ouvrir les paramètres"
L.WINDOW_BUTTON_CLEAR =                  "Effacer tous les objets\nMaintenir Maj pour ignorer la confirmation"
L.WINDOW_BUTTON_SORT1 =                  "Trier du plus récent au plus ancien\nTri actuel :|cffFFFFFF alphabétique|r"
L.WINDOW_BUTTON_SORT2 =                  "Trier par ordre alphabétique\nTri actuel :|cffFFFFFF plus récent d'abord|r"
L.WINDOW_BUTTON_CORNER =                 "Double " .. app.IconLMB .. "|cffFFFFFF : ajuster automatiquement la taille de la fenêtre|r"

L.WINDOW_HEADER_LOOT_DESC =              "|rAlt " .. app.IconLMB .. "|cffFFFFFF : chuchoter et demander l'objet\n" ..
                                         "|rMaj " .. app.IconLMB .. "|cffFFFFFF : lier l'objet\n" ..
                                         "|rMaj " .. app.IconRMB .. "|cffFFFFFF : supprimer l'objet"
L.WINDOW_HEADER_FILTERED =               "Filtré"
L.WINDOW_HEADER_FILTERED_DESC =          "|r" .. app.IconRMB .. "|cffFFFFFF : déboguer cet objet\n" ..
                                         "|rMaj " .. app.IconLMB .. "|cffFFFFFF : lier l'objet\n" ..
                                         "|rMaj " .. app.IconRMB .. "|cffFFFFFF : supprimer l'objet"

L.PLAYER_COLLECTED_APPEARANCE =          "a obtenu une apparence avec cet objet"
L.PLAYER_WHISPERED =                     "a été contacté par des utilisateurs de " .. app.NameShort
L.WHISPERED_TIME =                       "fois"
L.WHISPERED_TIMES =                      "fois"
L.WHISPER_COOLDOWN =                     "Vous ne pouvez chuchoter à un joueur qu'une fois toutes les 30 secondes par objet."

L.FILTER_REASON_UNTRADEABLE =            "Non échangeable"
L.FILTER_REASON_RARITY =                 "Rareté trop faible"
L.FILTER_REASON_KNOWN =                  "Apparence déjà connue"

-- Tweaks
L.INSTANT_BUTTON =                       "Obtenir maintenant !"
L.INSTANT_TOOLTIP =                      "Maintenir Maj pour recevoir instantanément l'objet et ignorer les 5 secondes."

-- Settings
L.SETTINGS_TOOLTIP =                     app.NameLong .. "\n|cffFFFFFF" ..
                                         app.IconLMB .. " : afficher / masquer la fenêtre\n" ..
                                         app.IconRMB .. " : " .. L.WINDOW_BUTTON_SETTINGS

L.SETTINGS_VERSION =                     GAME_VERSION_LABEL .. ":" -- "Version"
L.SETTINGS_SUPPORT_TEXTLONG =            "Le développement de cette extension demande beaucoup de temps et d'efforts.\nVeuillez envisager de soutenir financièrement le développeur."
L.SETTINGS_SUPPORT_TEXT =                "Soutien"
L.SETTINGS_SUPPORT_BUTTON =              "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =                "Merci !"
L.SETTINGS_HELP_TEXT =                   "Commentaires et aide"
L.SETTINGS_HELP_BUTTON =                 "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =                   "Rejoignez le serveur Discord."
L.SETTINGS_URL_COPY =                    "Ctrl + C pour copier :"
L.SETTINGS_URL_COPIED =                  "Lien copié dans le presse-papiers"

L.SETTINGS_KEYSLASH_TITLE =              SETTINGS_KEYBINDINGS_LABEL .. " & Commandes « Slash »" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. " : afficher / masquer la fenêtre"
L.SETTINGS_SLASH_TOGGLE =                "Afficher / masquer la fenêtre de suivi"
L.SETTINGS_SLASH_RESETPOS =              "Réinitialiser la position de la fenêtre"
L.SETTINGS_SLASH_WHISPER_DEFAULT =       "Réinitialiser le message chuchoté"
L.SETTINGS_SLASH_DELETE_DESC =           "Marquer les recettes uniques d'un personnage comme non apprises"
L.SETTINGS_SLASH_CHARREALM =             "Personnage-Royaume"

L.REQUIRES_RELOAD =                      "|cffFF0000" .. REQUIRES_RELOAD .. ".|r\n\nUtilisez |cffFFFFFF/reload|r ou reconnectez-vous." -- "Requires Reload"

L.GENERAL =                              GENERAL -- "General"
L.SETTINGS_ITEM_OVERLAY =                "Overlay sur les objets"
L.SETTINGS_BAGANATOR =                   "Pour les utilisateurs de Baganator, ceci est géré dans ses paramètres."
L.SETTINGS_ITEM_OVERLAY_DESC =           "Afficher une icône et du texte sur les objets pour indiquer leur statut.\n\n" .. L.REQUIRES_RELOAD
L.SETTINGS_ICON_POSITION =               "Position de l'icône"
L.SETTINGS_ICON_POSITION_DESC =          "Choisir le coin d'affichage de l'icône."
L.SETTINGS_ICONPOS_TL =                  "Haut gauche"
L.SETTINGS_ICONPOS_TR =                  "Haut droite"
L.SETTINGS_ICONPOS_BL =                  "Bas gauche"
L.SETTINGS_ICONPOS_BR =                  "Bas droite"
L.SETTINGS_ICONPOS_OVERLAP0 =            "Aucun problème de chevauchement connu."
L.SETTINGS_ICONPOS_OVERLAP1 =            "Cela peut recouper la qualité d'un objet artisanal."
L.SETTINGS_ICON_STYLE =                  "Style de l'icône"
L.SETTINGS_ICON_STYLE_DESC =             "Style de l'icône de statut."
L.SETTINGS_ICON_STYLE1 =                 "Cercle décoratif"
L.SETTINGS_ICON_STYLE1_DESC =            "Icône de type avec bordure d'état arrondie dans le coin"
L.SETTINGS_ICON_STYLE2 =                 "Cercle simple"
L.SETTINGS_ICON_STYLE2_DESC =            "Icône d'état avec fond rond uni dans un coin"
L.SETTINGS_ICON_STYLE3 =                 "Icône simple"
L.SETTINGS_ICON_STYLE3_DESC =            "Icône d'état dans le coin"
L.SETTINGS_ICON_STYLE4 =                 "Icône cosmétique"
L.SETTINGS_ICON_STYLE4_DESC =            "Bordure d'état dans le coin (sans animation)"
L.SETTINGS_ICON_ANIMATE =                "Animation de l'icône"
L.SETTINGS_ICON_ANIMATE_DESC =           "Afficher une animation tourbillonnante sur les objets utilisables / apprenables."
L.SETTINGS_ICONLEARNED =                 "Icône appris"
L.SETTINGS_ICONLEARNED_DESC =            "Afficher une icône pour indiquer que les objets à collectionner ci-dessous ont été appris."
L.DEFAULT =                              CHAT_DEFAULT -- Default
L.SETTINGS_ICONLEARNED_DESC2 =           "Vous pouvez définir un style distinct pour les icônes apprises."
L.SETTINGS_BINDTEXT =                    "Texte de liaison"
L.SETTINGS_BINDTEXT_DESC =               "Afficher un indicateur de texte pour les objets liés quand équipé (LqÉ), les objets liés au bataillon (LaB) et les objets liés au batailloin jusqu'à l'équipement (LaB).."
L.SETTINGS_PREVIEW =                     "Aperçu :"
L.SETTINGS_UNLEARNED =                   PROFESSIONS_CATEGORY_UNLEARNED -- Unlearned
L.SETTINGS_USABLE =                      "Utilisable"
L.SETTINGS_LEARNED =                     PROFESSIONS_CATEGORY_LEARNED -- Learned
L.SETTINGS_UNUSABLE =                    MOUNT_JOURNAL_FILTER_UNUSABLE -- Unusable
L.SETTINGS_PREVIEWTOOLTIP = {}
L.SETTINGS_PREVIEWTOOLTIP[1] =           "Les objets non appris sont entièrement nouveaux pour votre collection."
L.SETTINGS_PREVIEWTOOLTIP[2] =           "Les objets utilisables incluent, par exemple, les conteneurs, de nouvelles sources pour des apparences déjà connues, etc."
L.SETTINGS_PREVIEWTOOLTIP[3] =           "Les objets appris sont déjà présents dans votre collection."
L.SETTINGS_PREVIEWTOOLTIP[4] =           "Les objets non utilisables incluent, par exemple, les conteneurs verrouillés, les recettes pour un métier que vous ne possédez pas, etc."

L.SETTINGS_HEADER_COLLECTION =           "Informations de collection"
L.SETTINGS_ICON_NEW_MOG =                "Apparences"
L.SETTINGS_ICON_NEW_MOG_DESC =           "Afficher une icône pour indiquer qu'une apparence n'est pas encore apprise."
L.SETTINGS_ICON_NEW_SOURCE =             "Sources"
L.SETTINGS_ICON_NEW_SOURCE_DESC =        "Afficher une icône pour indiquer que la source d'un objet n'est pas encore apprise."
L.SETTINGS_ICON_NEW_CATALYST =           "Catalyseur"
L.SETTINGS_ICON_NEW_CATALYST_DESC =      "Afficher une icône lorsqu'un objet catalysé confère une nouvelle apparence."
L.SETTINGS_ICON_NEW_UPGRADE =            "Amélioration"
L.SETTINGS_ICON_NEW_UPGRADE_DESC =       "Afficher une icône lorsqu'une amélioration d'objet confère une nouvelle apparence."
L.SETTINGS_ICON_NEW_ILLUSION =           "Illusions"
L.SETTINGS_ICON_NEW_ILLUSION_DESC =      "Afficher une icône pour indiquer qu'une illusion n'est pas encore apprise."
L.SETTINGS_ICON_NEW_MOUNT =              "Montures"
L.SETTINGS_ICON_NEW_MOUNT_DESC =         "Afficher une icône pour indiquer qu'une monture n'est pas encore apprise."
L.SETTINGS_ICON_NEW_PET =                "Mascottes"
L.SETTINGS_ICON_NEW_PET_DESC =           "Afficher une icône pour indiquer qu'une mascotte n'est pas encore apprise."
L.SETTINGS_ICON_NEW_PET_MAX =            "Collecter 3/3"
L.SETTINGS_ICON_NEW_PET_MAX_DESC =       "Tenir également compte du nombre maximum de mascottes que vous pouvez posséder (généralement 3)."
L.SETTINGS_ICON_NEW_TOY =                "Jouets"
L.SETTINGS_ICON_NEW_TOY_DESC =           "Afficher une icône pour indiquer qu'un jouet n'est pas encore appris."
L.SETTINGS_ICON_NEW_RECIPE =             "Recettes"
L.SETTINGS_ICON_NEW_RECIPE_DESC =        "Afficher une icône pour indiquer qu'une recette n'est pas encore apprise."
L.SETTINGS_ICON_NEW_DECOR =              "Décor"
L.SETTINGS_ICON_NEW_DECOR_DESC =         "Afficher une icône pour indiquer que vous ne possédez pas l'objet de décoration pour votre logement."
L.SETTINGS_ICON_NEW_DECORXP =            "Uniquement avec l'XP de logis"
L.SETTINGS_ICON_NEW_DECORXP_DESC =       "Afficher une icône pour les décorations de logement qui confèrent de l'XP de logis."

L.SETTINGS_HEADER_OTHER_INFO =           "Autres informations"
L.SETTINGS_ICON_QUEST_GOLD =             "Valeur de revente des récompenses de quête"
L.SETTINGS_ICON_QUEST_GOLD_DESC =        "Afficher une icône indiquant quelle récompense de quête a la plus grande valeur de revente auprès des vendeurs, s'il y en a plusieurs."
L.SETTINGS_ICON_USABLE =                 "Objets utilisables"
L.SETTINGS_ICON_USABLE_DESC =            "Afficher une icône pour indiquer qu'un objet peut être utilisé (connaissances de métier, personnalisations déverrouillables et grimoires)."
L.SETTINGS_ICON_OPENABLE =               "Objets ouvrables"
L.SETTINGS_ICON_OPENABLE_DESC =          "Afficher une icône pour indiquer qu'un objet peut être ouvert, comme les coffrets verrouillés et les sacs de boss d'événements."

L.SETTINGS_HEADER_LOOT_TRACKER =         "Suivi du butin"
L.SETTINGS_MINIMAP_TITLE =               "Afficher l'icône de la mini-carte"
L.SETTINGS_MINIMAP_DESC =                "Afficher l'icône sur la mini-carte. Si vous la désactivez, " .. app.NameShort .. " reste accessible via le compartiment des addons."
L.SETTINGS_AUTO_OPEN =                   "Ouverture automatique de la fenêtre"
L.SETTINGS_AUTO_OPEN_DESC =              "Afficher automatiquement la fenêtre " .. app.NameShort .. " lorsqu'un objet éligible est récupéré."
L.SETTINGS_COLLECTION_MODE =             "Mode de collection"
L.SETTINGS_COLLECTION_MODE_DESC =        "Définit quand " .. app.NameShort .. " doit afficher les nouvelles transmogrifications obtenues par d'autres."
L.SETTINGS_MODE_APPEARANCES =            "Apparences"
L.SETTINGS_MODE_APPEARANCES_DESC =       "Afficher les objets uniquement s'ils ont une nouvelle apparence."
L.SETTINGS_MODE_SOURCES =                "Sources"
L.SETTINGS_MODE_SOURCES_DESC =           "Afficher les objets s'il s'agit d'une nouvelle source, y compris pour les apparences connues."
L.SETTINGS_RARITY =                      "Qualité"
L.SETTINGS_RARITY_DESC =                 "Définit à partir de quelle qualité " .. app.NameShort .. " doit afficher le butin."
L.SETTINGS_WHISPER =                     "Message chuchoté"
L.SETTINGS_WHISPER_CUSTOMIZE =           "Personnaliser"
L.SETTINGS_WHISPER_CUSTOMIZE_DESC =      "Personnaliser le message chuchoté"
L.WHISPER_POPUP_CUSTOMIZE =              "Personnalisez votre message chuchoté :"
L.WHISPER_POPUP_ERROR =                  "Le message ne contient pas |cff3FC7EB%item|r. Le message n'a pas été mis à jour."
L.WHISPER_POPUP_SUCCESS =                "Le message a été mis à jour."

L.SETTINGS_HEADER_TWEAKS =               "Ajustements"
L.SETTINGS_CATALYST =                    "Catalyseur instantané"
L.SETTINGS_CATALYST_DESC =               "Maintenez Maj enfoncée pour catalyser instantanément un objet, sans attendre les 5 secondes."
L.SETTINGS_VAULT =                       "Coffre hebdomadaire instantané"
L.SETTINGS_VAULT_DESC =                  "Maintenez Maj enfoncée pour recevoir instantanément votre récompense du Coffre hebdomadaire, sans attendre les 5 secondes."
L.SETTINGS_INSTANT_TOOLTIP =             "Afficher l'info-bulle"
L.SETTINGS_INSTANT_TOOLTIP_DESC =        "Afficher l'info-bulle expliquant le fonctionnement de cette fonctionnalité. Le texte du bouton change toujours même si cette option est désactivée."
L.SETTINGS_VENDOR_ALL =                  "Désactiver le filtre des vendeurs"
L.SETTINGS_VENDOR_ALL_DESC =             "Définit automatiquement les filtres des vendeurs sur |cffFFFFFFTous|r afin d'afficher les objets normalement non visibles pour votre classe."
L.SETTINGS_HIDE_LOOT_ROLL_WINDOW =       "Masquer la fenêtre de jet de butin"
L.SETTINGS_HIDE_LOOT_ROLL_WINDOW_DESC =  "Masque la fenêtre affichant les jets de butin et leurs résultats. Vous pouvez la réafficher avec |cff00ccff/loot|r."
