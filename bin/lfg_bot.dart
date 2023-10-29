import 'dart:async';
import 'dart:io';

import 'package:io/io.dart';
import 'package:l/l.dart';
import 'package:lfg_bot/core/bot/core.dart';
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

Future<void> runner() async {
  // load bot settings
  final settings = BotSettings.fromFile('data/bot_settings.json');

  // initialize bot
  final core = await LFGBotCore.initialize();

  // save settings and core to context
  core.context['settings'] = settings;
  core.context['core'] = core;
}
