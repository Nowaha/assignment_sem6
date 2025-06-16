import 'package:assignment_sem6/widgets/textinput.dart';
import 'package:flutter/material.dart';

mixin FormMixin<T extends StatefulWidget> on State<T> {
  final Map<TextEditingController, String? Function(String input)> _validators =
      {};
  final Map<TextEditingController, String> _errors = {};

  bool _loading = false;
  bool get loading => _loading;
  void setLoading(bool value, {bool updateState = true}) {
    if (_loading == value) return;
    _loading = value;
    if (updateState) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (var controller in _validators.keys) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Will run all registered validators from [registerValidators] and
  /// return true if there are no errors.
  /// If there are errors, they will be shown as errors on the respective
  /// [TextEditingController]s their [TextInput] widgets.
  bool validate() {
    _errors.clear();

    _validators.forEach((controller, validator) {
      String? error = validator(controller.text);
      if (error != null) {
        _errors[controller] = error;
      }
    });

    if (_errors.isNotEmpty) {
      setState(() {});
    }

    return _errors.isEmpty;
  }

  /// Register validators for the form fields to be used in [validate].
  /// [TextEditingController]s registered here will automatically
  /// have [TextEditingController.dispose] called when the widget is disposed.
  ///
  /// These should be registered in [initState] of the widget that uses this mixin.
  void registerValidators(
    Map<TextEditingController, String? Function(String input)> newValidators,
  ) {
    _validators.addAll(newValidators);
  }

  void setError(
    TextEditingController controller,
    String error, {
    bool updateState = true,
  }) {
    if (_errors.containsKey(controller) && _errors[controller] == error) return;
    _errors[controller] = error;
    if (updateState) {
      setState(() {});
    }
  }

  void clearError(TextEditingController controller, {bool updateState = true}) {
    if (!_errors.containsKey(controller)) return;

    _errors.remove(controller);

    if (updateState) {
      setState(() {});
    }
  }

  void clearAllErrors({bool updateState = true}) {
    if (_errors.isEmpty) return;
    _errors.clear();
    if (updateState) {
      setState(() {});
    }
  }

  void _nextOnSubmitted(TextEditingController controller, bool? obscure) {
    if (controller.text.isEmpty) return;
    
    // If the field is obscured, we want to skip through the reveal button
    if (obscure == true) {
      FocusScope.of(context).nextFocus();
    }
  }

  Widget buildFormTextInput(
    String label,
    TextEditingController controller, {
    bool expand = false,
    bool? obscure,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType? keyboardType,
    ValueChanged<String>? onSubmitted,
  }) => TextInput(
    label: label,
    controller: controller,
    enabled: !loading,
    errorText: _errors[controller],
    onChanged: (_) => clearError(controller),
    obscure: obscure,
    expand: expand,
    textInputAction: textInputAction,
    keyboardType: keyboardType,
    onSubmitted: onSubmitted ?? (_) => _nextOnSubmitted(controller, obscure),
  );
}
