import 'package:assignment_sem6/config/commentmarkdownconfig.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/extension/intextension.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/util/role.dart';
import 'package:assignment_sem6/widgets/actualtextbutton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/widget/markdown_block.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatefulWidget {
  final CommentView comment;
  final Function()? onDelete;

  const CommentWidget({super.key, required this.comment, this.onDelete});

  @override
  State<StatefulWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  static const double _maxHeight = 90.0;

  final _contentKey = GlobalKey();
  bool _isExpanded = false;
  bool _hasOverflow = false;

  late final bool canDelete;

  @override
  void initState() {
    super.initState();

    if (widget.onDelete == null) {
      canDelete = false;
    } else if (widget.comment.creator != null) {
      final authService = context.read<AuthState>();
      final currentUser = authService.getCurrentUser;
      final authorUUID = widget.comment.comment.creatorUUID;

      canDelete =
          currentUser != null &&
          (currentUser.uuid == authorUUID ||
              currentUser.role == Role.administrator ||
              currentUser.role == Role.moderator);
    } else {
      canDelete = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      widget.comment.comment.creationTimestamp,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _contentKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && mounted) {
        bool hasOverflow = renderBox.size.height > _maxHeight;
        if (hasOverflow != _hasOverflow) {
          setState(() {
            _hasOverflow = hasOverflow;
          });
        }
      }
    });

    final content = MarkdownBlock(
      key: _contentKey,
      data: widget.comment.comment.contents,
      generator: MarkdownGenerator(
        linesMargin: const EdgeInsets.symmetric(vertical: 2),
      ),
      config: commentMarkdownConfig,
    );

    final Widget? wrappedContent;
    if (!_isExpanded) {
      wrappedContent = ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          maxHeight: _maxHeight,
        ),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(scrollbars: false, overscroll: false),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: content,
          ),
        ),
      );
    } else {
      wrappedContent = SizedBox(width: double.infinity, child: content);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).colorScheme.surfaceContainerLow.withAlpha(100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              ActualTextButton(
                onTap: () {
                  context.push(
                    "/profile/${widget.comment.creator?.uuid ?? ""}",
                  );
                },
                text:
                    "${widget.comment.creator?.firstName ?? "Unknown"} ${widget.comment.creator?.lastName ?? ""}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              Expanded(
                child: Text(" commented:", style: TextStyle(fontSize: 14.0)),
              ),
              if (canDelete)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  tooltip: "Delete comment",
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(4.0),
                  iconSize: 18.0,
                  onPressed: () {
                    widget.onDelete?.call();
                  },
                ),
            ],
          ),
          Divider(height: 0),
          wrappedContent,
          if (_hasOverflow || _isExpanded)
            ActualTextButton(
              text: _isExpanded ? "Show less" : "Show more",
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              hoverColor: Theme.of(context).colorScheme.onSurface,
            ),
          Text(
            "${timestamp.day.toTwoDigits()} ${DateUtil.months[timestamp.month - 1]} ${timestamp.year}, ${timestamp.hour.toTwoDigits()}:${timestamp.minute.toTwoDigits()}:${timestamp.second.toTwoDigits()}",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
