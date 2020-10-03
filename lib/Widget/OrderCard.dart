import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 75.0,
              width: 45.0,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.add),
                  ),
                  Text('0'),
                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.minimize),
                  )
                ],
              ),
            ),
            Image.asset(
              "assets/images/lunch.jpeg",
              height: 75,
            ),
          ],
        ),
      ),
    );
  }
}
