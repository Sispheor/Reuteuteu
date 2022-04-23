
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ConsumptionGauge extends StatelessWidget {
  const ConsumptionGauge({
    Key? key,
    required this.max,
    required this.available
  }) : super(key: key);

  final double max;
  final double available;

  @override
  Widget build(BuildContext context) {

    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            radiusFactor: 0.8,
            minimum: 0,
            maximum: max,
            axisLineStyle: const AxisLineStyle(
                cornerStyle: CornerStyle.startCurve, thickness: 5),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 90,
                  positionFactor: 0,
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(available.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 30)),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(
                          'days',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 14),
                        ),
                      )
                    ],
                  )),
              const GaugeAnnotation(
                angle: 124,
                positionFactor: 1.1,
                widget: Text('0', style: TextStyle(fontSize: 14)),
              ),
              GaugeAnnotation(
                angle: 54,
                positionFactor: 1.1,
                widget: Text(max.toString(),
                    style: const TextStyle(fontSize: 14)),
              ),
            ],
            pointers: <GaugePointer>[
              RangePointer(
                  value: available,
                  width: 18,
                  pointerOffset: -6,
                  cornerStyle: CornerStyle.bothCurve,
                  color: Colors.green
              )

            ]),
      ],
    );

  }
}