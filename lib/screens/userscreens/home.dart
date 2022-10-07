import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:musayi/screens/userscreens/make_blood_requests.dart';
import 'package:musayi/screens/userscreens/register_donor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:musayi/widgets/show_donors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> donorStream =
      FirebaseFirestore.instance.collection('donors').snapshots();
  bool wannaSearch = false;

  TextEditingController userBloodQuery = TextEditingController();
  TextEditingController userLocationQuery = TextEditingController();

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress = '${placemark.locality}, ${placemark.subLocality},';
    userLocationQuery.text = completeAddress;
  }

  //  final StorageReference storageRef = FirebaseStorage.instance.ref();
  final donorRef = FirebaseFirestore.instance.collection('donors');

  StreamBuilder showSearchResults() {
    return StreamBuilder(
      stream: donorRef
          .orderBy('location')
          .where('location', arrayContains: userLocationQuery.text)
          .where('blood_group', isEqualTo: userBloodQuery.text)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<ShowDonors> allDonors = [];
        snapshot.data.docs.forEach((doc) {
          allDonors.add(ShowDonors.fromDocument(doc));
        });

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              allDonors.isEmpty
                  ? const Text("No Donors Found")
                  : Column(
                      children: allDonors,
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(children: <Widget>[
            Container(
              height: 150.0,
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Find a Donor",
                        style: TextStyle(
                            fontFamily: "Gotham",
                            fontSize: 20.0,
                            color: Colors.black),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          controller: userLocationQuery,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.my_location),
                                onPressed: getUserLocation),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "Location ...",
                          ),
                        )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      wannaSearch = false;
                                      userLocationQuery.clear();
                                      userBloodQuery.clear();
                                      FocusScope.of(context).unfocus();
                                    });
                                  }),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          hint: const Text("Choose Blood Group"),
                          items: const [
                            DropdownMenuItem(
                              value: "A+",
                              child: Text("A+"),
                            ),
                            DropdownMenuItem(
                              value: "B+",
                              child: Text("B+"),
                            ),
                            DropdownMenuItem(
                              value: "O+",
                              child: Text("O+"),
                            ),
                            DropdownMenuItem(
                              value: "AB+",
                              child: Text("AB+"),
                            ),
                            DropdownMenuItem(
                              value: "A-",
                              child: Text("A-"),
                            ),
                            DropdownMenuItem(
                              value: "B-",
                              child: Text("B-"),
                            ),
                            DropdownMenuItem(
                              value: "O-",
                              child: Text("O-"),
                            ),
                            DropdownMenuItem(
                              value: "AB-",
                              child: Text("AB-"),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              userBloodQuery.text = val!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                wannaSearch = true;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(color: Colors.red)),
                            ),
                            child: const Text(
                              "Search",
                              style: TextStyle(
                                  fontFamily: "Gotham",
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            "  Recent Donors",
            style: TextStyle(
                fontFamily: "Gotham", fontSize: 22.0, color: Colors.black),
          ),
          const SizedBox(
            height: 10.0,
          ),
          wannaSearch
              ? showSearchResults()
              : StreamBuilder(
                  stream: donorRef
                      .where("blood_group", isGreaterThan: "")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text("Loading"));
                    }
                    List<ShowDonors> allDonors = [];
                    for (var doc in snapshot.data!.docs) {
                      allDonors.add(ShowDonors.fromDocument(doc));
                    }

                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: allDonors,
                        ),
                      ),
                    );
                  },
                ),

          // StreamBuilder<QuerySnapshot>(
          //     stream: donorStream,
          //     builder: (BuildContext context,
          //         AsyncSnapshot<QuerySnapshot> snapshot) {
          //       if (snapshot.hasError) {
          //         return const Text('Something went wrong');
          //       }
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: Text("Loading"));
          //       }
          //       return Column(
          //         children:
          //             snapshot.data!.docs.map((DocumentSnapshot document) {
          //           Map<String, dynamic> data =
          //               document.data()! as Map<String, dynamic>;
          //           return Padding(
          //               padding: const EdgeInsets.only(top: 10, bottom: 10),
          //               child: ShowDonors(
          //                   Date_of_Birth: data['Date_of_Birth'],
          //                   blood_group: data['blood_group'],
          //                   gender: data['gender'],
          //                   location: data['location'],
          //                   name: data['name'],
          //                   tel: data['tel'])
          //               );
          //         }).toList(),
          //       );
          //     },
          //   ),
        ],
      ),

      // StreamBuilder<QuerySnapshot>(
      //   stream: donorStream,
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return const Text('Something went wrong');
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: Text("Loading"));
      //     }

      //     return ListView(
      //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
      //         Map<String, dynamic> data =
      //             document.data()! as Map<String, dynamic>;
      //         return Padding(
      //           padding: const EdgeInsets.only(top: 10, bottom: 10),
      //           child: ListTile(
      //               shape: const RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.only(
      //                       topLeft: Radius.circular(15),
      //                       topRight: Radius.circular(15),
      //                       bottomRight: Radius.circular(15),
      //                       bottomLeft: Radius.circular(15))),
      //               tileColor: Colors.blue[200],
      //               leading: RichText(
      //                   text: TextSpan(
      //                       text: "${data['location']} \n",
      //                       style: const TextStyle(color: Colors.black),
      //                       children: [
      //                     TextSpan(text: "  ${data['blood_group']}")
      //                   ])),
      //               title: Text(data['name']),
      //               subtitle: RichText(
      //                   text: TextSpan(
      //                       text: "${data['gender']} \n",
      //                       style: const TextStyle(color: Colors.black),
      //                       children: [TextSpan(text: data['tel'])]))),
      //         );
      //       }).toList(),
      //     );
      //   },
      // ),

      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.person_add),
              label: "Become Donor",
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
