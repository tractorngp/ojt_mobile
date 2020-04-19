import 'package:flutter/material.dart';
import 'package:ojt_app/style/style.dart';
import 'package:ojt_app/models/ojt_model.dart';

class AllOJTsCard extends StatefulWidget {
  final OJTsCardModel card;
  AllOJTsCard(this.card);
  
  @override
  AllOJTsCardState createState() {
    return new AllOJTsCardState(card);
  }
}

class AllOJTsCardState extends State<AllOJTsCard> {
  OJTsCardModel card;
  Size screenSize;
  AllOJTsCardState(this.card);
  
  void initState() {
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child:  new Container(
          height: 60.0,
          width: screenSize.width,
          child: new Stack(
            children: <Widget>[
              customCard
            ],
          ),
        ),
       
    );
  }


    Widget get customCard {
    
    return Container(
      padding: EdgeInsets.only(left: 0.0, right: 0.0),
      width: screenSize.width,
      height: 60.0,
      child: Card(
        color: Colors.white,
        elevation: 1.0,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              child: new Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: screenSize.width / 3.5,
                          padding: EdgeInsets.all(5.0),
                          child: Text(widget.card.title, style: headingTitleNormal, softWrap: true, maxLines: 3, textAlign: TextAlign.center)
                        ),
                        Container(
                          width: screenSize.width / 3.5,
                          padding: EdgeInsets.all(5.0),
                          child: Text(widget.card.id, style: referenceTextStyleSub, softWrap: true, maxLines: 3, textAlign: TextAlign.center)
                        ),
                        Container(
                          width: screenSize.width / 3.5,
                          padding: EdgeInsets.all(5.0),
                          child: Text(widget.card.status, style: referenceTextStyleSub, softWrap: true, maxLines: 3, textAlign: TextAlign.center)
                        ),
                      ],
                    )
                  ]
              )
            ),
            ],
          ),
        ),
      ),
    );
  }

}