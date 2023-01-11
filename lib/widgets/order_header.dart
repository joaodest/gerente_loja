import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {
  const OrderHeader({Key? key, required this.order}) : super(key: key);

  final DocumentSnapshot<Map<String, dynamic>> order;

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.getBloc<UserBloc>();

    final user = userBloc.getUser(order.data()!['clientId']);


    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${user["name"]}'),
              Text('${user['address']}')
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Produtos: R\$${order.get('productsPrice').toStringAsFixed(
                2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Total: R\$${order.get('totalPrice').toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ],
    );
  }
}