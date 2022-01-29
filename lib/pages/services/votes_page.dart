import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/in_development_info_widget.dart';
import 'package:flutter/material.dart';

class VotesPage extends StatelessWidget {
  const VotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context, 'Голосования'),
      bottomNavigationBar: Footer(context, FooterNav.services),
      body: const InDevelopmentInfo()
    );
  }
}
