import 'package:firepost/model/post_model.dart';
import 'package:firepost/pages/detail_page.dart';
import 'package:firepost/pages/signIn_page.dart';
import 'package:firepost/services/auth_service.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  _openDetail() async {
    Map result = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new DetailPage();
    }));
    if (result != null && result.containsKey('data')) {
      print(result['data']);
      _apiGetPosts();
    }
  }

  _apiGetPosts() async {
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((posts) => {
          _respPosts(posts),
        });
  }

  _respPosts(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Posts"),
        actions: [
          IconButton(
              onPressed: () {
                AuthService.signOut(context);
                Navigator.pushReplacementNamed(context, SignInPage.id);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          return _itemsOfPost(items[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetail,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _itemsOfPost(Post post) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            post.content,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
