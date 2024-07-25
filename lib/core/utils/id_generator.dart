import 'package:uuid/uuid.dart';

String idGenerator() {
  const uuid = Uuid();
  final id = uuid.v4();
  return id;
}
