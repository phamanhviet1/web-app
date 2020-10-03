import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/models/multiImage.dart';
import 'package:flutter_food_delivery/notifier/foodNotifier.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:toast/toast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/foundation.dart';

class UploadCard extends StatefulWidget {
  final bool isUpdating;

  UploadCard({this.isUpdating});

  @override
  _UploadCardState createState() => _UploadCardState();
}

class _UploadCardState extends State<UploadCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Food _currentFood;
  List _imageUrl = [];
  File _imageFile;
  List<String> categories = ["Burger", "Pizza", "Beer", "Coffee", "Turkey"];
  String _key;
  String foos = 'Select Category';
  bool editchange = false;
  List multiImageList = [];
  List<MultiImage> imageEditList = [];
  _collapse(String a) {
    String newKey;
    do {
      _key = randomNumeric(4);
      foos = a;
    } while (newKey == _key);
  }

  @override
  void initState() {
    super.initState();
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    if (foodNotifier.currentFood != null) {
      _currentFood = foodNotifier.currentFood;
    } else {
      _currentFood = new Food();
    }
    _imageUrl.addAll(_currentFood.image);
  }

  _showImageCreate(String url, int index) {
    print(index.toString());
    print(url);

    if (url != null) {
      print('showing image from url');
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          child: Stack(
            children: <Widget>[
              widget.isUpdating
                  ? Center(
                      child: Image.network(url, fit: BoxFit.cover, height: 250))
                  : Center(
                      child: Image.memory(multiImageList[index].data,
                          fit: BoxFit.cover, height: 250),
                    ),
              Align(
                alignment: Alignment.topCenter,
                child: FlatButton(
                    onPressed: () => _getLocalImage(index),
                    child: Text(
                      'Change Image',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                    onPressed: () => _deleteImage(index),
                    child: Text(
                      'Delete Image',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      );
    }
  }

  _showImageEdit(String url, int index) {
    print(index.toString());
    print(url);
    if (imageEditList[index].isUploaded == false)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Center(
                child: Image.network(
                  url,
                  height: 250,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: FlatButton(
                  onPressed: () => _getLocalImage(index),
                  child: Text(
                    'Change Image',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                  onPressed: () => _deleteImage(index),
                  child: Text(
                    'Delete Image',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      );
    else if (imageEditList[index].isUploaded == true) {
      print('showing image from local');
      print(imageEditList[index].url);
      return Stack(
        children: <Widget>[
          Center(
            child: new Image.memory(
              imageEditList[index].uint8list,
              height: 250,
              fit: BoxFit.fitHeight,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FlatButton(
                onPressed: () => _getLocalImage(index),
                child: Text(
                  'Change Image',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
                onPressed: () => _deleteImage(index),
                child: Text(
                  'Delete Image',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                )),
          )
        ],
      );
    }
  }

  _getLocalImage(int index) async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    var imageFile = mediaData.fileName;
    bool flag = false;
    _imageUrl.forEach(
      (element) {
        if (element == imageFile) {
          flag = true;
          Toast.show(" $imageFile is exitis", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        }
      },
    );
    if (imageFile != null && flag == false) {
      setState(() {
        if (widget.isUpdating == false) {
          multiImageList[index] = mediaData;
        } else {
          imageEditList[index] = new MultiImage(
              url: imageFile,
              mediaInfo: mediaData,
              isUploaded: true,
              uint8list: mediaData.data);
          _imageUrl[index] = mediaData.fileName;
          editchange = true;
        }
      });
    }
  }

  _addLocalImage(int index) async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    var imageFile = mediaData.fileName;
    bool flag = false;
    _imageUrl.forEach(
      (element) {
        if (element == imageFile) {
          flag = true;
          Toast.show(" $imageFile is exitis", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        }
      },
    );
    if (imageFile != null && flag == false && widget.isUpdating == false) {
      setState(() {
        print("add $index");
        multiImageList.add(mediaData);
        _imageUrl.add(mediaData.fileName);
      });
    }
    if (widget.isUpdating && flag == false) {
      setState(() {
        print("add $index");
        imageEditList.add(MultiImage(
            url: mediaData.fileName,
            mediaInfo: mediaData,
            isUploaded: true,
            uint8list: mediaData.data));

        editchange = true;
        _imageUrl.add(mediaData.fileName);
      });
    }
  }

  _deleteImage(int index) {
    if (multiImageList.isNotEmpty) {
      setState(() {
        multiImageList
            .removeWhere((element) => element.fileName == _imageUrl[index]);
        _imageUrl.remove(_imageUrl[index]);
      });
    }
    if (widget.isUpdating && imageEditList.isNotEmpty) {
      setState(() {
        imageEditList.remove(imageEditList[index]);
        _imageUrl.remove(_imageUrl[index]);
        editchange = true;
      });
    }
  }

  _onFoodUploaded(Food food) {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    foodNotifier.addFood(food);
    Navigator.pop(context);
  }

  _saveFood() {
    print('saveFood Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');
    print(imageEditList.length);

    widget.isUpdating
        ? uploadFile(
            imageEditList,
            widget.isUpdating,
            _currentFood,
            _onFoodUploaded,
          )
        : uploadFile(
            multiImageList,
            widget.isUpdating,
            _currentFood,
            _onFoodUploaded,
          );

    print("name: ${_currentFood.name}");
    print("category: ${_currentFood.category}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Name'),
        initialValue: _currentFood.name,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Name is required';
          }

          if (value.length < 3 || value.length > 20) {
            return 'Name must be more than 3 and less than 20';
          }

          return null;
        },
        onSaved: (String value) {
          _currentFood.name = value;
        },
      ),
    );
  }

  Widget _buildContentField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Content'),
        initialValue: _currentFood.content,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        style: TextStyle(fontSize: 20),
        onSaved: (String value) {
          _currentFood.content = value;
        },
      ),
    );
  }

  Widget _buildPriceField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Price'),
        initialValue: _currentFood.price,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20),
        onSaved: (String value) {
          _currentFood.price = value;
        },
      ),
    );
  }

  Widget _buildSaleField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Sale'),
        initialValue: _currentFood.sale,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20),
        onSaved: (String value) {
          _currentFood.sale = value;
        },
      ),
    );
  }

  Widget _buildCategoryField() {
    return ExpansionTile(
      key: new Key(_key),
      initiallyExpanded: false,
      title: widget.isUpdating ? Text(_currentFood.category) : Text(foos),
      children: [
        Container(
          height: 200,
          child: ListView.separated(
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(categories[index]),
                onTap: () {
                  setState(() {
                    this.foos = categories[index];
                    _currentFood.category = categories[index];
                    _collapse(this.foos);
                  });
                },
              );
            },
            itemCount: categories.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Colors.black);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build _${_imageUrl.length}");
    print("build _${imageEditList.length}");
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: _imageUrl.length != 0
                        ? GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(8),
                            itemCount: _imageUrl.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemBuilder: (_, index) {
                              if (editchange == false)
                                imageEditList.add(MultiImage(
                                    url: _imageUrl[index], isUploaded: false));
                              return Stack(children: [
                                widget.isUpdating
                                    ? _showImageEdit(_imageUrl[index], index)
                                    : _showImageCreate(_imageUrl[index], index)
                              ]);
                            })
                        : Image.network(
                            'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                            height: 250,
                            width: 200,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.isUpdating ? "Edit Food" : "Create Food",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  ButtonTheme(
                    child: RaisedButton(
                      onPressed: () => _addLocalImage(_imageUrl.length),
                      child: Text(
                        'Add Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  _buildNameField(),
                  _buildCategoryField(),
                  _buildContentField(),
                  _buildPriceField(),
                  _buildSaleField(),
                  SizedBox(
                    height: 16,
                  )
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveFood();
          Toast.show("Waiting ${multiImageList.length} seconds", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
