import 'dart:convert';

import 'package:converter_app/backdrop.dart';
import 'package:converter_app/category.dart';
import 'package:converter_app/category_tile.dart';
import 'package:converter_app/unit.dart';
import 'package:converter_app/unit_converter.dart';
import 'package:flutter/material.dart';

import 'api.dart';

/// Category Route (screen).
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory;
  Category _currentCategory;
  final _categories = <Category>[];
  var isLargeScreen = false;

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  static const _icons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',
  ];

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  // wait for our JSON asset to be loaded in (async).
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // We have static unit conversions located in our
    // assets/data/regular_units.json
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategory();
    }
  }

  Future<void> _retrieveLocalCategories() async {
    final json = DefaultAssetBundle.of(context).loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);

    if (data is! Map) {
      throw ('Data retrived from API is not a Map');
    }
    var categoryIndex = 0;
    data.keys.forEach((key) {
      final List<Unit> units = data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      var category = Category(
        name: key,
        units: units,
        color: _baseColors[categoryIndex],
        iconLocation: _icons[categoryIndex],
      );
      setState(() {
        if (categoryIndex == 0) {
          _defaultCategory = category;
        }
        _categories.add(category);
      });
      categoryIndex += 1;
    });
  }

  /// Retrieves a [Category] and its [Unit]s from an API on the web
  Future<void> _retrieveApiCategory() async {
    setState(() {
      _categories.add(Category(
        name: apiCategory['name'],
        units: [],
        color: _baseColors.last,
        iconLocation: _icons.last,
      ));
    });
    final api = Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);
    if (jsonUnits != null) {
      final units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(Unit.fromJson(unit));
      }
      setState(() {
        _categories.removeLast();
        _categories.add(Category(
          name: apiCategory['name'],
          units: units,
          color: _baseColors.last,
          iconLocation: _icons.last,
        ));
      });
    }
  }

  Widget _buildCategoryWidgets() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var _category = _categories[index];
          return CategoryTile(
            category: _category,
            onTap: _category.name == apiCategory['name'] && _category.units.isEmpty ? null : _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _categories.map((Category c) {
          return CategoryTile(
            category: c,
            onTap: _onCategoryTap,
          );
        }).toList(),
      );
    }
  }

  Widget _forTablets() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var _category = _categories[index];
        return CategoryTile(
          category: _category,
          onTap: _category.name == apiCategory['name'] && _category.units.isEmpty ? null : _onCategoryTap,
        );
      },
      itemCount: _categories.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 48.0),
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (isLargeScreen) {
            var _categoryColor = _currentCategory == null ? _defaultCategory : _currentCategory;
            return Scaffold(
              appBar: AppBar(
                title: Text('Unit Converter'),
                backgroundColor: _categoryColor.color,
                elevation: 0.0,
              ),
              body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 48.0),
                    child: _forTablets(),
                  ),
                ),
                Expanded(child: _currentCategory == null ? UnitConverter(category: _defaultCategory) : UnitConverter(category: _currentCategory)),
              ]),
            );
          } else {
            final listView = Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 48.0),
              child: _buildCategoryWidgets(),
            );

            return Backdrop(
              currentCategory: _currentCategory == null ? _defaultCategory : _currentCategory,
              frontPanel: _currentCategory == null ? UnitConverter(category: _defaultCategory) : UnitConverter(category: _currentCategory),
              backPanel: listView,
              frontTitle: Text('Unit Converter'),
              backTitle: Text('Select a Category'),
            );
          }
        },
      ),
    );
  }
}
