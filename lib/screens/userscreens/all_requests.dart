import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final Stream<QuerySnapshot> requestsStream =
      FirebaseFirestore.instance.collection('bloodRequest').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: requestsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15))),
                  tileColor: Colors.green[200],
                  title: RichText(
                      text: TextSpan(
                          text: "Location: ${data['location']} \n",
                          style: const TextStyle(color: Colors.black),
                          children: [
                        TextSpan(text: "BloodAmount: ${data['blood_amount']}")
                      ])),
                  subtitle: RichText(
                      text: TextSpan(
                          text: "BloodGroup: ${data['blood_group']} \n",
                          style: const TextStyle(color: Colors.black),
                          children: [
                        TextSpan(text: "Date of Need: ${data['Date_of_Need']}")
                      ])),
                  trailing: Chip(label: Text(data['status'])),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
