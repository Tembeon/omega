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
import 'package:lfg_bot/features/admin/admin_commands_creator.dart';
import 'package:lfg_bot/features/create/handler/create_handler.dart';
import 'package:lfg_bot/features/delete/handler/delete_handler.dart';
import 'package:lfg_bot/features/edit/handler/edit_handler.dart';
import 'package:lfg_bot/features/join/handler/join_handle.dart';
import 'package:lfg_bot/features/leave/handler/leave_handler.dart';
import 'package:lfg_bot/features/lfg_manager/lfg_manager.dart';
import 'package:lfg_bot/features/lfg_manager/message_handler.dart';
import 'package:lfg_bot/features/scheduler/scheduler.dart';

void main(List<String> arguments) => runZonedGuarded(
      runner,
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

Future<void> runner() async {
  // load bot settings
  final settings = BotSettings.fromFile('data/bot_settings.json');

  // initialize database
  _openSqlite();
  final database = PostsDatabase();

  // initialize bot
  final core = await LFGBotCore.initialize();

  final isLocaleInitialized = await initializeMessages(settings.locale);
  if (!isLocaleInitialized) {
    throw FatalException('Failed to initialize locale: ${settings.locale}');
  }

  final lfgManager = LFGManager(database: database, messageHandler: const MessageHandler());
  final scheduler = PostScheduler(database: database, core: core, lfgManager: lfgManager);

  Context.setRoot(
    Context.from({
      'settings': settings,
      'core': core,
      'db': database,
      'manager': lfgManager,
      'scheduler': scheduler,
    }),
  );

  await core.commandManager.registerCommand(createCategoryCommands());
  await core.commandManager.registerCommand(deleteCommand());
  await core.commandManager.registerCommand(editComponentHandler());
  await core.commandManager.registerCommand(adminCategoryCommands());

  await core.commandManager.registerComponent(joinComponentHandler());
  await core.commandManager.registerComponent(leaveComponentHandler());
}

DynamicLibrary _openSqlite() {
  return DynamicLibrary.open(_sqliteLibraryPath);
}

String get _sqliteLibraryPath {
  final scriptDir = File(Platform.script.toFilePath()).parent.parent;
  final libraryNextToScript = File('${scriptDir.path}/data/dependencies');
  if (Platform.isWindows) return '${libraryNextToScript.path}/dll/sqlite3.dll';
  if (Platform.isLinux) return '${libraryNextToScript.path}/so/sqlite3';
  if (Platform.isMacOS) return '${libraryNextToScript.path}/osx/sqlite3_arm64';

  throw FatalException('Unsupported platform: ${Platform.operatingSystem}');
}

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
