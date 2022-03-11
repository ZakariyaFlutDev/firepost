
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firepost/model/post_model.dart';

class RTDBService{
  static final _database = FirebaseDatabase.instance.ref("posts");

  static Future<Stream<DatabaseEvent>> addPost(Post post) async{
    _database.push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getPosts(String id) async{
    List<Post> items = [];
    Query _query = _database.orderByChild("userId").equalTo(id);
    DatabaseEvent event = await _query.once();


    print(event.snapshot.children.last.value);
    var result = event.snapshot.children.cast();
    print(result.runtimeType);

    for(var item in result){
      items.add(Post.fromJson(Map<String, dynamic>.from(item.value)));
    }
    return items;
  }
}