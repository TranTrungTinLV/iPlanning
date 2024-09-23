import 'package:flutter/material.dart';
import 'package:iplanning/widgets/categoriesUI.dart';

class CardCustom extends StatelessWidget {
  const CardCustom({
    super.key,
    required this.RandomImages,
  });

  final List RandomImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.4,
      margin: EdgeInsets.only(right: 10.0),
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: Stack(
          children: [
            Column(
              // mainAxisAlignment:
              //     MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          opacity: 0.8,
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.noRepeat,
                          image: NetworkImage(
                              'http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRvC27D9KlxeEham1w-Wpd_pu3hd4A-OywxRbdnx9JFLpcTD7dfL0bD_WI6Ro8QkzrPLkBMzA9osrMpi4JSP5Y'))),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'International Band Mu...',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Row(
                            children: [
                              for (int i = 0; i < RandomImages.length; i++)
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 0),
                                  child: Align(
                                      widthFactor: 0.5,
                                      child: CircleAvatar(
                                        // radius: 50,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundImage: NetworkImage(
                                            RandomImages[i],
                                          ),
                                        ),
                                      )),
                                ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              '+20 Going',
                              style: TextStyle(
                                  color: Color(0xff3F38DD), fontSize: 15),
                            ),
                          ),
                          SizedBox()
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('36 Guild Street London, UK'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          SizedBox(width: 10),
          CategoriesUI(
            icons: Icons.sports,
            titleCate: 'Sports',
            colour: Colors.red,
            textColour: Colors.white,
            iconColour: Colors.white,
          ),
          CategoriesUI(
            icons: Icons.sports,
            titleCate: 'Sports',
            colour: Colors.orange,
            textColour: Colors.white,
            iconColour: Colors.white,
          ),
          CategoriesUI(
            icons: Icons.sports,
            titleCate: 'Sports',
            colour: Colors.green,
            textColour: Colors.white,
            iconColour: Colors.white,
          ),
          CategoriesUI(
            icons: Icons.sports,
            titleCate: 'Sports',
            colour: Colors.blueAccent,
            textColour: Colors.white,
            iconColour: Colors.white,
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
