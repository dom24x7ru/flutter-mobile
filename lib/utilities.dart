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

  static String getDateFromNow(int dt) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    double duration = (now - dt) / 1000; // в секундах
    if (0 <= duration && duration <= 44) return 'несколько секунд назад';
    if (44 < duration && duration <= 89) return 'минуту назад';
    duration /= 60; // в минутах
    if (1.5 <= duration && duration <= 44) {
      final minutes = duration.round();
      if (11 <= minutes && minutes <= 19) return '$minutes минут назад';
      switch (minutes % 10) {
        case 0:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
          return '$minutes минут назад';
        case 1:
          return '$minutes минута назад';
        case 2:
        case 3:
        case 4:
          return '$minutes минуты назад';
        default:
          return '$minutes минут назад';
      }
    }
    if (44 < duration && duration <= 89) return 'час назад';
    duration /= 60; // в часах
    if (1.5 <= duration && duration <= 21) {
      final hours = duration.round();
      if (11 <= hours && hours <= 19) return '$hours часов назад';
      switch (hours % 10) {
        case 0:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
          return '$hours часов назад';
        case 1:
          return '$hours час назад';
        case 2:
        case 3:
        case 4:
          return '$hours часа назад';
        default:
          return '$hours часов назад';
      }
    }
    if (21 < duration && duration <= 35) return 'день назад';
    duration /= 24; // в днях
    if (1.5 <= duration && duration <= 25) {
      final days = duration.round();
      if (11 <= days && days <= 19) return '$days дней назад';
      switch (days % 10) {
        case 0:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
          return '$days дней назад';
        case 1:
          return '$days день назад';
        case 2:
        case 3:
        case 4:
          return '$days дня назад';
        default:
          return '$days дней назад';
      }
    }
    if (25 < duration && duration <= 45) return 'месяц назад';
    if (45 < duration && duration <= 319) {
      final months = (duration / 30).round();
      if (11 <= months && months <= 19) return '$months месяцев назад';
      switch (months % 10) {
        case 0:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
          return '$months месяцев назад';
        case 1:
          return '$months месяц назад';
        case 2:
        case 3:
        case 4:
          return '$months месяца назад';
        default:
          return '$months месяцев назад';
      }
    }
    if (319 < duration && duration <= 547) return 'год назад';
    if (547 < duration) {
      final years = (duration / 365).round();
      if (11 <= years && years <= 19) return '$years лет назад';
      switch (years % 10) {
        case 0:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
          return '$years лет назад';
        case 1:
          return '$years год назад';
        case 2:
        case 3:
        case 4:
          return '$years года назад';
        default:
          return '$years лет назад';
      }
    }
    return 'некоторое время назад';
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