import 'package:flutter/material.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          GestureDetector(
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
            GestureDetector(
              onTap: () {
                print('change image');
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 40.0),
                width: 150,
                height: 150,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                    image: DecorationImage(
                      opacity: 0.7,
                      image: NetworkImage(
                          'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg'),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              child: TextFieldCustom(
                        title: 'First Name',
                      ))), //first Name
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Container(
                              child: TextFieldCustom(
                        title: 'Last Name',
                        keyboardType: TextInputType.name,
                      ))), // LastName
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30.0),
                    child: TextFieldCustom(
                      title: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ), //Email
                  Container(
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: TextFieldCustom(
                      title: 'Country',
                      keyboardType: TextInputType.name,
                    ),
                  ), //country
                  TextFieldCustom(
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
