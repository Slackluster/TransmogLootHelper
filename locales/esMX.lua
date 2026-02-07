--------------------------------------
-- Equip Recommended Gear: esMX.lua --
--------------------------------------
-- Spanish (Mexico) localisation
-- Translator(s): Ferran Carril

-- Initialisation
if GetLocale() ~= "esMX" then return end
local appName, app = ...
local L = app.locales

-- Slash commands
L.INVALID_COMMAND =						"Comando no válido."
L.DELETED_ENTRIES =						"Entradas eliminadas:"
L.DELETED_REMOVED =						"Objetos únicos coleccionables eliminados:"

-- Version comms
L.NEW_VERSION_AVAILABLE =				"Hay una versión más nueva de " .. app.NameLong .. " disponible:"

-- Item overlay
L.BINDTEXT_WUE =						"WuE"
L.BINDTEXT_BOP =						"BoP"
L.BINDTEXT_BOE =						"BoE"
L.BINDTEXT_BOA =						"BoA"
L.RECIPE_UNCACHED =						"Por favor abre esta profesión para actualizar si se conoce la receta."

-- Loot tracker
L.DEFAULT_MESSAGE = 					"¿Necesitas el %item saqueaste? Si no, me gustaría tenerlo para transfiguración. :)"
L.CLEAR_CONFIRM =						"¿Deseas borrar todo el botín?"

L.WINDOW_BUTTON_CLOSE =					"Cerrar ventana"
L.WINDOW_BUTTON_LOCK =					"Bloquear ventana"
L.WINDOW_BUTTON_UNLOCK =				"Desbloquear ventana"
L.WINDOW_BUTTON_SETTINGS =				"Abrir opciones"
L.WINDOW_BUTTON_CLEAR =					"Borrar todos los objetos\nMantén Mayús presionado para omitir la confirmación"
L.WINDOW_BUTTON_SORT1 =					"Ordenar por más reciente primero\nOrden actual:|cffFFFFFF alfabético|r"
L.WINDOW_BUTTON_SORT2 =					"Ordenar alfabéticamente\nOrden actual:|cffFFFFFF más reciente primero|r"
L.WINDOW_BUTTON_CORNER =				"Doble " .. app.IconLMB .. "|cffFFFFFF: Ajustar tamaño automáticamente a la ventana|r"

L.WINDOW_HEADER_LOOT_DESC =				"|rAlt " .. app.IconLMB .. "|cffFFFFFF: Susurrar y solicitar el objeto\n|rMayús " .. app.IconLMB .. "|cffFFFFFF: Enlazar el objeto\n|rMayús " .. app.IconRMB .. "|cffFFFFFF: Eliminar el objeto"
L.WINDOW_HEADER_FILTERED =				"Filtrado"
L.WINDOW_HEADER_FILTERED_DESC =			"|r" .. app.IconRMB .. "|cffFFFFFF: Depurar este objeto\n|rMayús " .. app.IconLMB .. "|cffFFFFFF: Enlazar el objeto\n|rMayús " .. app.IconRMB .. "|cffFFFFFF: Eliminar el objeto"

L.PLAYER_COLLECTED_APPEARANCE =			"consiguió una apariencia de este objeto"	-- Preceded by a character name
L.PLAYER_WHISPERED =					"ha sido susurrado por " .. app.NameShort .. ""
L.WHISPERED_TIME =						"vez"
L.WHISPERED_TIMES =						"veces"
L.WHISPER_COOLDOWN =					"Solo puedes susurrar a un jugador una vez cada 30 segundos por objeto."

L.FILTER_REASON_UNTRADEABLE =			"No comercializable"
L.FILTER_REASON_RARITY =				"Rareza demasiado baja"
L.FILTER_REASON_KNOWN =					"Apariencia conocida"

-- Tweaks
L.INSTANT_BUTTON =						"¡Recíbelo ahora!"
L.INSTANT_TOOLTIP =						"Mantén Mayús presionado para recibir tu objeto al instante y omitir el temporizador de 5 segundos."

-- Settings
L.SETTINGS_TOOLTIP =					app.NameLong .. "\n|cffFFFFFF" .. app.IconLMB .. ": Activar/Desactivar la ventana\n" .. app.IconRMB .. ": " .. L.WINDOW_BUTTON_SETTINGS

L.SETTINGS_VERSION =					GAME_VERSION_LABEL .. ":"	-- "Version"
L.SETTINGS_SUPPORT_TEXTLONG =			"Desarrollar este addon requiere una cantidad significativa de tiempo y esfuerzo.\nPor favor, considera apoyar financieramente al desarrollador."
L.SETTINGS_SUPPORT_TEXT =				"Apoyar"
L.SETTINGS_SUPPORT_BUTTON =				"Buy Me a Coffee"	-- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =				"¡Gracias!"
L.SETTINGS_HELP_TEXT =					"Comentarios y Ayuda"
L.SETTINGS_HELP_BUTTON =				"Discord"	-- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =					"Únete al servidor de Discord."
L.SETTINGS_URL_COPY =					"Ctrl+C para copiar:"
L.SETTINGS_URL_COPIED =					"Enlace copiado al portapapeles"

L.SETTINGS_KEYSLASH_TITLE =				SETTINGS_KEYBINDINGS_LABEL .. " y Comandos"	-- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =	app.NameShort .. ": Activar/Desactivar ventana"
L.SETTINGS_SLASH_TOGGLE =				"Activar/Desactivar la ventana de seguimiento"
L.SETTINGS_SLASH_RESETPOS =				"Restablecer la posición de la ventana de seguimiento"
L.SETTINGS_SLASH_WHISPER_DEFAULT =		"Establecer el mensaje de susurro a su valor predeterminado"
L.SETTINGS_SLASH_DELETE_DESC =			"Marcar recetas únicas de un personaje, etc. como no aprendidas"
L.SETTINGS_SLASH_CHARREALM =			"Personaje-Reino"

L.GENERAL =								GENERAL	-- "General"
L.SETTINGS_ITEM_OVERLAY	=				"Superposición en objetos"
L.SETTINGS_BAGANATOR =					"Para usuarios de Baganator, esto se gestiona mediante las opciones propias de Baganator."
L.SETTINGS_ITEM_OVERLAY_DESC =			"Muestra un icono y texto en los objetos para indicar si son coleccionables y más.\n\n|cffFF0000" .. REQUIRES_RELOAD .. ".|r Usa |cffFFFFFF/reload|r o vuelve a conectarte."
L.SETTINGS_ICON_POSITION =				"Posición del icono"
L.SETTINGS_ICON_POSITION_DESC =			"En qué esquina aparece el icono."
L.SETTINGS_ICONPOS_TL =					"Arriba izquierda"
L.SETTINGS_ICONPOS_TR =					"Arriba derecha"
L.SETTINGS_ICONPOS_BL =					"Abajo izquierda"
L.SETTINGS_ICONPOS_BR =					"Abajo derecha"
L.SETTINGS_ICONPOS_OVERLAP0 =			"Sin problemas de superposición conocidos."
L.SETTINGS_ICONPOS_OVERLAP1 =			"Esto puede superponerse con la calidad de un objeto creado."
L.SETTINGS_ICON_STYLE =					"Estilo de icono"
L.SETTINGS_ICON_STYLE_DESC =			"El estilo del icono de estado."
L.SETTINGS_ICON_STYLE1 =				"Círculo elegante"
L.SETTINGS_ICON_STYLE1_DESC =			"Icono de tipo con borde de estado redondo"
L.SETTINGS_ICON_STYLE2 =				"Círculo simple"
L.SETTINGS_ICON_STYLE2_DESC =			"Icono de estado con fondo redondo simple"
L.SETTINGS_ICON_STYLE3 =				"Icono simple"
L.SETTINGS_ICON_STYLE3_DESC =			"Icono de estado"
L.SETTINGS_ICON_STYLE4 =				"Icono cosmético"
L.SETTINGS_ICON_STYLE4_DESC =			"Borde de estado en la esquina (sin animación)"
L.SETTINGS_ICON_ANIMATE =				"Animación del icono"
L.SETTINGS_ICON_ANIMATE_DESC =			"Muestra una bonita animación de remolino en los iconos para los objetos aprendibles y utilizables."
L.SETTINGS_ICONLEARNED =				"Icono de Aprendido"
L.SETTINGS_ICONLEARNED_DESC =			"Muestra un icono para indicar que los objetos coleccionables rastreados a continuación se han aprendido."
L.DEFAULT =								CHAT_DEFAULT	-- Default
L.SETTINGS_ICONLEARNED_DESC2 =			"Puedes establecer un estilo separado para los iconos de aprendidos."
L.SETTINGS_BINDTEXT =					"Texto de objetos ligados"
L.SETTINGS_BINDTEXT_DESC =				"Muestra un indicador de texto para los objetos que se ligan al equiparlos (BoE), objetos ligados a la banda guerrera (BoA) y ligados a la banda guerrera hasta que te equipas con ellos (WuE).\n\n" .. L.SETTINGS_BAGANATOR
L.SETTINGS_PREVIEW =					"Vista Previa:"
L.SETTINGS_UNLEARNED =					PROFESSIONS_CATEGORY_UNLEARNED	-- Unlearned
L.SETTINGS_USABLE =						"Utilizable"
L.SETTINGS_LEARNED =					PROFESSIONS_CATEGORY_LEARNED	-- Learned
L.SETTINGS_UNUSABLE =					MOUNT_JOURNAL_FILTER_UNUSABLE	-- Unusable
L.SETTINGS_PREVIEWTOOLTIP = {}
L.SETTINGS_PREVIEWTOOLTIP[1] =			"Objetos no aprendidos que son completamente nuevos en tu colección."
L.SETTINGS_PREVIEWTOOLTIP[2] =			"Objetos utilizables como contenedores, nuevas fuentes para apariencias ya conocidas, etc."
L.SETTINGS_PREVIEWTOOLTIP[3] =			"Objetos aprendidos que ya están en tu colección."
L.SETTINGS_PREVIEWTOOLTIP[4] =			"Objetos que no se pueden usar como contenedores bloqueados, recetas para profesiones que no conoces, etc."

L.SETTINGS_HEADER_COLLECTION =			"Información de colección"
L.SETTINGS_ICON_NEW_MOG =				"Apariencias"
L.SETTINGS_ICON_NEW_MOG_DESC =			"Muestra un icono para indicar que la apariencia de un objeto no se ha aprendido."
L.SETTINGS_ICON_NEW_SOURCE =			"Fuentes"
L.SETTINGS_ICON_NEW_SOURCE_DESC =		"Muestra un icono para indicar que la fuente de apariencia de un objeto no se ha aprendido."
L.SETTINGS_ICON_NEW_CATALYST =			"Al catalizar"
L.SETTINGS_ICON_NEW_CATALYST_DESC =		"Muestra un icono cuando al catalizar un objeto se obtenga una nueva apariencia."
L.SETTINGS_ICON_NEW_UPGRADE =			"Al mejorar"
L.SETTINGS_ICON_NEW_UPGRADE_DESC =		"Muestra un icono cuando al mejorar un objeto se obtenga una nueva apariencia."
L.SETTINGS_ICON_NEW_ILLUSION =			"Ilusiones"
L.SETTINGS_ICON_NEW_ILLUSION_DESC =		"Muestra un icono para indicar que una ilusión no se ha aprendido."
L.SETTINGS_ICON_NEW_MOUNT =				"Monturas"
L.SETTINGS_ICON_NEW_MOUNT_DESC =		"Muestra un icono para indicar que una montura no se ha aprendido."
L.SETTINGS_ICON_NEW_PET =				"Mascotas"
L.SETTINGS_ICON_NEW_PET_DESC =			"Muestra un icono para indicar que una mascota no se ha aprendido."
L.SETTINGS_ICON_NEW_PET_MAX =			"Conseguidos 3/3"
L.SETTINGS_ICON_NEW_PET_MAX_DESC =		"Ten en cuenta también el número máximo de mascotas que puedes poseer (normalmente 3)."
L.SETTINGS_ICON_NEW_TOY =				"Juguetes"
L.SETTINGS_ICON_NEW_TOY_DESC =			"Muestra un icono para indicar que un juguete no se ha aprendido."
L.SETTINGS_ICON_NEW_RECIPE =			"Recetas"
L.SETTINGS_ICON_NEW_RECIPE_DESC =		"Muestra un icono para indicar que una receta no se ha aprendido."
L.SETTINGS_ICON_NEW_DECOR =				"Adornos"
L.SETTINGS_ICON_NEW_DECOR_DESC =		"Muestra un icono para indicar que no posees un adorno de hogar."
L.SETTINGS_ICON_NEW_DECORXP =			"Solo con PE de casa"
L.SETTINGS_ICON_NEW_DECORXP_DESC =		"Solo mostrar el icono para adornos de hogares que otorgan PE de casa."

L.SETTINGS_HEADER_OTHER_INFO =			"Otra información"
L.SETTINGS_ICON_QUEST_GOLD =			"Valor de venta de recompensa de misión"
L.SETTINGS_ICON_QUEST_GOLD_DESC =		"Mostrar un icono para indicar qué recompensa de misión, si hay varias, tiene el valor de venta más alto."
L.SETTINGS_ICON_USABLE =				"Objetos utilizables"
L.SETTINGS_ICON_USABLE_DESC =			"Mostrar un icono para indicar que un objeto se puede utilizar (conocimiento de profesión, personalizaciones desbloqueables y libros de hechizos)."
L.SETTINGS_ICON_OPENABLE =				"Objetos que pueden abrirse"
L.SETTINGS_ICON_OPENABLE_DESC =			"Mostrar un icono para indicar que un objeto se puede abrir, como cajas fuertes y bolsas de jefes de eventos."

L.SETTINGS_HEADER_LOOT_TRACKER =		"Rastreador de botín"
L.SETTINGS_MINIMAP =					"Mostrar icono de minimapa"
L.SETTINGS_MINIMAP_DESC =				"Muestra el icono del minimapa. Si desactivas esto, " .. app.NameShort .. " sigue disponible en el apartado de Addons."
L.SETTINGS_AUTO_OPEN =					"Abrir ventana automáticamente"
L.SETTINGS_AUTO_OPEN_DESC =				"Abre automáticamente la ventana de " .. app.NameShort .. " cuando se saquea un objeto elegible."
L.SETTINGS_COLLECTION_MODE =			"Modo colección"
L.SETTINGS_COLLECTION_MODE_DESC =		"Establecer cuándo " .. app.NameShort .. " debe mostrar nuevo transmog saqueado por otros."
L.SETTINGS_MODE_APPEARANCES =			"Apariencias"
L.SETTINGS_MODE_APPEARANCES_DESC =		"Mostrar objetos solo si tienen una nueva apariencia."
L.SETTINGS_MODE_SOURCES =				"Fuentes"
L.SETTINGS_MODE_SOURCES_DESC =			"Mostrar objetos si son una nueva fuente, incluyendo apariencias conocidas."
L.SETTINGS_RARITY =						"Rareza"
L.SETTINGS_RARITY_DESC =				"Establece a partir de qué calidad " .. app.NameShort .. " debe mostrar el botín."
L.SETTINGS_WHISPER =					"Mensaje de susurro"
L.SETTINGS_WHISPER_CUSTOMIZE =			"Personalizar"
L.SETTINGS_WHISPER_CUSTOMIZE_DESC =		"Personaliza el mensaje de susurro"
L.WHISPER_POPUP_CUSTOMIZE = 			"Personaliza tu mensaje de susurro:"
L.WHISPER_POPUP_ERROR = 				"El mensaje no incluye |cff3FC7EB%item|r. Mensaje no actualizado."
L.WHISPER_POPUP_SUCCESS =				"Mensaje actualizado."

L.SETTINGS_HEADER_TWEAKS =				"Retoques"
L.SETTINGS_CATALYST =					"Catalizador instantáneo"
L.SETTINGS_CATALYST_DESC =				"Mantén Mayús presionado para catalizar instantáneamente un objeto, omitiendo el temporizador de 5 segundos."
L.SETTINGS_VAULT =						"Gran Cámara instantánea"
L.SETTINGS_VAULT_DESC =					"Mantén Mayús presionado para recibir instantáneamente tu recompensa de la Gran Cámara y omitir el temporizador de 5 segundos."
L.SETTINGS_INSTANT_TOOLTIP =			"Mostrar información emergente"
L.SETTINGS_INSTANT_TOOLTIP_DESC =		"Muestra la información emergente que explica cómo funciona esta función. El texto del botón sigue cambiando cuando esto está desactivado."
L.SETTINGS_VENDOR_ALL =					"Deshabilitar filtro de vendedor"
L.SETTINGS_VENDOR_ALL_DESC =			"Establece automáticamente todos los filtros de vendedor en |cffFFFFFFTodos|r para mostrar los objetos que normalmente no se mostrarían a tu clase."
L.SETTINGS_HIDE_LOOT_ROLL_WINDOW =		"Ocultar ventana de tirada de botín"
L.SETTINGS_HIDE_LOOT_ROLL_WINDOW_DESC =	"Oculta la ventana que muestra las tiradas de botín y sus resultados. Puedes mostrar la ventana de nuevo con |cff00ccff/loot|r."
