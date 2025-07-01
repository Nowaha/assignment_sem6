import 'package:assignment_sem6/widgets/sizedcircularprogressindicator.dart';
import 'package:flutter/material.dart';

class FetchingOverlay extends StatelessWidget {
  final bool visible;

  const FetchingOverlay({super.key, required this.visible});

  @override
  Widget build(BuildContext context) =>
      visible
          ? Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(50),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 24.0,
                      children: [
                        Text(
                          "Refreshing posts...",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedCircularProgressIndicator.square(size: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          : SizedBox.shrink();
}
