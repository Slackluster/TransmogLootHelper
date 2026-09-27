------------------------------------
-- Transmog Loot Helper: esMX.lua --
------------------------------------
-- Spanish (Mexico) localisation
-- Translator(s): Ferran Carril

if GetLocale() ~= "esMX" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Hay una versión más nueva de %s disponible:" -- %s becomes the addon name

L.INVALID_COMMAND =                      "Comando no válido"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Desarrollar este addon requiere una cantidad significativa de tiempo y esfuerzo."
L.SUPPORT_TEXTLONG2 =                    "Por favor, considera apoyar financieramente al desarrollador."
L.SUPPORT =                              "Apoyar"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "¡Gracias!"
L.FEEDBACK_AND_HELP =                    "Comentarios y Ayuda"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Únete al servidor de Discord."
L.CTRL_C_COPY =                          "Ctrl+C para copiar:"
L.LINK_COPIED =                          "Enlace copiado al portapapeles"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " y Comandos" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. ": Activar/Desactivar ventana"
L.TOGGLE_TRACKING_WINDOW =               "Activar/Desactivar la ventana de seguimiento"
L.RESET_WINDOW_POSITION =                "Restablecer la posición de la ventana de seguimiento"
L.OPEN_SETTINGS =                        "Abrir opciones"
L.CHARACTER_REALM =                      "Personaje-Reino"
L.DELETE_CHAR_RECIPES =                  "Marcar recetas únicas de un personaje, etc. como no aprendidas"
L.WHISPER_SET_DEFAULT =                  "Establecer el mensaje de susurro a su valor predeterminado"

L.GENERAL =                              GENERAL -- "General"
L.ITEM_OVERLAY =                         "Superposición en objetos"
L.ITEM_OVERLAY_DESC =                    "Muestra un icono y texto en los objetos para indicar si son coleccionables y más."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.ICON_POSITION =                        "Posición del icono"
L.ICON_POSITION_DESC =                   "En qué esquina aparece el icono."
L.BAGANATOR_SETTINGS =                   "Para usuarios de Baganator, esto se gestiona mediante las opciones propias de Baganator."
L.TOP_LEFT =                             "Arriba izquierda"
L.TOP_RIGHT =                            "Arriba derecha"
L.BOTTOM_LEFT =                          "Abajo izquierda"
L.BOTTOM_RIGHT =                         "Abajo derecha"
L.OVERLAP_ISSUES_NONE =                  "Sin problemas de superposición conocidos."
L.OVERLAP_ISSUES_QUALITY =               "Esto puede superponerse con la calidad de un objeto creado."
L.ICON_STYLE =                           "Estilo de icono"
L.ICON_STYLE_DESC =                      "El estilo del icono de estado."
L.ICON_STYLE_FANCYCIRCLE =               "Círculo elegante"
L.ICON_STYLE_FANCYCIRCLE_DESC =          "Icono de tipo con borde de estado redondo"
L.ICON_STYLE_SIMPLECIRCLE =              "Círculo simple"
L.ICON_STYLE_SIMPLECIRCLE_DESC =         "Icono de estado con fondo redondo simple"
L.ICON_STYLE_SIMPLEICON =                "Icono simple"
L.ICON_STYLE_SIMPLEICON_DESC =           "Icono de estado"
L.ICON_STYLE_COSMETICICON =              "Icono cosmético"
L.ICON_STYLE_COSMETICICON_DESC =         "Borde de estado en la esquina (sin animación)"
L.ICON_ANIMATION =                       "Animación del icono"
L.ICON_ANIMATION_DESC =                  "Muestra una bonita animación de remolino en los iconos para los objetos aprendibles y utilizables."
L.ICON_LEARNED =                         "Icono de Aprendido"
L.ICON_LEARNED_DESC =                    "Muestra un icono para indicar que los objetos coleccionables rastreados a continuación se han aprendido."
L.DEFAULT =                              CHAT_DEFAULT -- "Default"
L.ICON_LEARNED_DESC2 =                   "Puedes establecer un estilo separado para los iconos de aprendidos."
L.BINDING_TEXT =                         "Texto de objetos ligados"
L.BINDING_TEXT_DESC =                    "Muestra un indicador de texto para los objetos que se ligan al equiparlos (BoE), objetos ligados a la banda guerrera (BoA) y ligados a la banda guerrera hasta que te equipas con ellos (WuE)."

L.PREVIEW =                              "Vista Previa:"
L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- "Unlearned"
L.USABLE =                               "Utilizable"
L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- "Learned"
L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- "Unusable"
L.PREVIEW_TOOLTIP = {}
L.PREVIEW_TOOLTIP[1] =                   "Objetos no aprendidos que son completamente nuevos en tu colección."
L.PREVIEW_TOOLTIP[2] =                   "Objetos utilizables como contenedores, nuevas fuentes para apariencias ya conocidas, etc."
L.PREVIEW_TOOLTIP[3] =                   "Objetos aprendidos que ya están en tu colección."
L.PREVIEW_TOOLTIP[4] =                   "Objetos que no se pueden usar como contenedores bloqueados, recetas para profesiones que no conoces, etc."

L.COLLECTION_INFO =                      "Información de colección"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_ICON_DESC =                "Muestra un icono para indicar que la apariencia de un objeto no se ha aprendido."
L.APPEARANCE_SOURCES =                   "Fuentes"
L.APPEARANCE_SOURCES_ICON_DESC =         "Muestra un icono para indicar que la fuente de apariencia de un objeto no se ha aprendido."
-- L.CATALYST =                             "Catalyst"
L.CATALYST_ICON_DESC =                   "Muestra un icono cuando al catalizar un objeto se obtenga una nueva apariencia."
-- L.UPGRADE =                              "Upgrade"
L.UPGRADE_ICON_DESC =                    "Muestra un icono cuando al mejorar un objeto se obtenga una nueva apariencia."
L.ILLUSIONS =                            "Ilusiones"
L.ILLUSIONS_ICON_DESC =                  "Muestra un icono para indicar que una ilusión no se ha aprendido."
-- L.MOUNTS =                               MOUNTS -- "Mounts"
L.MOUNTS_ICON_DESC =                     "Muestra un icono para indicar que una montura no se ha aprendido."
-- L.PETS =                                 PETS -- "Pets"
L.PETS_ICON_DESC =                       "Muestra un icono para indicar que una mascota no se ha aprendido."
L.PETS_COLLECT_MAX =                     "Conseguidos 3/3"
L.PETS_COLLECT_MAX_ICON_DESC =           "Ten en cuenta también el número máximo de mascotas que puedes poseer (normalmente 3)."
L.TOYS =                                 "Juguetes"
L.TOYS_ICON_DESC =                       "Muestra un icono para indicar que un juguete no se ha aprendido."
-- L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.RECIPES_ICON_DESC =                    "Muestra un icono para indicar que una receta no se ha aprendido."
-- L.TRACK_PER_CHARACTER =                  "Track per Character"
-- L.TRACK_PER_CHARACTER_ICON_DESC =        "Show learned recipes as learnable for alts."
-- L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
L.DECOR_ICON_DESC =                      "Muestra un icono para indicar que no posees un adorno de hogar."
L.ONLY_HOUSE_XP =                        "Solo con PE de casa"
L.ONLY_HOUSE_XP_ICON_DESC =              "Solo mostrar el icono para adornos de hogares que otorgan PE de casa."

L.OTHER_INFORMATION =                    "Otra información"
L.QUEST_REWARD_SELL_VALUE =              "Valor de venta de recompensa de misión"
L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "Mostrar un icono para indicar qué recompensa de misión, si hay varias, tiene el valor de venta más alto."
L.USABLE_ITEMS =                         "Objetos utilizables"
L.USABLE_ITEMS_ICON_DESC =               "Mostrar un icono para indicar que un objeto se puede utilizar (conocimiento de profesión, personalizaciones desbloqueables y libros de hechizos)."
-- L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
L.CONTAINERS_ICON_DESC =                 "Mostrar un icono para indicar que un objeto se puede abrir, como cajas fuertes y bolsas de jefes de eventos."

L.LOOT_TRACKER =                         "Rastreador de botín"
L.SHOW_MINIMAP_ICON =                    "Mostrar icono de minimapa"
L.SHOW_MINIMAP_ICON_DESC =               "Muestra el icono del minimapa. Si desactivas esto, %s sigue disponible en el apartado de Addons." -- %s becomes the addon name
L.AUTO_OPEN_WINDOW =                     "Abrir ventana automáticamente"
L.AUTO_OPEN_WINDOW_DESC =                "Abre automáticamente la ventana de %s cuando se saquea un objeto elegible." -- %s becomes the addon name
L.COLLECTION_MODE =                      "Modo colección"
L.COLLECTION_MODE_DESC =                 "Establecer cuándo %s debe mostrar nuevo transmog saqueado por otros." -- %s becomes the addon name
L.COLLECTION_MODE_APPEARANCES_DESC =     "Mostrar objetos solo si tienen una nueva apariencia."
L.COLLECTION_MODE_SOURCES_DESC =         "Mostrar objetos si son una nueva fuente, incluyendo apariencias conocidas."
-- L.RARITY =                               RARITY -- "Rarity"
L.RARITY_SETTING_DESC =                  "Establece a partir de qué calidad %s debe mostrar el botín." -- %s becomes the addon name
L.WHISPER_MESSAGE =                      "Mensaje de susurro"
L.CUSTOMIZE =                            "Personalizar"
L.WHISPER_CUSTOMIZE_DESC1 =              "Personaliza el mensaje de susurro"
L.WHISPER_CUSTOMIZE_DESC2 =              "Personaliza tu mensaje de susurro:"
L.WHISPER_POPUP_ERROR =                  "El mensaje no incluye %s" -- %s becomes "%item"
L.WHISPER_POPUP_SUCCESS =                "Mensaje actualizado:"

L.TWEAKS =                               "Retoques"
L.INSTANT_CATALYST =                     "Catalizador instantáneo"
L.INSTANT_CATALYST_DESC =                "Mantén Mayús presionado para catalizar instantáneamente un objeto, omitiendo el temporizador de 5 segundos."
L.INSTANT_VAULT =                        "Gran Cámara instantánea"
L.INSTANT_VAULT_DESC =                   "Mantén Mayús presionado para recibir instantáneamente tu recompensa de la Gran Cámara y omitir el temporizador de 5 segundos."
L.SHOW_TOOLTIP =                         "Mostrar información emergente"
L.SHOW_TOOLTIP_SETTING_DESC =            "Muestra la información emergente que explica cómo funciona esta función. El texto del botón sigue cambiando cuando esto está desactivado."
L.DISABLE_VENDOR_FILTER =                "Deshabilitar filtro de vendedor"
L.DISABLE_VENDOR_FILTER_DESC =           "Establece automáticamente todos los filtros de vendedor en |cffFFFFFFTodos|r para mostrar los objetos que normalmente no se mostrarían a tu clase."
L.HIDE_LOOT_ROLL_WINDOW =                "Ocultar ventana de tirada de botín"
L.HIDE_LOOT_ROLL_WINDOW_DESC =           "Oculta la ventana que muestra las tiradas de botín y sus resultados. Puedes mostrar la ventana de nuevo con %s." -- %s becomes "/loot"

-- Item overlay
L.BINDTEXT_WUE =                         "WuE" -- Abbreviation for "Warbound until Equipped"
L.BINDTEXT_BOP =                         "BoP" -- Abbreviation for "Binds on Pickup"
L.BINDTEXT_BOE =                         "BoE" -- Abbreviation for "Binds on Equip"
L.BINDTEXT_BOA =                         "BoA" -- Abbreviation for "Binds to Account" (Warbound)
L.RECIPE_UNCACHED =                      "Por favor abre esta profesión para actualizar si se conoce la receta."

-- Loot tracker
L.DEFAULT_MESSAGE =                      "¿Necesitas el %item saqueaste? Si no, me gustaría tenerlo para transfiguración. :)"

L.CLOSE_WINDOW =                         "Cerrar ventana"
L.LOCK_WINDOW =                          "Bloquear ventana"
L.UNLOCK_WINDOW =                        "Desbloquear ventana"
L.CLEAR_ALL_ITEMS =                      "Borrar todos los objetos"
L.HOLD_SHIFT_TO_SKIP =                   "Mantén Mayús presionado para omitir la confirmación"
L.SORT_NEW =                             "Ordenar por más reciente primero"
L.SORT_ALPHABETICAL =                    "Ordenar alfabéticamente"
L.SORTED_CURRENT =                       "Orden actual:"
L.SORTED_ALPHABETICAL =                  "alfabético"
L.SORTED_NEW =                           "más reciente primero"
L.CLEAR_CONFIRM =                        "¿Deseas borrar todo el botín?"
L.DOUBLE =                               "Doble" -- Followed by RMB or LMB
-- L.CTRL =                                 "Ctrl" -- Followed by RMB or LMB
L.ALT =                                  "Alt" -- Followed by RMB or LMB
L.SHIFT =                                "Mayús" -- Followed by RMB or LMB
L.AUTOSIZE_WINDOW =                      "Ajustar tamaño automáticamente a la ventana"
L.WHISPER_AND_REQUEST_ITEM =             "Susurrar y solicitar el objeto"
L.LINK_ITEM =                            "Enlazar el objeto"
L.REMOVE_ITEM =                          "Eliminar el objeto"
L.DEBUG_ITEM =                           "Depurar este objeto"

-- L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
-- L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
L.FILTERED =                             "Filtrado"
L.PLAYER_COLLECTED_APPEARANCE =          "consiguió una apariencia de este objeto" -- Preceded by a character name
L.PLAYER_WHISPERED =                     "ha sido susurrado por %s" -- %s becomes the addon name
L.WHISPERED_TIME =                       "vez"
L.WHISPERED_TIMES =                      "veces"
L.WHISPER_COOLDOWN =                     "Solo puedes susurrar a un jugador una vez cada 30 segundos por objeto."
L.FILTER_REASON_UNTRADEABLE =            "No comercializable"
L.FILTER_REASON_RARITY =                 "Rareza demasiado baja"
L.FILTER_REASON_KNOWN =                  "Apariencia conocida"

-- Recipes
L.DELETED_ENTRIES =                      "Entradas eliminadas:"
L.DELETED_REMOVED =                      "Objetos únicos coleccionables eliminados:"

-- Tweaks
L.GET_IT_NOW =                           "¡Recíbelo ahora!"
L.HOLD_SHIFT_TOOLTIP =                   "Mantén Mayús presionado para recibir tu objeto al instante y omitir el temporizador de 5 segundos."
