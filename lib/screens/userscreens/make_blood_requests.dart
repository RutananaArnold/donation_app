import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musayi/constants/color_pallete.dart';
import 'package:musayi/screens/userscreens/all_requests.dart';
import 'package:musayi/widgets/rounded_button.dart';
import 'package:musayi/widgets/rounded_input.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class RequestBlood extends StatefulWidget {
  const RequestBlood({Key? key}) : super(key: key);

  @override
  State<RequestBlood> createState() => _RequestBloodState();
}

class _RequestBloodState extends State<RequestBlood> {
  final formkey = GlobalKey<FormState>();
  var needDate = TextEditingController();
  final locationCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 20))))) {
      return true;
    }
    return false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1980),
      lastDate: DateTime(2030),
      selectableDayPredicate: _decideWhichDayToEnable,
      helpText: 'SELECT DATE',
      cancelText: 'NOT NOW',
      confirmText: 'SET',
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        needDate.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  String bloodType = 'Blood Group';
  var bloodItems = [
    'Blood Group',
    'A+',
    'B+',
    'O+',
    'AB+',
    'A-',
    'B-',
    'O-',
    'AB-'
  ];
  String bloodAmount = '';
  String phone = '';

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference requests =
      FirebaseFirestore.instance.collection('bloodRequest');

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress = '${placemark.locality}, ${placemark.subLocality},';
    locationCtrl.text = completeAddress;
    print(completeAddress);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("REQUEST BLOOD"),
      ),
      body: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Center(
                child: Column(
              children: [
                RoundedInput(
                  label: "Location",
                  hint: "location",
                  icon: Icons.location_on,
                  handler: locationCtrl,
                  suffixIcon: IconButton(
                      onPressed: (() => getUserLocation()),
                      icon: const Icon(Icons.add_location_alt_rounded)),
                ),
                RoundedInput(
                  label: "Blood Amount",
                  hint: "Blood Amount(in Pints)",
                  icon: Icons.water_drop,
                  onChanged: (String value) {
                    setState(() {
                      bloodAmount = value;
                    });
                  },
                ),
                RoundedInput(
                  label: "Phone number",
                  hint: "tel",
                  icon: Icons.phone,
                  onChanged: (String value) {
                    setState(() {
                      phone = value;
                    });
                  },
                ),
                // blood group field
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  width: size.width * 0.9,
                  height: size.height * 0.13,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: size.width * 0.35,
                    child: DropdownButton(
                        value: bloodType,
                        items: bloodItems
                            .map((String items) => DropdownMenuItem(
                                value: items, child: Text(items)))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            bloodType = value!;
                          });
                        }),
                  ),
                ),
                RoundedInput(
                  label: "Date of Blood Request",
                  hint: "When Do you Need?",
                  icon: Icons.timelapse,
                  handler: needDate,
                  onChanged: (String value) {
                    setState(() {
                      needDate.text = value;
                    });
                  },
                  readOnly: true,
                  ontap: () => _selectDate(context),
                ),
                RoundedButton(
                    text: "Request Blood",
                    press: () {
                      if (formkey.currentState!.validate()) {
                        requestBlood(locationCtrl.text, bloodAmount, phone,
                            bloodType, needDate.text);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: ((context) => const Requests())),
                            (route) => true);
                      }
                    },
                    color: Colors.red),
                SizedBox(
                  height: size.height * 0.02,
                )
              ],
            )),
          )),
    );
  }

  // umake request

  Future<void> requestBlood(String location, String bloodAmount, String tel,
      String bloodGroup, String doNeed) {
    return requests
        .add({
          'location': location,
          'blood_amount': bloodAmount,
          'tel': tel,
          'blood_group': bloodGroup,
          'Date_of_Need': doNeed,
          'status': 'pending'
        })
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Request sent"))))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send request: $error"))));
  }
}
