import 'dart:async';
import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';
import 'package:l/l.dart';
import 'package:omega/core/const/exceptions.dart';
import 'package:omega/core/utils/config.dart';
import 'package:omega/core/utils/services.dart';
import 'package:omega/features/components/buttons/join/join_message_component.dart';
import 'package:omega/features/components/buttons/leave/leave_message_component.dart';
import 'package:omega/features/components/commands/activity/activity_commands_component.dart';
import 'package:omega/features/components/commands/admin/admin_commands_component.dart';
import 'package:omega/features/components/commands/create/create_command_component.dart';
import 'package:omega/features/components/commands/delete/delete_command_component.dart';
import 'package:omega/features/components/commands/edit/edit_command_handler.dart';

void main(List<String> arguments) => l.capture<void>(
      () => runZonedGuarded<void>(
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
      ),
      LogOptions(
        handlePrint: true,
        printColors: true,
        outputInRelease: true,
        messageFormatting: (message, logLevel, dateTime) => '[${dateTime.toIso8601String()}] $message',
      ),
    );

void runBot() => Future(() async {
      final config = Config.fromEnvironment();
      final dependencies = await Services.initialize(config: config);
      await initializeDateFormatting('ru', null);

      await dependencies.interactor.addComponents({
        const CreateCommandComponent(),
        const DeleteCommandComponent(),
        const EditCommandHandler(),
        const JoinMessageComponent(),
        const LeaveMessageComponent(),
        const AdminCommandComponent(),
        const ActivityCommandsComponent(),
      });

      await dependencies.interactor.forgetUnknown();
    });

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
