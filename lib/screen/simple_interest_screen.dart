import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerofcompounding/model/compound_interest_provider.dart';
import 'package:powerofcompounding/model/interest.dart';
import 'package:powerofcompounding/screen/interest_model.dart';
import 'package:provider/provider.dart';

class SimpleInterestScreen extends StatefulWidget {
  const SimpleInterestScreen({Key? key}) : super(key: key);

  @override
  _SimpleInterestScreenState createState() => _SimpleInterestScreenState();
}

class _SimpleInterestScreenState extends State<SimpleInterestScreen>
    with InterestModel {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _calcuateSimpleInterest();
    });
  }

  @override
  void dispose() {
    super.dispose();
    principalController.dispose();
    durationController.dispose();
    rateController.dispose();
  }

  Future<List<FlSpot>> getInterests(SimpleInterest interest, double time) {
    return Future.delayed(const Duration(milliseconds: 50), () async {
      List<FlSpot> spots = [];
      for (int i = 1; i <= time; i++) {
        interest.time = double.parse(i.toString());
        double ci = await interest.getInterest();
        log(ci.toString());
        spots.add(FlSpot(i.toDouble(), ci));
      }
      return spots;
    });
  }

  void _calcuateSimpleInterest() async {
    if (principalController.text.isEmpty) {
      principalController.text = '1000';
    }
    if (rateController.text.isEmpty) {
      rateController.text = '10';
    }
    if (durationController.text.isEmpty) {
      durationController.text = '10';
    }
    SimpleInterest interest = SimpleInterest();
    try {
      interest.principal = double.parse(principalController.text);
      interest.rate = double.parse(rateController.text);
      double time = double.parse(durationController.text);
      interest.time = time;
      double si = await interest.getInterest();
      context.read<SimpleInterestProvider>().setSimpleInterest(si);
      context
          .read<SimpleInterestProvider>()
          .setInterest(await getInterests(interest, time));
    } catch (e) {
      log(e.toString());
    }
  }

  Widget _lineChart() {
    SimpleInterestProvider provider = context.watch<SimpleInterestProvider>();
    if (provider.interests.isEmpty) {
      return Container();
    }
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
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
              spots: context.watch<SimpleInterestProvider>().interests,
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
        ),
        swapAnimationDuration: const Duration(milliseconds: 150), // Optional
        swapAnimationCurve: Curves.linear,
      ),
    );
  }

  Widget _simpleInterestForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: _calcuateSimpleInterest,
                child: const Text("Calculate"),
              ),
            ),
          ),
          Center(
            child: Text(
              "Unit. " +
                  NumberFormat("###,###,###,###,###,###.##", "en_US")
                      .format(context.watch<SimpleInterestProvider>().result)
                      .toString(),
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _lineChart(),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _simpleInterestForm();
  }
}
