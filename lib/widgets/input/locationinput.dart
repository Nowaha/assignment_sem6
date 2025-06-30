import "package:assignment_sem6/widgets/input/text/textinput.dart";
import "package:flutter/material.dart";

class LocationInput extends StatelessWidget {
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final bool required;

  const LocationInput({
    super.key,
    required this.latitudeController,
    required this.longitudeController,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Expanded(
          child: TextInput(
            label: "Latitude ${required ? "*" : ""}",
            keyboardType: TextInputType.number,
            controller: latitudeController,
          ),
        ),
        Expanded(
          child: TextInput(
            label: "Longitude ${required ? "*" : ""}",
            keyboardType: TextInputType.number,
            controller: longitudeController,
          ),
        ),
      ],
    );
  }
}
