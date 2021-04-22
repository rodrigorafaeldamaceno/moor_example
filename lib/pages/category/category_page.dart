import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:moor_example/db/database.dart';
import 'package:moor_example/stores/category/category_store.dart';
import 'package:moor_example/utils/background_helper.dart';
import 'package:moor_example/utils/utils.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _categoryNameController = TextEditingController();
  final _controller = CategoryStore();
  final _formKey = GlobalKey<FormState>();

  // ignore: cancel_subscriptions
  StreamSubscription<ConnectivityResult> subscription;
  @override
  void initState() {
    super.initState();

    // BackgroundHelper.initPlatformState().then((value) {
    //   synchronize();
    //   _controller.find();
    // });

    // synchronize();
    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   synchronize();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _addCategory() {
    _controller.findList().then((value) => print(value.length));

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Add category'),
                  TextFormField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value.isEmpty) return 'Required field';

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) return null;

                      await _controller.addCategory(
                        Category(
                          id: null,
                          name: _categoryNameController.text,
                        ),
                      );

                      _categoryNameController.clear();

                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addCategory,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          synchronize();
        },
        child: SingleChildScrollView(
          child: StreamBuilder<List<Category>>(
            stream: _controller.find(),
            initialData: <Category>[],
            builder:
                (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              if (!snapshot.hasData) return Container();

              List<Category> list = [];
              list.addAll(snapshot.data.reversed);

              return Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Text('${list.length} Records found'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(list[index].name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.sync,
                                color: list[index].synchronized == true
                                    ? Theme.of(context).accentColor
                                    : Colors.red,
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  print(list[index].toJson());
                                  await _controller
                                      .removeCategory(list[index].id);
                                  await _controller.removeCategoryFromServer(
                                      list[index].uuid);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
