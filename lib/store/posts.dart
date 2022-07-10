import 'package:dom24x7_flutter/models/post/post.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'posts.g.dart';

class PostsStore = _PostsStore with _$PostsStore;

abstract class _PostsStore with Store {
  @observable
  List<Post>? list;

  @action
  void addPost(Post post) {
    list = Utilities.addOrReplaceById(list, post);
  }

  @action
  void setPosts(List<Post> posts) {
    list = posts;
  }

  @action
  void clear() {
    list = null;
  }
}