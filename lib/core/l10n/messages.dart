import 'package:intl/intl.dart';

/// Localized strings shared across the Omega bot.
///
/// Each getter or method wraps an [Intl.message] call so translations can be
/// extracted into ARB files. Group related strings together to ease
/// maintenance and translation.

// Command option names and descriptions
String get commandOptionNameKey => Intl.message(
      'название',
      name: 'commandOptionNameKey',
      desc: 'Slash command option name for activity title.',
    );

String get commandOptionNameDescription => Intl.message(
      'Введите название активности',
      name: 'commandOptionNameDescription',
      desc: 'Prompt shown when user has to provide an activity title.',
    );

String get commandOptionDescriptionKey => Intl.message(
      'описание',
      name: 'commandOptionDescriptionKey',
      desc: 'Slash command option name for activity description.',
    );

String get commandOptionDescriptionDescription => Intl.message(
      'Введите описание активности',
      name: 'commandOptionDescriptionDescription',
      desc: 'Prompt shown when user has to provide an activity description.',
    );

String get commandOptionDateKey => Intl.message(
      'дата',
      name: 'commandOptionDateKey',
      desc: 'Slash command option name for activity date.',
    );

String get commandOptionDateDescription => Intl.message(
      'Введите дату начала активности [15 01 2023]',
      name: 'commandOptionDateDescription',
      desc: 'Prompt shown when user has to provide an activity start date.',
    );

String get commandOptionTimeKey => Intl.message(
      'время',
      name: 'commandOptionTimeKey',
      desc: 'Slash command option name for activity time.',
    );

String get commandOptionTimeDescription => Intl.message(
      'Введите время начала активности [15 01]',
      name: 'commandOptionTimeDescription',
      desc: 'Prompt shown when user has to provide an activity start time.',
    );

String get commandOptionTimezoneKey => Intl.message(
      'часовой_пояс',
      name: 'commandOptionTimezoneKey',
      desc: 'Slash command option name for activity timezone offset.',
    );

String get commandOptionTimezoneDescription => Intl.message(
      'Введите ваш текущий часовой пояс',
      name: 'commandOptionTimezoneDescription',
      desc: 'Prompt shown when user has to provide their timezone offset.',
    );

// Create command
String get createCommandDescription => Intl.message(
      'Создать активность',
      name: 'createCommandDescription',
      desc: 'Top-level command description for creating activities.',
    );

String get createCommandSubcommandDescription => Intl.message(
      'Создать сбор на активность',
      name: 'createCommandSubcommandDescription',
      desc: 'Description for the subcommand that creates an LFG for an activity.',
    );

String createCommandChannelRestriction(String channelId) => Intl.message(
      'Команда доступна только в канале для поиска группы: <#$channelId>',
      name: 'createCommandChannelRestriction',
      args: [channelId],
      desc: 'Error shown when the create command is used outside the LFG channel.',
      examples: const {'channelId': '123456789012345678'},
    );

String get createCommandDefaultDescription => Intl.message(
      'Создать рейд',
      name: 'createCommandDefaultDescription',
      desc: 'Fallback description for the create raid command.',
    );

// Edit command
String get editCommandName => Intl.message(
      'Редактировать LFG',
      name: 'editCommandName',
      desc: 'Context command title used to edit an existing LFG message.',
    );

String get editCommandMessageNotFound => Intl.message(
      'Не удалось редактировать сообщение [NotFound]',
      name: 'editCommandMessageNotFound',
      desc: 'Error shown when the target message cannot be fetched during edit.',
    );

String get selectedMessageIsNotLfg => Intl.message(
      'Данное сообщение не содержит LFG [LFGNotFound]',
      name: 'selectedMessageIsNotLfg',
      desc: 'Error shown when the selected message is not an LFG post.',
    );

String get editCommandNotAuthor => Intl.message(
      'Вы не можете редактировать это LFG, т.к. не являетесь его автором [NotAuthor]',
      name: 'editCommandNotAuthor',
      desc: 'Error shown when a user tries to edit an LFG they did not create.',
    );

String get editCommandModalTitle => Intl.message(
      'Редактирование LFG',
      name: 'editCommandModalTitle',
      desc: 'Title for the modal that edits an LFG post.',
    );

String get editCommandDescriptionLabel => Intl.message(
      'Описание',
      name: 'editCommandDescriptionLabel',
      desc: 'Label for the description field in the edit modal.',
    );

String get editCommandDescriptionPlaceholder => Intl.message(
      'Введите новое описание',
      name: 'editCommandDescriptionPlaceholder',
      desc: 'Placeholder shown for the description field in the edit modal.',
    );

String get editCommandDateLabel => Intl.message(
      'Дата начала',
      name: 'editCommandDateLabel',
      desc: 'Label for the date input in the edit modal.',
    );

String get editCommandStartTimePlaceholder => Intl.message(
      'Введите новое время начала',
      name: 'editCommandStartTimePlaceholder',
      desc: 'Placeholder shown for date/time fields when editing an LFG.',
    );

String get editCommandTimeLabel => Intl.message(
      'Время начала',
      name: 'editCommandTimeLabel',
      desc: 'Label for the time input in the edit modal.',
    );

String get editCommandModalMessageNotFound => Intl.message(
      'Не удалось отредактировать сообщение [NotFound]',
      name: 'editCommandModalMessageNotFound',
      desc: 'Error shown when the message disappears before modal submission.',
    );

String get editCommandCompleted => Intl.message(
      'Редактирование завершено',
      name: 'editCommandCompleted',
      desc: 'Confirmation shown after an LFG message has been edited.',
    );

// Delete command
String get deleteCommandName => Intl.message(
      'Удалить LFG',
      name: 'deleteCommandName',
      desc: 'Context command title used to delete an existing LFG message.',
    );

String get deleteCommandMessageNotFound => Intl.message(
      'Не удалось удалить сообщение [NotFound]',
      name: 'deleteCommandMessageNotFound',
      desc: 'Error shown when the bot cannot access a message during deletion.',
    );

String get deleteCommandNotAuthor => Intl.message(
      'Вы не можете удалить это LFG, т.к. не являетесь его автором [NotAuthor]',
      name: 'deleteCommandNotAuthor',
      desc: 'Error shown when a user tries to delete an LFG they did not create.',
    );

String deleteCommandSuccess(String title) => Intl.message(
      'Ваше LFG "$title" удалено.',
      name: 'deleteCommandSuccess',
      args: [title],
      desc: 'Confirmation shown when a user deletes their LFG post.',
      examples: const {'title': 'Raid Night'},
    );

// Admin command
String get adminCommandDescription => Intl.message(
      'Команды администратора',
      name: 'adminCommandDescription',
      desc: 'Description for the /admin command root.',
    );

String get adminDeleteSubcommandDescription => Intl.message(
      'Удалить LFG',
      name: 'adminDeleteSubcommandDescription',
      desc: 'Description for the subcommand that removes an LFG post.',
    );

String get adminDeleteMessageIdDescription => Intl.message(
      'ID сообщения для удаления',
      name: 'adminDeleteMessageIdDescription',
      desc: 'Description for the message id parameter in delete subcommand.',
    );

String get adminHealthDescription => Intl.message(
      'Узнать состояние бота',
      name: 'adminHealthDescription',
      desc: 'Description for the admin health subcommand.',
    );

String get adminSetGroupDescription => Intl.message(
      'Настройки бота',
      name: 'adminSetGroupDescription',
      desc: 'Description for the admin set subcommand group.',
    );

String get adminSetLfgChannelDescription => Intl.message(
      'Установить LFG канал',
      name: 'adminSetLfgChannelDescription',
      desc: 'Description for configuring the LFG channel.',
    );

String get adminSetPromoChannelDescription => Intl.message(
      'Установить канал для оповещений о LFG',
      name: 'adminSetPromoChannelDescription',
      desc: 'Description for configuring the promo channel.',
    );

String get adminPromotesGroupDescription => Intl.message(
      'Настройки объявлений бота',
      name: 'adminPromotesGroupDescription',
      desc: 'Description for the promotes subcommand group.',
    );

String get adminPromotesAddDescription => Intl.message(
      'Добавить новое сообщение',
      name: 'adminPromotesAddDescription',
      desc: 'Description for adding a new promote message.',
    );

String get adminPromotesTemplateHelp => Intl.message(
      'Шаблоны: {AUTHOR}, {DESCRIPTION}, {DATE}, {MAX_MEMBERS}, {NAME}, {MESSAGE_URL}',
      name: 'adminPromotesTemplateHelp',
      desc: 'Help text listing supported promote message templates.',
    );

String get adminPromotesWeightDescription => Intl.message(
      'Вес сообщения',
      name: 'adminPromotesWeightDescription',
      desc: 'Description for the promote message weight option.',
    );

String get adminPromotesRemoveDescription => Intl.message(
      'Удалить сообщение по ID',
      name: 'adminPromotesRemoveDescription',
      desc: 'Description for removing a promote message by id.',
    );

String get adminPromotesMessageIdDescription => Intl.message(
      'ID сообщения',
      name: 'adminPromotesMessageIdDescription',
      desc: 'Description for the promote message id option.',
    );

String get adminPromotesListDescription => Intl.message(
      'Показать все сообщения',
      name: 'adminPromotesListDescription',
      desc: 'Description for listing promote messages.',
    );

String get adminBotGroupDescription => Intl.message(
      'Тут можно получить информацию о настройках бота',
      name: 'adminBotGroupDescription',
      desc: 'Description for the admin bot information subcommand group.',
    );

String get adminBotChannelsDescription => Intl.message(
      'Каналы, в которых бот работает',
      name: 'adminBotChannelsDescription',
      desc: 'Description for listing working channels.',
    );

String get adminBotRolesDescription => Intl.message(
      'Получить список ролей для активности',
      name: 'adminBotRolesDescription',
      desc: 'Description for retrieving available roles per activity.',
    );

String get adminActivityOptionDescription => Intl.message(
      'Активность',
      name: 'adminActivityOptionDescription',
      desc: 'Description for the activity option in admin commands.',
    );

String get adminSetLfgChannelSet => Intl.message(
      'LFG канал установлен',
      name: 'adminSetLfgChannelSet',
      desc: 'Confirmation shown after setting the LFG channel.',
    );

String get adminSetLfgChannelCleared => Intl.message(
      'LFG канал удален',
      name: 'adminSetLfgChannelCleared',
      desc: 'Confirmation shown after clearing the LFG channel.',
    );

String get adminSetPromoChannelSet => Intl.message(
      'Канал уведомлений установлен',
      name: 'adminSetPromoChannelSet',
      desc: 'Confirmation shown after setting the promo channel.',
    );

String get adminSetPromoChannelCleared => Intl.message(
      'Канал уведомлений удален',
      name: 'adminSetPromoChannelCleared',
      desc: 'Confirmation shown after clearing the promo channel.',
    );

String get adminPromoteAdded => Intl.message(
      'Сообщение добавлено',
      name: 'adminPromoteAdded',
      desc: 'Confirmation shown after a promote message is added.',
    );

String get adminPromoteRemoved => Intl.message(
      'Сообщение удалено',
      name: 'adminPromoteRemoved',
      desc: 'Confirmation shown after a promote message is removed.',
    );

String get adminPromoteListHeader => Intl.message(
      '**Сообщения:**',
      name: 'adminPromoteListHeader',
      desc: 'Header displayed before listing promote messages.',
    );

String get adminBotChannelPrefix => Intl.message(
      'LFG канал: ',
      name: 'adminBotChannelPrefix',
      desc: 'Prefix used when showing the configured LFG channel.',
    );

String get adminBotPromoChannelPrefix => Intl.message(
      'Канал уведомлений: ',
      name: 'adminBotPromoChannelPrefix',
      desc: 'Prefix used when showing the configured promo channel.',
    );

String get commonValueNotSet => Intl.message(
      'Не установлен',
      name: 'commonValueNotSet',
      desc: 'Label used when a configuration value is missing.',
    );

String adminRolesAvailability(String activity, int freeSlots, String role) => Intl.message(
      'Активность "$activity" имеет $freeSlots свободных ролей "$role"',
      name: 'adminRolesAvailability',
      args: [activity, freeSlots, role],
      desc: 'Message showing how many free roles remain for an activity.',
      examples: const {
        'activity': 'Raid',
        'freeSlots': 2,
        'role': 'Tank',
      },
    );

String get adminChannelOptionDescription => Intl.message(
      'канал',
      name: 'adminChannelOptionDescription',
      desc: 'Description for the channel selection option.',
    );

String get adminRoleOptionDescription => Intl.message(
      'Роль',
      name: 'adminRoleOptionDescription',
      desc: 'Description for the role selection option.',
    );

String adminDeleteSuccess(String userName, String activityTitle) => Intl.message(
      'LFG пользователя "$userName", с активностью "$activityTitle" удалено.',
      name: 'adminDeleteSuccess',
      args: [userName, activityTitle],
      desc: 'Confirmation shown after an admin deletes someone else\'s LFG.',
      examples: const {
        'userName': 'OmegaUser',
        'activityTitle': 'Raid Night',
      },
    );

String get commonUnknownUser => Intl.message(
      'неизвестен',
      name: 'commonUnknownUser',
      desc: 'Fallback label when user information is missing.',
    );

// Activity command
String get activityCommandDescription => Intl.message(
      'Настройки активностей',
      name: 'activityCommandDescription',
      desc: 'Description for the /activity command root.',
    );

String get activityAddDescription => Intl.message(
      'Добавить активность',
      name: 'activityAddDescription',
      desc: 'Description for subcommand that adds a new activity.',
    );

String get promptEnterMaxMembers => Intl.message(
      'Введите максимальное количество участников',
      name: 'promptEnterMaxMembers',
      desc: 'Prompt asking for the maximum members of an activity.',
    );

String get promptEnterBannerUrl => Intl.message(
      'Введите URL баннера',
      name: 'promptEnterBannerUrl',
      desc: 'Prompt asking for the external banner URL.',
    );

String get promptUploadBanner => Intl.message(
      'Или загрузите баннер',
      name: 'promptUploadBanner',
      desc: 'Prompt suggesting to upload a banner file.',
    );

String get activityRemoveDescription => Intl.message(
      'Удалить активность',
      name: 'activityRemoveDescription',
      desc: 'Description for subcommand that removes an activity.',
    );

String get activityRolesGroupDescription => Intl.message(
      'Управлять ролями активности',
      name: 'activityRolesGroupDescription',
      desc: 'Description for the activity roles subcommand group.',
    );

String get activityRolesAddDescription => Intl.message(
      'Добавить роль в базу',
      name: 'activityRolesAddDescription',
      desc: 'Description for the subcommand adding a role to the pool.',
    );

String get promptEnterRoleNameWithEmoji => Intl.message(
      'Введите название роли (можно вставлять эмодзи)',
      name: 'promptEnterRoleNameWithEmoji',
      desc: 'Prompt asking for a role name with emoji support.',
    );

String get activityRolesRemoveDescription => Intl.message(
      'Убрать роль из базы',
      name: 'activityRolesRemoveDescription',
      desc: 'Description for subcommand removing a role from the pool.',
    );

String get promptEnterRoleName => Intl.message(
      'Введите название роли',
      name: 'promptEnterRoleName',
      desc: 'Prompt asking for a role name.',
    );

String get activityRolesConnectDescription => Intl.message(
      'Привязать роль к активности',
      name: 'activityRolesConnectDescription',
      desc: 'Description for subcommand linking a role to an activity.',
    );

String get promptEnterRoleQuantity => Intl.message(
      'Сколько участников требуется для этой роли',
      name: 'promptEnterRoleQuantity',
      desc: 'Prompt asking how many members are needed for the role.',
    );

String get activityRolesDisconnectDescription => Intl.message(
      'Отвязать роль от активности',
      name: 'activityRolesDisconnectDescription',
      desc: 'Description for subcommand unlinking a role from an activity.',
    );

String activityAddedMessage(String activityName) => Intl.message(
      'Активность "$activityName" добавлена',
      name: 'activityAddedMessage',
      args: [activityName],
      desc: 'Confirmation shown after adding an activity.',
      examples: const {'activityName': 'Raid'},
    );

String activityRemovedMessage(String activityName) => Intl.message(
      'Активность "$activityName" удалена',
      name: 'activityRemovedMessage',
      args: [activityName],
      desc: 'Confirmation shown after removing an activity.',
      examples: const {'activityName': 'Raid'},
    );

String roleAddedToDatabaseMessage(String roleName) => Intl.message(
      'Роль "$roleName" добавлена к базу данных',
      name: 'roleAddedToDatabaseMessage',
      args: [roleName],
      desc: 'Confirmation shown after adding a role to the pool.',
      examples: const {'roleName': 'Tank'},
    );

String roleRemovedFromDatabaseMessage(String roleName) => Intl.message(
      'Роль "$roleName" удалена из базы данных',
      name: 'roleRemovedFromDatabaseMessage',
      args: [roleName],
      desc: 'Confirmation shown after removing a role from the pool.',
      examples: const {'roleName': 'Tank'},
    );

String roleConnectedToActivityMessage(String roleName, String activityName) => Intl.message(
      'Роль "$roleName" привязана к активности "$activityName"',
      name: 'roleConnectedToActivityMessage',
      args: [roleName, activityName],
      desc: 'Confirmation shown after assigning a role to an activity.',
      examples: const {'roleName': 'Tank', 'activityName': 'Raid'},
    );

String roleDisconnectedFromActivityMessage(String roleName, String activityName) => Intl.message(
      'Роль "$roleName" отвязана от активности "$activityName"',
      name: 'roleDisconnectedFromActivityMessage',
      args: [roleName, activityName],
      desc: 'Confirmation shown after removing a role from an activity.',
      examples: const {'roleName': 'Tank', 'activityName': 'Raid'},
    );

// Promoter
String promoterChannelInvalid(String channelId) => Intl.message(
      'Канал для объявлений настроен неверно.\nID: $channelId',
      name: 'promoterChannelInvalid',
      args: [channelId],
      desc: 'Error when the configured promo channel is not a guild text channel.',
      examples: const {'channelId': '123456789012345678'},
    );

String get promoterDefaultTemplate => Intl.message(
      '{AUTHOR} собирает людей в {NAME}',
      name: 'promoterDefaultTemplate',
      desc: 'Fallback promote message template.',
    );

String get promoterNewGatheringTitle => Intl.message(
      'Новый сбор!',
      name: 'promoterNewGatheringTitle',
      desc: 'Title for the first line of the promote embed.',
    );

// Interactor
String get interactorUnknownResponse => Intl.message(
      'Я не знаю, как на это ответить :(',
      name: 'interactorUnknownResponse',
      desc: 'Fallback response when no handler is available.',
    );

String interactorCommandError(String error) => Intl.message(
      'Произошла ошибка при выполнении команды :(\n\n$error',
      name: 'interactorCommandError',
      args: [error],
      desc: 'Error message shown when a command handler throws.',
      examples: const {'error': 'Exception message'},
    );

// LFG manager
String get rolePickerTimeoutMessage => Intl.message(
      'Превышено время ожидания выбора роли',
      name: 'rolePickerTimeoutMessage',
      desc: 'Error shown when a member fails to pick a role in time.',
    );

String selectedRoleConfirmation(String role) => Intl.message(
      'Выбрана роль: $role',
      name: 'selectedRoleConfirmation',
      args: [role],
      desc: 'Confirmation shown after a member selects a role.',
      examples: const {'role': 'Tank'},
    );

String lfgNotFoundMessage(String id) => Intl.message(
      'LFG $id не найден',
      name: 'lfgNotFoundMessage',
      args: [id],
      desc: 'Error when an LFG post with the provided id does not exist.',
      examples: const {'id': '123456789'},
    );

String get lfgChannelNotConfigured => Intl.message(
      'Канал LFG не настроен',
      name: 'lfgChannelNotConfigured',
      desc: 'Error when the LFG channel is missing from configuration.',
    );

String lfgChannelInvalid(String channelId) => Intl.message(
      'Канал LFG не найден или настроен неправильно\nID: $channelId',
      name: 'lfgChannelInvalid',
      args: [channelId],
      desc: 'Error when the configured LFG channel is invalid.',
      examples: const {'channelId': '123456789012345678'},
    );

String get roleNotPickedMessage => Intl.message(
      'Роль не выбрана',
      name: 'roleNotPickedMessage',
      desc: 'Error when a member fails to select a role.',
    );

// LFG message builder
String get lfgStartTimeLabel => Intl.message(
      'Время сбора:',
      name: 'lfgStartTimeLabel',
      desc: 'Label for the start time of an LFG embed.',
    );

String lfgMembersLabel(int current, int max) => Intl.message(
      'Участники ($current/$max):',
      name: 'lfgMembersLabel',
      args: [current, max],
      desc: 'Label showing participants count in an LFG embed.',
      examples: const {'current': 1, 'max': 6},
    );

String get lfgJoinButtonLabel => Intl.message(
      '➕  Присоединиться',
      name: 'lfgJoinButtonLabel',
      desc: 'Label for the join button under an LFG message.',
    );

String get lfgLeaveButtonLabel => Intl.message(
      '➖  Покинуть',
      name: 'lfgLeaveButtonLabel',
      desc: 'Label for the leave button under an LFG message.',
    );

// Scheduler
String schedulerPostStartNotification(String title, String authorName) => Intl.message(
      'Время сбора для $title от $authorName наступило!',
      name: 'schedulerPostStartNotification',
      args: [title, authorName],
      desc: 'Notification sent when an LFG start time is reached.',
      examples: const {'title': 'Raid Night', 'authorName': 'Omega'},
    );

// Join component
String joinComponentRolePicked(String role) => Intl.message(
      'Вы выбрали роль $role',
      name: 'joinComponentRolePicked',
      args: [role],
      desc: 'Confirmation sent after a member picks a role from the role picker.',
      examples: const {'role': 'Tank'},
    );

String get joinComponentJoined => Intl.message(
      'Вы добавлены в LFG',
      name: 'joinComponentJoined',
      desc: 'Confirmation shown after joining an LFG.',
    );

String get joinComponentPrompt => Intl.message(
      'Выберите роль для участия',
      name: 'joinComponentPrompt',
      desc: 'Prompt suggesting to pick a role.',
    );

String get joinComponentPromptWithColon => Intl.message(
      'Выберите роль для участия:',
      name: 'joinComponentPromptWithColon',
      desc: 'Prompt with colon when rendering a select menu.',
    );

String get joinComponentRoleExampleOne => Intl.message(
      'Роль 1',
      name: 'joinComponentRoleExampleOne',
      desc: 'Placeholder label for the first example role.',
    );

String get joinComponentRoleExampleTwo => Intl.message(
      'Роль 2',
      name: 'joinComponentRoleExampleTwo',
      desc: 'Placeholder label for the second example role.',
    );

String get joinComponentRoleExampleThree => Intl.message(
      'Роль 3',
      name: 'joinComponentRoleExampleThree',
      desc: 'Placeholder label for the third example role.',
    );

// Leave component
String get leaveComponentLeft => Intl.message(
      'Вы покинули LFG',
      name: 'leaveComponentLeft',
      desc: 'Confirmation shown after leaving an LFG.',
    );

String get leaveComponentUnknownErrorTitle => Intl.message(
      'Произошла неизвестная ошибка при удалении вас из LFG',
      name: 'leaveComponentUnknownErrorTitle',
      desc: 'Header for an unexpected error during leave flow.',
    );

String generalMetadata(String metadata) => Intl.message(
      'Метаданные: $metadata',
      name: 'generalMetadata',
      args: [metadata],
      desc: 'Line prefixing additional error metadata.',
      examples: const {'metadata': 'Some error'},
    );

String generalStackTrace(String stack) => Intl.message(
      'Стек вызовов: $stack',
      name: 'generalStackTrace',
      args: [stack],
      desc: 'Line prefixing stack trace information.',
      examples: const {'stack': 'Stack trace'},
    );

// Command exceptions
String get tooManyPlayersMessage => Intl.message(
      'Невозможно присоединиться к сбору, так как он уже заполнен.',
      name: 'tooManyPlayersMessage',
      desc: 'Error when an activity is full.',
    );

String get creatorCannotLeaveMessage => Intl.message(
      'Невозможно покинуть сбор, так как вы являетесь его создателем. Если вы хотите удалить сбор, '
      'нажмите ПКМ по сообщению, выберите "Приложения", затем "Удалить LFG".',
      name: 'creatorCannotLeaveMessage',
      desc: 'Error when creator attempts to leave their own gathering.',
    );

String get alreadyJoinedMessage => Intl.message(
      'Вы уже присоединились к этому сбору.',
      name: 'alreadyJoinedMessage',
      desc: 'Error when trying to join an activity twice.',
    );

String get notJoinedMessage => Intl.message(
      'Невозможно покинуть сбор, в котором вы не участвуете.',
      name: 'notJoinedMessage',
      desc: 'Error when trying to leave an activity you are not part of.',
    );

String get notCreatorMessage => Intl.message(
      'Невозможно выполнить команду, так как вы не являетесь создателем сбора.',
      name: 'notCreatorMessage',
      desc: 'Error when a non-creator tries to modify an LFG.',
    );

String cantRespondError(String reason) => Intl.message(
      'Невозможно выполнить команду.\nПричина: $reason\nПопробуйте ещё раз или обратитесь к администрации сервера.',
      name: 'cantRespondError',
      args: [reason],
      desc: 'Generic message wrapping the reason why a command cannot be executed.',
      examples: const {'reason': 'Missing permissions'},
    );

// Admin health report
String get adminHealthStatsHeader => Intl.message(
      '**Stats:**',
      name: 'adminHealthStatsHeader',
      desc: 'Header for the stats section in admin health report.',
    );

String adminHealthPing(int milliseconds) => Intl.message(
      'Ping: ${milliseconds}ms',
      name: 'adminHealthPing',
      args: [milliseconds],
      desc: 'Displays the current ping in milliseconds.',
      examples: const {'milliseconds': 120},
    );

String get adminHealthLfgHeader => Intl.message(
      '**LFGs:**',
      name: 'adminHealthLfgHeader',
      desc: 'Header for the LFG section in admin health report.',
    );

String adminHealthScheduledCount(int count) => Intl.message(
      'Scheduled: $count',
      name: 'adminHealthScheduledCount',
      args: [count],
      desc: 'Shows how many LFG posts are scheduled.',
      examples: const {'count': 3},
    );

String adminHealthSchedulerUnavailable(String error) => Intl.message(
      'Scheduler unavailable: $error',
      name: 'adminHealthSchedulerUnavailable',
      args: [error],
      desc: 'Displayed when the scheduler cannot be queried.',
      examples: const {'error': 'Connection error'},
    );

String adminHealthTotalCount(int count) => Intl.message(
      'Total: $count',
      name: 'adminHealthTotalCount',
      args: [count],
      desc: 'Shows total count of LFG posts in database.',
      examples: const {'count': 42},
    );

String adminHealthDatabaseUnavailable(String error) => Intl.message(
      'Database unavailable: $error',
      name: 'adminHealthDatabaseUnavailable',
      args: [error],
      desc: 'Displayed when the database cannot be accessed.',
      examples: const {'error': 'Timeout'},
    );

// Interceptors
String get alwaysUserPermissionError => Intl.message(
      'У вас недостаточно прав для использования этой команды',
      name: 'alwaysUserPermissionError',
      desc: 'Error shown when a user without permissions tries to run an admin command.',
    );

String get alwaysUserUnknownMember => Intl.message(
      'Не удалось определить пользователя',
      name: 'alwaysUserUnknownMember',
      desc: 'Error when the interaction has no associated guild member.',
    );
