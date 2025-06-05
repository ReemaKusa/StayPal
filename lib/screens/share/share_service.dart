import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareContent({
    required String title,
    required String deepLinkId,
    required String type, 
  }) async {
    final Uri shareUri = Uri.parse('https://staypal.page.link/$type/$deepLinkId');

    final String shareText = '''
Check out this $type: $title
$shareUri
''';

    await Share.share(shareText);
  }
}
