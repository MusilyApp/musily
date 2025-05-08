// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;

const String pubspecFile = 'pubspec.yaml';
const String changelogFile = 'CHANGELOG.md';
const String downloadUrl = 'https://musily.app/';

String escapeMarkdownV2(String text) {
  const escapeChars = r'_*[]()~`>#+-=|{}.!';
  String escapedText = '';
  for (int i = 0; i < text.length; i++) {
    if (escapeChars.contains(text[i])) {
      escapedText += '\\${text[i]}';
    } else {
      escapedText += text[i];
    }
  }
  return escapedText;
}

Future<String> getVersion() async {
  final file = File(pubspecFile);
  if (!await file.exists()) {
    stderr.writeln('Error: $pubspecFile not found.');
    exit(1);
  }

  final lines = await file.readAsLines();
  for (final line in lines) {
    if (line.trim().startsWith('version:')) {
      try {
        String versionFull = line.split(':')[1].trim();
        String version = versionFull.split('+')[0];
        return version;
      } catch (e) {
        stderr.writeln(
            'Error: Could not parse version from $pubspecFile. Line: "$line"');
        exit(1);
      }
    }
  }
  stderr.writeln('Error: Version not found in $pubspecFile.');
  exit(1);
}

Future<String> getChangelogForVersion(String version) async {
  final file = File(changelogFile);
  if (!await file.exists()) {
    stderr.writeln('Error: $changelogFile not found.');
    exit(1);
  }

  final lines = await file.readAsLines();
  final changelogBuffer = StringBuffer();
  bool inTargetSection = false;

  final versionHeaderRegex = RegExp(
      r'^##\s*(\[)?' + RegExp.escape(version) + r'(\])?\s*$',
      caseSensitive: false);
  final anyHeaderRegex = RegExp(r'^##\s+');

  for (final line in lines) {
    if (versionHeaderRegex.hasMatch(line.trim())) {
      inTargetSection = true;
      continue;
    }

    if (inTargetSection) {
      if (anyHeaderRegex.hasMatch(line.trim())) {
        break;
      }
      changelogBuffer.writeln(line);
    }
  }

  final description = changelogBuffer.toString().trim();
  if (description.isEmpty) {
    stderr.writeln(
        'Error: Changelog description not found in $changelogFile for version $version.');
    stderr
        .writeln('Searched for header like: "## $version" or "## [$version]"');
    exit(1);
  }
  return description;
}

Future<void> sendTelegramMessage({
  required String botToken,
  required String chatId,
  required String version,
  required String changelog,
}) async {
  final url = Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');

  print(escapeMarkdownV2(changelog).replaceAll('\\*\\*', '\\*'));

  String text = """
🚀 *New Musily Update\\!* 🚀

*Version:* ${escapeMarkdownV2(version)}

*Changelog:*

${escapeMarkdownV2(changelog).replaceAll('\\*\\*', '*')}


Enjoy the new features\\!
""";

  final body = {
    'chat_id': chatId,
    'text': text,
    'parse_mode': 'MarkdownV2',
    'reply_markup': {
      'inline_keyboard': [
        [
          {'text': 'Download', 'url': downloadUrl}
        ]
      ]
    }
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Telegram message sent successfully!');
      final responseBody = jsonDecode(response.body);
      if (responseBody['ok'] == true) {
        print('Message ID: ${responseBody['result']['message_id']}');
      } else {
        print('Telegram API reported an error: ${responseBody['description']}');
      }
    } else {
      stderr.writeln('Error sending Telegram message: ${response.statusCode}');
      stderr.writeln('Response: ${response.body}');
      exit(1);
    }
  } catch (e) {
    stderr.writeln('Exception while sending Telegram message: $e');
    exit(1);
  }
}

void showHelp(ArgParser parser) {
  print('Usage: dart notify_update.dart [options]\n');
  print('Sends a Telegram notification about a new app update.\n');
  print('Options:');
  print(parser.usage);
  print(
      '\nMake sure `pubspec.yaml` and `CHANGELOG.md` are in the current directory.');
}

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('chat',
        abbr: 'c', help: 'Telegram Chat ID to send the message to.')
    ..addOption('token', abbr: 't', help: 'Telegram Bot Token.')
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Show this help message.');

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    stderr.writeln('Error parsing arguments: ${e.toString()}\n');
    showHelp(parser);
    exit(1);
  }

  if (argResults['help'] as bool) {
    showHelp(parser);
    exit(0);
  }

  final chatId = argResults['chat'] as String?;
  final botToken = argResults['token'] as String?;

  if (chatId == null || chatId.isEmpty) {
    stderr.writeln('Error: --chat <chat_id> is required.\n');
    showHelp(parser);
    exit(1);
  }

  if (botToken == null || botToken.isEmpty) {
    stderr.writeln('Error: --token <bot_token> is required.\n');
    showHelp(parser);
    exit(1);
  }

  try {
    print('Fetching version from $pubspecFile...');
    final version = await getVersion();
    print('Version found: $version');

    print('Fetching changelog from $changelogFile for version $version...');
    final changelog = await getChangelogForVersion(version);
    print('Changelog found:\n---\n$changelog\n---');

    print('Sending Telegram notification...');
    await sendTelegramMessage(
      botToken: botToken,
      chatId: chatId,
      version: version,
      changelog: changelog,
    );
  } catch (e) {
    if (e is! String && e is! int) {
      stderr.writeln('An unexpected error occurred: $e');
      exit(1);
    }
  }
}
