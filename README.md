# Omega

LFG bot designed to operate within a single server.
The main idea is to allow the editing of almost any information in the bot using commands.
Management is available only to roles with "Administrator" permission level.

## Activity Management

### Add new activity

`/activity add` — Add a new activity to the database.
This will immediately update the `/create` and `/activity`
commands, adding the newly created activity.

**Parameters:**

1. `name` — Name of the new activity. Standard and custom emojis can be used here.
2. `members` — Maximum number of participants for the activity. The number must be greater than 1 (2 or more).
3. `banner` — URL of the image to be displayed under the activity.
   If the image doesn't load, try restarting Discord.
   If this doesn't help, the image can't be loaded from the specified URL.
   Try uploading the image as a file.
4. `banner_file` — File to be used as a banner.
   Any file type is allowed, but for the best results, use images.
   You can select the file from your file explorer or copy and paste it (Ctrl + V) directly into the field.

### Remove Activity

`/activity remove` — Remove an existing activity from the database.
This will update the `/create` and `/activity` commands.

## Promotion Message Management

The bot can send a message about a created LFG to a selected channel. These messages can be customized.

### List Custom Messages

`/admin promotes list` — Retrieve all set custom messages with their IDs.
The number before the message is the identifier.

### Remove Custom Message

`/admin promotes remove` — Remove a custom message by its ID.

### Add Custom Message

`/admin promotes add` — Add a custom message. Templates supported:

1. `{AUTHOR}` — will be replaced with a link to the author.
2. `{DESCRIPTION}` — will be replaced with the LFG description.
3. `{DATE}` — will be replaced with the LFG date.
4. `{MAX_MEMBERS}` — will be replaced with the maximum number of participants for the LFG.
5. `{NAME}` — will be replaced with the LFG name.
6. `{MESSAGE_URL}` — will be replaced with a link to the channel and the original LFG message.

These templates are optional. Use them as needed.

## Channel Management

### Set LFG Channel

`/admin set lfg_channel` — Set the channel where the bot allows the `/create` command to be used.
If the channel is not specified, the `/create` command will be disabled.

### Set Promo Channel

`/admin set promo_channel` — Set the channel where the bot will notify others about the created LFG.
If the channel is not specified, notifications will not be created.

# Get started

1. Create a new Discord bot at https://discord.com/developers/applications.
2. Get a docker image from
   the [Docker Hub](https://hub.docker.com/repository/docker/tembeon/omega_bot/general): `docker pull tembeon/omega`.
3. Add the following environment variables to the docker container:
    - `OMEGA_SERVER_ID` — ID of the server where the bot will operate.
    - `OMEGA_TOKEN` — Bot token.
4. Run the container.
5. Now invite bot to the server and configure it using commands (remember about settings LFG channel, or /create command
   will be disabled).

## Build from source
Requirements:
1. Dart 3.4

Steps:
1. Clone the repository.
2. Run `dart pub get` to install dependencies.
3. Run `dart build exe bin/bot.dart` to build the executable. The binary will be located in the `bin` directory.

> [!TIP]
> If you want to build the bot for Windows, run `dart build` on Windows OS.
> For Linux, run it on Linux OS.
> The same applies to macOS.
>
> Generated executable always has a file extension `.exe`, but it will be run only for the appropriate OS.
