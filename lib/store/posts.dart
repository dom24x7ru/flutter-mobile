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
    list = Utilities.addOrReplaceById(list, post, false);
  }

  @action
  void setPosts(List<Post> posts) {
    list = posts;
  }

  @action
  void markAllAsDeleted() {
    if (list == null) return;
    for (var i = 0; i < list!.length; i++) {
      list![i].deleted = true;
    }
  }

  @action
  void clearDeleted() {
    if (list == null) return;
    list = list!.where((post) => !post.deleted).toList();
  }

  @action
  void clear() {
    list = null;
  }
}