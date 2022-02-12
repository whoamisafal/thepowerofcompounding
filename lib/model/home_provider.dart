import 'package:flutter/cupertino.dart';
import 'package:powerofcompounding/screen/ci_vs_si.dart';
import 'package:powerofcompounding/screen/compound_interest.dart';
import 'package:powerofcompounding/screen/emi.dart';
import 'package:powerofcompounding/screen/home.dart';
import 'package:powerofcompounding/screen/simple_interest_screen.dart';

class HomeProvider extends ChangeNotifier {
  List<WidgetHelperItem> widgets = [
    WidgetHelperItem(
        "Compound Interest", const CompoundInterestScreen(), false),
    WidgetHelperItem("Simple Interest", const SimpleInterestScreen(), false),
    WidgetHelperItem("Compound vs Simple Interest",
        const CompoundInterestVsSimpleInterest(), false),
    WidgetHelperItem(
        "EMI(Equated Monthly Installment) Calculator", const EMISystem(), false)
  ];

  void setShow(int index) {
    widgets[index].isShow = !widgets[index].isShow;
    notifyListeners();
  }

  void addWidets(WidgetHelperItem item) {
    widgets.add(item);
    notifyListeners();
  }
}
