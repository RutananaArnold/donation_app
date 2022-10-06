import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:musayi/screens/userscreens/make_blood_requests.dart';
import 'package:musayi/screens/userscreens/register_donor.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> donorStream =
      FirebaseFirestore.instance.collection('donors').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: donorStream,
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
                    tileColor: Colors.blue[200],
                    leading: RichText(
                        text: TextSpan(
                            text: "${data['location']} \n",
                            style: const TextStyle(color: Colors.black),
                            children: [
                          TextSpan(text: "  ${data['blood_group']}")
                        ])),
                    title: Text(data['name']),
                    subtitle: RichText(
                        text: TextSpan(
                            text: "${data['gender']} \n",
                            style: const TextStyle(color: Colors.black),
                            children: [TextSpan(text: data['tel'])]))),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.person_add),
              label: "Be Donor",
              backgroundColor: Colors.red,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: ((context) => const RegisterDonor())),
                    (route) => true);
              }),
          SpeedDialChild(
              child: const Icon(Icons.request_quote),
              label: "Request Blood",
              backgroundColor: Colors.green,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: ((context) => const RequestBlood())),
                    (route) => true);
              }),
        ],
      ),
    );
  }
}
