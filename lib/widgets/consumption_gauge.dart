
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
            showFirstLabel: false,
            startAngle: 270,
            endAngle: 270,
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
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 30)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(
                          '/ $max',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                              fontSize: 14),
                        ),
                      )
                    ],
                  )),
            ],
            pointers: <GaugePointer>[
              RangePointer(
                  value: available,
                  width: 12,
                  pointerOffset: -3,
                  cornerStyle: CornerStyle.bothCurve,
                  color: Colors.white
              )

            ]),
      ],
    );

  }
}