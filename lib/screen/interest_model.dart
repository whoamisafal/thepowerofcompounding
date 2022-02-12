import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin InterestModel {
  final TextEditingController _principalController = TextEditingController(
    text: '1000',
  );
  final TextEditingController _rateController = TextEditingController(
    text: '5',
  );
  final TextEditingController _durationController = TextEditingController(
    text: '10',
  );
  //final TextEditingController _compoundPerYear = TextEditingController(
  //  text: '1',
  //);
  TextEditingController get principalController => _principalController;
  TextEditingController get rateController => _rateController;
  TextEditingController get durationController => _durationController;

  Widget principalWidget() {
    return TextFormField(
      controller: _principalController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Principal',
        hintText: 'Enter Principal',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Widget rateWidget() {
    return TextFormField(
      controller: _rateController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Rate',
        hintText: 'Enter Rate',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Widget durationWidget() {
    return TextFormField(
      controller: _durationController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Duration',
        hintText: 'Time in year',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
