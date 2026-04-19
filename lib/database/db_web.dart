
import 'package:sembast_web/sembast_web.dart';

Future<Database> getDatabase() async {
  final factory = databaseFactoryWeb;
  return await factory.openDatabase('flash_word_book.db');
}
