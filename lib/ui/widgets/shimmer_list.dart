import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum ShimmerListTemplate { 
   Movie, 
   Ticket,
}

class ShimmerList extends StatelessWidget {
  final template;

  ShimmerList(this.template);

  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;
    int itemCount = 6;

    return SafeArea(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          return Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.blueGrey[100],
            child: ShimmerLayout(template),
            period: Duration(milliseconds: time),
          );
        },
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  final template;

  ShimmerLayout(this.template);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 70,
            height: 90,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blueGrey[100],
              image: DecorationImage(
                image: AssetImage('assets/ic_movie_grey.png'),
                fit: BoxFit.fitWidth
              )
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 17,
                  color: Colors.blueGrey[100],
                ),
                SizedBox(height: 7),
                Container(
                  height: 15,
                  width: 230,
                  color: Colors.blueGrey[50],
                ),
                SizedBox(height: 7),
                template == ShimmerListTemplate.Ticket
                  ? Container(
                      height: 15,
                      width: 200,
                      color: Colors.blueGrey[50],
                    )
                  : RatingStars(
                      voteAverage: 5,
                      color: Colors.blueGrey[50],
                    )
              ],
            )
          )          
        ],
      ),
    );
  }
}