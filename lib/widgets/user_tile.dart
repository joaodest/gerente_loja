import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.user}) : super(key: key);

  final Map<String, dynamic> user;


  @override
  Widget build(BuildContext context) {

    if(user.containsKey('money')) {
      return ListTile(
        title: Text(
          user['name'],
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          user['email'],
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pedidos: ${user['orders']}",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text("Gasto: R\$${user['money'].toStringAsFixed(2)}",
                style: TextStyle(color: Colors.white, fontSize: 12))
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              height: 20,
              child: Shimmer(
                child: Container(
                  color: Colors.white.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                )
              ),
            ),
            SizedBox(
              width: 50,
              height: 20,
              child: Shimmer(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ),
                  gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.grey
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                  )
              ),
            )
          ],
        ),
      );
    }
  }
}
