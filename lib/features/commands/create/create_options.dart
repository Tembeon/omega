import 'package:lfg_bot/core/utils/config_data_loader.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../../core/data/enums/activity_type.dart';

List<CommandOptionBuilder> createActivityOptionsFor(LFGActivityType type) {
  return [
    _nameOption(type),
    _descriptionOption,
    _dateOption,
    _timeOption,
    _timezoneOption,
  ];
}

/// Option for activity date input
CommandOptionBuilder get _dateOption {
  return CommandOptionBuilder(
    CommandOptionType.string,
    'дата',
    'Введите дату сбора [15 01 2023]',
    required: true,
  );
}

/// Option for activity time input
CommandOptionBuilder get _timeOption {
  return CommandOptionBuilder(
    CommandOptionType.string,
    'время',
    'Введите время сбора [08 30]',
    required: true,
  );
}

/// Option for activity description input
CommandOptionBuilder get _descriptionOption {
  return CommandOptionBuilder(
    CommandOptionType.string,
    'описание',
    'Введите описание вашего сбора',
    required: true,
  );
}

/// Option for user's timezone input
CommandOptionBuilder get _timezoneOption {
  Map<String, String> timezones = {
    'UTC±0 (GMT)': '0',
    'UTC+1 (WET)': '1',
    'UTC+2 (EET)': '2',
    'UTC+3 (MSK)': '3',
    'UTC+4 (GET)': '4',
  };

  List<ArgChoiceBuilder> getChoices() {
    final List<ArgChoiceBuilder> choices = [];

    timezones.forEach((key, value) {
      choices.add(ArgChoiceBuilder(key, value));
    });

    return choices;
  }

  return CommandOptionBuilder(
    CommandOptionType.integer,
    'часовой_пояс',
    'Введите ваш текущий часовой пояс',
    required: true,
    choices: getChoices(),
  );
}

CommandOptionBuilder _nameOption(LFGActivityType type) {
  List<ArgChoiceBuilder> getChoices() {
    final activities = switch (type) {
      LFGActivityType.dungeon => ConfigDataLoader.dungeons,
      LFGActivityType.raid => ConfigDataLoader.raids,
      LFGActivityType.custom => ConfigDataLoader.custom,
    };

    final List<ArgChoiceBuilder> choices = [];

    for (final activity in activities) {
      if (!activity.enabled) continue;
      choices.add(ArgChoiceBuilder(activity.name, activity.name));
    }

    return choices;
  }

  return CommandOptionBuilder(
    CommandOptionType.string,
    'название',
    'Введите название вашего сбора',
    choices: getChoices(),
    required: true,
  );
}
