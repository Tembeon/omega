import 'dart:convert';
import 'dart:io';

const String _arbDir = 'lib/core/l10n/arb';
const String _messagesFile = 'lib/core/l10n/messages.dart';
const String _generatedDir = 'lib/core/l10n/generated';

void _printUsage() {
  stdout
    ..writeln('Usage: dart run tool/l10n.dart <command>')
    ..writeln()
    ..writeln('Commands:')
    ..writeln('  sync    Extract messages and regenerate all locale files')
    ..writeln('  verify  Check that all ARB files share the same keys');
}

Future<void> _runCommand(List<String> args) async {
  final process = await Process.start('dart', args);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);
  final code = await process.exitCode;
  if (code != 0) {
    throw ProcessException('dart', args, 'Command failed with exit code $code', code);
  }
}

Future<void> _sync() async {
  stdout.writeln('Extracting messages to ARB…');
  await _runCommand([
    'run',
    'intl_translation:extract_to_arb',
    '--output-dir=$_arbDir',
    '--output-file=ru.arb',
    '--locale=ru',
    _messagesFile,
  ]);

  final arbDirectory = Directory(_arbDir);
  final arbFiles = arbDirectory
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.arb'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in arbFiles) {
    final locale = file.uri.pathSegments.last.replaceAll('.arb', '');
    stdout.writeln('Generating locale: $locale');
    await _runCommand([
      'run',
      'intl_translation:generate_from_arb',
      '--output-dir=$_generatedDir',
      '--no-use-deferred-loading',
      _messagesFile,
      file.path,
    ]);
  }
}

Future<void> _verify() async {
  final arbDirectory = Directory(_arbDir);
  final arbFiles = arbDirectory
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.arb'))
      .toList();

  if (arbFiles.isEmpty) {
    stdout.writeln('No ARB files found in $_arbDir');
    return;
  }

  final Map<String, Set<String>> localeKeys = {};
  for (final file in arbFiles) {
    final content = json.decode(await file.readAsString()) as Map<String, dynamic>;
    final keys = content.keys
        .where((key) => !key.startsWith('@') && key != '@@locale' && key != '@@last_modified')
        .toSet();
    final locale = content['@@locale'] as String? ?? file.uri.pathSegments.last.replaceAll('.arb', '');
    localeKeys[locale] = keys;
  }

  final reference = localeKeys.values.first;
  final mismatches = <String, Map<String, Set<String>>>{};

  localeKeys.forEach((locale, keys) {
    final missing = reference.difference(keys);
    final extra = keys.difference(reference);
    if (missing.isNotEmpty || extra.isNotEmpty) {
      mismatches[locale] = {'missing': missing, 'extra': extra};
    }
  });

  if (mismatches.isEmpty) {
    stdout.writeln('All locales contain the same message keys.');
    return;
  }

  stderr.writeln('Localization key mismatch detected:');
  mismatches.forEach((locale, diff) {
    final missing = diff['missing']!;
    final extra = diff['extra']!;
    if (missing.isNotEmpty) {
      stderr.writeln('  $locale is missing: ${missing.join(', ')}');
    }
    if (extra.isNotEmpty) {
      stderr.writeln('  $locale has extra: ${extra.join(', ')}');
    }
  });
  exitCode = 1;
}

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    _printUsage();
    exitCode = 1;
    return;
  }

  switch (args.first) {
    case 'sync':
      await _sync();
      break;
    case 'verify':
      await _verify();
      break;
    default:
      stderr.writeln('Unknown command: ${args.first}');
      _printUsage();
      exitCode = 1;
  }
}
