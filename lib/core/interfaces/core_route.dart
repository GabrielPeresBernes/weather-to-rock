import 'package:flutter/material.dart';

abstract interface class CoreRoute<Params> {
  String get path;

  String getLocation([Params? params]);

  Widget build([Params? params]);
}
