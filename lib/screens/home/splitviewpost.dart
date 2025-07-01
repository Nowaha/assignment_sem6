import 'package:assignment_sem6/screens/post/viewpost.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplitViewPost extends StatelessWidget {
  final ValueNotifier<String?> selectedListenable;
  final TimelineItem? Function(String key) getItem;
  final bool forceHidden;

  const SplitViewPost({
    super.key,
    required this.selectedListenable,
    required this.getItem,
    this.forceHidden = false,
  });

  @override
  Widget build(BuildContext context) =>
      !forceHidden
          ? ListenableBuilder(
            listenable: selectedListenable,
            builder: (context, _) {
              final value = selectedListenable.value;
              if (value != null) {
                final item = getItem(value);
                if (item == null) return SizedBox.shrink();

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(100),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ViewPost(
                      leading: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          selectedListenable.value = null;
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.fullscreen),
                          onPressed: () {
                            context.go(
                              "/post/${item.postUUID}",
                              extra: item.color,
                            );
                          },
                        ),
                      ],
                      key: ValueKey(item.key),
                      postUUID: item.postUUID,
                      backgroundColor: item.color,
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          )
          : SizedBox.shrink();
}
