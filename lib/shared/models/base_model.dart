import 'dart:collection';

class BaseModel {
  static HashMap<String, dynamic> fromMap(Map<String, dynamic> map) {
    return HashMap<String, dynamic>.from(map);
  }
}
