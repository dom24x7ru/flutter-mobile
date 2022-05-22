import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/resident.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Тип помещения
class SpaceType {
  String text;
  String value;

  SpaceType(this.text, this.value);
}

/// Тип собственности
class ResidentType {
  String text;
  String value;

  ResidentType(this.text, this.value);
}

class SpaceEditPage extends StatefulWidget {
  final Flat? flat;
  const SpaceEditPage(this.flat, {Key? key}) : super(key: key);

  @override
  State<SpaceEditPage> createState() => _SpaceEditPageState();
}

class _SpaceEditPageState extends State<SpaceEditPage> {
  final List<SpaceType> _spaceTypes = [];
  SpaceType? _spaceType;

  final List<ResidentType> _residentTypes = [
    ResidentType('Собственник', 'owner'),
    ResidentType('Арендатор', 'tenant'),
    ResidentType('Не указан', 'user')
  ];
  ResidentType? _residentType;

  late TextEditingController _cNumber;
  late TextEditingController _cSection;
  late TextEditingController _cFloor;
  late TextEditingController _cRooms;
  late TextEditingController _cSquare;

  bool _btnEnabled = false;

  @override
  void initState() {
    super.initState();

    _cNumber = TextEditingController();
    _cSection = TextEditingController();
    _cFloor = TextEditingController();
    _cRooms = TextEditingController();
    _cSquare = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      store.client.socket.emit('flat.types', {}, (String name, dynamic error, dynamic data) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
          );
          return;
        }
        setState(() {
          // загружаем список типов помещений
          for (var item in data) {
            _spaceTypes.add(SpaceType(item['name'], item['id'].toString()));
          }

          // теперь можно инициализировать поля помещения
          _initSpaceFields(store, widget.flat);
        });
      });
    });
  }

  @override
  void dispose() {
    _cNumber.dispose();
    _cSection.dispose();
    _cFloor.dispose();
    _cRooms.dispose();
    _cSquare.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    return Scaffold(
      appBar: Header(context, 'Редактировать'),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            DropdownButtonFormField<SpaceType>(
              isExpanded: true,
              decoration: const InputDecoration(
                  labelText: 'Тип помещения'
              ),
              value: _spaceType,
              onChanged: null,
              items: _spaceTypes.map<DropdownMenuItem<SpaceType>>((SpaceType value) {
                return DropdownMenuItem<SpaceType>(
                    value: value,
                    child: Text(value.text)
                );
              }).toList(),
            ),
            TextField(
              controller: _cNumber,
              keyboardType: TextInputType.number,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Номер помещения'
              )
            ),
            TextField(
              controller: _cSection,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Подъезд'
              )
            ),
            TextField(
              controller: _cFloor,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Этаж'
              )
            ),
            TextField(
              controller: _cRooms,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Количество комнат'
              )
            ),
            TextField(
              controller: _cSquare,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Размер помещения',
                suffix: Text('кв.м.')
              )
            ),
            DropdownButtonFormField<ResidentType>(
              isExpanded: true,
              decoration: const InputDecoration(
                  labelText: 'Вид владения'
              ),
              value: _residentType,
              onChanged: (ResidentType? value) {
                setState(() => _residentType = value!);
                _calcBtnEnabled();
              },
              items: _residentTypes.map<DropdownMenuItem<ResidentType>>((ResidentType value) {
                return DropdownMenuItem<ResidentType>(
                    value: value,
                    child: Text(value.text)
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _btnEnabled ? () => _save(context, store) : null,
              child: Text('Сохранить'.toUpperCase()),
            )
          ]
        )
      ),
    );
  }

  void _initSpaceFields(MainStore store, Flat? flat) {
    if (flat == null) return;
    setState(() {
      final dropdownSpaceType = _spaceTypes.firstWhere((type) => type.value == flat.type!.id.toString());
      _spaceType = dropdownSpaceType;
    });
    _cNumber.text = flat.number.toString();
    _cSection.text = flat.section != null ? flat.section.toString() : '';
    _cFloor.text = flat.floor != null ? flat.floor.toString() : '';
    _cRooms.text = flat.rooms != null ? flat.rooms.toString() : '';
    _cSquare.text = flat.square != 0 ? flat.square.toString() : '';

    final Person person = store.user.value!.person!;
    final Resident resident = flat.residents.firstWhere((resident) => resident.personId == person.id);
    setState(() {
      final dropdownResidentType = _residentTypes.firstWhere((type) => type.value == resident.extra!.type);
      _residentType = dropdownResidentType;
    });

    _calcBtnEnabled();
  }

  void _calcBtnEnabled() {
    setState(() {
      _btnEnabled = _spaceType != null // тип помещения должен быть выбран
        && _cNumber.text.trim().isNotEmpty // номер квартиры должен быть указан
        && _residentType != null; // вид владения должен быть выбран
    });
  }

  void _save(BuildContext context, MainStore store) {
    var data = {
      'id': widget.flat != null ? widget.flat!.id : null,
      'number': _cNumber.text.trim(),
      'section': _cSection.text.trim().isNotEmpty ? _cSection.text.trim() : null,
      'floor': _cFloor.text.trim().isNotEmpty ? _cFloor.text.trim() : null,
      'rooms': _cRooms.text.trim().isNotEmpty ? _cRooms.text.trim() : null,
      'square': _cSquare.text.trim().isNotEmpty ? _cSquare.text.trim() : null,
      'typeId': _spaceType!.value,
      'extra': {
        'type': _residentType!.value
      }
    };
    if (data['square'] != null) {
      data['square'] = data['square'].toString().replaceAll(',', '.');
    }
    store.client.socket.emit('flat.save', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data != null && data['status'] == 'OK') {
        Navigator.pop(context, 'save');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось сохранить данные по помещению. Попробуйте позже'), backgroundColor: Colors.red)
        );
      }
    });
  }
}
