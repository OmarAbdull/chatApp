import 'package:drift/drift.dart';

class ChatMessages extends Table {
  IntColumn get id => integer()();
  TextColumn get sender => text()();
  TextColumn get message => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
}
