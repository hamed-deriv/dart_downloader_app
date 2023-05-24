import 'dart:io';

/// Downloads a file from the given [url] and saves it to the given [savePath].
Future<void> downloadFile(String url, String savePath) async {
  final HttpClient client = HttpClient();

  try {
    final HttpClientRequest request = await client.getUrl(Uri.parse(url));
    final HttpClientResponse response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      final File file = File(savePath);
      final IOSink sink = file.openWrite();

      final int totalBytes = response.contentLength;
      int receivedBytes = 0;
      final DateTime startTime = DateTime.now();

      const int progressBarWidth = 40;
      double progress = 0;

      stdout.write('Progress: 0% [${' ' * progressBarWidth}]');

      await response.forEach((List<int> data) {
        receivedBytes += data.length;
        sink.add(data);

        // Update progress and display the progress bar.
        progress = (receivedBytes / totalBytes) * 100;
        final int filledWidth = (progressBarWidth * progress / 100).round();
        stdout.write(
          '\rProgress: ${progress.toStringAsFixed(2)}% [${'=' * filledWidth}${' ' * (progressBarWidth - filledWidth)}]',
        );

        // Calculate and display download speed.
        final int elapsedSeconds =
            DateTime.now().difference(startTime).inSeconds;
        double speed = receivedBytes / elapsedSeconds;
        String unit = 'bytes/sec';

        if (speed > 1024) {
          speed /= 1024;
          unit = 'KB/s';
        }

        if (speed > 1024) {
          speed /= 1024;
          unit = 'MB/s';
        }

        stdout
          ..write(' (${speed.toStringAsFixed(2)}) $unit')
          ..write('\x1B[K')
          ..write('\x1B[?25l');
      });

      await sink.close();
      print('\nFile downloaded successfully!');
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
    }
  } on Exception catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
