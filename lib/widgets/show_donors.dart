import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShowDonors extends StatelessWidget {
  final String? Date_of_Birth;
  final String? blood_group;
  final String? gender;
  final String? location;
  final String? name;
  final String? tel;

  ShowDonors(
      {Key? key,
      this.Date_of_Birth,
      this.blood_group,
      this.gender,
      this.location,
      this.name,
      this.tel})
      : super(key: key);

  factory ShowDonors.fromDocument(DocumentSnapshot doc) {
    return ShowDonors(
        Date_of_Birth: doc.get('Date_of_Birth'),
        blood_group: doc.get('blood_group'),
        gender: doc.get('gender'),
        location: doc.get('location'),
        name: doc.get('name'),
        tel: doc.get('tel'));
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: <Widget>[
                  SizedBox(
                      height: 120.0,
                      width: 100.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.black87,
                              alignment: Alignment.center,
                              child: Text(location!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.red,
                              child: Text(blood_group!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      Date_of_Birth!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: "Gotham",
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.person_pin,
                              color: Colors.redAccent,
                            ),
                            Text(
                              gender!,
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Gotham",
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                            InkWell(
                              onTap: () {
                                _launchURL("tel:$tel");
                              },
                              child: const Text(
                                "Call Now",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Gotham",
                                    fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
