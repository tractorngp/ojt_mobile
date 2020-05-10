import 'package:flutter/material.dart';
import 'package:ojt_app/style/style.dart';

class RatingChoiceComponent extends StatefulWidget {
  RatingChoiceComponent({Key key, this.questionText, this.orderNumber, this.options, this.answers, this.q_type, this.status, this.answer_values}) : super(key: key);
  final String questionText;
  final int orderNumber;
  final dynamic options;
  final dynamic answers;
  final dynamic answer_values;
  final String q_type;
  final String status;

  @override
  _RatingChoicePageState createState() => _RatingChoicePageState();
}

class _RatingChoicePageState extends State<RatingChoiceComponent> {
  List<bool> answersMarked = [];
  List<String> answers = [];
  Size screenSize;
  List<dynamic> optionsArr = [];
  int optionsLength;
  bool disabled = false;
  @override
  void initState() {
    super.initState();
    print("***************Init cells Rating****************");
    optionsArr = widget.options;
    optionsLength = widget.options.length;
    disabled = (widget.status != null ? (widget.status == 'completed' ? true : false) : false);
    if(disabled == true){
      populatedSelectedAnswers();
    }
  }

  void _showSnackBar(String text) {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: Container(
          padding: EdgeInsets.all(3.0),
          child: Text(text)
        )));
  }

  populatedSelectedAnswers(){
    for(var i=0;i<optionsArr.length;i++){
      if(widget.answer_values != null && widget.answer_values.length >= 0){
        if(widget.answer_values.indexOf(optionsArr[i]) >= 0){
          setState(() {
            widget.answers[i] = true;
          });
        }
      }
    }
  }

  ListView _buildList(context) {
    return new ListView.builder(
      itemCount: widget.options.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return new  Container(
          padding: EdgeInsets.all(5.0),
          child: InkWell(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if(disabled != null && disabled == false){
                            setState(() {
                            widget.answers[index] = !widget.answers[index];
                            if(widget.q_type == "single"){
                              print("Single choice");
                              if(widget.answers[index] == true){
                                for(var k=0;k<widget.answers.length;k++){
                                  if(k != index){
                                    widget.answers[k] = false;
                                  }
                                }
                              }
                            }
                            else{
                              print("Multiple choice");
                            }
                            
                            print(widget.answers);
                          });
                        }
                        else{
                          print("Disabled");
                          _showSnackBar("This is a completed assessment!");
                        }
                        
                      },
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: transparentColor), color: widget.answers[index] == true ? redThemeColor : Colors.white),
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text(index.toString(), style: widget.answers[index] == true ? textChoiceAnswerStyleWhite : textChoiceAnswerStyle, textAlign: TextAlign.center)
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Container(
                        width: screenSize.width/1.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              child: Text(optionsArr[index] , style: widget.answers[index] == true ? textChoiceAnswerStyle : textChoiceAnswerStyleNormal, maxLines: null),
                              onTap: (){
                                setState(() {
                                  widget.answers[index] = !widget.answers[index];

                                  if(widget.q_type == "single"){
                                    print("Single choice");
                                    if(widget.answers[index] == true){
                                      for(var k=0;k<widget.answers.length;k++){
                                        if(k != index){
                                          widget.answers[k] = false;
                                        }
                                      }
                                    }
                                  }
                                  else{
                                    print("Multiple choice");
                                  }
                                  print(widget.answers);
                                });
                              }
                            )                            
                          ],
                        ),
                      )
                    )
                  ],
                )
              )
          ),
        );
   
      });
    
  }
  
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return  
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0)
        ),
        child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15.0),
                width: screenSize.width * 0.83,
                child: Text(widget.orderNumber.toString()+ ". " + widget.questionText , style: questionStyle, maxLines: null, softWrap: true)
              ),
              Container(
                height: (optionsLength * 80).ceilToDouble(),
                padding: EdgeInsets.only(top: 10.0),
                child: _buildList(context)
              ),
              // (disabled == true) ? Container(
              //   padding: EdgeInsets.only(top: 15.0),
              //   width: screenSize.width * 0.83,
              //   child: Text((widget.answer_values != null && widget.answer_values.length >=0) ? ("Selected answers: " + widget.answer_values.join(", ")) : "" , style: questionStyle, maxLines: null, softWrap: true)
              // ) : Container()
          ],
        )
       
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}