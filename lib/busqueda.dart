import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'main.dart';

class MenuBusqueda extends StatefulWidget {
  //MenuRegion();
  List<RadioData> listaRadios = new List();
  @override
  _MenuBusqueda createState() => _MenuBusqueda();
}

class _MenuBusqueda extends State<MenuBusqueda> {
  List<RadioData> radiosFavoritas = new List();
  Future<List<CartaRadio>> radiosCartas; // = new List();

  Color fondo = Colors.redAccent;

  Future<List<CartaRadio>> futureBuilderCartas() async {
    List<RadioData> radiosTemp = new List();
    List<CartaRadio> cartas = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    String text = prefs.getKeys().toString();
    //print("[MenuFavoritos] " + text);
    //print(prefs.getString("  quillabamba: ").toString());
    List<String> nombres = prefs.get("cartasBusqueda");
    //print("[OBXXX] " + das.toString());
    //das.
    //prefs.get("cartasBusqueda").forEach((data) {
      //RadioData radioData = new RadioData(namex, linkx, sourcex, imagex)
      Dj().radiosDisponibles.forEach((radio) {
        if (nombres.contains(radio.name)) {
          //print("[FAVORITOS de key ]" + data.toString());
          radiosTemp.add(radio);
          CartaRadio temp = new CartaRadio(radio);
          cartas.add(temp);
        }
      });


      //print("[OBTENIDO DE KEY ]" + data);
      //print(prefs.getString(data));
    //});
    if (cartas.length==0) {
      //cartas.add();
    }
    return cartas;
    //return cartasBusqueda;
  }

  Future<List<RadioData>> lol() async {
    List<RadioData> radiosTemp = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    String text = prefs.getKeys().toString();
    //print("[MenuFavoritos] " + text);
    //print(prefs.getString("  quillabamba: ").toString());
    //List<String> das
    prefs.getKeys().toList().forEach((data) {
      //RadioData radioData = new RadioData(namex, linkx, sourcex, imagex)
      Dj().radiosDisponibles.forEach((radio) {
        if (radio.name == data) {
          //print("[BUSCADO ]" + data);
          radiosTemp.add(radio);
        }
      });
      //print("[BUSCADO ]"+data);
      //print(prefs.getString(data));
    });
    return radiosTemp;
  }

  void getFavoriteRadios() async {
    this.radiosFavoritas = await lol();
    this.radiosFavoritas.forEach((radio) {
      //print("[favoritos]" + radio.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    getFavoriteRadios();
    // TODO: implement build
    return //GridView.count(crossAxisCount: 3,children: <Widget>[
        //Container(
        //appBar: AppBar(title: Container(width: 400,child: CustomSearchField(),),),
      //child:
      FutureBuilder<List<CartaRadio>>(
        future: this.futureBuilderCartas(),
        builder: (BuildContext context, AsyncSnapshot<List<CartaRadio>> lista) {
          //List<CartaRadio>radiosCartas = await this.futureBuilderCartas();
          if (lista.connectionState == ConnectionState.done) {
            //if(lista.data != null ) {
             try {
               return GridView.count(
                 crossAxisCount: 3,
                 children: lista.data,
                 scrollDirection: Axis.vertical,
                 physics: BouncingScrollPhysics(),
               ); // unreachable
             }catch(e){
               return Container();
             }
            //}else
              //return Text("Ingrese su busqueda",style: TextStyle(fontSize: 20,color: Colors.white,),textAlign: TextAlign.center,);
          } else
            return Container(child: Text("CONSTRUYENDO"));
        },
      );
    //);

    //],scrollDirection: Axis.vertical,physics: BouncingScrollPhysics(),);
  }
}

class CartaRadio extends StatefulWidget {
  RadioData radiox;
  CartaRadio(RadioData radio) {
    radiox = radio;
  }
  @override
  _CartaRadioState createState() => _CartaRadioState(radiox);
}

class _CartaRadioState extends State<CartaRadio> {
  //final flutterWebViewPlugin = FlutterWebviewPlugin();
  static const platform = const MethodChannel("player.pe");
  RadioData radioData;
  Dj dijey = Dj();
  //String urlx = "http://13743.live.streamtheworld.com/CRP_OAS_SC";
  String urlx = "http://ip.melodyradios.com:8887/;";
  _CartaRadioState(RadioData radio) {
    this.radioData = radio;
    //this.urlx = this.radioData.sourceStream;
    //this.dijey.setLink(this.radioData.sourceStream);
    this.urlx = 'https://cp.usastreams.com/html5-player-mobil.aspx?stream=' +
        this.radioData.sourceStream;
    print(this.urlx);
    //String temp = 'https://cp.usastreams.com/html5-player-mobil.aspx?stream=';
    //this.radioData.sourceStream = this.radioData.sourceStream.substring(temp.length,this.radioData.sourceStream.length);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
        highlightColor: Colors.white70,
        splashColor: Colors.white12,
        onTap: () async {
          //print("[radio] " + this.radioData.sourceStream);
          seleccionado();
          this.dijey.isPlaying = true;
          playThis();
          //}
          //else{
          //}
        },
        child: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional(-1, -1),
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: new Image(
                      image: new CachedNetworkImageProvider(
                          this.radioData.imageSrc),
                      fit: BoxFit
                          .fill) //Image.network( this.radioData.imageSrc,fit: BoxFit.fill,)
                  ,
            ),
            //Container(height: 10,color: Colors.black54,),
            Column(
              children: <Widget>[
                Container(
                  height: 102,
                  color: Colors.transparent,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: Container(
                        height: 22,
                        width: 150,
                        color: Colors.black54,
                        child: Text(
                          this
                              .radioData
                              .name
                              .substring(0, this.radioData.name.length - 2),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> playThis() async {
    this.dijey.actualRadio = this.radioData;
    this.dijey.playingThisRadio = this.radioData.name;
    FirtsScreen.of(context).makePlayBarVisible();
    //firtsScreenKey.currentState.visiblePlayBar = true;
    //firtsScreenKey.currentState.makePlayBarVisible();
    print("[VISIVILITY] >> to true ... " + this.dijey.showPlayBar.toString());
    this.dijey.showPlayBar = true;
    print("dart >> playThis() Function ... " + this.radioData.sourceStream);
    var sendMap = <String, dynamic>{'url': this.radioData.sourceStream};
    await platform.invokeMethod("play", sendMap);
    //actualiza si esta en favoritos o no
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getKeys().toList();
    if (favs.contains(this.dijey.actualRadio.name)) {
      FirtsScreen.of(context).icono_actual =
          FirtsScreen.of(context).icono_favorito;
    } else {
      FirtsScreen.of(context).icono_actual =
          FirtsScreen.of(context).icono_no_favorito;
    }
  }

  void seleccionado() async {
    //funciona esto para database
    print("[CartaRadio.seleccionado()] name: " + this.radioData.name);
    print("[CartaRadio.seleccionado()] link: " + this.radioData.link);
    print("[CartaRadio.seleccionado()] source: " + this.radioData.sourceStream);

    this.dijey.audioSrcLink = this.radioData.sourceStream;
  }
}
