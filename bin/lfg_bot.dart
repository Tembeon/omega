import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:l/l.dart';
import 'package:lfg_bot/core/bot/core.dart';
import 'package:lfg_bot/core/const/exceptions.dart';
import 'package:lfg_bot/core/l10n/generated/messages_all_locales.dart';
import 'package:lfg_bot/core/utils/context/context.dart';
import 'package:lfg_bot/core/utils/database/tables/posts.dart';
import 'package:lfg_bot/core/utils/loaders/bot_settings.dart';
import 'package:lfg_bot/features/create/handler/create_handle.dart';
import 'package:lfg_bot/features/lfg_manager/lfg_manager.dart';
import 'package:lfg_bot/features/lfg_manager/message_handler.dart';

void main(List<String> arguments) => runZonedGuarded(
      runner,
      (error, stack) {
        l.e('Root level exception:\n$error\n\n$stack');

        if (error case FatalException(:final exitCode)) {
          exit(exitCode);
        }

        // exit(ExitCode.software.code);
      },
    );

Future<void> runner() async {
  // load bot settings
  final settings = BotSettings.fromFile('data/bot_settings.json');

  // initialize database
  _openSqlite();
  final database = PostsDatabase();

  // initialize bot
  final core = await LFGBotCore.initialize();

  final isLocaleInitialized = await initializeMessages(settings.locale);
  if (!isLocaleInitialized) throw FatalException('Failed to initialize locale: ${settings.locale}');

  final lfgManager = LFGManager(database: database, messageHandler: const MessageHandler());

  Context.setRoot(
    Context.from({
      'settings': settings,
      'core': core,
      'db': database,
      'manager': lfgManager,
    }),
  );

  await core.commandManager.registerCommands([
    createRaidCommand(),
    createDungeonCommand(),
    createCustomCommand(),
  ]);
}

DynamicLibrary _openSqlite() {
  return DynamicLibrary.open(_sqliteLibraryPath);
}

String get _sqliteLibraryPath {
  final scriptDir = File(Platform.script.toFilePath()).parent.parent;
  final libraryNextToScript = File('${scriptDir.path}/data/dependencies');
  if (Platform.isWindows) return '${libraryNextToScript.path}/dll/sqlite3.dll';
  if (Platform.isLinux) return '${libraryNextToScript.path}/so/sqlite3';

  throw FatalException('Unsupported platform: ${Platform.operatingSystem}');
}
