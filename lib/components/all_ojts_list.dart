import 'package:flutter/material.dart';
import 'package:ojt_app/components/all_ojts_card.dart';
import 'package:ojt_app/models/ojt_model.dart';
import 'package:ojt_app/style/style.dart';
import 'package:flutter/cupertino.dart';

class AllOJTsCardList extends StatelessWidget {
  final List<OJTsCardModel> cards;
  AllOJTsCardList(this.cards);
  BuildContext viewContext;
  ListView _buildList(context) {
    return new ListView.builder(
      itemCount: cards.length,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector( 
              onTap: () {
                print("Here I'm! " + index.toString()) ;
                viewContext = context;
              },
              child: AllOJTsCard(cards[index])
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }
}