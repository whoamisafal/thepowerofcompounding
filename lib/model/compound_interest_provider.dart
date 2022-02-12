import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class CompoundInterestProvider extends ChangeNotifier {
  double _result = 0;
  List<FlSpot> _dots = [
    const FlSpot(0, 0),
  ];
  List<FlSpot> get spots => _dots;
  double get result => _result;
  void setCompoundInterest(double interest) {
    _result = interest;
    notifyListeners();
  }

  void setData(List<FlSpot> data) {
    _dots.clear();
    _dots = data;
    notifyListeners();
  }
}

class SimpleInterestProvider extends ChangeNotifier {
  double _result = 0;
  List<FlSpot> _interests = [
    const FlSpot(0, 0),
  ];
  List<FlSpot> get interests => _interests;
  void setInterest(List<FlSpot> interest) {
    _interests.clear();
    _interests = interest;
    notifyListeners();
  }

  double get result => _result;
  void setSimpleInterest(double interest) {
    _result = interest;
    notifyListeners();
  }
}

class CIANDSIProvider extends ChangeNotifier {
  double _si = 0;
  double _ci = 0;
  double _cisemi = 0;
  double _ciquarter = 0;
  double _cimonthly = 0;
  double get si => _si;
  double get ci => _ci;
  double get cisemi => _cisemi;
  double get ciquarter => _ciquarter;
  double get cimonthly => _cimonthly;
  bool isCalculating = false;
  double totalTasks = 0;
  double finishedTask = 0;
  void setTotalTasks(double total) {
    totalTasks = total;
    notifyListeners();
  }

  void incermentFinishedTask() {
    finishedTask++;
    notifyListeners();
  }

  void setFinishedTasks(double finished) {
    finishedTask = finished;
    notifyListeners();
  }

  List<FlSpot> _simpleInterests = [
    const FlSpot(0, 0),
  ];
  List<FlSpot> _compoundInterestSemiAnually = [
    const FlSpot(0, 0),
  ];
  List<FlSpot> _compoundInterestQuater = [
    const FlSpot(0, 0),
  ];
  List<FlSpot> _compoundInterestMonthly = [
    const FlSpot(0, 0),
  ];
  List<FlSpot> get compoundInterestSemiAnually => _compoundInterestSemiAnually;
  List<FlSpot> _compoundInterests = [
    const FlSpot(0, 0),
  ];
  List<FlSpot> get compoundInterestsQuater => _compoundInterestQuater;
  List<FlSpot> get compoundInterestsMonthly => _compoundInterestMonthly;
  List<FlSpot> get simpleInterests => _simpleInterests;
  List<FlSpot> get compoundInterests => _compoundInterests;
  void setCalculating() {
    isCalculating = true;
    notifyListeners();
  }

  void setInterests(List<FlSpot> si, List<FlSpot> ci1, List<FlSpot> ci2,
      List<FlSpot> ci3, List<FlSpot> ci4) {
    _simpleInterests.clear();
    _compoundInterests.clear();
    _compoundInterestSemiAnually.clear();
    _compoundInterestQuater.clear();
    _compoundInterestMonthly.clear();
    _simpleInterests = si;
    _compoundInterests = ci1;
    _compoundInterestSemiAnually = ci2;
    _compoundInterestQuater = ci3;
    _compoundInterestMonthly = ci4;
    isCalculating = false;
    notifyListeners();
  }

  void setSimpleInterest(double interest) {
    _si = interest;
    notifyListeners();
  }

  void setCompoundInterest(double interest) {
    _ci = interest;
    notifyListeners();
  }

  void setCompoundInterestSemiAnually(double interest) {
    _cisemi = interest;
    notifyListeners();
  }

  void setCompoundInterestQuater(double interest) {
    _ciquarter = interest;
    notifyListeners();
  }

  void setCIMontly(double interest) {
    _cimonthly = interest;
    notifyListeners();
  }
}

class EMIProvider extends ChangeNotifier {
  double _emi = 0;
  double _interest = 0;
  double totalAmount = 0;
  double get emi => _emi;
  double get interest => _interest;
  bool isCalculating = false;
  bool isProgressForEMIS = false;
  bool isShowGraph = false;
  List<FlSpot> _emis = [
    const FlSpot(0, 0),
  ];
  List<FlSpot> get emis => _emis;
  void setCalculating() {
    isCalculating = true;
    notifyListeners();
  }

  void setCalculatingForEMIS(bool isProgress) {
    isProgressForEMIS = isProgress;
    notifyListeners();
  }

  void setEMIS(List<FlSpot> emi) {
    _emis.clear();
    _emis = emi;
    isProgressForEMIS = false;
    notifyListeners();
  }

  void setEMI(double emi) {
    _emi = emi;
    isCalculating = false;
    notifyListeners();
  }

  void setInterest(double interest) {
    _interest = interest;
    isCalculating = false;
    notifyListeners();
  }

  void setAmount(double amount) {
    totalAmount = amount;
    isCalculating = false;
    notifyListeners();
  }
}
