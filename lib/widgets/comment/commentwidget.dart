import 'package:assignment_sem6/config/commentmarkdownconfig.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:assignment_sem6/extension/intextension.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/util/role.dart';
import 'package:assignment_sem6/widgets/actualtextbutton.dart';
import 'package:assignment_sem6/widgets/comment/commentsection.dart';
import 'package:assignment_sem6/widgets/comment/writecomment.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/dashedlinepainter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/widget/markdown_block.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatefulWidget {
  final CommentView comment;
  final Function()? onDelete;
  final Function()? onReply;

  final bool isPreview;
  final ResourceService? resourceService;
  final String Function()? getContents;
  final Function(String contents)? setContents;

  const CommentWidget._({
    super.key,
    required this.comment,
    this.onDelete,
    this.onReply,
    this.isPreview = false,
    this.resourceService,
    this.getContents,
    this.setContents,
  });

  const CommentWidget({
    Key? key,
    required CommentView comment,
    Function()? onDelete,
    Function()? onReply,
  }) : this._(key: key, comment: comment, onDelete: onDelete, onReply: onReply);

  const CommentWidget.preview({
    Key? key,
    required CommentView comment,
    required ResourceService resourceService,
    required String Function() getContents,
    required Function(String contents) setContents,
  }) : this._(
         key: key,
         comment: comment,
         isPreview: true,
         resourceService: resourceService,
         getContents: getContents,
         setContents: setContents,
       );

  @override
  State<StatefulWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  static const double _maxHeight = 90.0;

  final _contentKey = GlobalKey();
  bool _isExpanded = false;
  bool _hasOverflow = false;
  bool _replyOpen = false;

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
      config:
          widget.isPreview
              ? commentEditMarkdownConfig(
                context: context,
                localResourceService: widget.resourceService!,
                getContents: widget.getContents!,
                setContents: widget.setContents!,
              )
              : commentMarkdownConfig(context: context),
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

    bool isReply = widget.comment.comment.replyToUUID != null;
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 42.0 : 0.0,
        top: widget.isPreview ? 0.0 : (isReply ? 16.0 : 24.0),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              color: Theme.of(context).colorScheme.surfaceContainerLow
                  .withAlpha(widget.isPreview ? 255 : 100),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        " at ${timestamp.day.toTwoDigits()} ${DateUtil.months[timestamp.month - 1]} ${timestamp.year}, ${timestamp.hour.toTwoDigits()}:${timestamp.minute.toTwoDigits()}:${timestamp.second.toTwoDigits()}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    if (canDelete)
                      IconButton(
                        icon: Icon(Icons.delete),
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    hoverColor: Theme.of(context).colorScheme.onSurface,
                  ),
                if (!isReply && widget.onReply != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _replyOpen = !_replyOpen;
                      });
                    },
                    label: Text("Reply"),
                    icon: Icon(Icons.reply),
                  ),
              ],
            ),
          ),
          if (_replyOpen)
            Stack(
              children: [
                Positioned(
                  left: CommentSection.replyLeftPadding / 2,
                  top: 0,
                  bottom: 0,
                  child: CustomPaint(
                    painter: DashedLinePainter.vertical(
                      x: 0,
                      dashHeight: 14.0,
                      dashSpacing: 8.0,
                      strokeWidth: 2.0,
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withAlpha(100),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: CommentSection.replyLeftPadding,
                    top: 16.0,
                  ),
                  child: WriteComment(
                    postUUID: widget.comment.comment.postUUID,
                    replyToUUID: widget.comment.comment.uuid,
                    onCommentAdded: () {
                      setState(() {
                        _replyOpen = false;
                      });

                      widget.onReply?.call();
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
