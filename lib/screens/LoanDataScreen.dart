import 'package:flutter/material.dart';

import '../utils/Spacing.dart';
import 'PersonalDataFormScreen.dart';

class LoanDataScreen extends StatefulWidget {
  const LoanDataScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoanDataScreen> createState() => _LoanDataScreenState();
}

class _LoanDataScreenState extends State<LoanDataScreen> {
  late double money;
  late String monthsText;

  Map<String, double> timeMap = {
    '1 month': 1.0,
    '3 months': 3.0,
    '6 months': 6.0,
    '1 year': 12.0
  };

  @override
  void initState() {
    money = 100.0;
    monthsText = timeMap.keys.first;
    super.initState();
  }

  List<String> computeValues() {
    double numberOfMonths = timeMap[monthsText]!;
    double monthlyRate = money / numberOfMonths + 1 / 100 * money;
    double totalPayment = monthlyRate * numberOfMonths;
    return [
      '${totalPayment.toStringAsFixed(2)} €',
      monthsText,
      '${monthlyRate.toStringAsFixed(2)} €'
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, textAlign: TextAlign.center),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Spacing(vertical: true),
            Row(
              children: [Text('What amount of money do you wish to borrow?')],
            ),
            const Spacing(vertical: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Slider(
                    value: money,
                    onChanged: (newValue) {
                      setState(() {
                        money = newValue;
                      });
                    },
                    min: 100.0,
                    max: 1000.0,
                    divisions: 18,
                    label: '${money.round()} €',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text('${money.round()} €'),
                )
              ],
            ),
            const Spacing(vertical: true),
            Row(
              children: [Text('How long you want your loan term to be?')],
            ),
            const Spacing(vertical: true),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton<String>(
                isExpanded: true,
                value: monthsText,
                icon: const Icon(Icons.arrow_downward),
                elevation: 4,
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    monthsText = newValue!;
                  });
                },
                items: timeMap.keys
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Text(value),
                                ],
                              ),
                            ))
                    .toList(),
              ),
            ),
            const Spacing(vertical: true),
            Table(
              children: [
                TableRow(
                    children:
                        const ['Total Payment', 'Total Period', 'Monthly Rate']
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e, textAlign: TextAlign.center),
                                ))
                            .toList()),
                TableRow(
                    children: computeValues()
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ))
                        .toList())
              ],
            ),
            Expanded(child: Container()),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: ElevatedButton(
                      child: const Text('Agree & Continue'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => PersonalDataFormScreen(
                                    title: widget.title))));
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
