import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum ShimmerListTemplate { 
   Movie, 
   Ticket,
   Promo,
   Wallet,
}

class ShimmerList extends StatelessWidget {
  final template;
  final int itemCount;

  ShimmerList(this.template, {this.itemCount: 6});

  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
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
        )
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  final template;

  ShimmerLayout(this.template);

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
      default:
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          width: 200,
          height: 50,
        );
    }    
  }
}