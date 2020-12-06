import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperapp/Widgets/grid.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Map<String, String>> popular = [
    {'img': 'assets/dashboard/sports.jpg', "name": 'Sports', "key": 'sports'},
    {
      'img': 'assets/dashboard/wildlife.jpg',
      "name": 'Wildlife',
      "key": 'wildlife'
    },
    {
      'img': 'assets/dashboard/bicycle.jpg',
      "name": 'Bicycle',
      "key": 'bicycle'
    },
    {'img': 'assets/dashboard/cars.jpg', "name": 'Cars', "key": 'car'},
    {
      'img': 'assets/dashboard/holiday.jpg',
      "name": 'Holiday',
      "key": 'holiday'
    },
    {'img': 'assets/dashboard/music.jpg', "name": 'Music', "key": 'music'},
    {'img': 'assets/dashboard/nature.jpg', "name": 'Nature', "key": 'nature'},
    {'img': 'assets/dashboard/city.jpeg', "name": 'City', "key": 'city'},
    {'img': 'assets/dashboard/neon.jpg', "name": 'Neon', "key": 'neon'},
    {'img': 'assets/dashboard/planes.jpg', "name": 'Planes', "key": 'planes'},
    {'img': 'assets/dashboard/rain.jpg', "name": 'Rain', "key": 'rain'},
    {'img': 'assets/dashboard/code.jpg', "name": 'Coding', "key": 'coding'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Categories',
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w700, fontSize: 24),
                ),
                SizedBox(
                  height: 16,
                ),
                StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  crossAxisCount: 4,
                  itemCount: popular.length,
                  itemBuilder: (BuildContext context, int index) =>
                      StagCategory(
                          img: popular[index]['img'],
                          name: popular[index]['name'],
                          value: popular[index]['key']),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class StagCategory extends StatelessWidget {
  final String img, name, value;

  StagCategory({@required this.img, @required this.name, @required this.value});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GridPage(
                      search: value,
                      heading: name,
                    )));
      },
      child: Container(
        child: Stack(
          children: [
            ClipRRect(
              child: Image.asset(img),
              borderRadius: BorderRadius.circular(10),
            ),
            Positioned(
              bottom: 5,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
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
