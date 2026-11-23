------------------------------------
-- Transmog Loot Helper: koKR.lua --
------------------------------------
-- Korean (Korea) localisation
-- Translator(s):

if GetLocale() ~= "koKR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "%s의 새 버전이 출시되었습니다:" -- %s becomes the addon name

L.INVALID_COMMAND =                      "잘못된 명령어"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "이 애드온을 개발하는 데에는 많은 시간과 노력이 필요합니다."
L.SUPPORT_TEXTLONG2 =                    "개발자를 금전적으로 후원하는 것을 고려해 주세요."
L.SUPPORT =                              "후원"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "감사합니다!"
L.FEEDBACK_AND_HELP =                    "피드백 및 도움말"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Discord 서버에 참여하세요."
L.CTRL_C_COPY =                          "Ctrl+C를 눌러 복사:"
L.LINK_COPIED =                          "링크를 클립보드에 복사했습니다"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " 및 슬래시 명령어" -- "Keybindings"
_G["BINDING_NAME_TLH_TOGGLEWINDOW"] =    app.NameShort .. ": 창 열기/닫기"
L.TOGGLE_TRACKING_WINDOW =               "추적 창 열기/닫기"
L.RESET_WINDOW_POSITION =                "추적 창 위치 초기화"
L.OPEN_SETTINGS =                        "설정 열기"
L.CHARACTER_REALM =                      "캐릭터-서버"
L.DELETE_CHAR_RECIPES =                  "캐릭터 고유 제조법 등을 미습득으로 표시"
L.WHISPER_SET_DEFAULT =                  "귓속말을 기본 내용으로 초기화"

L.GENERAL =                              GENERAL -- "General"
L.ITEM_OVERLAY =                         "아이템 오버레이"
L.ITEM_OVERLAY_DESC =                    "아이템에 아이콘과 텍스트를 표시하여 수집 상태 등의 정보를 알려줍니다."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.ICON_POSITION =                        "아이콘 위치"
L.ICON_POSITION_DESC =                   "아이콘이 표시될 모서리를 설정합니다."
L.BAGANATOR_SETTINGS =                   "Baganator 사용자는 Baganator 자체 설정에서 관리합니다."
L.TOP_LEFT =                             "왼쪽 위"
L.TOP_RIGHT =                            "오른쪽 위"
L.BOTTOM_LEFT =                          "왼쪽 아래"
L.BOTTOM_RIGHT =                         "오른쪽 아래"
L.OVERLAP_ISSUES_NONE =                  "알려진 충돌 문제가 없습니다."
L.OVERLAP_ISSUES_QUALITY =               "제작 아이템의 품질 표시와 겹칠 수 있습니다."
L.ICON_STYLE =                           "아이콘 스타일"
L.ICON_STYLE_DESC =                      "상태 아이콘의 스타일입니다."
L.ICON_STYLE_FANCYCIRCLE =               "화려한 원형"
L.ICON_STYLE_FANCYCIRCLE_DESC =          "모서리에 원형 상태 테두리가 있는 유형 아이콘"
L.ICON_STYLE_SIMPLECIRCLE =              "단순한 원형"
L.ICON_STYLE_SIMPLECIRCLE_DESC =         "모서리에 단순한 원형 배경의 상태 아이콘"
L.ICON_STYLE_SIMPLEICON =                "단순한 아이콘"
L.ICON_STYLE_SIMPLEICON_DESC =           "모서리 상태 아이콘"
L.ICON_STYLE_COSMETICICON =              "꾸미기 아이콘"
L.ICON_STYLE_COSMETICICON_DESC =         "모서리 상태 테두리 (애니메이션 없음)"
L.ICON_ANIMATION =                       "아이콘 애니메이션"
L.ICON_ANIMATION_DESC =                  "배우거나 사용할 수 있는 아이템의 아이콘에 멋진 회전 애니메이션을 표시합니다."
L.ICON_LEARNED =                         "수집 완료 아이콘"
L.ICON_LEARNED_DESC =                    "아래에서 추적하는 수집품을 이미 배웠다면 아이콘을 표시합니다."
L.DEFAULT =                              CHAT_DEFAULT -- "Default"
L.ICON_LEARNED_DESC2 =                   "수집한 항목의 아이콘에 별도 스타일을 지정할 수 있습니다."
L.BINDING_TEXT =                         "단축키 텍스트"
L.BINDING_TEXT_DESC =                    "착용 시 귀속(BoE), 전투부대 귀속(BoA), 착용 전까지 전투부대 귀속(WuE) 아이템에 텍스트 표시를 추가합니다."

L.PREVIEW =                              "미리보기:"
L.UNLEARNED =                            PROFESSIONS_CATEGORY_UNLEARNED -- "Unlearned"
L.USABLE =                               "사용 가능"
L.LEARNED =                              PROFESSIONS_CATEGORY_LEARNED -- "Learned"
L.UNUSABLE =                             MOUNT_JOURNAL_FILTER_UNUSABLE -- "Unusable"
L.PREVIEW_TOOLTIP = {}
L.PREVIEW_TOOLTIP[1] =                   "미수집 아이템은 컬렉션에 없는 완전히 새로운 아이템입니다."
L.PREVIEW_TOOLTIP[2] =                   "사용 가능한 아이템에는 상자나 이미 알고 있는 형상의 새로운 획득처 등이 포함됩니다."
L.PREVIEW_TOOLTIP[3] =                   "이미 배운 아이템은 컬렉션에 들어 있습니다."
L.PREVIEW_TOOLTIP[4] =                   "사용할 수 없는 아이템에는 잠긴 상자나 배우지 않은 전문 기술의 제조법 등이 포함됩니다."

L.COLLECTION_INFO =                      "수집 정보"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_ICON_DESC =                "아이템의 형상을 아직 수집하지 않았다면 아이콘을 표시합니다."
L.APPEARANCES_SOURCES =                  "획득처"
L.APPEARANCES_SOURCES_ICON_DESC =        "아이템의 형상 획득처를 아직 수집하지 않았다면 아이콘을 표시합니다."
L.CATALYST =                             "촉매"
L.CATALYST_ICON_DESC =                   "아이템을 촉매 변환하면 새로운 형상을 얻을 수 있는 경우 아이콘을 표시합니다."
L.UPGRADE =                              "강화"
L.UPGRADE_ICON_DESC =                    "아이템을 강화하면 새로운 형상을 얻을 수 있는 경우 아이콘을 표시합니다."
L.ILLUSIONS =                            "환영"
L.ILLUSIONS_ICON_DESC =                  "아직 배우지 않은 환영에 아이콘을 표시합니다."
L.MOUNTS =                               MOUNTS -- "Mounts"
L.MOUNTS_ICON_DESC =                     "아직 배우지 않은 탈것에 아이콘을 표시합니다."
L.PETS =                                 PETS -- "Pets"
L.PETS_ICON_DESC =                       "아직 배우지 않은 애완동물에 아이콘을 표시합니다."
L.PETS_COLLECT_MAX =                     "3/3 수집"
L.PETS_COLLECT_MAX_ICON_DESC =           "보유할 수 있는 애완동물의 최대 수(보통 3마리)도 고려합니다."
L.TOYS =                                 "장난감"
L.TOYS_ICON_DESC =                       "아직 배우지 않은 장난감에 아이콘을 표시합니다."
L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.RECIPES_ICON_DESC =                    "아직 배우지 않은 제조법에 아이콘을 표시합니다."
L.TRACK_PER_CHARACTER =                  "캐릭터별 추적"
L.TRACK_PER_CHARACTER_ICON_DESC =        "부캐릭터에게는 이미 배운 제조법도 배울 수 있는 것으로 표시합니다."
L.DECOR =                                CATALOG_SHOP_TYPE_DECOR -- "Decor"
L.DECOR_ICON_DESC =                      "소유하지 않은 주택 장식에 아이콘을 표시합니다."
L.ONLY_HOUSE_XP =                        "주택 경험치 제공 시에만"
L.ONLY_HOUSE_XP_ICON_DESC =              "주택 경험치를 주는 주택 장식에만 아이콘을 표시합니다."

L.OTHER_INFORMATION =                    "기타 정보"
L.QUEST_REWARD_SELL_VALUE =              "퀘스트 보상 상점 판매 가격"
L.QUEST_REWARD_SELL_VALUE_ICON_DESC =    "퀘스트 보상 옵션이 여러 개일 때 상점 판매 가격이 가장 높은 보상에 아이콘을 표시합니다."
L.USABLE_ITEMS =                         "사용 가능한 아이템"
L.USABLE_ITEMS_ICON_DESC =               "전문 기술 지식, 해금 가능한 꾸미기, 마법책 등 사용 가능한 아이템에 아이콘을 표시합니다."
L.CONTAINERS =                           AUCTION_CATEGORY_CONTAINERS -- "Containers"
L.CONTAINERS_ICON_DESC =                 "자물쇠 상자나 축제 우두머리 주머니 등 열 수 있는 아이템에 아이콘을 표시합니다."

L.LOOT_TRACKER =                         "전리품 추적기"
L.SHOW_MINIMAP_ICON =                    "미니맵 아이콘 표시"
L.SHOW_MINIMAP_ICON_DESC =               "미니맵 아이콘을 표시합니다. 비활성화해도 애드온 메뉴에서 %s을(를) 사용할 수 있습니다." -- %s becomes the addon name
L.AUTO_OPEN_WINDOW =                     "창 자동 열기"
L.AUTO_OPEN_WINDOW_DESC =                "대상 아이템을 획득하면 %s 창을 자동으로 표시합니다." -- %s becomes the addon name
L.COLLECTION_MODE =                      "수집 모드"
L.COLLECTION_MODE_DESC =                 "다른 플레이어가 획득한 새로운 형상변환 아이템을 %s이(가) 언제 표시할지 설정합니다." -- %s becomes the addon name
L.COLLECTION_MODE_APPEARANCES_DESC =     "새로운 형상을 가진 아이템만 표시합니다."
L.COLLECTION_MODE_SOURCES_DESC =         "이미 알고 있는 형상이라도 새로운 획득처인 아이템을 표시합니다."
L.RARITY =                               RARITY -- "Rarity"
L.RARITY_SETTING_DESC =                  "%s이(가) 전리품을 표시할 최소 품질을 설정합니다." -- %s becomes the addon name
L.WHISPER_MESSAGE =                      "귓속말 메시지"
L.CUSTOMIZE =                            "사용자 지정"
L.WHISPER_CUSTOMIZE_DESC1 =              "귓속말 내용 사용자 지정"
L.WHISPER_CUSTOMIZE_DESC2 =              "귓속말 내용을 사용자 지정하세요:"
L.WHISPER_POPUP_ERROR =                  "메시지에 %s이(가) 포함되어 있지 않습니다" -- %s becomes "%item"
L.WHISPER_POPUP_SUCCESS =                "메시지 업데이트됨:"

L.TWEAKS =                               "편의 기능"
L.INSTANT_CATALYST =                     "즉시 촉매"
L.INSTANT_CATALYST_DESC =                "Shift 키를 누르면 5초 타이머를 건너뛰고 아이템을 즉시 촉매 변환합니다."
L.INSTANT_VAULT =                        "위대한 금고 즉시 수령"
L.INSTANT_VAULT_DESC =                   "Shift 키를 누르면 5초 타이머를 건너뛰고 위대한 금고 보상을 즉시 받습니다."
L.SHOW_TOOLTIP =                         "툴팁 표시"
L.SHOW_TOOLTIP_SETTING_DESC =            "기능 설명 툴팁을 표시합니다. 이 기능을 꺼도 버튼 텍스트는 계속 바뀝니다."
L.DISABLE_VENDOR_FILTER =                "판매자 필터 비활성화"
L.DISABLE_VENDOR_FILTER_DESC =           "모든 판매자 필터를 자동으로 \"전체\"로 설정하여 직업에 따라 숨겨진 아이템도 표시합니다."
L.HIDE_LOOT_ROLL_WINDOW =                "전리품 주사위 창 숨기기"
L.HIDE_LOOT_ROLL_WINDOW_DESC =           "전리품 주사위 및 결과 창을 숨깁니다. %s을(를) 사용하면 다시 표시할 수 있습니다." -- %s becomes "/loot"

-- Item overlay
L.BINDTEXT_WUE =                         "착용 전까지 전투부대 귀속" -- Abbreviation for "Warbound until Equipped"
L.BINDTEXT_BOP =                         "획득 시 귀속" -- Abbreviation for "Binds on Pickup"
L.BINDTEXT_BOE =                         "착용 시 귀속" -- Abbreviation for "Binds on Equip"
L.BINDTEXT_BOA =                         "계정 귀속" -- Abbreviation for "Binds to Account" (Warbound)
L.RECIPE_UNCACHED =                      "이 제조법의 수집 상태를 갱신하려면 해당 전문 기술을 여세요."
L.LEARN_UNBOUND =                        "이 아이템을 판매, 파괴 또는 마력 추출하여 형상을 수집하세요."
L.BUGGED_ITEM =                          "이 아이템에는 버그가 있어 형상을 수집하지 못할 수 있습니다."

-- Loot tracker
L.DEFAULT_MESSAGE =                      "획득하신 %item 아이템이 필요하신가요? 필요 없으시면 형상변환용으로 받고 싶어요. :)"

L.CLOSE_WINDOW =                         "창 닫기"
L.LOCK_WINDOW =                          "창 잠금"
L.UNLOCK_WINDOW =                        "창 잠금 해제"
L.CLEAR_ALL_ITEMS =                      "모든 아이템 지우기"
L.HOLD_SHIFT_TO_SKIP =                   "Shift 키를 누르면 확인 건너뛰기"
L.SORT_NEW =                             "최신순 정렬"
L.SORT_ALPHABETICAL =                    "가나다순 정렬"
L.SORTED_CURRENT =                       "Ordenação atual:"
L.SORTED_ALPHABETICAL =                  "가나다순"
L.SORTED_NEW =                           "최신순"
L.CLEAR_CONFIRM =                        "모든 전리품을 지우시겠습니까?"
L.DOUBLE =                               "두 번" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "창에 맞게 크기 자동 조절"
L.WHISPER_AND_REQUEST_ITEM =             "귓속말로 아이템 요청"
L.LINK_ITEM =                            "아이템 링크"
L.REMOVE_ITEM =                          "아이템 제거"
L.DEBUG_ITEM =                           "이 아이템 디버그"

L.WEAPONS =                              AUCTION_CATEGORY_WEAPONS -- "Weapons"
L.ARMOR =                                AUCTION_CATEGORY_ARMOR -- "Armor"
L.FILTERED =                             "필터 적용됨"
L.PLAYER_COLLECTED_APPEARANCE =          "이 아이템의 형상을 수집함" -- Preceded by a character name
L.PLAYER_WHISPERED =                     "%s 사용자에게 귓속말을 받음" -- %s becomes the addon name
L.WHISPERED_TIME =                       "시간"
L.WHISPERED_TIMES =                      "회"
L.WHISPER_COOLDOWN =                     "같은 아이템에 대해서는 플레이어에게 30초에 한 번만 귓속말을 보낼 수 있습니다."
L.FILTER_REASON_UNTRADEABLE =            "거래 불가"
L.FILTER_REASON_RARITY =                 "희귀도가 너무 낮음"
L.FILTER_REASON_KNOWN =                  "수집한 형상"

-- Recipes
L.DELETED_ENTRIES =                      "삭제된 항목:"
L.DELETED_REMOVED =                      "고유 수집품 제거됨:"

-- Tweaks
L.GET_IT_NOW =                           "지금 받기!"
L.HOLD_SHIFT_TOOLTIP =                   "Shift 키를 누르면 5초 타이머를 건너뛰고 아이템을 즉시 받습니다."
