// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(
    String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'ru';

  static m0(activityName) => "Активность \"${activityName}\" добавлена";

  static m1(activityName) => "Активность \"${activityName}\" удалена";

  static m2(userName, activityTitle) => "LFG пользователя \"${userName}\", с активностью \"${activityTitle}\" удалено.";

  static m3(error) => "Database unavailable: ${error}";

  static m4(milliseconds) => "Ping: ${milliseconds}ms";

  static m5(count) => "Scheduled: ${count}";

  static m6(error) => "Scheduler unavailable: ${error}";

  static m7(count) => "Total: ${count}";

  static m8(activity) => "Для активности \"${activity}\" роль для промо сообщений удалена.";

  static m9(activity, roleMention) => "Текущая роль для пинга активности \"${activity}\": ${roleMention}";

  static m10(activity) => "Для активности \"${activity}\" роль для промо сообщений не установлена.";

  static m11(activity, roleMention) => "Для активности \"${activity}\": роль ${roleMention} будет оповещена в промо сообщениях.";

  static m12(activity, freeSlots, role) => "Активность \"${activity}\" имеет ${freeSlots} свободных ролей \"${role}\"";

  static m13(name, offset) => "Таймзона \"${name}\" со смещением ${offset} добавлена.";

  static m14(name) => "Таймзона \"${name}\" уже существует.";

  static m15(name) => "Таймзона \"${name}\" не найдена.";

  static m16(name) => "Таймзона \"${name}\" удалена.";

  static m17(reason) => "Невозможно выполнить команду.\nПричина: ${reason}\nПопробуйте ещё раз или обратитесь к администрации сервера.";

  static m18(channelId) => "Команда доступна только в канале для поиска группы: <#${channelId}>";

  static m19(title) => "Ваше LFG \"${title}\" удалено.";

  static m20(metadata) => "Метаданные: ${metadata}";

  static m21(stack) => "Стек вызовов: ${stack}";

  static m22(error) => "Произошла ошибка при выполнении команды :(\n\n${error}";

  static m23(role) => "Вы выбрали роль ${role}";

  static m24(channelId) => "Канал LFG не найден или настроен неправильно\nID: ${channelId}";

  static m25(current, max) => "Участники (${current}/${max}):";

  static m26(id) => "LFG ${id} не найден";

  static m27(channelId) => "Канал для объявлений настроен неверно.\nID: ${channelId}";

  static m28(authorMention, activityName) => "${authorMention} собирает людей в ${activityName}";

  static m29(roleName) => "Роль \"${roleName}\" добавлена к базу данных";

  static m30(roleName, activityName) => "Роль \"${roleName}\" привязана к активности \"${activityName}\"";

  static m31(roleName, activityName) => "Роль \"${roleName}\" отвязана от активности \"${activityName}\"";

  static m32(roleName) => "Роль \"${roleName}\" удалена из базы данных";

  static m33(title, authorName) => "Время сбора для ${title} от ${authorName} наступило!";

  static m34(role) => "Выбрана роль: ${role}";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      'activityAddDescription': MessageLookupByLibrary.simpleMessage('Добавить активность'),
    'activityAddedMessage': m0,
    'activityCommandDescription': MessageLookupByLibrary.simpleMessage('Настройки активностей'),
    'activityRemoveDescription': MessageLookupByLibrary.simpleMessage('Удалить активность'),
    'activityRemovedMessage': m1,
    'activityRolesAddDescription': MessageLookupByLibrary.simpleMessage('Добавить роль в базу'),
    'activityRolesConnectDescription': MessageLookupByLibrary.simpleMessage('Привязать роль к активности'),
    'activityRolesDisconnectDescription': MessageLookupByLibrary.simpleMessage('Отвязать роль от активности'),
    'activityRolesGroupDescription': MessageLookupByLibrary.simpleMessage('Управлять ролями активности'),
    'activityRolesRemoveDescription': MessageLookupByLibrary.simpleMessage('Убрать роль из базы'),
    'adminActivityOptionDescription': MessageLookupByLibrary.simpleMessage('Активность'),
    'adminBotChannelPrefix': MessageLookupByLibrary.simpleMessage('LFG канал: '),
    'adminBotChannelsDescription': MessageLookupByLibrary.simpleMessage('Каналы, в которых бот работает'),
    'adminBotGroupDescription': MessageLookupByLibrary.simpleMessage('Тут можно получить информацию о настройках бота'),
    'adminBotPromoChannelPrefix': MessageLookupByLibrary.simpleMessage('Канал уведомлений: '),
    'adminBotRolesDescription': MessageLookupByLibrary.simpleMessage('Получить список ролей для активности'),
    'adminChannelOptionDescription': MessageLookupByLibrary.simpleMessage('канал'),
    'adminCommandDescription': MessageLookupByLibrary.simpleMessage('Команды администратора'),
    'adminDeleteMessageIdDescription': MessageLookupByLibrary.simpleMessage('ID сообщения для удаления'),
    'adminDeleteSubcommandDescription': MessageLookupByLibrary.simpleMessage('Удалить LFG'),
    'adminDeleteSuccess': m2,
    'adminHealthDatabaseUnavailable': m3,
    'adminHealthDescription': MessageLookupByLibrary.simpleMessage('Узнать состояние бота'),
    'adminHealthLfgHeader': MessageLookupByLibrary.simpleMessage('**LFGs:**'),
    'adminHealthPing': m4,
    'adminHealthScheduledCount': m5,
    'adminHealthSchedulerUnavailable': m6,
    'adminHealthStatsHeader': MessageLookupByLibrary.simpleMessage('**Stats:**'),
    'adminHealthTotalCount': m7,
    'adminPromoteAdded': MessageLookupByLibrary.simpleMessage('Сообщение добавлено'),
    'adminPromoteListHeader': MessageLookupByLibrary.simpleMessage('**Сообщения:**'),
    'adminPromoteRemoved': MessageLookupByLibrary.simpleMessage('Сообщение удалено'),
    'adminPromotesAddDescription': MessageLookupByLibrary.simpleMessage('Добавить новое сообщение'),
    'adminPromotesGroupDescription': MessageLookupByLibrary.simpleMessage('Настройки объявлений бота'),
    'adminPromotesListDescription': MessageLookupByLibrary.simpleMessage('Показать все сообщения'),
    'adminPromotesMessageIdDescription': MessageLookupByLibrary.simpleMessage('ID сообщения'),
    'adminPromotesRemoveDescription': MessageLookupByLibrary.simpleMessage('Удалить сообщение по ID'),
    'adminPromotesRoleActivityOptionDescription': MessageLookupByLibrary.simpleMessage('Активность'),
    'adminPromotesRoleClearDescription': MessageLookupByLibrary.simpleMessage('Очистить роль'),
    'adminPromotesRoleCleared': m8,
    'adminPromotesRoleCurrent': m9,
    'adminPromotesRoleNotSet': m10,
    'adminPromotesRoleOptionDescription': MessageLookupByLibrary.simpleMessage('Роль для пинга'),
    'adminPromotesRoleSet': m11,
    'adminPromotesRoleSetDescription': MessageLookupByLibrary.simpleMessage('Установить роль для упоминания'),
    'adminPromotesRoleViewDescription': MessageLookupByLibrary.simpleMessage('Показать текущую роль'),
    'adminPromotesTemplateHelp': MessageLookupByLibrary.simpleMessage('Шаблоны: AUTHOR, DESCRIPTION, DATE, MAX_MEMBERS, NAME, MESSAGE_URL'),
    'adminPromotesWeightDescription': MessageLookupByLibrary.simpleMessage('Вес сообщения'),
    'adminRoleOptionDescription': MessageLookupByLibrary.simpleMessage('Роль'),
    'adminRolesAvailability': m12,
    'adminSetGroupDescription': MessageLookupByLibrary.simpleMessage('Настройки бота'),
    'adminSetLfgChannelCleared': MessageLookupByLibrary.simpleMessage('LFG канал удален'),
    'adminSetLfgChannelDescription': MessageLookupByLibrary.simpleMessage('Установить LFG канал'),
    'adminSetLfgChannelSet': MessageLookupByLibrary.simpleMessage('LFG канал установлен'),
    'adminSetPromoChannelCleared': MessageLookupByLibrary.simpleMessage('Канал уведомлений удален'),
    'adminSetPromoChannelDescription': MessageLookupByLibrary.simpleMessage('Установить канал для оповещений о LFG'),
    'adminSetPromoChannelSet': MessageLookupByLibrary.simpleMessage('Канал уведомлений установлен'),
    'adminTimezoneAdded': m13,
    'adminTimezoneAlreadyExists': m14,
    'adminTimezoneInvalidName': MessageLookupByLibrary.simpleMessage('Введите корректное название таймзоны.'),
    'adminTimezoneNameDescription': MessageLookupByLibrary.simpleMessage('Название таймзоны'),
    'adminTimezoneNotFound': m15,
    'adminTimezoneOffsetDescription': MessageLookupByLibrary.simpleMessage('Смещение относительно UTC (часы)'),
    'adminTimezoneRemoved': m16,
    'adminTimezonesAddDescription': MessageLookupByLibrary.simpleMessage('Добавить новую таймзону'),
    'adminTimezonesGroupDescription': MessageLookupByLibrary.simpleMessage('Управление таймзонами'),
    'adminTimezonesRemoveDescription': MessageLookupByLibrary.simpleMessage('Удалить таймзону'),
    'alreadyJoinedMessage': MessageLookupByLibrary.simpleMessage('Вы уже присоединились к этому сбору.'),
    'alwaysUserPermissionError': MessageLookupByLibrary.simpleMessage('У вас недостаточно прав для использования этой команды'),
    'alwaysUserUnknownMember': MessageLookupByLibrary.simpleMessage('Не удалось определить пользователя'),
    'cantRespondError': m17,
    'commandOptionDateDescription': MessageLookupByLibrary.simpleMessage('Введите дату начала активности [15 01 2023]'),
    'commandOptionDateKey': MessageLookupByLibrary.simpleMessage('дата'),
    'commandOptionDescriptionDescription': MessageLookupByLibrary.simpleMessage('Введите описание активности'),
    'commandOptionDescriptionKey': MessageLookupByLibrary.simpleMessage('описание'),
    'commandOptionNameDescription': MessageLookupByLibrary.simpleMessage('Введите название активности'),
    'commandOptionNameKey': MessageLookupByLibrary.simpleMessage('название'),
    'commandOptionTimeDescription': MessageLookupByLibrary.simpleMessage('Введите время начала активности [15 01]'),
    'commandOptionTimeKey': MessageLookupByLibrary.simpleMessage('время'),
    'commandOptionTimezoneDescription': MessageLookupByLibrary.simpleMessage('Введите ваш текущий часовой пояс'),
    'commandOptionTimezoneKey': MessageLookupByLibrary.simpleMessage('часовой_пояс'),
    'commonUnknownUser': MessageLookupByLibrary.simpleMessage('неизвестен'),
    'commonValueNotSet': MessageLookupByLibrary.simpleMessage('Не установлен'),
    'createCommandChannelRestriction': m18,
    'createCommandDefaultDescription': MessageLookupByLibrary.simpleMessage('Создать рейд'),
    'createCommandDescription': MessageLookupByLibrary.simpleMessage('Создать активность'),
    'createCommandSubcommandDescription': MessageLookupByLibrary.simpleMessage('Создать сбор на активность'),
    'creatorCannotLeaveMessage': MessageLookupByLibrary.simpleMessage('Невозможно покинуть сбор, так как вы являетесь его создателем. Если вы хотите удалить сбор, нажмите ПКМ по сообщению, выберите \"Приложения\", затем \"Удалить LFG\".'),
    'deleteCommandMessageNotFound': MessageLookupByLibrary.simpleMessage('Не удалось удалить сообщение [NotFound]'),
    'deleteCommandName': MessageLookupByLibrary.simpleMessage('Удалить LFG'),
    'deleteCommandNotAuthor': MessageLookupByLibrary.simpleMessage('Вы не можете удалить это LFG, т.к. не являетесь его автором [NotAuthor]'),
    'deleteCommandSuccess': m19,
    'editCommandCompleted': MessageLookupByLibrary.simpleMessage('Редактирование завершено'),
    'editCommandDateLabel': MessageLookupByLibrary.simpleMessage('Дата начала'),
    'editCommandDescriptionLabel': MessageLookupByLibrary.simpleMessage('Описание'),
    'editCommandDescriptionPlaceholder': MessageLookupByLibrary.simpleMessage('Введите новое описание'),
    'editCommandMessageNotFound': MessageLookupByLibrary.simpleMessage('Не удалось редактировать сообщение [NotFound]'),
    'editCommandModalMessageNotFound': MessageLookupByLibrary.simpleMessage('Не удалось отредактировать сообщение [NotFound]'),
    'editCommandModalTitle': MessageLookupByLibrary.simpleMessage('Редактирование LFG'),
    'editCommandName': MessageLookupByLibrary.simpleMessage('Редактировать LFG'),
    'editCommandNotAuthor': MessageLookupByLibrary.simpleMessage('Вы не можете редактировать это LFG, т.к. не являетесь его автором [NotAuthor]'),
    'editCommandStartTimePlaceholder': MessageLookupByLibrary.simpleMessage('Введите новое время начала'),
    'editCommandTimeLabel': MessageLookupByLibrary.simpleMessage('Время начала'),
    'generalMetadata': m20,
    'generalStackTrace': m21,
    'interactorCommandError': m22,
    'interactorUnknownResponse': MessageLookupByLibrary.simpleMessage('Я не знаю, как на это ответить :('),
    'joinComponentJoined': MessageLookupByLibrary.simpleMessage('Вы добавлены в LFG'),
    'joinComponentPrompt': MessageLookupByLibrary.simpleMessage('Выберите роль для участия'),
    'joinComponentPromptWithColon': MessageLookupByLibrary.simpleMessage('Выберите роль для участия:'),
    'joinComponentRoleExampleOne': MessageLookupByLibrary.simpleMessage('Роль 1'),
    'joinComponentRoleExampleThree': MessageLookupByLibrary.simpleMessage('Роль 3'),
    'joinComponentRoleExampleTwo': MessageLookupByLibrary.simpleMessage('Роль 2'),
    'joinComponentRolePicked': m23,
    'leaveComponentLeft': MessageLookupByLibrary.simpleMessage('Вы покинули LFG'),
    'leaveComponentUnknownErrorTitle': MessageLookupByLibrary.simpleMessage('Произошла неизвестная ошибка при удалении вас из LFG'),
    'lfgChannelInvalid': m24,
    'lfgChannelNotConfigured': MessageLookupByLibrary.simpleMessage('Канал LFG не настроен'),
    'lfgJoinButtonLabel': MessageLookupByLibrary.simpleMessage('➕  Присоединиться'),
    'lfgLeaveButtonLabel': MessageLookupByLibrary.simpleMessage('➖  Покинуть'),
    'lfgMembersLabel': m25,
    'lfgNotFoundMessage': m26,
    'lfgStartTimeLabel': MessageLookupByLibrary.simpleMessage('Время сбора:'),
    'notCreatorMessage': MessageLookupByLibrary.simpleMessage('Невозможно выполнить команду, так как вы не являетесь создателем сбора.'),
    'notJoinedMessage': MessageLookupByLibrary.simpleMessage('Невозможно покинуть сбор, в котором вы не участвуете.'),
    'promoterChannelInvalid': m27,
    'promoterDefaultTemplate': m28,
    'promoterNewGatheringTitle': MessageLookupByLibrary.simpleMessage('Новый сбор!'),
    'promptEnterBannerUrl': MessageLookupByLibrary.simpleMessage('Введите URL баннера'),
    'promptEnterMaxMembers': MessageLookupByLibrary.simpleMessage('Введите максимальное количество участников'),
    'promptEnterRoleName': MessageLookupByLibrary.simpleMessage('Введите название роли'),
    'promptEnterRoleNameWithEmoji': MessageLookupByLibrary.simpleMessage('Введите название роли (можно вставлять эмодзи)'),
    'promptEnterRoleQuantity': MessageLookupByLibrary.simpleMessage('Сколько участников требуется для этой роли'),
    'promptUploadBanner': MessageLookupByLibrary.simpleMessage('Или загрузите баннер'),
    'roleAddedToDatabaseMessage': m29,
    'roleConnectedToActivityMessage': m30,
    'roleDisconnectedFromActivityMessage': m31,
    'roleNotPickedMessage': MessageLookupByLibrary.simpleMessage('Роль не выбрана'),
    'rolePickerTimeoutMessage': MessageLookupByLibrary.simpleMessage('Превышено время ожидания выбора роли'),
    'roleRemovedFromDatabaseMessage': m32,
    'schedulerPostStartNotification': m33,
    'selectedMessageIsNotLfg': MessageLookupByLibrary.simpleMessage('Данное сообщение не содержит LFG [LFGNotFound]'),
    'selectedRoleConfirmation': m34,
    'tooManyPlayersMessage': MessageLookupByLibrary.simpleMessage('Невозможно присоединиться к сбору, так как он уже заполнен.')
  };
}
