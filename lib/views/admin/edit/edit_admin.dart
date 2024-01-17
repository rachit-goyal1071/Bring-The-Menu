import 'package:bring_the_menu/views/admin/complete_profile/complete_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controller/database_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_widget.dart';

class AdminEditPage extends StatefulWidget {
  const AdminEditPage({super.key});

  @override
  State<AdminEditPage> createState() => _AdminEditPageState();
}

class _AdminEditPageState extends State<AdminEditPage> {


  final constants = Get.put(Constants());
  final db = Get.put(DatabaseController());

  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController restaurantLocationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController upiController = TextEditingController();

  RxString openTime = 'Select Time'.obs;
  RxString closeTime = 'Select Time'.obs;
  GeoPoint? _currentPoint;

  @override
  void dispose() {
    // Dispose of controllers
    restaurantNameController.dispose();
    restaurantLocationController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    upiController.dispose();

    // Dispose of RxString
    openTime.close();
    closeTime.close();

    super.dispose();
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getCurrentPosition();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constants.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: Get.width / 30,
              right: Get.width / 30,
              top: Get.width / 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bring the menu admin',
                style: TextStyle(
                    color: constants.whiteTextColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Get.height / 50),
              Text(
                'Edit Profile',
                style: TextStyle(
                    color: constants.whiteTextColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              ),

              SizedBox(height: Get.height / 13),

              InputWidget(
                  constants: constants,
                  title: 'Restaurant Name',
                  hintText: 'eg: My awesome restaurant.',
                  controller: restaurantNameController,
                  isObscrue: false),

              SizedBox(height: Get.height / 30),

              InputWidget(
                  constants: constants,
                  title: 'Location Pincode',
                  hintText: 'Fetching.....',
                  controller: restaurantLocationController,

                  isObscrue: false),

              SizedBox(height: Get.height / 30),

              // Phone & Website
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width / 1.95,
                    child: InputWidget(
                        textInputType: TextInputType.phone,
                        constants: constants,
                        title: 'Phone',
                        hintText: 'eg: 8813900000',
                        controller: phoneController,
                        isObscrue: false),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Website',
                        style: TextStyle(
                            color: constants.whiteTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      SizedBox(height: Get.height / 60),
                      Container(
                        width: Get.width / 3.05,
                        height: Get.height / 17,
                        decoration: BoxDecoration(
                            color: constants.inputBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: constants.inputStrokeColor)),
                        child: TextFormField(
                          controller: websiteController,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'eg: www.google.com',
                            hintStyle: TextStyle(
                                color: constants.inputHintTextColor,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),

              // UPI
              SizedBox(height: Get.height / 30),
              InputWidget(
                  constants: constants,
                  title: 'UPI',
                  hintText: 'eg: 8813@paytm',
                  controller: upiController,
                  isObscrue: false),

              // Opening Closing
              SizedBox(height: Get.height / 30),
              Obx(() => Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Open Time',
                          style: TextStyle(
                              color: constants.whiteTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        SizedBox(height: Get.height / 60),
                        InkWell(
                          onTap: () async {
                            final TimeOfDay? newTime =
                            await showTimePicker(
                              context: context,
                              initialTime:
                              const TimeOfDay(hour: 12, minute: 00),
                            );

                            final time =
                                '${newTime!.hour} : ${newTime.minute}';
                            openTime.value = time;
                          },
                          child: Container(
                            width: Get.width / 3,
                            height: Get.height / 17,
                            decoration: BoxDecoration(
                                color: constants.inputBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: constants.inputStrokeColor)),
                            child: Center(
                              child: Text(
                                openTime.toString(),
                                style: TextStyle(
                                    color: constants.inputHintTextColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Close Time',
                          style: TextStyle(
                              color: constants.whiteTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        SizedBox(height: Get.height / 60),
                        InkWell(
                          onTap: () async {
                            final TimeOfDay? newTime =
                            await showTimePicker(
                              context: context,
                              initialTime:
                              const TimeOfDay(hour: 12, minute: 00),
                            );

                            final time =
                                '${newTime!.hour} : ${newTime.minute}';
                            closeTime.value = time;
                          },
                          child: Container(
                            width: Get.width / 3,
                            height: Get.height / 17,
                            decoration: BoxDecoration(
                                color: constants.inputBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: constants.inputStrokeColor)),
                            child: Center(
                              child: Text(
                                closeTime.toString(),
                                style: TextStyle(
                                    color: constants.inputHintTextColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),

              SizedBox(height: Get.height / 30),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomButton(
                        constants: constants,
                        title: 'Submit',
                        onTap: () {
                          print("000000000000 submit");
                          try {
                            db.createProfile(
                                restaurantNameController.text,
                                _currentPoint!,
                                phoneController.text,
                                websiteController.text,
                                upiController.text,
                                openTime.string,
                                closeTime.string
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                        width: Get.width / 4,
                        height: Get.height / 18),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
