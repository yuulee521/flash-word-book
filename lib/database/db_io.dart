import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

Future<Database> getDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(dir.path, 'flash_word_book.db');
  final factory = databaseFactoryIo;
  return await factory.openDatabase(dbPath);
}
