import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:intl/intl.dart';

class Utilities {
  /// Возвращает текстовое представление квартиры
  static String getFlatTitle(Flat flat) {
    String title = 'кв. №${flat.number}';
    if (flat.floor != null) title += ' эт. ${flat.floor}';
    if (flat.section != null) title += ' п. ${flat.section}';
    return title;
  }

  static String getPersonTitle(IMPerson imPerson, Person owner, [bool you = false]) {
    Person person = imPerson.person;
    if (you) {
      if (person.id == owner.id) return 'Вы';
    }

    String fullName = '';
    if (person.surname != null) {
      fullName += person.surname!;
    }
    if (person.name != null) {
      fullName += ' ${person.name!}';
    }
    if (person.midname != null) {
      fullName += ' ${person.midname!}';
    }
    if (fullName.trim().isEmpty) {
      final flat = imPerson.flat;
      return 'сосед(ка) из ${Utilities.getFlatTitle(flat)}';
    }
    return fullName.trim();
  }

  static String getChannelTitle(Person owner, IMChannel channel) {
    if (channel.title != null) return channel.title!;
    // раз нет заголовка, то это приватный чат с соседом, нужно указать его имя, либо квартиру
    final List<IMPerson> imPersons = channel.persons;
    late IMPerson imPerson;
    for (var item in imPersons) {
      if (item.person.id != owner.id) imPerson = item;
    }
    return getPersonTitle(imPerson, owner);
  }

  static String getHeaderTitle(String title, [int maxLength = 17]) {
    if (title.length < maxLength) return title;
    return title.substring(0, maxLength) + '...';
  }

  static String getDateFormat(int dt, [String format = 'dd.MM.y HH:mm:ss']) {
    return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(dt));
  }

  static String getDateFormatShort(int dt) {
    return getDateFormat(dt, 'dd.MM.y');
  }

  static String getTimeFormat(int dt) {
    return getDateFormat(dt, 'HH:mm');
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

  static String getDateIM(int dt) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    double duration = (now - dt) / 1000; // в секундах
    // меньше суток: показываем только время
    if (duration < 24 * 60 * 60) return getTimeFormat(dt);
    // меньше недели: показываем день недели
    if (duration < 7 * 24 * 60 * 60) {
      final week = getDateFormat(dt, 'E');
      switch (week) {
        case 'Mon': return 'пн';
        case 'Tue': return 'вт';
        case 'Wed': return 'ср';
        case 'Thu': return 'чт';
        case 'Fri': return 'пт';
        case 'Sat': return 'сб';
        case 'Sun': return 'вс';
      }
    }
    // меньше года: показываем день и месяц
    if (duration < 356 * 24 * 60 * 60) {
      final day = getDateFormat(dt, 'd');
      switch (getDateFormat(dt, 'M')) {
        case '1': return '$day янв.';
        case '2': return '$day фев.';
        case '3': return '$day мар.';
        case '4': return '$day апр.';
        case '5': return '$day май';
        case '6': return '$day июн.';
        case '7': return '$day июл.';
        case '8': return '$day авг.';
        case '9': return '$day сен.';
        case '10': return '$day окт.';
        case '11': return '$day ноя.';
        case '12': return '$day дек.';
      }
    }
    // больше года: показываем дату без времени
    return getDateFormatShort(dt);
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

  static List<T>? deleteById<T extends Model>(List<T>? list, T obj) {
    if (list  == null || list.isEmpty) return list;
    for (int index = 0; index < list.length; index++) {
      if (list[index].id == obj.id) {
        list.removeAt(index);
      }
    }
    return list;
  }

  static List<T> sortById<T extends Model>(List<T> list) {
    list.sort((obj1, obj2) {
      if (obj1.id > obj2.id) return 1;
      if (obj1.id < obj2.id) return -1;
      return 0;
    });
    return list;
  }
}