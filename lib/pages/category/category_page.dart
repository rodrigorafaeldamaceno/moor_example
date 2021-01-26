import 'package:flutter/material.dart';
import 'package:moor_example/db/database.dart';
import 'package:moor_example/stores/category/category_store.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _categoryNameController = TextEditingController();
  final _controller = CategoryStore();
  final _formKey = GlobalKey<FormState>();

  _addCategory() {
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
                  RaisedButton(
                    color: Colors.blue,
                    colorBrightness: Brightness.dark,
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
      body: SingleChildScrollView(
        child: StreamBuilder<List<Category>>(
          stream: _controller.find(),
          initialData: List<Category>(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            return !snapshot.hasData
                ? Container()
                : Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text('${snapshot.data.length} Records found'),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(snapshot.data[index].synchronized);
                            return ListTile(
                              title: Text(snapshot.data[index].name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sync,
                                    color: snapshot.data[index].synchronized ==
                                            true
                                        ? Theme.of(context).accentColor
                                        : Colors.red,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await _controller.removeCategory(
                                          snapshot.data[index].id);
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
    );
  }
}
