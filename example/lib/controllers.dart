library controllers;

import 'package:forcemvc2/forcemvc2.dart';
//import 'dart:indexed_db';
import 'dart:async';
//import 'dart:convert';

class myList {
  String label;
  List values;
}

@Controller
class myControllers {
  @RequestMapping(value:'/', method:'GET')
  String home(ForceRequest req, Model model) {
    return 'index';
  }

  @RequestMapping(value: '/verify', method: 'POST')
  Future<String> verify(ForceRequest req, Model model) async {
    var myParams = await req.getPostParams();
 /*    Map myParams = new Map();
    req.getPostData(usejson: false).then((params) {
   
   // Map<String, List> other = new Map();
    List x = params.split("&");
    for (String atom in x) {
      List particle = atom.split("=");
      String key = Uri.decodeQueryComponent(particle[0]);
      String value = Uri.decodeComponent(particle[1]);
      if (key.endsWith("[]")) {
        key = key.replaceFirst("[]", "");
      if (myParams.containsKey(key)) {
          (myParams[key] as List).add(value);
      } else {
        myParams[key] = new List();
        myParams[key].add(value);
      }
      
      } else {
      myParams[key] = value;
      }
    }
  
    }); */
    //print(myParams);
    model.addAttribute("params", myParams);

    return "verify";
  }

  Future getParams(ForceRequest req) {
    Completer completer = new Completer();
       Map myParams = new Map();
    req.getPostData(usejson: false).then((params) {
   
   // Map<String, List> other = new Map();
    List x = params.split("&");
    for (String atom in x) {
      List particle = atom.split("=");
      String key = Uri.decodeQueryComponent(particle[0]);
      String value = Uri.decodeComponent(particle[1]);
      if (key.endsWith("[]")) {
        key = key.replaceFirst("[]", "");
      if (myParams.containsKey(key)) {
          (myParams[key] as List).add(value);
      } else {
        myParams[key] = new List();
        myParams[key].add(value);
      }
      
      } else {
      myParams[key] = value;
      }
    }
  completer.complete(myParams);
    });
    return completer.future;

  }
  

}