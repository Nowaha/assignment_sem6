import 'package:assignment_sem6/mixin/formmixin.dart';
import 'package:assignment_sem6/util/validation.dart';
import 'package:assignment_sem6/widgets/view/filter/locationrect.dart';
import 'package:flutter/material.dart';

class LocationFilter extends StatefulWidget {
  final LocationRect? locationRect;
  final Function(LocationRect?) updateLocation;

  const LocationFilter({
    super.key,
    required this.locationRect,
    required this.updateLocation,
  });

  @override
  State<StatefulWidget> createState() => _LocationFilterState();
}

class _LocationFilterState extends State<LocationFilter> with FormMixin {
  final TextEditingController nController = TextEditingController();
  final TextEditingController eController = TextEditingController();
  final TextEditingController sController = TextEditingController();
  final TextEditingController wController = TextEditingController();

  @override
  void initState() {
    super.initState();

    registerValidators({
      nController: (input) => _validateLatitude(input),
      eController: (input) => _validateLongitude(input),
      sController: (input) => _validateLatitude(input),
      wController: (input) => _validateLongitude(input),
    });

    _reset();
  }

  void _reset() {
    nController.text = widget.locationRect?.north.toString() ?? "";
    eController.text = widget.locationRect?.east.toString() ?? "";
    sController.text = widget.locationRect?.south.toString() ?? "";
    wController.text = widget.locationRect?.west.toString() ?? "";
  }

  String? _validateLatitude(input) =>
      input.isNotEmpty || !_allEmpty()
          ? Validation.isValidLatitude(input).message
          : null;

  String? _validateLongitude(input) =>
      input.isNotEmpty || !_allEmpty()
          ? Validation.isValidLongitude(input).message
          : null;

  bool _allEmpty() {
    return nController.text.isEmpty &&
        eController.text.isEmpty &&
        sController.text.isEmpty &&
        wController.text.isEmpty;
  }

  void _onSubmit() {
    clearAllErrors();
    if (!validate()) return;

    if (_allEmpty()) {
      widget.updateLocation(null);
      return;
    }

    widget.updateLocation(
      LocationRect(
        north: double.parse(nController.text),
        east: double.parse(eController.text),
        south: double.parse(sController.text),
        west: double.parse(wController.text),
      ),
    );
  }

  Widget _buildNumberInput(String letter, TextEditingController controller) =>
      Expanded(
        child: buildFormTextInput(
          "°$letter",
          controller,
          maxLength: 8,
          keyboardType: TextInputType.number,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              _buildNumberInput("N", nController),
              _buildNumberInput("E", eController),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              _buildNumberInput("S", sController),
              _buildNumberInput("W", wController),
            ],
          ),
          SizedBox(),
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  clearAllErrors();
                  nController.clear();
                  eController.clear();
                  sController.clear();
                  wController.clear();
                },
                child: Text("Clear"),
              ),
              OutlinedButton(
                onPressed: () {
                  clearAllErrors();
                  _reset();
                },
                child: Text("Reset"),
              ),
              Expanded(child: Container()),
              FilledButton(onPressed: _onSubmit, child: Text("Apply")),
            ],
          ),
        ],
      ),
    );
  }
}
