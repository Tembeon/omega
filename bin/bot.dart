import 'dart:async';
import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:io/io.dart';
import 'package:l/l.dart';
import 'package:omega/core/const/exceptions.dart';
import 'package:omega/core/l10n/generated/messages_all.dart';
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

          exit(ExitCode.software.code);
        },
      ),
      LogOptions(
        handlePrint: true,
        printColors: true,
        outputInRelease: true,
        messageFormatting: (log) => '[${log.timestamp.toIso8601String()}] ${log.message}',
      ),
    );

void runBot() => Future(() async {
      final rawConfig = Config.fromEnvironment();
      final locale = await _prepareLocale(rawConfig.locale);
      final config = rawConfig.copyWith(locale: locale);
      final dependencies = await Services.initialize(config: config);

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

const Set<String> _supportedLocales = {'en', 'ru'};
const String _fallbackLocale = 'en';

Future<String> _prepareLocale(String? rawLocale) async {
  final locale = _resolveLocale(rawLocale);

  if (rawLocale == null || rawLocale.trim().isEmpty) {
    l.i('OMEGA_LOCALE not set. Using default "$locale".');
  }

  return _initializeIntl(locale);
}

String _resolveLocale(String? rawLocale) {
  if (rawLocale == null) {
    return _fallbackLocale;
  }

  final trimmed = rawLocale.trim();
  if (trimmed.isEmpty) {
    return _fallbackLocale;
  }

  final normalized = trimmed.toLowerCase().replaceAll('-', '_');
  final base = normalized.split('_').first;

  if (_supportedLocales.contains(base)) {
    if (normalized != base) {
      l.i('Locale "$rawLocale" resolved to "$base".');
    }
    return base;
  }

  l.w('Locale "$rawLocale" is not supported. Falling back to "$_fallbackLocale".');
  return _fallbackLocale;
}

Future<String> _initializeIntl(String locale) async {
  Intl.defaultLocale = locale;

  final loaded = await initializeMessages(locale);
  if (!loaded && locale != _fallbackLocale) {
    l.w('Failed to load messages for "$locale". Falling back to "$_fallbackLocale".');
    return _initializeIntl(_fallbackLocale);
  }

  await initializeDateFormatting(_dateFormattingLocale(locale), null);
  l.i('Locale set to "$locale".');
  return locale;
}

String _dateFormattingLocale(String locale) {
  if (locale == 'ru') {
    return 'ru';
  }

  return 'en_US';
}
