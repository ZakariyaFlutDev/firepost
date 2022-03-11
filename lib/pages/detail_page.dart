import 'package:firepost/model/post_model.dart';
import 'package:firepost/pages/home_page.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var titleController = TextEditingController();
  var contentController = TextEditingController();

  _addPost() async {
    String title = titleController.text.toString();
    String content = contentController.text.toString();
    if (title.isEmpty || content.isEmpty) return;

    _apiAddPost(title, content);
  }

  _apiAddPost(String title, String content) async {
    var id = await Prefs.loadUserId();

    RTDBService.addPost(Post(id!, title, content)).then((response) => {
          _respAddPost(),
        });
  }

  _respAddPost() {
    Navigator.of(context).pop({'data': 'done'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Page"),
        ),
        body: SingleChildScrollView(
            child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  hintText: "Content",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.blue,
                child: ElevatedButton(
                  child: Text("Add"),
                  onPressed: _addPost,
                ),
              )
            ],
          ),
        )));
  }
}
