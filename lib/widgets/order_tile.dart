import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/order_header.dart';

class OrderTile extends StatelessWidget {
  OrderTile({Key? key, required this.order}) : super(key: key);

  final DocumentSnapshot<Map<String, dynamic>> order;

  final states = [
    '',
    'Em Preparação',
    'Em Trasporte',
    'Aguardando Entrega',
    'Entregue'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.id),
          initiallyExpanded: (order.data()!)['status'] != 4,
          title: Text(
            "#${order.id.substring(order.id.length - 7, order.id.length)} - "
            "${states[order.data()!["status"]]}",
            style: TextStyle(
              color: (order.data()!)['status'] != 4
                  ? Colors.grey.shade800
                  : Colors.green,
            ),
          ),
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderHeader(order: order),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data()!['products'].map<Widget>((p) {
                      return ListTile(
                        title: Text(p["product"]['title'] + " " + p["size"]),
                        subtitle: Text(p["category"] + "/" + p['pid']),
                        trailing: Text(
                          "${p["quantity"].toString()} x R\$ ${p["product"]["price"]}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('user')
                              .doc(order["clientId"])
                              .collection('orders')
                              .doc(order.id)
                              .delete();
                          order.reference.delete();
                        },
                        child: Text("Excluir"),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red),
                      ),
                      TextButton(
                        onPressed: order.get('status') > 1
                            ? () {
                                order.reference.update(
                                    {'status': order.get('status') - 1});
                              }
                            : null,
                        child: Text("Regredir"),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey[850]),
                      ),
                      TextButton(
                        onPressed: order.get('status') < 4
                            ? () {
                                order.reference.update(
                                    {'status': order.get('status') + 1});
                              }
                            : null,
                        child: Text("Avançar"),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.green),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
