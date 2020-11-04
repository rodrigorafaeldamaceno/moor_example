import 'package:flutter/material.dart';
import 'package:moor_example/db/database.dart';
import 'package:moor_example/pages/category/category_page.dart';
import 'package:moor_example/stores/products/products_store.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _controller = ProductsStore();
  final _formKey = GlobalKey<FormState>();

  _addProduct() {
    _controller.nameController.clear();
    _controller.descriptionController.clear();
    _controller.qtdController.clear();
    _controller.priceController.clear();
    _controller.selectedCategory = null;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    'Add product',
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    controller: _controller.nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value.isEmpty) return 'Required field';

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _controller.descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value.isEmpty) return 'Required field';

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _controller.qtdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    validator: (value) {
                      if (value.isEmpty) return 'Required field';

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _controller.priceController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: 'Price'),
                    validator: (value) {
                      if (value.isEmpty) return 'Required field';

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  StreamBuilder(
                    stream: _controller.findCategories(),
                    initialData: List<Category>(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Category>> snapshot) {
                      if (!snapshot.hasData) return Container();

                      return DropdownButtonFormField<Category>(
                        value: _controller.selectedCategory,
                        validator: (value) {
                          if (value == null) return 'Required field';

                          return null;
                        },
                        items: snapshot.data
                            .map<DropdownMenuItem<Category>>(
                              (e) => DropdownMenuItem<Category>(
                                value: e,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onChanged: (value) {
                          _controller.selectedCategory = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Category',
                        ),
                      );
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

                      await _controller.addProduct();

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
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.category_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addProduct,
      ),
      body: StreamBuilder<List<Product>>(
        stream: _controller.find(),
        initialData: List<Product>(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
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
                              onPressed: () async {
                                await _controller.removeProduct(
                                  snapshot.data[index].id,
                                );
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
