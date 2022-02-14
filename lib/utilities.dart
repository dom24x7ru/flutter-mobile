import 'package:dom24x7_flutter/models/model.dart';
import 'package:intl/intl.dart';

class Utilities {
  static String getHeaderTitle(String title) {
    if (title.length < 20) return title;
    return title.substring(0, 20) + '...';
  }

  static String getDateFormat(int dt) {
    return DateFormat('dd.MM.y HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(dt));
  }

  static String numberFormat(double value) {
    var f = NumberFormat('###.00');
    var result = f.format(value);
    return result;
  }

  static String percent(double value) {
    var f = NumberFormat('###.00');
    var result = f.format((value * 10000).round() / 100);
    return '$result%';
  }

  static List<T> addOrReplaceById<T extends Model>(List<T>? list, T obj) {
    list ??= [];
    if (list.where((item) => obj.id == item.id).isEmpty) {
      list.add(obj);
    } else {
      for (int index = 0; index < list.length; index++) {
        if (list[index].id == obj.id) {
          list[index] = obj;
        }
      }
    }
    return list;
  }
}