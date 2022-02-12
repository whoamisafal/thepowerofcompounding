import 'dart:developer';
import 'dart:math' as math;

mixin Interest {
  late double principal;
  late double rate;
  late double time;
  late double interest;
  late double total;

  Future<double> getInterest();

  double getTotal();
}

class SimpleInterest with Interest {
  @override
  Future<double> getInterest() async {
    return Future.delayed(const Duration(milliseconds: 50), () {
      interest = principal * (rate / 100) * time;
      return interest;
    });
  }

  @override
  double getTotal() {
    total = principal + interest;
    return total;
  }
}

class CompoundInterest with Interest {
  double _compoundValue = 1;
  void setCompoundValue(double value) {
    _compoundValue = value;
  }

  @override
  Future<double> getInterest() {
    return Future.delayed(const Duration(milliseconds: 50), () {
      if (_compoundValue == 0) {
        throw Exception("Compound value cannot be zero");
      }
      if (_compoundValue > 12) {
        throw Exception("Compound value cannot be greater than 12");
      }

      interest = principal *
          (math.pow(
                  1 + (rate / (_compoundValue * 100)), _compoundValue * time) -
              1);

      //log("$principal::$time::$_compoundValue ::" + interest.toString());
      return interest;
    });
  }

  @override
  double getTotal() {
    total = principal + interest;
    return total;
  }
}

class EMI with Interest {
  @override
  Future<double> getInterest() {
    return Future.delayed(const Duration(milliseconds: 50), () async {
      double emi = await getEMI();
      interest = emi * time * 12 - principal;
      return interest;
    });
  }

  Future<double> getEMI() {
    return Future.delayed(const Duration(milliseconds: 50), () {
      double r = (rate / 100) / 12;
      double n = time * 12;
      double e =
          principal * r * math.pow((1 + r), n) / (math.pow((1 + r), n) - 1);
      return e;
    });
  }

  @override
  double getTotal() {
    total = principal + interest;
    return total;
  }
}
