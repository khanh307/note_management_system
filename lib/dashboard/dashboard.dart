import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: DChartPie(
          data: const [
            {'domain': 'Pending', 'measure': 70},
            {'domain': 'Done', 'measure': 60},
            {'domain': 'Processing', 'measure': 88},
          ],
          fillColor: (pieData, index) {
            switch (pieData['domain']) {
              case 'Processing':
                return Colors.grey[600];
              case 'Done':
                return Colors.blue[900];
              default:
                return Colors.red;
            }
          },
          labelColor: Colors.white,
          labelPosition: PieLabelPosition.inside,
          labelFontSize: 15,
          labelLineThickness: 1,
          labelLinelength: 16,
          labelPadding: 5,
          pieLabel: (Map<dynamic, dynamic> pieData, int? index) {
            return pieData['domain'] +
                ': ' +
                pieData['measure'].toString() +
                '%';
          },
          strokeWidth: 2,
          animationDuration: const Duration(milliseconds: 1200),
        ),
      ),
    );
  }
}
