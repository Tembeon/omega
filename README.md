# LFG Bot [WIP]

A Discord bot for finding groups for Destiny 2 activities (but can be used for other games too).
This bot was designed to be used only in a single server, so it will not work in multiple servers at once.

## Setup

Steps to run this bot (compiled version):

1. Download the latest release from the [release page]() and extract it to any folder.
2. Open `data` folder, edit `bot_config.json` file and fill in the required fields:

| Field             | Description                                                                                                                                                                      |
|:------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `server_id`       | ID of the server where the bot will be used. You can get it by enabling developer mode in Discord settings and right-clicking on the server icon.                                |
| `bot_token`       | Token can be obtained by creating a new application in [Discord Developer Portal](https://discord.com/developers/applications) and adding a bot to it.                           |
| `lfg_channel`     | Channel where the bot will send LFG messages. You can get it by enabling developer mode in Discord settings and right-clicking on the channel.                                   |
| `promo_channel`   | Channel where the bot will send LFG's promotional messages. You can get it by enabling developer mode in Discord settings and right-clicking on the channel.                     |
| `events_channels` | List of channels which are subscribed to promotion channels. Bot will check these channels for deleted messages by sender and delete them. Optional, you can omit setting it up. |

3. run bot executable file, if everything is set up correctly, you should see a message in the console saying
   that the bot is ready (and many other useful messages, such as bot name, id, etc.).
4. You will see invite-link in the console, use it to invite the bot to your server.

## Usage

See table for a list of commands.

| Commands                               | Description                                                                                        | Permission level                   |
|:---------------------------------------|:---------------------------------------------------------------------------------------------------|:-----------------------------------|
| `/create raid`                         | Creates new LFG for Raid activity. Bot will suggest raids from raids.json file                     | all users                          |
| `/create dungeon`                      | Creates new LFG for Dungeon activity. Bot will suggest dungeons from dungeons.json file            | all users                          |
| `/create activity`                     | Creates new LFG for Custom activity. Bot will suggest activities from custom.json file             | all users                          |
| `/edit {activity_id}`                  | Allows to edit some LFG information.                                                               | only LFG author                    |
| `/delete {activity_id}`                | Deletes LFG by ID. ID are generated for every LFG post in bottom. Also, ID of post is a message ID | only LFG author                    |
| `/admin delete_activity {activity_id}` | Deletes LFG by ID. Allows to delete any post.                                                      | role with administrator permission |
| `/admin status`                        | Sends information about bot work.                                                                  | role with administrator permission |
| `/admin send_guide`                    | Sends information to channel with instructions how to use bot.                                     | role with administrator permission |


## Build from source
### Requirements
- [Dart SDK](https://dart.dev/get-dart) (Requires Dart 3.1)

### Steps
1. Clone this repository
2. Open terminal in the project folder and run `dart pub get` to install dependencies
3. Run `dart run build_runner build` to generate required files
4. Run `dart build exe bin/lfg_bot.dart` to build bot executable file. File will be located in `bin` folder.
5. Copy `data` folder to the same folder where executable file is located.
6. Setup bot_config.json file (see Setup section for more information).



