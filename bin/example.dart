import 'dart:io';

import 'package:dart_downloader/downloader.dart';

void main(List<String> arguments) {
  stdout.write('Enter URL: ');
  final String url = stdin.readLineSync() ?? '';

  stdout.write('Enter save path: ');
  final String? savePath = stdin.readLineSync();

  stdout.write('File name: ');
  final String? fileName = stdin.readLineSync();

  downloadFile(url, '$savePath/$fileName');
}
