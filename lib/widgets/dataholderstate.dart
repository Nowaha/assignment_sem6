import 'package:assignment_sem6/mixin/toastmixin.dart';
import 'package:flutter/material.dart';

abstract class DataHolderState<T extends StatefulWidget, D> extends State<T>
    with ToastMixin {
  bool _isLoading = true;
  D? data;

  bool get isLoading => _isLoading;

  LoadingState get loadingState {
    if (_isLoading) {
      return LoadingState.loading;
    } else if (data == null) {
      return LoadingState.error;
    } else {
      return LoadingState.success;
    }
  }

  Widget loadingIndicator(BuildContext context) => CircularProgressIndicator();
  Widget errorIndicator(BuildContext context) =>
      Icon(Icons.error, size: 48, color: Colors.red);
  Widget content(BuildContext context);
  Widget getChild(BuildContext context) => switch (loadingState) {
    LoadingState.loading => loadingIndicator(context),
    LoadingState.error => errorIndicator(context),
    LoadingState.success => content(context),
  };

  Future<D?> getDataFromSource();

  void refreshData() async {
    _isLoading = true;
    setState(() {});

    data = await getDataFromSource().onError((error, stackTrace) {
      showToast("There was an error loading your data.");
      print(error);

      setState(() {
        data = null;
        _isLoading = false;
      });
      return null;
    });

    if (data == null) {
      showToast("Data could not be found.");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }
}

enum LoadingState { loading, error, success }
