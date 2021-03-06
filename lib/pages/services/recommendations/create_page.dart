import 'dart:convert';

import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/recommendation/recommendation.dart';
import 'package:dom24x7_flutter/models/recommendation/recommendation_category.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RecommendationCategoryItem {
  String text;
  String value;

  RecommendationCategoryItem(this.text, this.value);
}

class RecommendationCreatePage extends StatefulWidget {
  final Recommendation? recommendation;
  final RecommendationCategory? category;
  const RecommendationCreatePage(this.recommendation, {Key? key, this.category}) : super(key: key);

  @override
  State<RecommendationCreatePage> createState() => _RecommendationCreatePageState();
}

class _RecommendationCreatePageState extends State<RecommendationCreatePage> {
  late SocketClient _client;

  final List<RecommendationCategoryItem> _recommendationCategories = [];
  RecommendationCategoryItem? _recommendationCategory;

  late TextEditingController _cTitle;
  late TextEditingController _cBody;
  late TextEditingController _cPhone;
  late TextEditingController _cSite;
  late TextEditingController _cEmail;
  late TextEditingController _cAddress;
  late TextEditingController _cInstagram;
  late TextEditingController _cTelegram;

  bool _btnEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _cTitle = TextEditingController();
    _cBody = TextEditingController();
    _cPhone = TextEditingController();
    _cSite = TextEditingController();
    _cEmail = TextEditingController();
    _cAddress = TextEditingController();
    _cInstagram = TextEditingController();
    _cTelegram = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;
      _client.socket.emit('recommendation.categories', {}, (String name, dynamic error, dynamic data) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
          );
          return;
        }
        setState(() {
          // ?????????????????? ???????????? ??????????????????
          for (var item in data) {
            _recommendationCategories.add(RecommendationCategoryItem(item['name'], item['id'].toString()));
          }

          // ????????????, ???????? ????????????????????, ?????????? ???????????????????????????????? ???????? ?????????????????????????? ??????????????????????????
          _initRecommendationFields(widget.recommendation, widget.category);
        });
      });
    });
  }

  @override
  void dispose() {
    _cTitle.dispose();
    _cBody.dispose();
    _cPhone.dispose();
    _cSite.dispose();
    _cEmail.dispose();
    _cAddress.dispose();
    _cInstagram.dispose();
    _cTelegram.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final String title = widget.recommendation != null ? '??????????????????????????' : '??????????????';

    return Scaffold(
      appBar: Header.get(context, title),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            DropdownButtonFormField<RecommendationCategoryItem>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: '??????????????????'
              ),
              value: _recommendationCategory,
              onChanged: (RecommendationCategoryItem? value) {
                setState(() => _recommendationCategory = value!);
                _calcBtnEnabled();
              },
              items: _recommendationCategories.map<DropdownMenuItem<RecommendationCategoryItem>>((RecommendationCategoryItem value) {
                return DropdownMenuItem<RecommendationCategoryItem>(
                    value: value,
                    child: Text(value.text)
                );
              }).toList(),
            ),
            TextField(
              controller: _cTitle,
              onChanged: (String value) => _calcBtnEnabled(),
              decoration: const InputDecoration(
                labelText: '??????????????????'
              )
            ),
            TextField(
              controller: _cBody,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (String value) => _calcBtnEnabled(),
              decoration: const InputDecoration(
                labelText: '???????????????? ????????????????????????'
              ),
            ),
            TextField(
              controller: _cPhone,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                prefix: Text('+7 '),
                labelText: '??????????????'
              ),
            ),
            TextField(
              controller: _cSite,
              decoration: const InputDecoration(
                prefix: Text('https://'),
                labelText: '????????'
              ),
            ),
            TextField(
              controller: _cEmail,
              decoration: const InputDecoration(
                labelText: '????. ??????????'
              ),
            ),
            TextField(
              controller: _cAddress,
              decoration: const InputDecoration(
                labelText: '??????????'
              ),
            ),
            TextField(
              controller: _cInstagram,
              decoration: const InputDecoration(
                prefix: Text('@'),
                labelText: '??????????????????'
              ),
            ),
            TextField(
              controller: _cTelegram,
              decoration: const InputDecoration(
                prefix: Text('@'),
                labelText: '????????????????'
              ),
            ),
            // ElevatedButton(
            //   onPressed: () => _showImageMenu(context),
            //   child: Text('???????????????? ????????????????'.toUpperCase()),
            // ),
            ElevatedButton(
              onPressed: _btnEnabled && !_isLoading ? () => _save(context, store) : null,
              child: Text('??????????????????'.toUpperCase()),
            )
          ]
        )
      )
    );
  }

  void _showImageMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      builder: (BuildContext context) {
        return Container(
          height: 140,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection(ImageSource.gallery);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)
                ),
                child: const Text('??????????????'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection(ImageSource.camera);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)
                ),
                child: const Text('????????????'),
              )
            ]
          )
        );
      }
    );
  }

  void _handleImageSelection(ImageSource source) async {
    final result = await ImagePicker().pickImage(source: source);
    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final data = {
        'base64': base64Encode(bytes),
        'name': result.name,
        'size': bytes.length,
        'width': image.width,
        'height': image.height
      };
      _client.socket.emit('file.upload', data, (String name, dynamic error, dynamic data) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
          );
          return;
        }
        if (data == null || data['status'] != 'OK') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('?????????????????? ?????????????????????? ????????????. ???????????????????? ??????????...'), backgroundColor: Colors.red)
          );
          return;
        }
      });
    }
  }

  void _calcBtnEnabled() {
    setState(() {
      _btnEnabled = _recommendationCategory != null // ?????????????????? ???????????? ???????? ??????????????
          && _cTitle.text.trim().isNotEmpty // ?????????????????? ???????????? ???????? ????????????????
          && _cBody.text.trim().isNotEmpty; // ???????????????? ???????????? ???????? ??????????????????
    });
  }

  void _initRecommendationFields(Recommendation? recommendation, RecommendationCategory? category) {
    if (category != null) {
      setState(() {
        final dropdownCategory = _recommendationCategories.firstWhere((item) => item.value == category.id.toString());
        _recommendationCategory = dropdownCategory;
      });
    }
    if (recommendation == null) return;
    setState(() {
      final category = recommendation.category;
      final dropdownCategory = _recommendationCategories.firstWhere((item) => item.value == category.id.toString());
      _recommendationCategory = dropdownCategory;
    });

    _cTitle.text = recommendation.title;
    _cBody.text = recommendation.body;

    final extra = recommendation.extra;
    if (extra.phone != null) _cPhone.text = extra.phone!.substring(1);
    if (extra.site != null) _cSite.text = extra.site!;
    if (extra.email != null) _cEmail.text = extra.email!;
    if (extra.address != null) _cAddress.text = extra.address!;
    if (extra.instagram != null) _cInstagram.text = extra.instagram!;
    if (extra.telegram != null) _cTelegram.text = extra.telegram!;

    _calcBtnEnabled();
  }

  void _save(BuildContext context, MainStore store) {
    var data = {
      'id': widget.recommendation != null ? widget.recommendation!.id : null,
      'title': _cTitle.text.trim(),
      'body': _cBody.text.trim(),
      'categoryId': _recommendationCategory!.value,
      'extra': {
        'phone': _cPhone.text.trim().isNotEmpty ? '7${_cPhone.text.trim()}' : null,
        'site': _cSite.text.trim().isNotEmpty ? _cSite.text.trim() : null,
        'email': _cEmail.text.trim().isNotEmpty ? _cEmail.text.trim() : null,
        'address': _cAddress.text.trim().isNotEmpty ? _cAddress.text.trim() : null,
        'instagram': _cInstagram.text.trim().isNotEmpty ? _cInstagram.text.trim() : null,
        'telegram': _cTelegram.text.trim().isNotEmpty ? _cTelegram.text.trim() : null
      }
    };
    setState(() => _isLoading = true);
    _client.socket.emit('recommendation.save', data, (String name, dynamic error, dynamic data) {
      setState(() => _isLoading = false);
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
          const SnackBar(content: Text('???? ?????????????? ?????????????????? ????????????????????????. ???????????????????? ??????????'), backgroundColor: Colors.red)
        );
      }
    });
  }
}
