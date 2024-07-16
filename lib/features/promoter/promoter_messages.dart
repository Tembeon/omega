import 'dart:math';

class MessageTemplates {
  static final Random _random = Random();

  static final List<String> lfgMessages = [
    'Новый LFG пост.\nАктивность: {name}\nСсылка: https://discord.com/channels/{guildId}/{channelId}/{postId}',
    'Кто-то создал LFG.\nАктивность: {name}\nСсылка: https://discord.com/channels/{guildId}/{channelId}/{postId}',
    'Новый сбор LFG.\nАктивность: {name}\nСсылка: https://discord.com/channels/{guildId}/{channelId}/{postId}',
    'Появился новый LFG.\nАктивность: {name}\nСсылка: https://discord.com/channels/{guildId}/{channelId}/{postId}',
    'Новый LFG пост активен.\nАктивность: {name}\nСсылка: https://discord.com/channels/{guildId}/{channelId}/{postId}',
    'LFG пост создан.\nАктивность: {name}\nСсылка: https://discord.com/channels/{guildId}/{channelId}/{postId}',
  ];

  static String getRandomLFGMessage(String name, String guildId, String channelId, String postId) {
    final template = lfgMessages[_random.nextInt(lfgMessages.length)];
    return template
        .replaceAll('{name}', name)
        .replaceAll('{guildId}', guildId)
        .replaceAll('{channelId}', channelId)
        .replaceAll('{postId}', postId);
  }
}
