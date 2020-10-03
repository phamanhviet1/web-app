import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/models/Auth.dart';

import 'package:flutter_food_delivery/notifier/authNotifier.dart';
import 'package:flutter_food_delivery/notifier/foodNotifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:flutter_food_delivery/notifier/orderNotifier.dart';
import '../models/InforUser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:firebase/firebase.dart' as fb;

loginAdmin(Auth auth, AuthNotifier authNotifier) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  // final GoogleSignInAuthentication googleSignInAuthentication =
  //     await googleSignInAccount.authentication;

  // final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     idToken: googleSignInAuthentication.idToken,
  //     accessToken: googleSignInAuthentication.accessToken);

  // final AuthResult result =
  //     await _firebaseAuth.signInWithCredential(credential);

  final AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
      email: "123@gmail.com", password: "123456");
  if (result != null) {
    FirebaseUser firebaseUser = result.user;
    if (firebaseUser != null) {
      print("Log In: ${firebaseUser.email}");
      authNotifier.setUser(firebaseUser);
    }
  }
}

login(Auth auth, AuthNotifier authNotifier) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  final AuthResult result =
      await _firebaseAuth.signInWithCredential(credential);

  if (result != null) {
    FirebaseUser firebaseUser = result.user;
    if (firebaseUser != null) {
      print("Log In: ${firebaseUser.email}");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  await _firebaseAuth.signOut().catchError((error) => print(error.code));
  await googleSignIn.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser != null) {
    print('log in $firebaseUser');
    authNotifier.setUser(firebaseUser);
  }
}

getFoods(FoodNotifier foodNotifier) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection('Foods').getDocuments();

  List<Food> _foodList = [];

  snapshot.documents.forEach((document) {
    Food food = Food.fromMap(document.data);
    _foodList.add(food);
  });

  foodNotifier.foodList = _foodList;
  return _foodList.length;
}

uploadFile(
    List mediaInfo, bool isUpdating, Food food, Function foodUploaded) async {
  List<String> listUrl = [];

  if (mediaInfo.isNotEmpty && isUpdating == false) {
    print("create url");
    mediaInfo.forEach(
      (element) {
        try {
          String mimeType = mime(path.basename(element.fileName));

          var metaData = fb.UploadMetadata(contentType: mimeType);
          var uuid = Uuid().v4();
          print(uuid);
          fb.StorageReference storageReference =
              fb.storage().ref('foods/images').child(uuid);

          fb.UploadTask uploadTask =
              storageReference.put(element.data, metaData);

          var imageUri;

          uploadTask.future.then((snapshot) => {
                Future.delayed(Duration(milliseconds: 1)).then((value) => {
                      snapshot.ref.getDownloadURL().then((dynamic uri) {
                        imageUri = uri;
                        print('Download URL: ${imageUri.toString()}');
                        String url = imageUri.toString();
                        listUrl.add(url);
                      })
                    })
              });
        } catch (e) {
          print('File Upload Error: $e');
        }
      },
    );
  } else if (mediaInfo.isNotEmpty && isUpdating == true) {
    print("change url");
    mediaInfo.forEach(
      (element) {
        print("index ${element.url.indexOf("https://firebasestorage")}");
        if (element.url.indexOf("http") == 0) {
          print("url : ${element.url}");
          listUrl.add(element.url);
        } else {
          try {
            String mimeType = mime(path.basename(element.url));

            var metaData = fb.UploadMetadata(contentType: mimeType);
            var uuid = Uuid().v4();
            print(uuid);
            fb.StorageReference storageReference =
                fb.storage().ref('foods/images').child(uuid);

            fb.UploadTask uploadTask =
                storageReference.put(element.uint8list, metaData);

            var imageUri;

            uploadTask.future.then((snapshot) => {
                  Future.delayed(Duration(milliseconds: 1)).then((value) => {
                        snapshot.ref.getDownloadURL().then((dynamic uri) {
                          imageUri = uri;
                          print('Download URL: ${imageUri.toString()}');
                          String url = imageUri.toString();
                          listUrl.add(url);
                        })
                      })
                });
          } catch (e) {
            print('File Upload Error: $e');
          }
        }
      },
    );
  } else {
    print('...skipping image upload');
    _uploadFood(food, isUpdating, foodUploaded);
  }
  print("length ${mediaInfo.length}");
  await Future.delayed(Duration(seconds: (mediaInfo.length + 1))).then(
      (value) =>
          _uploadFood(food, isUpdating, foodUploaded, imageUrl: listUrl));
  print('...File Upload Complete');
}

_uploadFood(Food food, bool isUpdating, Function foodUploaded,
    {List<String> imageUrl}) async {
  CollectionReference foodRef = Firestore.instance.collection('Foods');

  if (imageUrl.isNotEmpty) {
    food.image = imageUrl;
  }

  if (isUpdating) {
    food.updatedAt = Timestamp.now();

    await foodRef.document(food.id).updateData(food.toMap());

    foodUploaded(food);
    print('updated food with id: ${food.id}');
  } else {
    food.createdAt = Timestamp.now();

    DocumentReference documentRef = await foodRef.add(food.toMap());

    food.id = documentRef.documentID;

    print('uploaded food successfully: ${food.toString()}');

    await documentRef.setData(food.toMap(), merge: true);

    foodUploaded(food);
  }
}

deleteFood(Food food, Function foodDeleted) async {
  if (food.image != null) {
    var storage = fb.storage();
    food.image.forEach((element) async {
      var httpsReference = storage.refFromURL(element);

      print(httpsReference.fullPath);

      await httpsReference.delete();
    });

    print('image deleted');
  }

  await Firestore.instance.collection('Foods').document(food.id).delete();
  foodDeleted(food);
}

// ignore: non_constant_identifier_names
UploadOrderCard(Food food, String email) async {
  CollectionReference foodRef = Firestore.instance.collection(email);
  food.createdAt = Timestamp.now();
  DocumentReference documentRef = await foodRef.add(food.toMap());

  food.id = documentRef.documentID;

  print('Order food successfully: ${food.toString()}');

  await documentRef.setData(food.toMap(), merge: true);
}

addPhone(String user, String phone) async {
  try {
    DocumentReference foodRef =
        Firestore.instance.collection("$user").document("user");
    foodRef.updateData({
      "Phone": "$phone",
    });

    print('user ${user.toString()}');
    return user;
  } catch (error) {
    return null;
  }
}

addAddress(String user, String address) async {
  try {
    DocumentReference foodRef =
        Firestore.instance.collection("$user").document("user");
    foodRef.updateData({
      "Address": "$address",
    });
    print('user ${user.toString()}');
    return user;
  } catch (error) {
    return null;
  }
}

getOrder(OrderNotifier orderNotifier, String displayname, List cartname) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection(displayname).getDocuments();

  List<Food> _foodOrder = [];

  snapshot.documents.forEach((document) {
    Food food = Food.fromMap(document.data);

    _foodOrder.add(food);
    if (cartname.indexOf(food.flag) == -1 && food.flag != "1")
      cartname.add(food.flag);
  });
  cartname.sort((a, b) => a.compareTo(b));
  orderNotifier.orderList = _foodOrder;
  print("ok");
  print('getcart ${cartname.length}');
}

Future<Infor> getInfor(OrderNotifier orderNotifier, String user) async {
  Infor inf;

  QuerySnapshot snapshot =
      await Firestore.instance.collection(user).getDocuments();
  snapshot.documents.forEach((document) {
    if (document.documentID == "user") inf = Infor.fromMap(document.data);
  });

  if (inf == null) {
    Firestore.instance
        .collection(user)
        .document("user")
        .setData({"flag": "1", "Address": "1", "Phone": "1"});
    Firestore.instance.collection("user").document(user).setData({
      "flag": "1",
    });
  }

  orderNotifier.infor = inf;
  print("infor changed ${orderNotifier.infor.flag}");
  return inf;
}

getAlluser(List user) async {
  List b = [];
  QuerySnapshot snapshot =
      await Firestore.instance.collection("user").getDocuments();
  snapshot.documents.forEach((document) {
    b.add(document.documentID);
  });
  user.addAll(b);
}

getSelectInfor(OrderNotifier orderNotifier, String user) async {
  Infor inf;

  QuerySnapshot snapshot =
      await Firestore.instance.collection(user).getDocuments();
  snapshot.documents.forEach((document) {
    if (document.documentID == "user") inf = Infor.fromMap(document.data);
  });

  orderNotifier.selectInfor = inf;
  print("infor changed ${orderNotifier.infor.flag}");
}

deleteOrder(Food food, String user) async {
  await Firestore.instance.collection(user).document(food.id).delete();
}
