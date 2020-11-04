import 'package:flutter/material.dart';
import 'package:moor_example/db/database.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _categoryNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        _categoryNameController.clear();

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
                      if (_categoryNameController.text.isNotEmpty)
                        await MyDatabase.instance.categoryDAO.addCategory(
                          Category(
                              id: null, name: _categoryNameController.text),
                        );

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

  Future _removeCategory(int id) async {
    await MyDatabase.instance.categoryDAO.removeCategory(id);
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
      body: StreamBuilder<List<Category>>(
        stream: MyDatabase.instance.categoryDAO.find(),
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
                          return ListTile(
                            title: Text(snapshot.data[index].name),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removeCategory(snapshot.data[index].id);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
