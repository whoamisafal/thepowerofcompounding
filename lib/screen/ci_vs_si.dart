import 'dart:developer';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:powerofcompounding/model/compound_interest_provider.dart';
import 'package:powerofcompounding/model/interest.dart';
import 'package:powerofcompounding/screen/interest_model.dart';

class CompoundInterestVsSimpleInterest extends StatefulWidget {
  const CompoundInterestVsSimpleInterest({Key? key}) : super(key: key);

  @override
  _CompoundInterestVsSimpleInterestState createState() =>
      _CompoundInterestVsSimpleInterestState();
}

class _CompoundInterestVsSimpleInterestState
    extends State<CompoundInterestVsSimpleInterest> with InterestModel {
  List<LegendItem> legendItems = [
    LegendItem("Simple Interest", Colors.blue),
    LegendItem("Compound Interest Anually", Colors.red),
    LegendItem("Compound Interest Semi-Anually", Colors.green),
    LegendItem("Compound Interest Quarterly", Colors.orange),
    LegendItem("Compound Interest Monthly", Colors.purple),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 250), () => {_calculate()});
  }

  @override
  void dispose() {
    super.dispose();

    principalController.dispose();
    durationController.dispose();
    rateController.dispose();
  }

  Future<List<FlSpot>> getCIInterests(
      CompoundInterest interest, double time) async {
    return Future.delayed(const Duration(microseconds: 50), () async {
      List<FlSpot> spots = [];
      for (int i = 1; i <= time; i++) {
        interest.time = double.parse(i.toString());
        double ci = await interest.getInterest();
        log(ci.toString());
        spots.add(FlSpot(i.toDouble(), ci));
        context.read<CIANDSIProvider>().incermentFinishedTask();
      }
      return spots;
    });
  }

  double _calculateTotalTasks(double duration) {
    return duration * 5;
  }

  void _calculate() async {
    // For simple interest
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
      CIANDSIProvider provider = context.read<CIANDSIProvider>();
      provider.setCalculating();
      provider.setTotalTasks(0);
      provider.setFinishedTasks(0);

      SimpleInterest interest = SimpleInterest();
      double principal = double.parse(principalController.text);
      double time = double.parse(durationController.text);
      double rate = double.parse(rateController.text);
      interest.principal = principal;
      interest.time = time;
      interest.rate = rate;
      provider.setTotalTasks(_calculateTotalTasks(time) + 5);
      //For Compound Interest
      //Anually
      CompoundInterest interest1 = CompoundInterest();
      interest1.principal = principal;
      interest1.time = time;
      interest1.rate = rate;
      interest1.setCompoundValue(1);

      //Semi-Anually
      CompoundInterest interest2 = CompoundInterest();
      interest2.principal = principal;
      interest2.time = time;
      interest2.rate = rate;
      interest2.setCompoundValue(2);

      //Quarterly
      CompoundInterest interest3 = CompoundInterest();
      interest3.principal = principal;
      interest3.time = time;
      interest3.rate = rate;
      interest3.setCompoundValue(4);

      //Monthly
      CompoundInterest interest4 = CompoundInterest();
      interest4.principal = principal;
      interest4.time = time;
      interest4.rate = rate;
      interest4.setCompoundValue(12);
      double ci3 = await interest3.getInterest();
      provider.incermentFinishedTask();
      var _ci3 = await getCIInterests(interest3, time);
      double si = await interest.getInterest();
      provider.incermentFinishedTask();
      var _simpleIntrests = await getSInterests(interest, time);
      double ci1 = await interest1.getInterest();
      provider.incermentFinishedTask();
      var _ci1 = await getCIInterests(interest1, time);
      double ci4 = await interest4.getInterest();
      provider.incermentFinishedTask();
      double ci2 = await interest2.getInterest();
      provider.incermentFinishedTask();
      var _ci2 = await getCIInterests(interest2, time);
      var _ci4 = await getCIInterests(interest4, time);

      provider.setCompoundInterest(ci1);
      provider.setSimpleInterest(si);
      provider.setCompoundInterestSemiAnually(ci2);
      provider.setCompoundInterestQuater(ci3);
      provider.setCIMontly(ci4);
      provider.setInterests(_simpleIntrests, _ci1, _ci2, _ci3, _ci4);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<FlSpot>> getSInterests(SimpleInterest interest, double time) {
    return Future.delayed(const Duration(microseconds: 50), () async {
      List<FlSpot> spots = [];
      for (int i = 1; i <= time; i++) {
        interest.time = double.parse(i.toString());
        double ci = await interest.getInterest();

        spots.add(FlSpot(i.toDouble(), ci));
        context.read<CIANDSIProvider>().incermentFinishedTask();
      }
      return spots;
    });
  }

  Widget _lineChart() {
    CIANDSIProvider provider = context.watch<CIANDSIProvider>();
    if (provider.compoundInterests.isEmpty ||
        provider.simpleInterests.isEmpty) {
      return Container();
    }
    if (provider.isCalculating) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            children: const [
              CupertinoActivityIndicator(
                radius: 25,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      width: Size.infinite.width,
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
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: provider.simpleInterests,
              colors: [
                legendItems[0].color,
              ],
            ),
            LineChartBarData(
              isCurved: true,
              spots: provider.compoundInterests,
              colors: [
                legendItems[1].color,
              ],
            ),
            LineChartBarData(
              isCurved: true,
              spots: provider.compoundInterestSemiAnually,
              colors: [
                legendItems[2].color,
              ],
            ),
            LineChartBarData(
              isCurved: true,
              spots: provider.compoundInterestsQuater,
              colors: [
                legendItems[3].color,
              ],
            ),
            LineChartBarData(
              isCurved: true,
              spots: provider.compoundInterestsMonthly,
              colors: [
                legendItems[4].color,
              ],
            ),
          ],
          minX: 0,
          maxX: double.parse(durationController.text) + 1,
          minY: 0,
        ),
      ),
    );
  }

  List<String> _analysis() {
    CIANDSIProvider provider = context.watch<CIANDSIProvider>();
    List<String> analysis = [];
    analysis.add("Simple Interest is " + provider.si.toStringAsFixed(2));
    analysis.add("Compound Interest is " + provider.ci.toStringAsFixed(2));
    analysis.add("Compound Interest Semi-Anually is " +
        provider.cisemi.toStringAsFixed(2));
    analysis.add("Compound Interest Monthly is " +
        provider.cimonthly.toStringAsFixed(2));
    analysis.add("Compound Interest Quarterly is " +
        provider.ciquarter.toStringAsFixed(2));

    if (provider.si > provider.ci &&
        provider.si > provider.cisemi &&
        provider.si > provider.ciquarter &&
        provider.si > provider.cimonthly) {
      analysis.add("Simple Interest is the best");
    } else if (provider.ci > provider.si &&
        provider.ci > provider.cisemi &&
        provider.ci > provider.ciquarter &&
        provider.ci > provider.cimonthly) {
      analysis.add("Compound Interest anually is the best");
      //if not include anually
      if (provider.si > provider.cisemi &&
          provider.si > provider.ciquarter &&
          provider.si > provider.cimonthly) {
        analysis.add("Simple Interest is the best if not include CI anually");
      } else if (provider.cisemi > provider.si &&
          provider.cisemi > provider.ciquarter &&
          provider.cisemi > provider.cimonthly) {
        analysis.add(
            "Compound Interest Semi-Anually is the best if not include CI anually");
      } else if (provider.ciquarter > provider.si &&
          provider.ciquarter > provider.cisemi &&
          provider.ciquarter > provider.cimonthly) {
        analysis.add(
            "Compound Interest Quarterly is the best if not include CI anually");
      } else {
        analysis.add(
            "Compound Interest Monthly is the best if not include CI anually");
      }
      //End
    } else if (provider.cisemi > provider.si &&
        provider.cisemi > provider.ci &&
        provider.cisemi > provider.ciquarter &&
        provider.cisemi > provider.cimonthly) {
      analysis.add("Compound Interest Semi-Anually is the best");
      //if not include semi-anually
      if (provider.si > provider.ci &&
          provider.si > provider.cimonthly &&
          provider.si > provider.ciquarter) {
        analysis.add("Simple Interest is the best if not include Semi-Anually");
      } else if (provider.ci > provider.si &&
          provider.ci > provider.cimonthly &&
          provider.ci > provider.ciquarter) {
        analysis.add(
            "Compound Interest anually is the best if not include Semi-Anually");
      } else if (provider.cimonthly > provider.si &&
          provider.cimonthly > provider.ci &&
          provider.cimonthly > provider.ciquarter) {
        analysis.add(
            "Compound Interest Monthly is the best if not include Semi-Anually");
      } else {
        analysis.add(
            "Compound Interest Quarterly is the best if not include Semi-Anually");
      }

      //End if not include semi-anually
    } else if (provider.ciquarter > provider.si &&
        provider.ciquarter > provider.cisemi &&
        provider.ciquarter > provider.ci &&
        provider.ciquarter > provider.cimonthly) {
      analysis.add("Compound Interest Quarterly is the best");

      if (provider.si > provider.ci &&
          provider.si > provider.cisemi &&
          provider.si > provider.cimonthly) {
        analysis.add("Simple Interest is the best if not include CI Quarterly");
      } else if (provider.ci > provider.si &&
          provider.ci > provider.cisemi &&
          provider.ci > provider.cimonthly) {
        analysis.add(
            "Compound Interest anually is the best if not include CI Quarterly");
      } else if (provider.cisemi > provider.si &&
          provider.cisemi > provider.ci &&
          provider.cisemi > provider.cimonthly) {
        analysis.add(
            "Compound Interest Semi-Anually is the best if not include CI Quarterly");
      } else {
        analysis.add(
            "Compound Interest Quarterly is the best if not include CI Quarterly");
      }
    } else {
      analysis.add("Compound Interest Monthly is the best");
      if (provider.si > provider.ci &&
          provider.si > provider.cisemi &&
          provider.si > provider.ciquarter) {
        analysis.add("Simple Interest is the best if  not include CI monthly");
      } else if (provider.ci > provider.si &&
          provider.ci > provider.cisemi &&
          provider.ci > provider.ciquarter) {
        analysis.add(
            "Compound Interest anually is the best if  not include CI monthly");
      } else if (provider.cisemi > provider.si &&
          provider.cisemi > provider.ci &&
          provider.cisemi > provider.ciquarter) {
        analysis.add(
            "Compound Interest Semi-Anually is the best if  not include CI monthly");
      } else if (provider.ciquarter > provider.si &&
          provider.ciquarter > provider.cisemi &&
          provider.ciquarter > provider.ci) {
        analysis.add(
            "Compound Interest Quarterly is the best if  not include CI monthly");
      }
    }

    if (provider.si == provider.ci) {
      analysis.add("Simple Interest is equal to Compound Interest");
    }
    if (provider.si > provider.ci) {
      analysis.add("Simple Interest is greater than Compound Interest");
    }
    if (provider.si < provider.ci) {
      analysis.add("Simple Interest is less than Compound Interest");
    }
    if (provider.si == provider.cisemi) {
      analysis
          .add("Simple Interest is equal to Compound Interest Semi-Anually");
    }
    if (provider.si > provider.cisemi) {
      analysis.add(
          "Simple Interest is greater than Compound Interest Semi-Anually");
    }
    if (provider.si < provider.cisemi) {
      analysis
          .add("Simple Interest is less than Compound Interest Semi-Anually");
    }
    if (provider.si == provider.ciquarter) {
      analysis.add("Simple Interest is equal to Compound Interest Quarterly");
    }
    if (provider.si > provider.ciquarter) {
      analysis
          .add("Simple Interest is greater than Compound Interest Quarterly");
    }
    if (provider.si < provider.ciquarter) {
      analysis.add("Simple Interest is less than Compound Interest Quarterly");
    }
    if (provider.si == provider.cimonthly) {
      analysis.add("Simple Interest is equal to Compound Interest Monthly");
    }
    if (provider.si > provider.cimonthly) {
      analysis.add("Simple Interest is greater than Compound Interest Monthly");
    }
    if (provider.si < provider.cimonthly) {
      analysis.add("Simple Interest is less than Compound Interest Monthly");
    }
    if (provider.ci == provider.cimonthly) {
      analysis.add(
          "Compound Interest Anually is equal to Compound Interest Monthly");
    }
    if (provider.ci == provider.ciquarter) {
      analysis.add(
          "Compound Interest Anually is equal to Compound Interest Quarterly");
    }

    return analysis;
  }

  Widget _legends() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: legendItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(color: legendItems[index].color),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    legendItems[index].name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _analysisList() {
    if (context.watch<CIANDSIProvider>().isCalculating) {
      return Container();
    }
    log(_analysis().toString());
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: _analysis().length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _analysis()[index],
                      softWrap: true,
                      maxLines: 25,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _form() {
    CIANDSIProvider provider = context.watch<CIANDSIProvider>();
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
                onPressed: _calculate,
                child: const Text("Calculate"),
              ),
            ),
          ),
          if (provider.isCalculating)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Please wait..."),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${provider.finishedTask}/${provider.totalTasks} tasks finished",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                    ),
                  ],
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
          if (!provider.isCalculating) _legends(),
          if (!provider.isCalculating) _analysisList(),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _form();
  }
}

class LegendItem {
  final String name;
  final Color color;

  LegendItem(this.name, this.color);
}
