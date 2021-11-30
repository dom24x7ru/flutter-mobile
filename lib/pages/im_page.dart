import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class IMPage extends StatelessWidget {
  const IMPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context, 'Чаты'),
      bottomNavigationBar: Footer(context, FooterNav.im),
    );
  }
}
