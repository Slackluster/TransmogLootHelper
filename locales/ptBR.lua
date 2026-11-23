------------------------------------
-- Transmog Loot Helper: ptBR.lua --
------------------------------------
-- Portuguese (Brazil) localisation
-- Translator(s):

if GetLocale() ~= "ptBR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Há uma versão mais recente de %s disponível:" -- %s becomes the addon name

L.INVALID_COMMAND =                      "Comando inválido"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Desenvolver este addon exige muito tempo e dedicação."
L.SUPPORT_TEXTLONG2 =                    "Considere apoiar financeiramente o desenvolvedor."
L.SUPPORT =                              "Apoiar"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Obrigado!"
L.FEEDBACK_AND_HELP =                    "Comentários e Ajuda"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Entre no servidor do Discord."
L.CTRL_C_COPY =                          "Ctrl+C para copiar:"
L.LINK_COPIED =                          "Link copiado para a área de transferência"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " e comandos de barra" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. ": Alternar janela"
L.TOGGLE_TRACKING_WINDOW =               "Alternar janela de rastreamento"
L.RESET_WINDOW_POSITION =                "Redefinir posição da janela de rastreamento"
L.OPEN_SETTINGS =                        "Abrir as configurações"
L.CHARACTER_REALM =                      "Personagem-Reino"
L.DELETE_CHAR_RECIPES =                  "Marcar receitas exclusivas e outros itens de um personagem como não aprendidos"
L.WHISPER_SET_DEFAULT =                  "Restaurar a mensagem de sussurro padrão"

L.GENERAL =                              GENERAL -- "General"
L.ITEM_OVERLAY =                         "Sobreposição de itens"
L.ITEM_OVERLAY_DESC =                    "Exibe um ícone e texto nos itens para indicar o estado da coleção e outras informações."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.ICON_POSITION =                        "Posição do ícone"
L.ICON_POSITION_DESC =                   "Em qual canto o ícone será exibido."
L.BAGANATOR_SETTINGS =                   "Para usuários do Baganator, isso é gerenciado nas configurações do próprio Baganator."
L.TOP_LEFT =                             "Superior esquerdo"
L.TOP_RIGHT =                            "Superior direito"
L.BOTTOM_LEFT =                          "Inferior esquerdo"
L.BOTTOM_RIGHT =                         "Inferior direito"
L.OVERLAP_ISSUES_NONE =                  "Nenhum problema de sobreposição conhecido."
L.OVERLAP_ISSUES_QUALITY =               "Isso pode se sobrepor à qualidade de um item criado."
L.ICON_STYLE =                           "Estilo do ícone"
L.ICON_STYLE_DESC =                      "O estilo do ícone de estado."
L.ICON_STYLE_FANCYCIRCLE =               "Círculo ornamentado"
L.ICON_STYLE_FANCYCIRCLE_DESC =          "Ícone de tipo com borda redonda de estado no canto"
L.ICON_STYLE_SIMPLECIRCLE =              "Círculo simples"
L.ICON_STYLE_SIMPLECIRCLE_DESC =         "Ícone de estado com fundo circular simples no canto"
L.ICON_STYLE_SIMPLEICON =                "Ícone simples"
L.ICON_STYLE_SIMPLEICON_DESC =           "Ícone de estado no canto"
L.ICON_STYLE_COSMETICICON =              "Ícone cosmético"
L.ICON_STYLE_COSMETICICON_DESC =         "Borda de estado no canto (sem animação)"
L.ICON_ANIMATION =                       "Animação do ícone"
L.ICON_ANIMATION_DESC =                  "Exibe um efeito espiral animado nos ícones de itens aprendíveis e utilizáveis."
L.ICON_LEARNED =                         "Ícone de itens aprendidos"
L.ICON_LEARNED_DESC =                    "Mostra um ícone para indicar que os colecionáveis rastreados abaixo já foram aprendidos."
L.DEFAULT =                              CHAT_DEFAULT -- "Default"
L.ICON_LEARNED_DESC2 =                   "Você pode definir um estilo separado para ícones de itens aprendidos."
L.BINDING_TEXT =                         "Texto do atalho de tecla"
L.BINDING_TEXT_DESC =                    "Mostra um indicador de texto para itens Vinculados ao Equipar (BoE), Vinculados ao Bando de Guerra (BoA) e Vinculados ao Bando de Guerra até Equipar (WuE)."

L.PREVIEW =                              "Prévia:"
L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- "Unlearned"
L.USABLE =                               "Utilizável"
L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- "Learned"
L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- "Unusable"
L.PREVIEW_TOOLTIP = {}
L.PREVIEW_TOOLTIP[1] =                   "Itens não aprendidos são completamente novos para sua coleção."
L.PREVIEW_TOOLTIP[2] =                   "Itens utilizáveis incluem recipientes, novas fontes de aparências já conhecidas etc."
L.PREVIEW_TOOLTIP[3] =                   "Itens aprendidos já estão na sua coleção."
L.PREVIEW_TOOLTIP[4] =                   "Itens inutilizáveis incluem recipientes trancados, receitas de profissões que você não conhece etc."

L.COLLECTION_INFO =                      "Informações de coleção"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_ICON_DESC =                "Mostra um ícone se a aparência de um item ainda não foi aprendida."
L.APPEARANCES_SOURCES =                  "Fontes"
L.APPEARANCES_SOURCES_ICON_DESC =        "Mostra um ícone se a fonte da aparência de um item ainda não foi aprendida."
L.CATALYST =                             "Catalisador"
L.CATALYST_ICON_DESC =                   "Mostra um ícone quando catalisar um item concede uma nova aparência."
L.UPGRADE =                              "Aprimoramento"
L.UPGRADE_ICON_DESC =                    "Mostra um ícone quando aprimorar um item concede uma nova aparência."
L.ILLUSIONS =                            "Ilusões"
L.ILLUSIONS_ICON_DESC =                  "Mostra um ícone para uma ilusão ainda não aprendida."
L.MOUNTS =                               MOUNTS -- "Mounts"
L.MOUNTS_ICON_DESC =                     "Mostra um ícone para uma montaria ainda não aprendida."
L.PETS =                                 PETS -- "Pets"
L.PETS_ICON_DESC =                       "Mostra um ícone para um mascote ainda não aprendido."
L.PETS_COLLECT_MAX =                     "Coletar 3/3"
L.PETS_COLLECT_MAX_ICON_DESC =           "Também considera o número máximo de mascotes que você pode ter (geralmente 3)."
L.TOYS =                                 "Brinquedos"
L.TOYS_ICON_DESC =                       "Mostra um ícone para um brinquedo ainda não aprendido."
L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.RECIPES_ICON_DESC =                    "Mostra um ícone para uma receita ainda não aprendida."
L.TRACK_PER_CHARACTER =                  "Rastrear por Personagem"
L.TRACK_PER_CHARACTER_ICON_DESC =        "Mostrar receitas já aprendidas como aprendíveis para personagens alternativos."
L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
L.DECOR_ICON_DESC =                      "Mostra um ícone se você não possui uma decoração de moradia."
L.ONLY_HOUSE_XP =                        "Somente com EXP da Casa"
L.ONLY_HOUSE_XP_ICON_DESC =              "Mostrar o ícone apenas para decorações de moradia que concedem EXP da Casa."

L.OTHER_INFORMATION =                    "Outras informações"
L.QUEST_REWARD_SELL_VALUE =              "Valor de venda das recompensas de missão"
L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "Mostra um ícone indicando qual recompensa de missão tem o maior valor de venda, quando houver várias opções."
L.USABLE_ITEMS =                         "Itens utilizáveis"
L.USABLE_ITEMS_ICON_DESC =               "Mostra um ícone para itens utilizáveis (conhecimento de profissão, personalizações desbloqueáveis e livros de feitiços)."
L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
L.CONTAINERS_ICON_DESC =                 "Mostra um ícone para itens que podem ser abertos, como cofres trancados e bolsas de chefes de eventos."

L.LOOT_TRACKER =                         "Rastreador de Saque"
L.SHOW_MINIMAP_ICON =                    "Mostrar ícone no minimapa"
L.SHOW_MINIMAP_ICON_DESC =               "Mostra o ícone no minimapa. Se desativado, %s continuará disponível no Compartimento de Addons." -- %s becomes the addon name
L.AUTO_OPEN_WINDOW =                     "Abrir janela automaticamente"
L.AUTO_OPEN_WINDOW_DESC =                "Exibe automaticamente a janela de %s ao saquear um item elegível." -- %s becomes the addon name
L.COLLECTION_MODE =                      "Modo de coleção"
L.COLLECTION_MODE_DESC =                 "Defina quando %s deve mostrar novas transmogrificações saqueadas por outros jogadores." -- %s becomes the addon name
L.COLLECTION_MODE_APPEARANCES_DESC =     "Mostrar itens apenas se tiverem uma nova aparência."
L.COLLECTION_MODE_SOURCES_DESC =         "Mostrar itens se forem uma nova fonte, mesmo para aparências conhecidas."
L.RARITY =                               RARITY -- "Rarity"
L.RARITY_SETTING_DESC =                  "Defina a qualidade mínima de saque que %s deve mostrar." -- %s becomes the addon name
L.WHISPER_MESSAGE =                      "Mensagem de Sussurro"
L.CUSTOMIZE =                            "Personalizar"
L.WHISPER_CUSTOMIZE_DESC1 =              "Personalizar mensagem de sussurro"
L.WHISPER_CUSTOMIZE_DESC2 =              "Personalize sua mensagem de sussurro:"
L.WHISPER_POPUP_ERROR =                  "A mensagem não inclui %s" -- %s becomes "%item"
L.WHISPER_POPUP_SUCCESS =                "Mensagem atualizada:"

L.TWEAKS =                               "Ajustes"
L.INSTANT_CATALYST =                     "Catalisador instantâneo"
L.INSTANT_CATALYST_DESC =                "Segure Shift para catalisar um item imediatamente, pulando o temporizador de 5 segundos."
L.INSTANT_VAULT =                        "Grande Cofre instantâneo"
L.INSTANT_VAULT_DESC =                   "Segure Shift para receber imediatamente sua recompensa do Grande Cofre, pulando o temporizador de 5 segundos."
L.SHOW_TOOLTIP =                         "Mostrar dica de interface"
L.SHOW_TOOLTIP_SETTING_DESC =            "Mostra a dica de interface que explica como o recurso funciona. O texto do botão continuará mudando mesmo quando isso estiver desativado."
L.DISABLE_VENDOR_FILTER =                "Desativar filtro de vendedor"
L.DISABLE_VENDOR_FILTER_DESC =           "Define automaticamente todos os filtros dos vendedores como \"Todos\" para exibir itens normalmente ocultos para sua classe."
L.HIDE_LOOT_ROLL_WINDOW =                "Ocultar janela de rolagem de saque"
L.HIDE_LOOT_ROLL_WINDOW_DESC =           "Oculta a janela de rolagem do saque e seus resultados. Você pode exibi-la novamente com %s." -- %s becomes "/loot"

-- Item overlay
L.BINDTEXT_WUE =                         "Vinculado ao Bando de Guerra até Equipar" -- Abbreviation for "Warbound until Equipped"
L.BINDTEXT_BOP =                         "Vinculado ao pegar" -- Abbreviation for "Binds on Pickup"
L.BINDTEXT_BOE =                         "Vinculado ao equipar" -- Abbreviation for "Binds on Equip"
L.BINDTEXT_BOA =                         "Vinculado à conta" -- Abbreviation for "Binds to Account" (Warbound)
L.RECIPE_UNCACHED =                      "Abra esta profissão para atualizar o estado da receita na coleção."
L.LEARN_UNBOUND =                        "Venda, destrua ou desencante este item para aprender sua aparência."
L.BUGGED_ITEM =                          "Este item está com problemas e talvez não seja possível aprender sua aparência."

-- Loot tracker
L.DEFAULT_MESSAGE =                      "Você precisa do item %item que saqueou? Se não, eu gostaria de ficar com ele para transmogrificação. :)"

L.CLOSE_WINDOW =                         "Fechar janela"
L.LOCK_WINDOW =                          "Bloquear janela"
L.UNLOCK_WINDOW =                        "Desbloquear janela"
L.CLEAR_ALL_ITEMS =                      "Limpar todos os itens"
L.HOLD_SHIFT_TO_SKIP =                   "Segure Shift para pular a confirmação"
L.SORT_NEW =                             "Ordenar pelos mais recentes"
L.SORT_ALPHABETICAL =                    "Ordenar alfabeticamente"
L.SORTED_CURRENT =                       "Ordenação atual:"
L.SORTED_ALPHABETICAL =                  "alfabética"
L.SORTED_NEW =                           "mais recentes primeiro"
L.CLEAR_CONFIRM =                        "Deseja limpar todo o saque?"
L.DOUBLE =                               "Duplo" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "Ajustar automaticamente ao tamanho da janela"
L.WHISPER_AND_REQUEST_ITEM =             "Sussurrar e solicitar o item"
L.LINK_ITEM =                            "Vincular o item"
L.REMOVE_ITEM =                          "Remover o item"
L.DEBUG_ITEM =                           "Depurar este item"

L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
L.FILTERED =                             "Filtrado"
L.PLAYER_COLLECTED_APPEARANCE =          "aparência deste item coletada" -- Preceded by a character name
L.PLAYER_WHISPERED =                     "recebeu sussurros de usuários de %s" -- %s becomes the addon name
L.WHISPERED_TIME =                       "tempo"
L.WHISPERED_TIMES =                      "vezes"
L.WHISPER_COOLDOWN =                     "Você só pode sussurrar para um jogador uma vez a cada 30 segundos por item."
L.FILTER_REASON_UNTRADEABLE =            "Não negociável"
L.FILTER_REASON_RARITY =                 "Raridade muito baixa"
L.FILTER_REASON_KNOWN =                  "Aparência conhecida"

-- Recipes
L.DELETED_ENTRIES =                      "Entradas excluídas:"
L.DELETED_REMOVED =                      "Colecionáveis exclusivos removidos:"

-- Tweaks
L.GET_IT_NOW =                           "Obtenha agora!"
L.HOLD_SHIFT_TOOLTIP =                   "Segure Shift para receber seu item imediatamente, pulando o temporizador de 5 segundos."
