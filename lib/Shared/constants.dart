import 'package:flutter/material.dart';

// TODO: Add context so we can use themes

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Color.fromRGBO(28, 28, 28, 1)),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(28, 28, 28, 1), width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFF0889B6), width: 2.0)
  ),
);