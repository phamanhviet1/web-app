import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:flutter_food_delivery/models/InforUser.dart';
import 'package:flutter_food_delivery/notifier/notifier.dart';
import 'package:flutter_food_delivery/pages/SignInPage.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Infor _infor;
  Future<Infor> loadSettingsFuture;
  List uuuu = [];

  @override
  void initState() {
    super.initState();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    getInfor(orderNotifier, authNotifier.user.email);
    getAlluser(uuuu);
    Future.delayed(Duration(milliseconds: 750)).then((_) {
      getAlluser(uuuu);
    });
    Future.delayed(Duration(milliseconds: 750)).then((_) {
      _infor = orderNotifier.infor;
    });
  }

  void _showDialogPhone(String value, user) {
    AlertDialog alertDialog = new AlertDialog(
      title: new Text("Alert Dialog title"),
      content: TextFormField(
        initialValue: value,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          labelText: 'Phone',
        ),
        onChanged: (String save) {
          value = save;
          print('onchanged $value');
        },
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        new FlatButton(
          child: new Text(value != null ? "Update" : "Create"),
          onPressed: () {
            setState(() {
              addPhone(user, value) != null
                  ? _infor.phone = value
                  : print("eror");
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  void _showDialogAddress(String value, user) {
    // return object of type Dialog
    AlertDialog alertDialog = new AlertDialog(
      title: new Text("Alert Dialog title"),
      content: TextFormField(
        initialValue: value,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          labelText: 'Address',
        ),
        onChanged: (String save) {
          value = save;
          print('onchanged $value');
        },
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        new FlatButton(
            child: new Text(value != null ? "Update" : "Create"),
            onPressed: () {
              setState(() {
                _infor.address = value;
              });
              addAddress(user, value);

              Navigator.of(context, rootNavigator: true).pop();
            })
      ],
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);

    _infor = orderNotifier.infor;

    if (_infor != null && authNotifier.user.email != "123@gmail.com")
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon((Icons.person)),
                Text(
                  " Account: ${authNotifier.user.displayName}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                FlatButton(
                  onPressed: () {
                    signout(authNotifier).whenComplete(() =>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignInPage())));
                  },
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        Text("Log Out "),
                        Icon(Icons.exit_to_app),
                      ],
                    ),
                  )),
                ),
              ],
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                _showDialogAddress(_infor.address, authNotifier.user.email);
              },
              child: Row(children: [
                Icon((Icons.home)),
                Text(" Address  : ",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(fontSize: 20.0),
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                        text: '${_infor.address}'),
                  ),
                ),
              ]),
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                _showDialogPhone(_infor.phone, authNotifier.user.email);
              },
              child: Row(children: [
                Icon((Icons.phone)),
                Text(" Phone      : ",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(fontSize: 20.0),
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                        text: '${orderNotifier.infor.phone}'),
                  ),
                ),
              ]),
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
              height: 30,
            ),
            Row(children: [
              Icon((Icons.shopping_cart)),
              Text(" Cart Order",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ]),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    else if (uuuu.isNotEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(border: Border.all()),
        child: ListView.separated(
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(uuuu[index]),
              onTap: () {
                setState(() {
                  orderNotifier.selectUser = uuuu[index];

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => MainScreen(
                            returnPage: [3, 0],
                          )));
                });
              },
            );
          },
          itemCount: uuuu.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: Colors.black);
          },
        ),
      );
    } else
      return Container(child: Center(child: CircularProgressIndicator()));
  }
}
