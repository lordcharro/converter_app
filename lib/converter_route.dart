import 'package:converter_app/unit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConverterRoute extends StatefulWidget {
  final List<Unit> units;
  final Color color;

  @override
  _ConverterRoute createState() => _ConverterRoute();

  const ConverterRoute({@required this.units, @required this.color})
      : assert(units != null),
        assert(color != null);
}

class _ConverterRoute extends State<ConverterRoute>
{
  @override
  Widget build(BuildContext context) {
    final unitWidgets = widget.units.map((Unit unit) {
      return Container(
        color: widget.color,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      );
    }).toList();

    return ListView(
      children: unitWidgets,
    );
  }
}
