import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

Future<void> sendFormatExceptionMessage(
  ISlashCommandInteractionEvent event,
) async {
  final time = event.args[2].value;
  final date = event.args[3].value;

  await event.respond(
    MessageBuilder.content(
      'Некорректно введено время.\n'
      'Пожалуйста, обратите внимание на подсказки во время заполнения данных.\n '
      '\n'
      'Введено: $time, $date\n'
      'Ожидаемый формат: 08 30, 01 01 2023\n'
      'Обозначения: час минута, число месяц год',
    ),
    hidden: true,
  );
}

Future<void> sendUnexpectedErrorMessage(
  IInteractionEventWithAcknowledge event, {
  Object? e,
}) async {
  final sb = StringBuffer()..writeln('Что-то пошло не так...');
  if (e != null) {
    sb
      ..writeln()
      ..writeln(e.toString());
  }

  await event.respond(
    MessageBuilder.content(sb.toString()),
    hidden: true,
  );
}
