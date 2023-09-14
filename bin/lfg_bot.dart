import 'dart:async';
import 'dart:io';

import 'package:io/io.dart';
import 'package:l/l.dart';
import 'package:lfg_bot/core/bot/core.dart';
import 'package:lfg_bot/core/bot/interactions.dart';
import 'package:lfg_bot/core/const/exceptions.dart';
import 'package:lfg_bot/core/utils/loaders/bot_settings.dart';

void main(List<String> arguments) => runZonedGuarded(
      runner,
      (error, stack) {
        l.e('Root level exception:\n$error\n$stack');

        if (error case FatalException(:final exitCode)) {
          exit(exitCode);
        }

        exit(ExitCode.software.code);
      },
    );

void runner() {
  // load bot settings
  final settings = BotSettings.fromFile('data/bot_settings.json');
  print('Using locale: ${settings.locale.get('locale')}');

  // initialize bot
  final bot = BotCore().bot;
  final interactions = BotInteractions(bot).interactions;
}
