import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class SembastDatabase {
  static const _fileName = 'loyalty_cards.db';

  // Open (creates on first run)
  static Future<Database> open() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final path = p.join(dir.path, _fileName);
    return databaseFactoryIo.openDatabase(path);
  }

  // Full path to the DB file
  static Future<String> filePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, _fileName);
  }
}