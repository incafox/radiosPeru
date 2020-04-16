import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
//import 'package:flutter_radio/flutter_radio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:android_intent/android_intent.dart';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radio_peru_fixed/regiones.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:radio_peru_fixed/favoritos.dart';
import 'package:radio_peru_fixed/busqueda.dart';
//import 'package:flutter_admob/flutter_admob.dart';
import 'package:admob_flutter/admob_flutter.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
//import 'package:admob_flutter/admob_flutter.dart';
const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';
String urlpapa;//= await urlF();
//void main() => runApp(MyApp());
void main() async{

  //Dj dijey = Dj();
  //await dijey.getRadios();
  Admob.initialize('ca-app-pub-4537282655890052~3650132832');
  //runApp(MyApp2());
  runApp(new MaterialApp(
    home: new MyApp2(),
  ));
  Dj dijey = Dj();
  await dijey.getRadios();
}

Future<String> urlF() async {
  String url = "asdas";
  url =await Firestore.instance.collection('radios').document('radiosPeru').snapshots().first.then((data){return data.data.toString();});// .then((data) {
  return url;
}

class MyApp2 extends StatefulWidget {
  @override
  _MyAppState2 createState() => new _MyAppState2();
}

class _MyAppState2 extends State<MyApp2> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new MyApp(),
        title: new Text("Radios Peru Stereo\n By Twelve Angles",textAlign: TextAlign.center,
          style: new TextStyle(color: Colors.yellowAccent,//fontStyle: FontStyle.italic,
              fontWeight: FontWeight.normal,
              fontSize: 33.0
          ),),
        image: new Image.network('http://circuloagorameraki.com/wp-content/uploads/2018/06/sol.png'),
        backgroundColor: Colors.redAccent,
        styleTextUnderTheLoader: new TextStyle(fontSize: 20),
        photoSize: 150.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.yellow
    );
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //urlpapa = await urlF();
  @override
  Widget build(BuildContext context) {
//Color.fromRGBO(60, 50, 182, 0.9)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarColor: Colors.redAccent,systemNavigationBarIconBrightness: Brightness.light,statusBarBrightness: Brightness.dark,statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: 'Radios Peru Stereo',
      theme: ThemeData(splashColor: Colors.redAccent,hintColor: Colors.transparent,backgroundColor: Colors.black,primaryColor: Colors.redAccent
      ),
      //home: MyHomePage(title: 'Hola mama'),
      home: DefaultTabController(
        length: 3,
        child: FirtsScreen(),
      ),
    );
  }

  Future<String> urlF() async {
    String url = "asdas";
    url =await Firestore.instance.collection('radios').document('radiosPeru').snapshots().first.then((data){return data.data.toString();});// .then((data) {
    return url;
  }
}

class RadioData{
  String name = "";
  String link = "";
  String sourceStream = "";
  String imageSrc = "";
  RadioData(String namex, String linkx, String sourcex, String imagex)
  {
    this.name = namex;
    this.link = linkx;
    this.sourceStream = sourcex;
    this.imageSrc = imagex;
  }
  setData(String namex, String linkx, String sourcex, String imagex)
  {
    this.name = namex;
    this.link = linkx;
    this.sourceStream = sourcex;
    this.imageSrc = imagex;
  }
}
//CLASE SINGLETON PARA EL CONTROL DE
//LA ACTUAL MUSICA QUE SE ESTA TOCANDO
class Dj {
  RadioData actualRadio; //para almacenar los datos de reproduccion actuales
  bool showPlayBar = false;
  String audioSrcLink = '';
  String imageSrcLink = '';
  bool srcAvailable = false;
  bool isPlaying = false;
  List<String> radiosDisponiblesNombres = new List();
  List<RadioData> radiosDisponibles = new List();
  List<Expanded> radiosCards = new List();
  bool obtencionDeDatosTerminado = false;
  String playingThisRadio = "";
  //var cassete = FlutterRadio();
  //fin de streming con webview
  static final Dj _dj = new Dj._internal();
  factory Dj() {
    return _dj;
  }
  Dj._internal();
  //Dj.

  Future<void> audioStart() async {
    //await FlutterRadio.audioStart();
    print('Audio Start OK');
  }
  setLink(String linkAudio) {
    this.audioSrcLink = linkAudio;
    this.srcAvailable = true;
  }
  playUrl(String link) async{
    //FlutterRadio.play(url: link);
    //this.cassete.
  }
  pause() async {
    //FlutterRadio.pause();
  }
  /*
  Stream<bool> countStream() async* {
    yield this.obtencionDeDatosTerminado ;
  }*/

  //funcion construye una lista de class:radiosData
  //que son las radios disponibles


  Future<List<RadioData>> getAvailableRadios() async
  {
    List<RadioData> listaDeRadios = new List();
    /*
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    final defaults = <String, dynamic>{'radios2': 'default welcome'};
    await remoteConfig.setDefaults(defaults);
    List<RadioData> listaDeRadios = new List();
    await remoteConfig.fetch(expiration: const Duration(days: 1005));
    await remoteConfig.activateFetched();
    print('radios xd: ' + remoteConfig.getString('radios2'));
    String lol = remoteConfig.getString('radios2');
    */

    //lol = lol.substring(1,lol.length-1);
    //List<String> pol=lol.split("},");
    //print (pol[0].toString());
/*
    for (int i =0;i<pol.length;i++)
    {
      //print (pol[i].toString());
      List<String> temp = pol[i].split(":{");
      String nombre = temp[0].substring(1,temp[0].length-1);
      List<String> temp2   = temp[1].split(",");
      String link = temp2[0].substring(temp2[0].indexOf("http"));
      link = link.substring(0,link.length-1);
      String source = temp2[1].substring(temp2[0].indexOf("http"));
      if (source.length>1) {
        source = source.substring(2, source.length);
        source = source.substring(0,source.indexOf('"'));
      }
      print ('nombre > ' + nombre);
      print ('link   > ' + link );
      print ('source > ' + source);
      RadioData radioTemp = RadioData(nombre, link, source);
      //radioTemp.setData(nombre, link, source);
      //print (radioTemp.toString());
      //listaDeRadios.add(new RadioData(nombre, link, source));
      listaDeRadios.add(radioTemp);
      //for (final x in this.radiosDisponibles){
      //this.radiosCards.add(new Expanded(child: new CartaRadio(radioTemp)));
      //}
    }
    print ("SIZE : " + pol.length.toString());
    return listaDeRadios;
    */
    /*
    Firestore.instance.collection('radios').document('radiosPeru').snapshots().listen(
            (data)=>
            print(data.data)
    );*/



    //DocumentSnapshot lol = Firestore.instance.collection('radios').document('radiosPeru').snapshots();
    //print(lol["link"]);
    //print(lol);
    //final CollectionReference database = Firestore.instance.collection("radios");
    //database.document("radiosPeru").snapshots().
    //itemRefShop = database.reference().child('Shop');
    //final response = await http.get('https://api.myjson.com/bins/1g1g6c');  //ultimo domingo
//    final response = await http.get('https://api.myjson.com/bins/13of9u'); //last confiermed
    final response = await http.get('https://twelveangles.page.link/Radios'); //last confiermed

    //print("[GET DATA] " + urlpapa);
    //final response = await http.get(urlpapa);
    var decoded = ((json.decode(response.body)));
    print (decoded);
    String de = decoded.toString();
    de = de.substring(1,de.length-1);
    print (de);
    List<String>ded= de.split("},");
    print (ded);
    for (int i = 0; i<ded.length; i++) {
      //print(ded[i]);
      List<String> temp = ded[i].split("{link: ");
      List<String> temp2 = temp[1].split("source: ");
      String name = temp[0];
      String link = temp2[0].replaceAll(" ", "");
      String source = temp2[1].replaceAll(" ", "");
      //print ("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
      String tem = "image: ";
      int temp3 = temp2[1].indexOf(tem) + tem.length;
      String imageSrc = temp2[1].substring(temp3);
      //print (imageSrc);
      source = source.substring(0,source.indexOf("image")-1);
      print ("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
      print("*[name] : " + name  );
      print("*[link] : " + link);
      print("*[source] : " + source);
      print("*[image] : " + imageSrc);

      RadioData radioTemp = RadioData(name, link, source, imageSrc);
      this.radiosDisponiblesNombres.add(name);
      listaDeRadios.add(radioTemp);
    }
    return listaDeRadios;
  }
  void getRadios() async{
    this.radiosDisponibles = await this.getAvailableRadios();

    print ("tmr" + this.radiosDisponibles.toString());
    print ("tmr" + this.radiosDisponibles.length.toString());
    this.obtencionDeDatosTerminado = true;
    //print (this.obtencionDeDatosTerminado);

  }

}

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MyAppbar({this.title});
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.amber,
      height: preferredSize.height,
      child: new Center(
        child: new Text(title),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(770.0);
}

class FirtsScreen extends StatefulWidget {
  static _FirtsScreenState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_FirtsScreenState>());
  //@override
  _FirtsScreenState createState() => _FirtsScreenState();
}

//final firtsScreenKey = new GlobalKey<_FirtsScreenState>();
class _FirtsScreenState extends State<FirtsScreen> {
  Cartas menuCartas = new Cartas();
  AdmobInterstitial interstitialAd = AdmobInterstitial(
    //adUnitId: 'ca-app-pub-3940256099942544/1033173712',
    adUnitId: 'ca-app-pub-4537282655890052/1128513918',
  );
  //bool favoritoPresionado = false;
  String _actual_src = '';
  String _actual_img = '';
  Icon icono = Icon(Icons.play_arrow,size: 60,);
  Icon icono_no_favorito = Icon(Icons.favorite_border,size: 28,);
  Icon icono_favorito = Icon(Icons.favorite,size: 28,);
  Icon icono_actual = Icon(Icons.favorite_border,size: 28,);
  static const platform = const MethodChannel("player.pe");
  bool toggle=false;
  bool visiblePlayBar = false;
  String actualRadio = "";
  StreamController<int> _controllerPageIndex = StreamController<int>();
  int pagina = 0;
  Dj dijey = Dj(); //para reproduccion
  //List<RadioData> radiosDisponibles = new List();
  PageController pageController = PageController(initialPage: 0,);
  final _nativeAdmob = NativeAdmob();
  //GlobalKey<FormFieldState<String>> firstNameKey = new GlobalKey<FormFieldState<String>>();

  //static const platform = const MethodChannel("player.pe");
  //webview
  //FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();

  //CustomTabBar miTabBar ;
  /*= CustomTabBar(
  pageControllerx: pageController,
  pageNamesx: pages.keys.toList(),
  );*/

  void update_player(CartaAds cartita) {
    _actual_src = cartita.get_audioSrc();
  }

  void makePlayBarVisible()
  {
    interstitialAd.load();
    //if (interstitialAd.isLoaded) {
      interstitialAd.show();
    //}
    setState(() {
      this.visiblePlayBar = true;
      this.actualRadio = this.dijey.playingThisRadio;
      this.icono = Icon(Icons.stop,size: 40,);
    });
  }

  void play ()
  {
    //dijey.play();
    this.toggle = !this.toggle;
    if(!this.toggle){
      //this.icono =new Icon(Icons.pause,size: 40,);
      //FlutterRadio.play(url: this.dijey.audioSrcLink);
    }
    else{
      //this.icono =new Icon(Icons.play_arrow,size: 40,);
      //this.dijey.pause();
    }
    print (toggle);
  }
  Future<void> stopRadio()async {
    print("[METHOD CHANNEL] stopRadio");
    await platform.invokeMethod("stop");
}
  Future<void> playAgain()async {
    print("[METHOD CHANNEL] stopRadio");
    //await platform.invokeMethod("stop");
    var sendMap = <String, dynamic> {
      'url': this.dijey.actualRadio.sourceStream
    };
    await platform.invokeMethod("play", sendMap);
  }

  void _playPressed()
  {
    this.stopRadio();
    setState(() {
      this.dijey.isPlaying = !this.dijey.isPlaying;
      if (this.dijey.isPlaying){
        this.icono = Icon(Icons.stop,size: 40,);
        this.playAgain();
      }
      else
      {
        this.icono = Icon(Icons.play_arrow,size: 40,);
      }


    });
  }

  void update(){
    _nativeAdmob.initialize(appID: "ca-app-pub-4537282655890052~3650132832");
    setState(() {
      //this.pageController.jumpToPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    //this.dijey.audioStart();
    //print("iniciando app ...");
    final Map<String, Widget> pages = <String, Widget>{
      'RADIOS   ': new Center(
        child: new Text('My Music not implemented'),
      ),
      'FAVORITOS': new Center(
        child: new MenuFavoritos(),
      ),
      'BUSQUEDA ' : new Center(
    child:Column(children: <Widget>[
      AppBar(backgroundColor: Colors.transparent,title: Container(color: Colors.transparent,width: 400,child: CustomSearchField(),),),
    new MenuBusqueda()
    ],) ,//'BUSQUEDA': new MenuBusqueda(),
      )
      //'Feed': new Feed(),
    };
    /*
    final CustomTabBar  miTabBar = CustomTabBar(
      pageControllerx: pageController,
      pageNamesx: pages.keys.toList(),
    );
*/
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    //this.pageController.initialPage = 0;
    //this.dijey.getRadios();
    //print ("datos : " + this.dijey.radiosDisponibles.length.toString());
    //print (this.dijey.radiosDisponibles[4].name);
    return Scaffold(
        appBar: AppBar(centerTitle: true,leading: MaterialButton(onPressed: (){
          print("asda");
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            //return MenuBusqueda();
            //pageController.animateToPage(2, duration: Duration(milliseconds: 400),curve: SawTooth(20)); //=FirtsScreen.of(context).icono_favorito;
            //FirtsScreen.of(context).gotoBusqueda();
            //return ShowCapScreen();
          }));
          },
          ),//child: Icon(Icons.search,color: Colors.white,size:33,)   ,) ,
          actions: <Widget>[MaterialButton(onPressed: (){print("asda");}, child: Icon(Icons.share,color: Colors.white,size: 30,),height: 20,)],
          title: Container(width: 300,height: 155 ,child: Text("Radios Peru Stereo",style: TextStyle(fontFamily: 'Raleway',fontSize: 20),textAlign: TextAlign.center,)) ,
          flexibleSpace: Container(height: 30,),
          //backgroundColor: Colors.transparent,
          elevation: 10,
          bottom: CustomTabBar(stream: this._controllerPageIndex.stream,
            pageControllerx: pageController,
            pageNamesx: pages.keys.toList(),
          )
          /*
          CustomTabBar(
            pageControllerx: pageController,
            pageNamesx: pages.keys.toList(),
          )*/
          ,
               /***
              TabBar(indicatorColor: Colors.amber,
                tabs: <Widget>[
                  Container(
                    height: 30,
                    child: Text("MIX",style: TextStyle(fontStyle:  FontStyle.italic),),
                  ),
                  Container(
                    height: 30,
                    child: Text("REGION"),
                  ),
                  //BottomNavigationBar(
                  //),
                ],
              ),*/

        ),
        //drawer: Drawer(elevation: 30,),,
        /*
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton:
        Visibility(visible: this.visiblePlayBar,child:
        Container(height: 80,width: 80,child:
          FloatingActionButton(
            onPressed: () {this._playPressed();},
            tooltip: 'Increment',
            child: this.icono,
            elevation: 8.0,
            backgroundColor: Colors.indigo,
          ),
        ),
        ),
        */
        body:
          PageView(onPageChanged: (pag)async {
              this._controllerPageIndex.add(pag);
              print("[PAGINA]   " +pag.toString());
              //Scaffold.of(context).
              //CustomTabBar.of(context).setState((){print ("[CTM MIERDA]");});
              //miTabBar.createState() // => _CustomTabBarState(controller: pageControllerx,nombres: pageNamesx); ;
            },
            controller: this.pageController,
            children:
            <Widget>[
              //pages.values.toList()
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        const Color.fromARGB(255, 87, 97, 249),
                        const Color.fromARGB(255, 253, 72, 72),
                      ],
                      stops: [0.0, 1.0],
                    )),
                //color: Colors.amberAccent,
                child: this.menuCartas),
                Container(
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 87, 97, 249),
                      const Color.fromARGB(255, 253, 72, 72),
                    ],
                    stops: [0.0, 1.0],
                  )),
                  child: MenuFavoritos(),
                  //color: Colors.amberAccent,
                ),

              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        const Color.fromARGB(255, 87, 97, 249),
                        const Color.fromARGB(255, 253, 72, 72),
                      ],
                      stops: [0.0, 1.0],
                    )),
                //color: Colors.amberAccent,
                child: Column(children: <Widget>[
                  AppBar(title: Container(width: 400,child: CustomSearchField(),),),
                  Expanded(child:  Container(child: MenuBusqueda()),)
                ],),
              ),


            ],
          ),

        //Visibility(visible: false,maintainSize: false,child:
        bottomNavigationBar:
                Visibility(maintainState: false,visible:this.visiblePlayBar,maintainSize: false,child:
        Theme(data: Theme.of(context).copyWith(
          //canvasColor: Color.fromARGB(225, 97, 87, 229),
          primaryColor: Colors.transparent,
        ),
            child:  Container(color: Colors.transparent,
              height: 134, //130
              child:
              Column(
                children: <Widget>[
                  //Expanded(
                    //  child:
                      Container(height: 67,decoration: BoxDecoration(color: Colors.red ,// .fromARGB(225, 17, 47, 229),
                        borderRadius: BorderRadius.all(Radius.circular(0)),),
                        child: Row(children: <Widget>[

                          //Material(child: Ink.image(image: Image.network("https://www.scmobiliario.com/wp-content/uploads/2017/05/Icono-Telefono.png") )),
                          //RaisedButton(onPressed: () {this._setFavorite();},color: Colors.red,child: Icon(Icons.access_time,size: 30,color: Colors.white,) ,animationDuration: Duration(milliseconds: 100),),
                          Container(padding:EdgeInsets.fromLTRB(5, 2, 3, 2),width: 65,child:
                          FloatingActionButton(heroTag: "btn1",highlightElevation: 20,
                            onPressed: () {this._setFavorite();},
                            tooltip: 'Increment',
                            child: this.icono_actual,
                            elevation: 8.0,
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          )
                            ,),
                          /*
                          Container(padding: EdgeInsets.fromLTRB(5, 2, 2, 2),width: 65,child:
                          FloatingActionButton(heroTag: "btn2",
                            onPressed: () {print("dadsad");},
                            tooltip: 'Increment',
                            child: Icon(Icons.share,size: 28,),
                            elevation: 8.0,
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          )
                            ,),

                          */
                          Expanded(child:
                          Container(padding: EdgeInsets.fromLTRB(5, 2, 2, 2),child:
                          FloatingActionButton(heroTag: "btn3",foregroundColor: Colors.redAccent,
                            onPressed: () {print("dada");},
                            tooltip: 'Increment',
                            child: Text("Reproduciendo \n" + this.actualRadio.replaceAll(":", ""),style: TextStyle(fontSize: 15,color: Colors.white),textAlign: TextAlign.center,),
                            elevation: 8.0,
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          ),

                          ),
                              ),
                          Container(padding: EdgeInsets.fromLTRB(5, 2, 2, 2),height: 65,width: 65,child:
                          FloatingActionButton(heroTag: "btn4",
                            onPressed: () {this._playPressed();},
                            tooltip: 'Increment',
                            child: this.icono,
                            elevation: 8.0,
                            backgroundColor: Colors.black,
                          ),
                          ),

                          /*
                          Container(padding:EdgeInsets.fromLTRB(5, 2, 2, 2),width: 65,child:
                          FloatingActionButton(heroTag: "btn5",highlightElevation: 20,
                            onPressed: () {print("dada");},
                            tooltip: 'Increment',
                            child: Icon(Icons.volume_mute , size: 28,color: Colors.white,),
                            elevation: 8.0,
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          )
                            ,),
                          */

                          //Text(" Reproduciendo \n" + this.actualRadio,style: TextStyle(fontSize: 18,color: Colors.white),textAlign: TextAlign.left,),
                          //Text( this.actualRadio,textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Colors.white),),
                          /*
                          Container(child: Column(children: <Widget>[
                            Text("    Reproduciendo:",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,),
                            Text( this.actualRadio,textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Colors.white),)
                          ],),)
                          */
                        ]
                          ,),
                        //  child: Card(),
                      ),
                      //Expanded(child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),)),

                    /*
                  Expanded(
                      child: BottomNavigationBar(
                        //onTap: ,
                        //currentIndex: 0,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(backgroundColor: Colors.white,
                              icon: Icon(Icons.search), title: Text('Buscar')),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.bookmark_border, color: Colors.white,), title: Text('Favoritos',style: TextStyle(color: Colors.white),)),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.settings, color: Colors.white  ,), title: Text('Preferencias',style: TextStyle(color: Colors.white),)),
                        ],
                      )

                  )

                  */
                      Expanded( child: Container(color: Colors.black, height:67,child:
                      AdmobBanner(
                        //adUnitId: 'ca-app-pub-3940256099942544/6300978111',
                        adUnitId: 'ca-app-pub-4537282655890052/6217242964',
                        adSize: AdmobBannerSize.BANNER,
                      )



                        ,)),
                ],
              ),


            ))
                )
        //Theme(data: Theme.of().co, child: null)

      /**
          BottomNavigationBar(
          onTap: (int index){
          print (index);
          if (index==0){this._playPressed();}
          if (index==1){
          print ("agregado a favoritos");
          }
          },
          //fixedColor: Colors.grey,
          //currentIndex: 0,
          items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
          icon: this.icono, title: Text("")),
          BottomNavigationBarItem(
          icon: Icon(Icons.star_border,color: Colors.white,size: 35,), title: Text('',style: TextStyle(color: Colors.white),)),
          ],
          )

       */

      /**
      Container(color: Colors.deepPurpleAccent,
          height: 115,
          child: Column(
            children: <Widget>[
              Expanded(
                  child:
                  BottomNavigationBar(
                    onTap: (int index){
                      print (index);
                      if (index==0){this._playPressed();}
                      if (index==1){
                        print ("agregado a favoritos");
                      }
                    },
                    //fixedColor: Colors.grey,
                    //currentIndex: 0,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: this.icono, title: Text('PLAY'),backgroundColor: Colors.teal),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.stars), title: Text('Aniadir a favs')),

                    ],
                  )
              ),
              Expanded(
                  child: BottomNavigationBar(
                    //onTap: ,
                    //currentIndex: 0,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(backgroundColor: Colors.transparent,
                          icon: Icon(Icons.radio), title: Text('Emisoras')),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.bookmark_border,), title: Text('Favoritos')),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.dashboard), title: Text('Preferencias')),
                    ],
                  ))
            ],
          ),
        )
        */
    );
  }

  void _setFavorite()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //print("FAVORITO");
    //_incrementCounter() async {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //int counter = (prefs.getInt('counter') ?? 0) + 1;
      //List<String> datos = [this.dijey.actualRadio.name,this.dijey.actualRadio.imageSrc,this.dijey.actualRadio.sourceStream];
      //print('Pressed $counter times.');
      //await prefs.setStringList(this.dijey.actualRadio.name, datos);


      List<String> favs = prefs.getKeys().toList();
    if (!favs.contains(this.dijey.actualRadio.name)){
      //print("[FAVORITO ]  NO ES FAVORITO");
    setState(() {
      this.icono_actual =this.icono_favorito;
      //List<String> favs = prefs.getKeys().toList();
    });
    List<String> datos = [this.dijey.actualRadio.name,this.dijey.actualRadio.imageSrc,this.dijey.actualRadio.sourceStream];
    //print('Pressed $counter times.');
    await prefs.setStringList(this.dijey.actualRadio.name, datos);
    }
    else{
      //print("[FAVORITO ]  ES FAVORITO");
      setState(() {
        this.icono_actual =this.icono_no_favorito;
        //List<String> favs = prefs.getKeys().toList();
      });
      //List<String> datos = [this.dijey.actualRadio.name,this.dijey.actualRadio.imageSrc,this.dijey.actualRadio.sourceStream];
      //print('Pressed $counter times.');
      //await prefs.setStringList(this.dijey.actualRadio.name, datos);
      await prefs.remove(this.dijey.actualRadio.name);
    }
  }

  void _unsetFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(this.dijey.actualRadio.name);  //setStringList(this.dijey.actualRadio.name, datos);
  }
}

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget{
  static _CustomTabBarState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_CustomTabBarState>());
  //static _FirtsScreenState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_FirtsScreenState>());

  CustomTabBar({this.stream,Key key,this.pageControllerx, this.pageNamesx}): super(key: key);// : super();

  PageController pageControllerx;
  List<String> pageNamesx;
  //final Function() notifyParent;
  final Stream<int> stream;
  //List<Color> adornos;
  @override
  _CustomTabBarState createState() => _CustomTabBarState(controller: pageControllerx,nombres: pageNamesx);

  @override
  final Size preferredSize = new Size(0, 65);
/*
  void updatePag(int pag){
    this.createState().updatePage(pag);
  }*/
}

typedef PageCallback = void Function(int page);
class _CustomTabBarState extends  State<CustomTabBar>  {
  //CustomTabBar({ this.pageController, this.pageNames })
    //  : super(listenable: pageController);
  _CustomTabBarState({PageController controller, List<String> nombres}){
    this.pageController = controller;
    this.pageNames = nombres;
    //this.listenController = controller;
    //this.onPageSelect = 0;
  }
  //admob
  //final _nativeAdmob = NativeAdmob();
  final _nativeAdmob = NativeAdmob();
  int indexTemp=0;
  //AdmobBannerSize bannerSize;
   //PageCallback onPageSelect;
  PageController pageController;
   List<String> pageNames;
   List<Color> adornos = [Colors.transparent,Colors.transparent,Colors.transparent];
   List<Widget> listaFinal;
   Color _color = Colors.indigoAccent;
   //ValueListenable<PageController> listenController;
   //Listenable zController ;
   void updatePage(int pagina){
     this.adornos = [Colors.transparent,Colors.transparent,Colors.transparent];
     setState(() {
       //print ("[UPDATED] :V");
       this.adornos[pagina] = Colors.white.withOpacity(0.3);
       //this._color = Colors.teal;
     });
   }

  @override
  void initState() {
    super.initState();
/*
    setState(() {
      //this.updatePage(this.indexTemp);
    });
*/
    //_nativeAdmob.initialize(appID: "ca-app-pub-4537282655890052~3650132832");


    setState(() {
      widget.stream.listen((page) {
        //_updateSeconds(seconds);
        //print ("[FROM RECEIVER ] " + page.toString());
        this.updatePage(page);
      });
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    //FirebaseAdMob.instance.initialize(appId: "ca-app-pub-4537282655890052~3650132832").then((response){
      //myBanner..load()..show();
    //});
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    return
      Column(children: <Widget>[
      /*
        Container(color: Colors.indigoAccent,height: 90,

        child:
        NativeAdmobBannerView(
          adUnitID: "ca-app-pub-3940256099942544/8135179316",
          style: BannerStyle.light, // enum dark or light
          showMedia: false, // whether to show media view or not
          contentPadding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 0.0), // content padding
        ),



      )


      ,*/
      Container(
      height: 70,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
      decoration: new BoxDecoration(backgroundBlendMode: BlendMode.luminosity,
        color: Colors.red.shade800.withOpacity(0.4),
        borderRadius: new BorderRadius.circular(20.0),
      ),
      child:
      Column(children: <Widget>[ new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
        new List.generate(pageNames.length, (int index) {
          return
            Container(decoration: new BoxDecoration(backgroundBlendMode: BlendMode.luminosity,
              color: Colors.red.shade800.withOpacity(0.4),
              borderRadius: new BorderRadius.circular(20.0),
            ),
            child:
            InkWell(radius: 20,borderRadius: BorderRadius.circular(10),
              child:
              //PhysicalModel(borderRadius: BorderRadius.circular(25.0) ,child:
              //Column(children: <Widget>[
              AnimatedContainer(decoration: new BoxDecoration(//backgroundBlendMode: BlendMode.luminosity,
                //color: Colors.red.shade800.withOpacity(0.4),
                  color: this.adornos[index],
                borderRadius: new BorderRadius.circular(20.0),
              ),
                  padding: EdgeInsets.all(7),height: 40,
                  duration: Duration(milliseconds: 100),curve: Curves.bounceOut,child:
                Text(
                    pageNames[index],textAlign: TextAlign.center,
                    style: textTheme.subhead.copyWith(fontSize: 18,
                        color: Colors.white
                        //Colors.white.withOpacity(pageController.page==index ? 1 : 0.1,),fontSize: 20)
                )//,Container(width: 30,color: Colors.black,child: Text("______"),)
                  ,)
                )
                //], )
              //)
              , onTap: () {
                this.updatePage(index);
                /*
                setState(() {
                  widget.stream.listen((page) {
                    //_updateSeconds(seconds);
                    //print ("[FROM RECEIVER ] " + page.toString());
                    this.updatePage(page);
                  });
                });*/
                //this.indexTemp = index;
                /*
                this.adornos = [Colors.transparent,Colors.transparent,Colors.transparent];
                setState(() {
                    this.adornos[index] = Colors.white.withOpacity(0.3);
                    //this._color = Colors.teal;
                });
                */
                /*
                setState(() {
                  this.updatePage(index);
                });
                */
                 pageController.animateToPage(
                  index,
                  curve: Curves.decelerate,
                  duration: const Duration(milliseconds: 300),
                );
              }
          )
            );
        })
            .toList(),
      ),
      //Container(width: 400,child: CustomSearchField(),)

      ],)
    )//;
    ],);

  }
}
/*
* Cartas: clase para crear el menu principal de cartas
* en la primera pantalla de inicio*/
int tmr;
List<Widget> cartasLibres = new List();
List<Widget> cartasBusqueda = new List();
class Cartas extends StatelessWidget {
  //static _FirtsScreenState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_FirtsScreenState>());
  Dj dijey = Dj();
  List<Widget> cartasTriples = new List();
  //List<Widget> cartasLibres = new List();
  /*
  Cartas(FlutterWebviewPlugin webview) {
    this.webView = webview;
  }*/

  @override
  Widget build(BuildContext context) {

    //TextEditingController searchController = new TextEditingController();
    List<Widget> tmr = [
      CartaAds(),
      CartaAds(),
      CartaAds(),
      CartaTripleRadio(1,2,3),
    ];
    this.creaCartas();
    return GridView.builder(physics: BouncingScrollPhysics(),
        itemCount: cartasLibres.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    itemBuilder: (BuildContext context, int index) {
    return new Container(margin: EdgeInsets.all(0),color: Colors.transparent,
    child: new GridTile(
    //footer: new Text(this.cartasTriples[index].toString()),
    child: cartasLibres[index], //just for testing, will fill with image later
    ),
    );
    },
    );//ListView( physics: BouncingScrollPhysics(), children: this.cartasTriples,);
    //this.cartasLibres.
  }
  void creaCartas(){
    //int i = 0;
    //this.cartasTriples.add(CartaAds());
    //this.cartasTriples.add(CustomSearchField());

    //DEPRECATED
    /*for (int i =0 ; i<this.dijey.radiosDisponibles.length-3;i = i+3){
      var temp = CartaTripleRadio(i,i+1,i+2);
      this.cartasTriples.add(temp);
    }
    this.cartasTriples.add(CartaAds());*/
    //DEPRECATED
    for (int i =0 ; i<this.dijey.radiosDisponibles.length;i = i+1){
      var temp = new CartaRadio(this.dijey.radiosDisponibles[i]);
      cartasLibres.add(temp);
    }
  }
}


class ListViewSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new ListView.builder(
          itemCount: 200,
          itemBuilder: (context, index) {
            final count = index + 1;

            return new ListTile(
              leading: new CircleAvatar(
                child: new Text("$count"),
                backgroundColor: Colors.lightGreen[700],
              ),
              title: new Text("Title number $count"),
              subtitle: new Text("This is the subtitle number $count"),
            );
          },
        ),
      ),
    );
  }
}

class CustomSearchField extends StatelessWidget{
  Text texto;
  CustomSearchField(){
  }
  //@override
  //final Size preferredSize = new Size(0.0, 55.0);

  @override
  Widget build(BuildContext context) {
    //TextTheme textTheme = Theme
     //   .of(context)
       // .textTheme;
    return Container(child: Card(color: Colors.white,child: TextField(onChanged: (dataS){
      FirtsScreen.of(context).update();
      this.filtra(dataS, cartasLibres);
      },maxLines: 1,textAlign: TextAlign.center,decoration: InputDecoration(filled: false,hintText: "Ingrese Radio(nombre).",hintStyle: TextStyle(fontStyle: FontStyle.italic,color: Colors.blueGrey)),),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),),height: 45,width: 25,color: Colors.red.shade800.withOpacity(0.0),);
  }

  void filtra(String data,List<Widget> lista)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (data.length >= 2) {
      cartasBusqueda.clear();
      List<String> listax = new List();
      prefs.remove("cartasBusqueda");
      lista.forEach((e) async {
        CartaRadio temp = (e);
        if (temp.radiox.name.contains(data)) {
          //print("[FILTRA: ]" + temp.radiox.name);
          //lista.remove(e);
          listax.add(temp.radiox.name);
          await prefs.setStringList("cartasBusqueda", listax);
          //cartasBusqueda.add(temp);
          //print("[FILTRA: ]" + cartasBusqueda.length.toString());
        }
      });
    }else
      {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("cartasBusqueda");
      }
  }

}

class CartaTripleRadio extends StatelessWidget {
  Dj dijey = Dj();
  List<Expanded> cartas = new List();
  int a,b,c;
  CartaTripleRadio(int a,int b, int c){
    //this.webView = webview;
    this.a = a;
    this.b = b;
    this.c = c;
  }
  @override
  Widget build(BuildContext context) {
    //todo: cached image, gesture detector
    //TextEditingController searchController = new TextEditingController();
    //cartas.add(Expanded(child: Card()));
    //this.creaCartas();
    return Row(
      children: <Widget> [
         //this.dijey.radiosCards[52],
         Expanded(child: CartaRadio(this.dijey.radiosDisponibles[a]),),
         Expanded(child: CartaRadio(this.dijey.radiosDisponibles[b]),),
         Expanded(child: CartaRadio(this.dijey.radiosDisponibles[c]),),
         //Expanded(child: CartaRadio(),),
      ]
    );
  }
}


class CartaRadio extends StatefulWidget{
  RadioData radiox;
  CartaRadio(RadioData radio){
    radiox = radio;
  }
  @override
  _CartaRadioState createState() => _CartaRadioState(radiox);
}

class _CartaRadioState extends State<CartaRadio> {
  //final flutterWebViewPlugin = FlutterWebviewPlugin();
  static const platform = const MethodChannel("player.pe");
  AdmobInterstitial interstitialAd = AdmobInterstitial(
    adUnitId: 'ca-app-pub-3940256099942544/1033173712',
  );
  RadioData radioData;
  Dj dijey = Dj();
  //String urlx = "http://13743.live.streamtheworld.com/CRP_OAS_SC";
  String urlx = "http://ip.melodyradios.com:8887/;";
  _CartaRadioState(RadioData radio){
    this.radioData = radio;
    //this.urlx = this.radioData.sourceStream;
    //this.dijey.setLink(this.radioData.sourceStream);
    this.urlx = 'https://cp.usastreams.com/html5-player-mobil.aspx?stream='+ this.radioData.sourceStream;
    print(this.urlx);
    //String temp = 'https://cp.usastreams.com/html5-player-mobil.aspx?stream=';
    //this.radioData.sourceStream = this.radioData.sourceStream.substring(temp.length,this.radioData.sourceStream.length);
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 124.0,
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child:
      //SizeTransition(sizeFactor: )
      InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: ()async{
          print("[radio] " +this.radioData.sourceStream);
            seleccionado();
            this.dijey.isPlaying = true;
            playThis();
          //}
          //else{
          //}
        },
        child:
        Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional(-1, -1),
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child:  new Image(image: new CachedNetworkImageProvider(this.radioData.imageSrc),fit: BoxFit.fill) //Image.network( this.radioData.imageSrc,fit: BoxFit.fill,)
              ,),
            //Container(height: 10,color: Colors.black54,),
            Column(children: <Widget>[
              Container(height: 102,color: Colors.transparent,),
          ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child:
              Container(height: 22,width: 150,color: Colors.black54,child: Text(this.radioData.name.substring(0,this.radioData.name.length-2), maxLines: 1,textAlign: TextAlign.center,style: TextStyle(color: Colors.white),))
          )
            ],),
          ],)

        ,)
      ,
    );
  }
  Future<void> playThis()async{
    this.dijey.actualRadio = this.radioData;
    this.dijey.playingThisRadio = this.radioData.name;
    FirtsScreen.of(context).makePlayBarVisible();
    //firtsScreenKey.currentState.visiblePlayBar = true;
    //firtsScreenKey.currentState.makePlayBarVisible();
    print("[VISIVILITY] >> to true ... " + this.dijey.showPlayBar.toString());
    this.dijey.showPlayBar = true;
    print("dart >> playThis() Function ... " + this.radioData.sourceStream);
    var sendMap = <String, dynamic> {
      'url': this.radioData.sourceStream
    };
    await platform.invokeMethod("play", sendMap);

    //actualiza si esta en favoritos o no
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getKeys().toList();
    if (favs.contains(this.dijey.actualRadio.name)){
      FirtsScreen.of(context).icono_actual =FirtsScreen.of(context).icono_favorito;
    }
    else{
      FirtsScreen.of(context).icono_actual =FirtsScreen.of(context).icono_no_favorito;
    }
    //return radiosTemp;

  }

  void seleccionado () async
  {

    //funciona esto para database
    //print ("[CartaRadio.seleccionado()] name: "+ this.radioData.name );
    //print ("[CartaRadio.seleccionado()] link: "+ this.radioData.link );
    //print ("[CartaRadio.seleccionado()] source: "+ this.radioData.sourceStream );
    
    //Firestore.instance.collection("radios").document('lubeck').setData(data)
    //Firestore firestore = Firestore.getInstance();
    String url = await urlF();
    Firestore.instance.collection('radios').document('radiosPeru').snapshots().first.then((data) {
      print (data.data);
      url = data.data["link"];
      //return data.data["link"];
    }) ;
        /*.listen(
            (data)=>
        url = data.data["link"]
        //print("[FIREBASE]"+data.data["link"])
    );*/

    print("[FIREBASE]"+url);
    this.dijey.audioSrcLink = this.radioData.sourceStream;

    //FlutterRadio.playOrPause(url: this.radioData.sourceStream);

    //dijey.setLink("http://18253.live.streamtheworld.com/MAG_AAC_SC");
    //if (dijey.isPlaying==false){
      //print ("false...");
      //this.dijey.play2(this.radioData.sourceStream);
      //this.dijey.audioPlayer.setUrl(this.radioData.sourceStream);
    //int i = await dijey.audioPlayer.play(this.radioData.sourceStream);
    //print ("res > " + i.toString());
    //this.dijey.isPlaying = true;
      //this.dijey.play2()
    /*
    if (dijey.isPlaying==true){
      print ("true ... ");
      this.dijey.audioPlayer.stop();
      this.dijey.audioPlayer.setUrl(this.radioData.sourceStream);

    }*/
    //this.dijey.audioPlayer.setUrl(this.radioData.sourceStream);
    //this.dijey.audioPlayer.pla
  }

  Future<String> urlF() async {
    String url = "asdas";
    url =await Firestore.instance.collection('radios').document('radiosPeru').snapshots().first.then((data){return data.data.toString();});// .then((data) {
      //print (data.data);
      //url = data.data["link"];
      //return data.data["link"];
    //}) ;
    return url;
  }

  void procesaSnapshot(DocumentSnapshot data)
  {
    print (data.data);
  }

  //funcion para obtener los datos que tiene el dj.
  wPlay( BuildContext context){
    /*
    print("[wPlay] ...");
    this.flutterWebViewPlugin.launch(
      this.radioData.sourceStream,
      rect: Rect.fromLTWH(0.0, 0.0, MediaQuery.of(context).size.width, 0.0),
      userAgent: kAndroidUserAgent,withJavascript: true,enableAppScheme: true,
    );*/
  }

   // implementacion original FUNCIONA!!
  //funcion construye widget de la informacion de las radios
  void remoteconf() async
  {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    final defaults = <String, dynamic>{'radios': 'link'};
    await remoteConfig.setDefaults(defaults);

    await remoteConfig.fetch(expiration: const Duration(days: 5));
    await remoteConfig.activateFetched();
    print('radios xd: ' + remoteConfig.getString('radios2'));
    String lol = remoteConfig.getString('radios2');
    lol = lol.substring(1,lol.length-1);
    List<String> pol=lol.split("},");
    print (pol[0].toString());

    /*
    for (int i =0;i<pol.length;i++)
    {
      //print (pol[i].toString());
      List<String> temp = pol[i].split(":{");
      String nombre = temp[0].substring(1,temp[0].length-1);
      List<String> temp2   = temp[1].split(",");
      String link = temp2[0].substring(temp2[0].indexOf("http"));
      link = link.substring(0,link.length-1);
      String source = temp2[1].substring(temp2[0].indexOf("http"));
      if (source.length>1) {
        source = source.substring(2, source.length);
        source = source.substring(0,source.indexOf('"'));
      }
      print ('nombre > ' + nombre);
      print ('link   > ' + link );
      print ('source > ' + source);
    }*/
    //print ("SIZE : " + pol.length.toString());

  }
}

//ADS
class CartaAds extends StatelessWidget {
  String _audio_src = '';
  String _image_src = '';
  Dj dijey = Dj();
  String get_audioSrc() {
    return this._audio_src;
  }

  String get_imageSrc() {
    return this._image_src;
  }

  void set_audioSrc(String link) {
    this._audio_src = link;
  }

  void set_imageSrc(String link) {
    this._image_src = link;
  }

  @override
  Widget build(BuildContext context) {
    //todo: cached image, gesture detector
    //TextEditingController searchController = new TextEditingController();

    return Container(
      height: 70,
      child: Card(),
    );
  }

  void alSerTocado(String audioState, String imageState) {
    audioState = this._audio_src;
    imageState = this._image_src;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/*
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  birthday: DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);*/