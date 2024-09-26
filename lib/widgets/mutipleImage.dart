import 'package:flutter/material.dart';
import 'package:iplanning/widgets/singleImageEvent.dart';

class MutipleImage extends StatelessWidget {
  const MutipleImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 10),
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SingleImageEvents(),
                  SingleImageEvents(),
                  SingleImageEvents(),
                  GestureDetector(
                    onTap: () {
                      print('add images');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height,
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.orange,
                        weight: 200,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
