import 'package:flutter/material.dart';
import 'package:ojt_app/style/style.dart';
import 'package:ojt_app/models/ojt_model.dart';
import 'package:date_format/date_format.dart';

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
  String formattedDate;
  var difference;
  void initState() {
    super.initState();
    formattedDate = (widget.card.due_date != null ? "Due on: " + getFormattedDate(widget.card.due_date) : null);
    var date1 = (widget.card.assigned_date != null ? DateTime.parse(widget.card.assigned_date) : null);
    if(date1 != null){
      var date2 = DateTime.now();
      difference = date2.difference(date1).inDays;
    }
   
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child:  new Container(
          height: 100.0,
          width: screenSize.width,
          child: new Stack(
            children: <Widget>[
              customCard
            ],
          ),
        ),
       
    );
  }

  String getFormattedDate(date){
    var dateParsed = DateTime.parse(date);
    var formattedDate = formatDate(dateParsed, [dd, '-', MM , '-', yyyy]).toString();
    return formattedDate;
  }

  Widget get customCard {
    return Container(
      padding: EdgeInsets.only(left: 0.0, right: 0.0),
      width: screenSize.width,
      height: 100.0,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              child:  ListTile(
                title: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(1.0),
                      width: ((screenSize.width * 3)/4) - 30,
                      child: Text.rich(TextSpan(text: widget.card.ojt_name, style: headingTitleBold), maxLines: 2, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,textScaleFactor: 1.2, softWrap: true, textDirection: TextDirection.ltr),
                    ),
                    Container(
                      padding: EdgeInsets.all(1.0),
                      width: ((screenSize.width * 1)/4) - 30,
                      child: Text.rich(TextSpan(text: (difference != null ? (difference.toString() + " days") : ""), style: headingTitleBold), maxLines: 2, textAlign: TextAlign.end, overflow: TextOverflow.ellipsis,textScaleFactor: 1.0, softWrap: true, textDirection: TextDirection.ltr),
                    )
                  ]
                ),
                subtitle: Container(
                  padding: EdgeInsets.all(1.0),
                  width: screenSize.width,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(1.0),
                        alignment: Alignment.bottomLeft,
                        width: ((screenSize.width * 3)/4) - 30,
                        child: Text((formattedDate != null ? formattedDate : ""), style: referenceTextStyleSub, maxLines: 2, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, softWrap: true)
                      ),
                      Container(
                        padding: EdgeInsets.all(1.0),
                        alignment: Alignment.bottomRight,
                        width: ((screenSize.width * 1)/4) - 30,
                        child: Text.rich(TextSpan(text: widget.card.status, style: referenceTextStyleSub), maxLines: 2, textAlign: TextAlign.end, overflow: TextOverflow.ellipsis, softWrap: true, textDirection: TextDirection.rtl),
                      )
                    ],
                  ),
                ),
              )
            ),
            ],
          ),
        ),
      ),
    );
  }

}