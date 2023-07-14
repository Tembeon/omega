import 'dart:async';
import 'dart:io';

import 'package:io/io.dart';
import 'package:l/l.dart';
import 'package:lfg_bot/core/bot/nyxx_core.dart';
import 'package:lfg_bot/core/bot/nyxx_interactions.dart';
import 'package:lfg_bot/core/utils/config_data_loader.dart';
import 'package:lfg_bot/core/utils/flavors.dart';

void main(List<String> arguments) => runZonedGuarded(
      runner,
      (error, stack) {
        if (error is ConfigFileMissing) {
          l.e(error.toString());
          exit(ExitCode.config.code);
        }

        print(stack);
        l.e(error.toString(), stack);
        exit(ExitCode.software.code);
      },
    );

void runner() {
  // load bot settings
  Flavors.readFromFile(useTestEnvironment: true);
  ConfigDataLoader().load();

  // initialize bot
  final bot = BotCore().bot;
  final interactions = BotInteractions(bot).interactions;
}
