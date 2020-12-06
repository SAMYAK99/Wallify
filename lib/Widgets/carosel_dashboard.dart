import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperapp/Widgets/StaggeredGrid.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        CarouselSlider(
          height: 180.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          // autoPlayAnimationDuration: Duration(milliseconds: 1000),
          viewportFraction: 0.8,
          items: [
            Content(
                img: 'assets/homepage/motivation.jpg',
                title: 'Motivation',
                content:
                    'Push yourself, because no one else is going to do it for you',
                tag: 'motivation'),
            Content(
                img: 'assets/homepage/anime.jpg',
                title: 'Anime',
                content: 'Giving up is what kills people',
                tag: 'anime'),
            Content(
                img: 'assets/homepage/art.jpg',
                title: 'Street Art',
                content: 'Am I wasting my time talking to you ? ',
                tag: 'art'),
            Content(
                img: 'assets/homepage/roses.jpg',
                title: 'Roses',
                content: 'My life is part humor, part roses, part thorns',
                tag: 'roses'),
            Content(
                img: 'assets/homepage/concert.jpg',
                title: 'Concert',
                content:
                    'If you told me I could only do one thing, I would choose live concerts',
                tag: 'concert'),
          ],
        ),
      ],
    );
  }
}

class Content extends StatelessWidget {
  String img, title, content, tag;
  Content({this.img, this.title, this.content, this.tag});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CarouselGrid(
                      search: tag,
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(img),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                content,
                style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
