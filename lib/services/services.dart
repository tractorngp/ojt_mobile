import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:ojt_app/services/constants.dart' as Constants;

class RestDatasource {
  final Firestore firestore = Firestore.instance;
  HttpsCallable callable;

  Future<DocumentSnapshot> login(String userid, String password) async {
    DocumentReference documentReference = Firestore.instance.collection("users").document(userid);
    DocumentSnapshot docsnap = await documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        print(datasnapshot.data['name'].toString());
        return datasnapshot;
      }
      else{
        return null;
      }
    });
    return docsnap;
  }

  Future<DocumentReference> getDocumentReference(String collection, String docID) async{
    return Firestore.instance.collection(collection).document(docID);
  }

  Future<dynamic> fetchOJTsCount(String user) async{
    callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'callNumberOfOJTs')
          ..timeout = const Duration(seconds: 30);

    try {
        dynamic result = await callable.call(
          <String, dynamic>{
            'user': user,
          }
        );
        return result;
    } on CloudFunctionsException catch (e) {
        print('caught firebase functions exception');
        print(e.code);
        print(e.message);
        print(e.details);
        return e;
    } catch (e) {
        print('caught generic exception');
        print(e);
        return e;
    }
  }

  Future<dynamic> fetchOJTsData(String tokenId, DocumentSnapshot _lastDocument, String status) async{
    var userRef = firestore.collection('users').document(tokenId);
    var returnData;
    if(status != null){
        if(_lastDocument != null){
          returnData = await firestore.collection('assigned_ojts')
              .where('active', isEqualTo: true)
              .where("assigned_to", isEqualTo: userRef)
              .where("status", isEqualTo: "assigned")
              .orderBy('record_id',descending: false)
              .startAfterDocument(_lastDocument).limit(Constants.nor).getDocuments().then((data) {
                return data;
              }, onError: ((err){
                  print(err);
                return err;
          }));  
        }
        else{
          returnData = await firestore.collection('assigned_ojts')
          .where('active', isEqualTo: true)
          .where("assigned_to", isEqualTo: userRef)
          .where("status", isEqualTo: "assigned")
          .orderBy('record_id',descending: false).limit(Constants.nor).getDocuments().then((data) {
            return data;
          }, onError: ((err){
                  print(err);
                return err;
          }));
        }
    }
    else{
      if(_lastDocument != null){
        returnData = await firestore.collection('assigned_ojts')
            .where('active', isEqualTo: true)
            .where("assigned_to", isEqualTo: userRef)
            .orderBy('record_id',descending: false)
            .startAfterDocument(_lastDocument).limit(Constants.nor).getDocuments().then((data) {
              return data;
            }, onError: ((err){
                print(err);
              return err;
        }));  
      }
      else{
        returnData = await firestore.collection('assigned_ojts')
        .where('active', isEqualTo: true)
        .where("assigned_to", isEqualTo: userRef)
        .orderBy('record_id',descending: false).limit(Constants.nor).getDocuments().then((data) {
          return data;
        }, onError: ((err){
                print(err);
              return err;
        }));
      }
    }
    
    return returnData;
  }

}