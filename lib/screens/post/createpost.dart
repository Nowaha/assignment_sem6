import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/service/groupservice.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/mixin/formmixin.dart';
import 'package:assignment_sem6/widgets/collapsible/collapsiblewithheader.dart';
import 'package:assignment_sem6/widgets/input/dateselector.dart';
import 'package:assignment_sem6/widgets/input/text/markdowneditor.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/toast.dart';
import 'package:assignment_sem6/util/validation.dart';
import 'package:assignment_sem6/widgets/loadingiconbutton.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/input/chiplistinput.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  static const String routeName = "/post/create";

  const CreatePost({super.key});

  @override
  State<StatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> with FormMixin {
  final List<String> _allGroups = [];

  final _titleController = TextEditingController();
  final _contentsController = TextEditingController();
  final _latitudeController = TextEditingController(text: "41.8719");
  final _longitudeController = TextEditingController(text: "12.5674");
  final ValueNotifier<DateTime?> _startTimestamp = ValueNotifier(
    DateTime.now()
        .copyWith(millisecond: 0, microsecond: 0)
        .subtract(const Duration(minutes: 5)),
  );
  final ValueNotifier<DateTime?> _endTimestamp = ValueNotifier(
    DateTime.now().copyWith(millisecond: 0, microsecond: 0),
  );
  final List<String> _tags = [];
  final List<String> _selectedGroups = [];

  @override
  void initState() {
    super.initState();

    registerValidators({
      _titleController: (input) => Validation.isValidPostName(input).message,
      _contentsController:
          (input) => Validation.isValidPostContents(input).message,
      _latitudeController: (input) => Validation.isValidLatitude(input).message,
      _longitudeController:
          (input) => Validation.isValidLongitude(input).message,
    });

    _fetchGroups();
  }

  void _fetchGroups() async {
    final groupService = context.read<GroupService>();
    final groups = await groupService.getAll();

    if (!context.mounted) return;

    setState(() {
      _allGroups.clear();
      _allGroups.addAll(groups.map((group) => group.name).toList());
      _allGroups.remove("Everyone");
    });
  }

  void _attemptToCreate() async {
    if (loading) return;
    setLoading(true);

    clearAllErrors();
    if (!validate()) {
      setLoading(false);
      return;
    }

    final authState = context.read<AuthState>();
    final postService = context.read<PostService>();

    try {
      final post = await postService.createNewPost(
        Post.create(
          creatorUUID: authState.getCurrentUser!.uuid,
          title: _titleController.text,
          postContents: _contentsController.text,
          startTimestamp: _startTimestamp.value!.millisecondsSinceEpoch,
          endTimestamp: _endTimestamp.value?.millisecondsSinceEpoch,
          latLng: LatLng(
            double.parse(_latitudeController.text),
            double.parse(_longitudeController.text),
          ),
          groups: _selectedGroups,
          tags: _tags,
        ),
      );

      if (context.mounted) {
        Toast.showToast(
          context,
          "Post created successfully!",
          duration: ToastLength.long,
        );

        context.go("/post/${post.uuid}");
      }
    } on ArgumentError catch (error) {
      final TextEditingController controller = switch (error.name) {
        "post.title" => _titleController,
        "post.contents" => _contentsController,
        _ => _contentsController,
      };

      setError(controller, error.message);
    } catch (error) {
      setError(_contentsController, "An error occurred. Please try again.");
      print("Error during post creation: $error");
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen.scroll(
      title: Text("Create Post"),
      child: SizedBox(
        width: 960,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            buildFormTextInput(
              "Title *",
              _titleController,
              maxLength: Validation.maxPostTitleLength,
              autoFocus: true,
            ),

            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300),
              child: MarkdownEditor(
                controller: _contentsController,
                label: "Contents *",
                enabled: !loading,
                errorText: getError(_contentsController),
                onChanged: (_) => clearError(_contentsController),
                maxLength: Validation.maxPostContentsLength,
              ),
            ),

            CollapsibleWithHeader(
              title: "Post Metadata",
              noIntrinsicWidth: true,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location:",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 12),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: buildFormTextInput(
                            "Latitude *",
                            _latitudeController,
                          ),
                        ),
                        Expanded(
                          child: buildFormTextInput(
                            "Longitude *",
                            _longitudeController,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Date range:",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 12),
                    Row(
                      spacing: 8,
                      children: [
                        DateSelector(
                          label: "Start Date *",
                          selectedDate: _startTimestamp.value,
                          onDateSelected: (newDate) {
                            _startTimestamp.value = newDate;
                            if (_endTimestamp.value != null &&
                                _endTimestamp.value!.isBefore(newDate!)) {
                              _endTimestamp.value = _startTimestamp.value?.add(
                                const Duration(minutes: 5),
                              );
                            }
                            setState(() {});
                          },
                        ),
                        DateSelector(
                          label: "End Date (optional)",
                          selectedDate: _endTimestamp.value,
                          onDateSelected: (newDate) {
                            _endTimestamp.value = newDate;
                            if (newDate != null &&
                                _startTimestamp.value!.isAfter(newDate)) {
                              _startTimestamp.value = newDate.subtract(
                                const Duration(minutes: 5),
                              );
                            }
                            setState(() {});
                          },
                          clearable: true,
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Tags (${_tags.length}/${Validation.maxPostTags}):",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 8),
                    ChipListInput(
                      chips: _tags,
                      hintText: "+ Add tag",
                      maxLength: Validation.maxPostTags,
                      onChipAdded: (tag) {
                        setState(() {
                          _tags.add(tag);
                        });
                      },
                      onChipRemoved: (tag) {
                        setState(() {
                          _tags.remove(tag);
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Groups (${_selectedGroups.length}/${Validation.maxPostGroups}):",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "Leave empty to allow everyone to view the post.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 8),
                    ChipListInput(
                      chips: _selectedGroups,
                      hintText: "+ Add group",
                      maxLength: Validation.maxPostGroups,
                      onChipAdded: (group) {
                        setState(() {
                          _selectedGroups.add(group);
                        });
                      },
                      onChipRemoved: (group) {
                        setState(() {
                          _selectedGroups.remove(group);
                        });
                      },
                      suggestions: _allGroups,
                      suggestOnFocus: true,
                      strict: true,
                    ),
                  ],
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 16,
              children: [
                // OutlinedButton(child: const Text("Preview"), onPressed: () {}),
                LoadingIconButton(
                  icon: Icon(Icons.add),
                  label: "Create Post",
                  loading: loading,
                  onPressed: _attemptToCreate,
                ),
              ],
            ),

            ListenableBuilder(
              listenable: _contentsController,
              builder: (context, _) {
                if (_contentsController.text.isEmpty) {
                  return const Text("No contents to preview.");
                }
                return MarkdownWidget(
                  shrinkWrap: true,
                  selectable: false,
                  data: _contentsController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
