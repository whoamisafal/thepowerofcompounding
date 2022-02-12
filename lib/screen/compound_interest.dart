import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerofcompounding/model/compound_interest_provider.dart';
import 'package:powerofcompounding/model/interest.dart';
import 'package:powerofcompounding/screen/interest_model.dart';
import 'package:provider/provider.dart';

class CompoundInterestScreen extends StatefulWidget {
  const CompoundInterestScreen({Key? key}) : super(key: key);

  @override
  _CompoundInterestScreenState createState() => _CompoundInterestScreenState();
}

class _CompoundInterestScreenState extends State<CompoundInterestScreen>
    with InterestModel {
  final TextEditingController _compoundPerYear = TextEditingController(
    text: '1',
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _calculateCompoundInterest();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _compoundPerYear.dispose();
    principalController.dispose();
    durationController.dispose();
    rateController.dispose();
  }

  Future<List<FlSpot>> getInterests(CompoundInterest interest, double time) {
    return Future.delayed(const Duration(milliseconds: 250), () async {
      List<FlSpot> spots = [];
      for (int i = 1; i <= time; i++) {
        interest.time = double.parse(i.toString());
        double ci = await interest.getInterest();

        spots.add(FlSpot(i.toDouble(), ci));
      }
      return spots;
    });
  }

  void _calculateCompoundInterest() async {
    CompoundInterest interest = CompoundInterest();
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
      interest.principal = double.parse(principalController.text);
      interest.rate = double.parse(rateController.text);
      double time = double.parse(durationController.text);
      interest.time = time;
      interest.setCompoundValue(double.parse(_compoundPerYear.text));
      double ci = await interest.getInterest();
      log(ci.toString());
      context.read<CompoundInterestProvider>().setCompoundInterest(ci);
      List<FlSpot> spots = await getInterests(interest, time);

      context.read<CompoundInterestProvider>().setData(spots);
    } catch (e) {
      log(e.toString());
    }
  }

  Widget get _compundsPerYearWidget {
    return TextFormField(
      controller: _compoundPerYear,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Compounds per year',
        hintText: 'Enter Compunds per year',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Widget _lineChart() {
    CompoundInterestProvider provider =
        context.watch<CompoundInterestProvider>();
    if (provider.spots.isEmpty) {
      return Container();
    }
    return SizedBox(
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
              spots: provider.spots,
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
    );
  }

  Widget _compoundInterestForm() {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _compundsPerYearWidget,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: _calculateCompoundInterest,
                child: const Text("Calculate"),
              ),
            ),
          ),
          Center(
            child: Text(
              "Unit. " +
                  NumberFormat("###,###,###,###,###,###.##", "en_US")
                      .format(context.watch<CompoundInterestProvider>().result)
                      .toString(),
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _lineChart(),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _compoundInterestForm();
  }
}
