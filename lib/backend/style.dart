import 'package:flutter/material.dart';

final kBoxStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: const [
    BoxShadow(
      color: Colors.indigo,
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxStyleGradient = BoxDecoration(
  gradient: LinearGradient(
    colors: [Colors.indigo, Colors.indigo.shade100],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  ),
  borderRadius: BorderRadius.circular(10),
  boxShadow: const [
    BoxShadow(
      color: Colors.indigo,
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ],
);

final textstyle = const TextStyle(
    fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w600);

final textstyle2 = const TextStyle(
    fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600);

final textstyle3 = const TextStyle(fontSize: 12, color: Colors.blue);

final textstyle4 = const TextStyle(fontSize: 18, color: Colors.white);
