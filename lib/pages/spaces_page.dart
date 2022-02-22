import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class SpacesPage extends StatefulWidget {
  const SpacesPage({Key? key}) : super(key: key);

  @override
  _SpacesPageState createState() => _SpacesPageState();
}

class _SpacesPageState extends State<SpacesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(context, 'Помещения'),
        bottomNavigationBar: Footer(context, FooterNav.news),
        floatingActionButton: FloatingActionButton(
            onPressed: () => { showAddEditSpace(context) },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add)
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('карточка помещения')
                )
              )
            );
          }
        )
    );
  }

  void showAddEditSpace(BuildContext context) {
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
