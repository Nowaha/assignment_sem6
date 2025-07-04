import 'package:assignment_sem6/data/dao/impl/memoryresourcedao.dart';
import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/data/repo/impl/resourcerepositoryimpl.dart';
import 'package:assignment_sem6/data/service/commentservice.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/data/service/impl/resourceserviceimpl.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/fileutil.dart';
import 'package:assignment_sem6/util/validation.dart';
import 'package:assignment_sem6/widgets/comment/commentwidget.dart';
import 'package:assignment_sem6/widgets/input/text/markdowneditor.dart';
import 'package:assignment_sem6/widgets/loadingiconbutton.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteComment extends StatefulWidget {
  final String postUUID;
  final String? replyToUUID;
  final VoidCallback? onCommentAdded;

  const WriteComment({
    super.key,
    required this.postUUID,
    this.replyToUUID,
    this.onCommentAdded,
  });

  @override
  State<StatefulWidget> createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  final ResourceService _localResourceService = ResourceServiceImpl(
    repository: ResourceRepositoryImpl(dao: MemoryResourceDao()..init()),
  );
  final TextEditingController _controller = TextEditingController();
  String? errorText;
  bool _isPreviewing = false;
  bool _loading = false;

  void _onSubmit() async {
    if (_loading) return;
    setState(() {
      errorText = null;
      _loading = true;
    });

    final comment = _controller.text;
    final validationResult = Validation.isValidComment(comment);
    if (validationResult != CommentValidationResult.valid) {
      setState(() {
        errorText = validationResult.message;
        _loading = false;
      });
      return;
    }

    final authState = context.read<AuthState>();
    final commentService = context.read<CommentService>();
    final resourceService = context.read<ResourceService>();

    try {
      for (final resource in await _localResourceService.getAll()) {
        if (!_controller.text.contains(resource.uuid)) {
          continue;
        }
        await resourceService.addResource(resource);
      }

      await commentService.addComment(
        widget.postUUID,
        creatorUUID: authState.getCurrentUser!.uuid,
        contents: comment,
        replyToUUID: widget.replyToUUID,
      );
    } catch (e) {
      setState(() {
        errorText = "An error occurred while posting. Please try again.";
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = false;
      _controller.clear();
      _isPreviewing = false;
    });

    widget.onCommentAdded?.call();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: MarkdownEditor(
            controller: _controller,
            resourceService: _localResourceService,
            label: "Write a comment",
            maxLength: Validation.maxCommentLength,
            errorText: errorText,
            onChanged:
                (_) => setState(() {
                  errorText = null;
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 8,
          children: [
            IconButton.filledTonal(
              icon: Icon(Icons.add_photo_alternate_outlined),
              iconSize: 20,
              constraints: BoxConstraints(),
              onPressed: () async {
                final file = await FileUtil.pickFile(FileType.image);
                if (file == null) return;
                if (file.bytes == null || file.bytes!.isEmpty) return;

                final fileName = file.name;
                final fileExtension = fileName.split(".").last.toLowerCase();
                final resource = Resource.create(
                  type: ResourceType.image,
                  name: fileName.replaceAll(".$fileExtension", ""),
                  originalExtension: fileExtension,
                  data: file.bytes!,
                );
                await _localResourceService.addResource(resource);

                setState(() {
                  _controller.text +=
                      "\n![$fileName](${resource.uuid}|width=300)";
                });
              },
            ),
            Spacer(),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _isPreviewing = !_isPreviewing;
                });
              },
              child: const Text("Preview"),
            ),
            LoadingIconButton(
              onPressed: _onSubmit,
              label: "Post Comment",
              loading: _loading,
              icon: const Icon(Icons.send_rounded, size: 18),
            ),
          ],
        ),
        if (_isPreviewing)
          ListenableBuilder(
            listenable: _controller,
            builder:
                (context, _) => CommentWidget.preview(
                  comment: CommentView(
                    comment: Comment.create(
                      creatorUUID: authState.getCurrentUser!.uuid,
                      postUUID: widget.postUUID,
                      contents: _controller.text,
                    ),
                    creator: authState.getCurrentUser,
                  ),
                  resourceService: _localResourceService,
                  getContents: () => _controller.text,
                  setContents: (contents) {
                    _controller.text = contents;
                  },
                ),
          ),
      ],
    );
  }
}
