import 'dart:io';

import 'package:flutter/material.dart';

import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/widgets/ImagePicker.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';
import 'package:iplanning/widgets/signup.dart';

class EditScreen extends StatefulWidget {
  UserModel userData;
  EditScreen(
      {super.key,
      required this.enteremail,
      this.fisrtName,
      this.lastName,
      this.phoneNumber,
      this.country,
      // required this.onSave,
      required this.avatarEdit,
      required this.userData});
  final String enteremail;
  String? fisrtName;
  String? lastName;
  String? avatarEdit;
  String? phoneNumber;
  String? country;
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _countryController;
  var _authService = AuthenticationService();
  File? _selectedImage;

  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _nameController = TextEditingController(text: widget.fisrtName);
    _emailController = TextEditingController(text: widget.enteremail);
    _phoneController = TextEditingController(text: widget.phoneNumber);
    _countryController = TextEditingController(text: widget.country);
  }

  Future<void> _handleSave() async {
    setState(() {
      _isLoading = true;
    });
    try {
      widget.userData.name = _nameController.text;
      widget.userData.phone =
          _phoneController.text.isEmpty ? null : _phoneController.text;
      widget.userData.country =
          _countryController.text.isEmpty ? null : _countryController.text;

      await _authService.updateUser(widget.userData,
          newAvatars: _selectedImage);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update profile: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          GestureDetector(
              onTap: _handleSave,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.transparent,
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(alignment: Alignment.center, children: [
              Container(
                width: 200, // Kích thước mới lớn hơn
                height: 200,
                child: ImageUserPicker(
                  onPickImage: (File pickedImage) {
                    _selectedImage = pickedImage;
                  },
                ),
              ),
              IgnorePointer(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 40.0),

                  width: 200, // Kích thước lớn hơn cho icon camera
                  height: 200,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 50,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                      image: DecorationImage(
                        opacity: 0.7,
                        image: widget.avatarEdit != null
                            ? NetworkImage(widget.avatarEdit!)
                            : NetworkImage(
                                'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg'),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            ]),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              child: TextFieldCustom(
                        controller:
                            _nameController != null ? _nameController : null,
                        labelText: 'username',
                        title: 'username',
                        keyboardType: TextInputType.name,
                      ))), // LastName
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30.0),
                    child: TextFieldCustom(
                      controller:
                          _emailController != null ? _emailController : null,
                      title: 'email',
                      readonly: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ), //Email
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: widget.country != null
                        ? TextFieldCustom(
                            controller: _countryController,
                            title: widget.country!,
                            keyboardType: TextInputType.number,
                          )
                        : TextFieldCustom(
                            controller: _countryController,
                            title: 'Country',
                            keyboardType: TextInputType.number,
                          ), //country,
                  ),
                  widget.phoneNumber != null
                      ? TextFieldCustom(
                          controller: _phoneController,
                          title: widget.phoneNumber!,
                          keyboardType: TextInputType.number,
                        )
                      : TextFieldCustom(
                          controller: _phoneController,
                          title: 'Phone Number',
                          keyboardType: TextInputType.number,
                        ) //phone number
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
