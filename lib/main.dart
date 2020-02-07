import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main() => runApp(MyApp());



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TipsterTuyo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseMessaging _firebaseMessaging=new FirebaseMessaging();





  @override
  void initState() {
    // TODO: implement initState

    super.initState();






    _firebaseMessaging.configure(
      onResume: (Map<String,dynamic> message) {
        print(message);
      },
      onMessage: (Map<String,dynamic> message) {
        print(message);
        },
      onLaunch: (Map<String,dynamic> message) {
        print(message);
      }

      );
    _firebaseMessaging.getToken().then((token){
      print("token"+token);
      Firestore.instance.collection("tokens").document(token).setData({"token":token}).then((onValue)=>{
          print("successfully aded")
      }).catchError((onError)=>{
          print("error in adding token")
      });
    });

  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(

          title:Center(
            child:Row(
              children: <Widget>[
                new MyExploreWidget1(),
                Expanded(
                    child:Center(child:Text.rich(TextSpan(text: "Kazanmayan Kalmasın!!",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.white))))
                ),
                new MyExploreWidget1()
              ],
            )
          ),



          backgroundColor: Color.fromARGB(250,11,14,48)
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(image: new AssetImage("assets/wallpaper.jpg"),fit: BoxFit.cover)
        ),
        child:Center(
          child: _buildBody(context),
        ) ,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // TODO: get actual snapshot from Cloud Firestore

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tuyolar').orderBy("timestamp",descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
//    final record1 = Tips.fromSnapshot(data);
    final record= TipsFormatted(data);



    return Padding(
      key: ValueKey(record.evsahibi),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image:  new DecorationImage(image: new AssetImage("assets/back.jpg"),fit: BoxFit.cover)

        ),
        child: ListTile(
          leading: new MyExploreWidget(),
          title: Padding(
              padding:EdgeInsets.only(top: 2.0,bottom: 2.0),
              child: Container(
                child: Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text.rich(TextSpan(text: record.evsahibi+"-"+record.deplasman,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)))
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.yellow[700]
                ),

              ),
          ),
          trailing: Container(
            width: 50.0,
            height: 50.0,
            child: Center(
              child: Text.rich(TextSpan(
                text: record.oran,style: TextStyle(color: Colors.white,fontSize: 16)
              )),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255,	12, 92, 31),
              shape: BoxShape.circle,
              

            ),

          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text.rich(TextSpan(text: record.tuyo,style: TextStyle(color: Colors.white))),
                ),
                decoration:BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(5.0),
                ),

              ),

              Container(
                  child: Text.rich(TextSpan(text: record.mac_tarihi+" - "+record.mac_saati,style: TextStyle(color: Color.fromARGB(200, 255,183,73),fontStyle: FontStyle.italic)))

              )
            ],
          ),

          onTap: () => print(record),
        ),
        
      ),
    );
  }
}

class MyExploreWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var assetImage=new AssetImage('assets/ballDark.png');
    var image=new Image(image: assetImage,width: 45.0,height: 45.0);

    return new Container(child: image);
  }
}
class MyExploreWidget1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var assetImage=new AssetImage('assets/appbar_icon.png');
    var image=new Image(image: assetImage,width: 30.0,height: 30.0);

    return new Container(child: image);
  }
}


class Tips{
  final String evsahibi;
  final String deplasman;
  final String tuyo;
  final String oran;
  final String mac_saati;
  final String mac_tarihi;
  final DocumentReference reference;


  Tips.fromMap(Map<String, dynamic> map, {this.reference})
      :
        assert(map['evsahibi'] != null),
        assert(map['deplasman'] != null),
        assert(map['tuyo'] != null),
        assert(map['oran'] != null),
        assert(map['mac_saati'] != null),
        assert(map['mac_tarihi'] != null),



        evsahibi = map['evsahibi'],
        deplasman = map['deplasman'],
        tuyo = map['tuyo'],
        oran = map['oran'],
        mac_saati = map['mac_saati'],
        mac_tarihi = map['mac_tarihi'];


  Tips.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Tips<$evsahibi:$deplasman:$tuyo:$oran:$mac_saati$mac_tarihi>";


}

//    if(map["evsahibi"]==null || map["deplasman"]==null || map["tuyo"]==null || map["oran"]==null || map["mac_saati"]==null || map["mac_tarihi"]==null){
//
//    }else{
//      evsahibi = map['evsahibi'];
//      deplasman = map['deplasman'];
//      tuyo = map['tuyo'];
//      oran = map['oran'];
//      mac_saati = map['mac_saati'];
//      mac_tarihi = map['mac_tarihi'];
//    }
//
class TipsFormatted{
  String evsahibi;
  String deplasman;
  String tuyo;
  String oran;
  String mac_saati;
  String mac_tarihi;
  DocumentReference reference;
  Map<String, dynamic> map;

  TipsFormatted(DocumentSnapshot snapshot){
    this.map=snapshot.data;
    if(map["evsahibi"]==null){
      evsahibi="*";
    }else{
      evsahibi=map["evsahibi"];
    }

    if(map["deplasman"]==null){
      deplasman="*";
    }else{
      deplasman=map["deplasman"];
    }
    if(map["tuyo"]==null){
      tuyo="*";
    }else{
      tuyo=map["tuyo"];
    }
    if(map["oran"]==null){
      oran="*";
    }else{
      oran=map["oran"];
    }
    if(map["mac_saati"]==null){
      mac_saati="*";
    }else{
      mac_saati=map["mac_saati"];
    }
    if(map["mac_tarihi"]==null){
      mac_tarihi="*";
    }else{
      mac_tarihi=map["mac_tarihi"];
    }

//    evsahibi=map["evsahibi"];
//    deplasman=map["deplasman"];
//    tuyo=map["tuyo"];
//    oran=map["oran"];
//    mac_saati=map["mac_saati"];
//    mac_tarihi=map["mac_tarihi"];

  }
}
