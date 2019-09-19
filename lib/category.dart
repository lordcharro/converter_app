import 'package:converter_app/unit.dart';
import 'package:flutter/material.dart';

final _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

/// A custom [Category] widget.
/// The widget is composed on an [Icon] and [Text]. Tapping on the widget shows
/// a colored [InkWell] animation.
class Category {
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;
  final List<Unit> units;

  /// Creates a [Category].
  /// A [Category] saves the name of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  const Category({Key key, @required this.name, @required this.color, @required this.iconLocation, @required this.units})
      : assert(name != null),
        assert(color != null),
        assert(iconLocation != null),
        assert(units != null);

}
