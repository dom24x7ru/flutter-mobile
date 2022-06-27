import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'im_image.g.dart';

@HiveType(typeId: 22)
class IMImage extends Model {
  @HiveField(1)
  late String name;
  @HiveField(2)
  late int size;
  @HiveField(3)
  late String uri;
  @HiveField(4)
  late int width;
  @HiveField(5)
  late int height;

  IMImage(id, this.name, this.size, this.uri, this.width, this.height) : super(id);

  IMImage.fromMap(Map<String, dynamic> map) : super(map['id']) {
    name = map['name'];
    size = map['size'];
    uri = map['uri'];
    width = map['width'];
    height = map['height'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'uri': uri,
      'width': width,
      'height': height
    };
  }
}