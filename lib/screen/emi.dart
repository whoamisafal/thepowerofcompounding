import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerofcompounding/model/compound_interest_provider.dart';
import 'package:powerofcompounding/model/interest.dart';
import 'package:powerofcompounding/screen/interest_model.dart';
import 'package:provider/provider.dart';

class EMISystem extends StatefulWidget {
  const EMISystem({Key? key}) : super(key: key);

  @override
  _EMISystemState createState() => _EMISystemState();
}

class _EMISystemState extends State<EMISystem> with InterestModel {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _calculateEMI();
    });
  }

  _calculateEMI() async {
    EMIProvider provider = context.read<EMIProvider>();
    if (principalController.text.isEmpty) {
      principalController.text = '1000';
    }
    if (rateController.text.isEmpty) {
      rateController.text = '10';
    }
    if (durationController.text.isEmpty) {
      durationController.text = '10';
    }
    try {
      EMI emi = EMI();
      provider.setCalculating();
      provider.isShowGraph = false;
      double principal = double.parse(principalController.text);
      double time = double.parse(durationController.text);
      double rate = double.parse(rateController.text);
      emi.principal = principal;
      emi.time = time;
      emi.rate = rate;
      double emiValue = await emi.getEMI();
      double totalInterest = await emi.getInterest();
      double totalAmount = emi.getTotal();
      provider.setEMI(emiValue);
      provider.setInterest(totalInterest);
      provider.setAmount(totalAmount);
    } catch (e) {
      log(e.toString());
    }
  }

  _calculateEMIDurationBasis() async {
    EMIProvider provider = context.read<EMIProvider>();

    try {
      provider.setCalculatingForEMIS(true);
      EMI emi = EMI();
      provider.isShowGraph = true;

      double principal = double.parse(principalController.text);
      double time = double.parse(durationController.text);
      double rate = double.parse(rateController.text);
      emi.principal = principal;

      emi.rate = rate;
      List<FlSpot> list = [];
      for (double i = 1; i <= time; i++) {
        emi.time = i;
        double emiValue = await emi.getEMI();
        list.add(FlSpot(i, emiValue));
      }
      provider.setEMIS(list);
    } catch (e) {
      log(e.toString());
    }
  }

  Widget _result() {
    EMIProvider provider = context.watch<EMIProvider>();
    if (provider.isCalculating) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      );
    }
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width,
            height: 125,
            child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Loan EMI (Monthly Payment)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    NumberFormat("###,###,###,###,###,###.##", "en_US")
                        .format(provider.emi),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            height: 125,
            child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Total Interest Payable",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    NumberFormat("###,###,###,###,###,###.##", "en_US")
                        .format(provider.interest)
                        .toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            height: 125,
            child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Total Payment\n(Principal + Interest)",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    NumberFormat("###,###,###,###,###,###.##", "en_US")
                        .format(provider.totalAmount)
                        .toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _graphOnTheBaisOfDuration() {
    EMIProvider provider = context.watch<EMIProvider>();
    if (provider.isProgressForEMIS) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      );
    }
    if (!provider.isShowGraph) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
                rightTitles: SideTitles(showTitles: false),
                topTitles: SideTitles(showTitles: false),
                bottomTitles: SideTitles(
                  showTitles: true,
                  margin: 10,
                  getTitles: (value) {
                    return value.toInt().toString() + "Y";
                  },
                )),
            lineBarsData: [
              LineChartBarData(
                spots: provider.emis,
                isCurved: true,
                dotData: FlDotData(
                  show: true,
                ),
                belowBarData: BarAreaData(
                  show: false,
                ),
                colors: [
                  Colors.blue,
                ],
                barWidth: 4,
              ),
            ],
            minX: 0,
            maxX: double.parse(durationController.text) + 1,
            minY: 0,
          ),
          swapAnimationDuration: const Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear,
        ),
      ),
    );
  }

  Widget _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: principalWidget(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: rateWidget(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: durationWidget(),
        ),
        Center(
          child: OutlinedButton(
            onPressed: _calculateEMI,
            child: const Text("Calculate"),
          ),
        ),
        _result(),
        Center(
          child: OutlinedButton(
            onPressed: _calculateEMIDurationBasis,
            child: const Text("Show Graph"),
          ),
        ),
        _graphOnTheBaisOfDuration(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _form();
  }
}
