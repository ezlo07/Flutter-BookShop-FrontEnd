import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clothes_app/api_connection/api_connection.dart';


class RecycleFragmentScreen extends StatelessWidget {

  String generateCargoNumber({String prefix = 'CARGO-', int length = 8}) {
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    var random = Random();
    var randomString = '';

    for (var i = 0; i < length; i++) {
      var randomIndex = random.nextInt(characters.length);
      randomString += characters[randomIndex];
    }

    return prefix + randomString;
  }

  CurrentUser currentUser = Get.put(CurrentUser());
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController serialNoController = TextEditingController();
  String CargoNo = "";
  String GettedCargoNo = "Cargo No ";


  void giveCode() async{
    CargoNo = generateCargoNumber();
  }

  void saveRecycle() async {
    giveCode();

    try {
      var res = await http.post(
        Uri.parse(API.checkAndUpload),
        body: {
          "recycle_id": "1",
          "user_id": currentUser.user.user_id.toString(),
          "serialNo": serialNoController.text,
          "ibanNo": ibanController.text,
          "dateTime": DateTime.now().toString(),
          "cargoNo": CargoNo,
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfAddNewOrder = jsonDecode(res.body);

        if (responseBodyOfAddNewOrder["success"] == true) {
          Fluttertoast.showToast(msg: "Check given Cargo No to Send Your Book");

        } else {
          print(res.body + DateTime.now().toString()); // Add this line to print the response body
          Fluttertoast.showToast(msg: "Error: Your new order was NOT placed.");
        }
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error: $errorMsg");
    }
  }

  void getCargo() async {
    try{
      var res= await http.post(Uri.parse(API.getCargo),
      body: {
        'user_id': currentUser.user.user_id.toString(),
        'serialNo': serialNoController.text,
        'ibanNo': ibanController.text,
      });

      if (res.statusCode == 200) {
        String cargoNo = res.body;
        print('Received cargoNo: $cargoNo');
        GettedCargoNo = cargoNo;
        Fluttertoast.showToast(msg: "Correct: Please Refresh This Screen.");

        // Do further processing with the cargoNo as needed
      } else {
        Fluttertoast.showToast(msg: "Error: Your new order was NOT placed.");
      }
    }
    catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error: $errorMsg");
    }

  }

  void updateIBAN() async{
    try {
      var res = await http.post(
        Uri.parse(API.updateIBAN),
        body: {
          "user_id": currentUser.user.user_id.toString(),
          "serialNo": serialNoController.text,
          "ibanNo": ibanController.text,
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfAddNewOrder = jsonDecode(res.body);

        if (responseBodyOfAddNewOrder["success"] == true) {
          Fluttertoast.showToast(msg: "Your IBAN changed Successfully");

        } else {
          Fluttertoast.showToast(msg: "Error");
        }
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error: $errorMsg");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 0, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recycle:",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            //title
            const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 30, 8.0, 8.0),
              child: Text(
                "Please Enter Serial No and IBAN Number\n\n ! If you read the book you bought within 1 month.\n The shipping number will appear below. !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            //IBAN text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: serialNoController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Serial No',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            //IBAN text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: ibanController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'IBAN Number',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            //confirm Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Adjust this property based on your desired button alignment
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveRecycle(); // Call the saveRecycle() function
                  },
                  child: Text('Confirm'),
                ),
                ElevatedButton(
                  onPressed: () {
                    updateIBAN(); // Call the updateIBAN() function
                  },
                  child: Text('Update IBAN'),
                ),
              ],
            ),


            const SizedBox(height: 20),

            //Cargo No
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30), // Adjust the value as needed
              child: TextFormField(
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: GettedCargoNo,
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            //Get Cargo No
            ElevatedButton(
              onPressed: () {
                getCargo();
              },
              child: Text('Get Cargo Number'),
            ),


          ],
        ),
      ),
    );
  }
}