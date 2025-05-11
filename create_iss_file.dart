// ignore_for_file: avoid_print

import 'dart:io';

import 'package:args/args.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('version', abbr: 'v', help: 'Version of the app.');

  final argResults = parser.parse(args);
  final version = argResults['version'] as String?;
  if (version == null) {
    print('Version is required. Use --version <version> to specify it.');
    exit(1);
  }
  final issContent = '''; musily_installer.iss
[Setup]
AppName=Musily
AppVersion=$version
DefaultDirName={localappdata}\\Musily
OutputBaseFilename=musily-installer
DefaultGroupName=Musily
Compression=lzma
SolidCompression=yes
AppSupportURL=https://musily.app/
LicenseFile=LICENSE
AppPublisher=Musily
AppPublisherURL=https://musily.app/
AppID=AppMusilyMusic

[Files]
Source: "build\\windows\\x64\\runner\\Release\\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\\Musily"; Filename: "{app}\\Musily.exe"

''';

  final issFile = File('musily_installer.iss');
  await issFile.writeAsString(issContent);
  print('Inno Setup script created at ${issFile.path}');
}
