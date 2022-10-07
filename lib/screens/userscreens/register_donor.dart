import 'package:flutter/material.dart';
import 'package:musayi/screens/userscreens/index.dart';
import 'package:musayi/widgets/rounded_button.dart';
import 'package:musayi/widgets/rounded_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/color_pallete.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class RegisterDonor extends StatefulWidget {
  const RegisterDonor({Key? key}) : super(key: key);

  @override
  State<RegisterDonor> createState() => _RegisterDonorState();
}

class _RegisterDonorState extends State<RegisterDonor> {
  final formKey = GlobalKey<FormState>();
  var dateOfBirth = TextEditingController();
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
        dateOfBirth.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // Initial Selected Value
  String genderType = 'Choose your sex';

  // List of items in our dropdown menu
  var genderItems = [
    'Choose your sex',
    'male',
    'female',
    'other',
  ];

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
  String name = ' ';
  String phone = '';

  // Create a CollectionReference called donors that references the firestore collection
  CollectionReference donors = FirebaseFirestore.instance.collection('donors');

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
        title: const Text("Thank you Hero!!"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                RoundedInput(
                  label: "Name",
                  hint: "name",
                  icon: Icons.label,
                  onChanged: (String value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
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
                // gender field
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
                        value: genderType,
                        items: genderItems
                            .map((String items) => DropdownMenuItem(
                                value: items, child: Text(items)))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            genderType = value!;
                          });
                        }),
                  ),
                ),
                RoundedInput(
                  label: "Date of Birth",
                  hint: "Select Date",
                  icon: Icons.timelapse,
                  handler: dateOfBirth,
                  onChanged: (String value) {
                    setState(() {
                      dateOfBirth.text = value;
                    });
                  },
                  readOnly: true,
                  ontap: () => _selectDate(context),
                ),
                RoundedButton(
                    text: "Ready to Donate",
                    press: () {
                      if (formKey.currentState!.validate()) {
                        print(
                            "$name, $locationCtrl, $phone, $bloodType, $genderType,${dateOfBirth.text}");
                        addDonor(name, locationCtrl.text, phone, bloodType,
                            genderType, dateOfBirth.text);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: ((context) => Index())),
                            (route) => true);
                      }
                    },
                    color: Colors.red),
                SizedBox(
                  height: size.height * 0.02,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // uploading donor

  Future<void> addDonor(String fullName, String location, String tel,
      String bloodGroup, String gender, String doB) {
    return donors
        .add({
          'name': fullName,
          'location': location,
          'tel': tel,
          'blood_group': bloodGroup,
          'gender': gender,
          'Date_of_Birth': doB
        })
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Donor Added"))))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add donor: $error"))));
  }
}
