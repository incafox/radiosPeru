import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';
/*
* cada MenuRegion contiene informacion acerca de una region*/
class MenuRegion extends StatefulWidget{
  //MenuRegion();
  List<RadioData> listaRadios = new List();
  @override
  _MenuRegion createState() => _MenuRegion();
}

class _MenuRegion extends State<MenuRegion>{
  Color fondo = Colors.redAccent;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(children: <Widget>[
    Container(color: Colors.transparent,child:
      ExpansionTile(title:Row(children: <Widget>[Icon(Icons.radio),Text("  AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
                children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: fondo,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: fondo,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: Colors.red,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: Colors.deepPurple,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: Colors.deepPurple,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: Colors.deepPurple,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: Colors.deepPurple,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: Colors.deepPurple,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: Colors.deepPurple,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: Colors.deepPurple,
    )),
    Container(color: Colors.transparent,child:
    ExpansionTile(title: Row(children: <Widget>[Icon(Icons.radio),Text("   AREQUIPA",textAlign: TextAlign.left,style: new TextStyle(fontSize: 18,color: Colors.white))],),
      children: <Widget>[Text("fsfsf",textAlign: TextAlign.left,),Text("dadasds")],backgroundColor: Colors.deepPurple,
    ))
    ],);
  }
}