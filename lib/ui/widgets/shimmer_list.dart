import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum ShimmerListTemplate { 
   Movie, 
   Ticket,
   Promo,
   Wallet,
   MovieCard,
   MovieCardPortrait,
}

class ShimmerList extends StatelessWidget {
  final template;
  final int itemCount;

  ShimmerList(this.template, {this.itemCount: 7});

  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          scrollDirection: [ShimmerListTemplate.MovieCard, ShimmerListTemplate.MovieCardPortrait].contains(template) ? Axis.horizontal : Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            offset += 5;
            time = 800 + offset;

            return Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.blueGrey[100],
              child: ShimmerLayout(template, index, itemCount),
              period: Duration(milliseconds: time),
            );
          },
        )
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  final template;
  final int index;
  final int itemCount;

  ShimmerLayout(this.template, this.index, this.itemCount);

  @override
  Widget build(BuildContext context) {

    switch(this.template) {
      case ShimmerListTemplate.Ticket:
      case ShimmerListTemplate.Movie:
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
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 17,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.blueGrey[100],
                      ),
                    ),
                    SizedBox(height: 7),
                    Container(
                      height: 15,
                      width: 230,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.blueGrey[50],
                      ),
                    ),
                    SizedBox(height: 7),
                    template == ShimmerListTemplate.Ticket
                      ? Container(
                          height: 15,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.blueGrey[50],
                          ),
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
      case ShimmerListTemplate.Promo:
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blueGrey[100],
          ),
        );
      case ShimmerListTemplate.Wallet:
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blueGrey[100],
          ),
        );
      case ShimmerListTemplate.MovieCard:
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            margin: EdgeInsets.only(
              left: (index == 0) ? defaultMargin : 0,
              right: (index == itemCount - 1) ? defaultMargin : 15
            ),
            height: 140,
            width: 210,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey[100],
            ),
          )
        );
      case ShimmerListTemplate.MovieCardPortrait:
        return Container(
          child: Container(
            margin: EdgeInsets.only(
              left: (index == 0) ? defaultMargin : 0,
              right: (index == itemCount - 1) ? defaultMargin : 15
            ),
            height: 160,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey[100],
            ),
          )
        );
      default:
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          width: 200,
          height: 50,
        );
    }    
  }
}