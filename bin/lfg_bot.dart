import 'dart:async';
import 'dart:io';

import 'package:l/l.dart';
import 'package:lfg_bot/core/const/exceptions.dart';
import 'package:lfg_bot/core/utils/config.dart';
import 'package:lfg_bot/core/utils/context/context.dart';
import 'package:lfg_bot/core/utils/services.dart';
import 'package:lfg_bot/core/utils/loaders/bot_settings.dart';
import 'package:lfg_bot/features/create/handler/create_handle.dart';
import 'package:lfg_bot/features/delete/handler/delete_handler.dart';
import 'package:lfg_bot/features/edit/handler/edit_handler.dart';
import 'package:lfg_bot/features/join/handler/join_handle.dart';
import 'package:lfg_bot/features/leave/handler/leave_handler.dart';

void main(List<String> arguments) => runZonedGuarded(
      runBot,
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, message) => l.i('[${DateTime.now()}] $message'),
      ),
      (error, stack) {
        l.e('Root level exception:\n$error\n\n$stack');

        if (error case FatalException(:final exitCode)) {
          exit(exitCode);
        }

        // exit(ExitCode.software.code);
      },
    );

void runBot() => Future(() async {
      final config = Config.fromEnvironment();
      final dependencies = await Services.initialize(config: config);
      _loadLegacyPart();

      await dependencies.commandManager.registerCommand(createCategoryCommands());
      await dependencies.commandManager.registerCommand(deleteCommand());
      await dependencies.commandManager.registerCommand(editComponentHandler());

      await dependencies.commandManager.registerComponent(joinComponentHandler());
      await dependencies.commandManager.registerComponent(leaveComponentHandler());
    });

void _loadLegacyPart() {
  final settings = BotSettings.fromFile('data/bot_settings.json');
  Context.setRoot(
    Context.from({
      'settings': settings,
    }),
  );
}

@Deprecated('Use runBot instead')
// Future<void> runner() async {
//   // load bot settings
//   final settings = BotSettings.fromFile('data/bot_settings.json');
//
//   // initialize database
//   _openSqlite();
//   final database = PostsDatabase();
//
//   // initialize bot
//   final core = await LFGBotCore.initialize(token: settings.botConfig.botToken);
//
//   final isLocaleInitialized = await initializeMessages(settings.locale);
//   if (!isLocaleInitialized) throw FatalException('Failed to initialize locale: ${settings.locale}');
//
//   final lfgManager = LFGManager(database: database, messageHandler: const MessageHandler());
//   final scheduler = PostScheduler(database: database, core: core, lfgManager: lfgManager);
//
//   Context.setRoot(
//     Context.from({
//       'settings': settings,
//       'core': core,
//       'db': database,
//       'manager': lfgManager,
//       'scheduler': scheduler,
//     }),
//   );
//
//   await core.commandManager.registerCommand(createCategoryCommands());
//   await core.commandManager.registerCommand(deleteCommand());
//   await core.commandManager.registerCommand(editComponentHandler());
//
//   await core.commandManager.registerComponent(joinComponentHandler());
//   await core.commandManager.registerComponent(leaveComponentHandler());
// }

Future<String> getCPUArchitecture() async {
  if (Platform.isWindows) {
    final cpu = Platform.environment['PROCESSOR_ARCHITECTURE'];
    if (cpu == null) throw FatalException('Failed to get CPU architecture');
    return cpu;
  } else {
    final info = await Process.run('uname', ['-m']);
    final cpu = info.stdout.toString().replaceAll('\n', '');
    return cpu;
  }
}
