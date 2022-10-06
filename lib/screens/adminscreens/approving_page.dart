import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musayi/widgets/rounded_button.dart';

class ApprovingPage extends StatefulWidget {
  final DocumentSnapshot<Object?> document;
  final String location;
  final String bloodAmount;
  final String tel;
  final String group;
  final String date;
  const ApprovingPage(
      {Key? key,
      required this.document,
      required this.location,
      required this.bloodAmount,
      required this.tel,
      required this.group,
      required this.date})
      : super(key: key);

  @override
  State<ApprovingPage> createState() => _ApprovingPageState();
}

class _ApprovingPageState extends State<ApprovingPage> {
  final requestDB = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 10,
                  child: Column(children: [
                    Wrap(
                      children: [
                        const Text(
                          "Location: ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.location,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ]),
                ),
              ),

              // 2nd
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 10,
                  child: Column(children: [
                    Wrap(
                      children: [
                        const Text(
                          "Blood Amount: ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.bloodAmount,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ]),
                ),
              ),

              // 3rd
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 10,
                  child: Column(children: [
                    Wrap(
                      children: [
                        const Text(
                          "Phone: ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.tel,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ]),
                ),
              ),

              // 4TH
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 10,
                  child: Column(children: [
                    Wrap(
                      children: [
                        const Text(
                          "Blood Group: ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.group,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ]),
                ),
              ),

              // 5th

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 10,
                  child: Column(children: [
                    Wrap(
                      children: [
                        const Text(
                          "Date of Need: ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.date,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ]),
                ),
              ),

              RoundedButton(
                  text: "Approve",
                  press: () {
                    requestDB
                        .collection('bloodRequest')
                        .doc(widget.document.id)
                        .update({'status': 'approved'})
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text("Client approved successfully"))))
                        .catchError((error) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content:
                                    Text("Failed to update user: $error"))));
                  },
                  color: const Color.fromARGB(255, 76, 143, 197))
            ],
          ),
        ),
      ),
    );
  }
}
