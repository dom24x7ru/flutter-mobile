import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpacesPage extends StatefulWidget {
  const SpacesPage({Key? key}) : super(key: key);

  @override
  _SpacesPageState createState() => _SpacesPageState();
}

class _SpacesPageState extends State<SpacesPage> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final residents = store.user.value!.residents;

    return Scaffold(
        appBar: Header(context, 'Помещения'),
        bottomNavigationBar: const Footer(FooterNav.news),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddEditSpace(context),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add)
        ),
        body: ListView.builder(
          itemCount: residents.length,
          itemBuilder: (BuildContext context, int index) {
            final resident = residents[index];
            return GestureDetector(
              onLongPress: () => _showMenu(context),
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                      child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('кв. ${resident.flat!.number}')
                      )
                  )
              )
            );
          }
        )
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showAddEditSpace(context);
                },
                child: Text('Редактировать'.toUpperCase())
              ),
              ElevatedButton(
                onPressed: () => {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)
                ),
                child: Text('Удалить'.toUpperCase())
              )
            ]
          )
        );
      }
    );
  }

  void _showAddEditSpace(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            padding: const EdgeInsets.all(15.0),
            child: const Text('форма добавления/редактирования помещения')
          );
        }
    );
  }
}
