import 'package:assignment_sem6/config/posteditmarkdownconfig.dart';
import 'package:assignment_sem6/data/dao/impl/memoryresourcedao.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/repo/impl/resourcerepositoryimpl.dart';
import 'package:assignment_sem6/data/service/impl/resourceserviceimpl.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:assignment_sem6/mixin/formmixin.dart';
import 'package:assignment_sem6/screens/post/attachments/attachmentlist.dart';
import 'package:assignment_sem6/util/location.dart';
import 'package:assignment_sem6/widgets/collapsible/collapsible.dart';
import 'package:assignment_sem6/widgets/collapsible/collapsiblewithheader.dart';
import 'package:assignment_sem6/widgets/input/dateselector.dart';
import 'package:assignment_sem6/widgets/input/groupinput.dart';
import 'package:assignment_sem6/widgets/input/text/markdowneditor.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/toast.dart';
import 'package:assignment_sem6/util/validation.dart';
import 'package:assignment_sem6/widgets/loadingiconbutton.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/input/chiplistinput.dart';
import 'package:assignment_sem6/widgets/view/map/impl/selectpointmap.dart';
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
  final Map<String, String> _selectedGroups = {};
  final List<String> _attachments = [];
  bool _locationPickerOpen = false;
  final _selectedPoint = ValueNotifier<LatLng>(LatLng(41.8719, 12.5674));

  final ResourceService localResourceService = ResourceServiceImpl(
    repository: ResourceRepositoryImpl(dao: MemoryResourceDao()..init()),
  );

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

    _latitudeController.addListener(() {
      setState(() {
        _selectedPoint.value = LatLng(
          double.parse(_latitudeController.text),
          double.parse(_longitudeController.text),
        );
      });
    });
    _longitudeController.addListener(() {
      setState(() {
        _selectedPoint.value = LatLng(
          double.parse(_latitudeController.text),
          double.parse(_longitudeController.text),
        );
      });
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
    final resourceService = context.read<ResourceService>();

    try {
      for (final resource in await localResourceService.getAll()) {
        if (!_contentsController.text.contains(resource.uuid) &&
            !_attachments.contains(resource.uuid)) {
          continue;
        }
        await resourceService.addResource(resource);
      }

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
          groups: _selectedGroups.values.toList(),
          tags: _tags,
          attachments: _attachments,
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
    bool anyMetadataErrors =
        getError(_latitudeController) != null ||
        getError(_longitudeController) != null;

    return Screen(
      title: Text("Create Post"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      padding: EdgeInsets.zero,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 960,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: Screen.defaultPadding.copyWith(bottom: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildFormTextInput(
                      "Title *",
                      _titleController,
                      maxLength: Validation.maxPostTitleLength,
                      autoFocus: true,
                    ),

                    SizedBox(height: 12),

                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: MarkdownEditor(
                        controller: _contentsController,
                        resourceService: localResourceService,
                        label: "Contents *",
                        enabled: !loading,
                        errorText: getError(_contentsController),
                        onChanged: (_) => clearError(_contentsController),
                        maxLength: Validation.maxPostContentsLength,
                      ),
                    ),

                    SizedBox(height: 12),

                    CollapsibleWithHeader.textTitle(
                      title: "Attachments (${_attachments.length})",
                      noIntrinsicWidth: true,
                      initiallyCollapsed: true,
                      child: AttachmentList.editable(
                        attachments: _attachments,
                        resourceService: localResourceService,
                        onAttachmentAdded: (resource) {
                          setState(() {
                            _attachments.add(resource.uuid);
                          });
                        },
                        onDelete: (uuid) {
                          setState(() {
                            _attachments.remove(uuid);
                          });
                        },
                      ),
                    ),

                    Divider(height: 32),

                    CollapsibleWithHeader.textTitle(
                      title: "Post Metadata",
                      noIntrinsicWidth: true,
                      containsError: anyMetadataErrors,
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
                                IconButton.filled(
                                  onPressed: () {
                                    setState(() {
                                      _locationPickerOpen =
                                          !_locationPickerOpen;
                                    });
                                  },
                                  icon: const Icon(Icons.my_location),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Collapsible(
                              isCollapsed: !_locationPickerOpen,
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: SelectPointMap(
                                  selectedPoint: _selectedPoint.value,
                                  onPointSelected: (LatLng latLng) {
                                    setState(() {
                                      _selectedPoint.value = latLng;
                                      _latitudeController
                                          .text = LocationUtil.latLonToString(
                                        latLng.latitude,
                                      );
                                      _longitudeController
                                          .text = LocationUtil.latLonToString(
                                        latLng.longitude,
                                      );
                                    });
                                  },
                                ),
                              ),
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
                                Expanded(
                                  child: DateSelector(
                                    label: "Start Date *",
                                    selectedDate: _startTimestamp.value,
                                    onDateSelected: (newDate) {
                                      _startTimestamp.value = newDate;
                                      if (_endTimestamp.value != null &&
                                          _endTimestamp.value!.isBefore(
                                            newDate!,
                                          )) {
                                        _endTimestamp.value = _startTimestamp
                                            .value
                                            ?.add(const Duration(minutes: 5));
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: DateSelector(
                                    label: "End Date (optional)",
                                    selectedDate: _endTimestamp.value,
                                    onDateSelected: (newDate) {
                                      _endTimestamp.value = newDate;
                                      if (newDate != null &&
                                          _startTimestamp.value!.isAfter(
                                            newDate,
                                          )) {
                                        _startTimestamp.value = newDate
                                            .subtract(
                                              const Duration(minutes: 5),
                                            );
                                      }
                                      setState(() {});
                                    },
                                    clearable: true,
                                  ),
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
                            GroupInput(
                              selectedGroups: _selectedGroups,
                              onChanged:
                                  (newGroups) => setState(() {
                                    _selectedGroups.clear();
                                    _selectedGroups.addAll(newGroups);
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Divider(height: 32),
                    Text(
                      "Preview",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
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
                          config: postEditMarkdownConfig(
                            context: context,
                            localResourceService: localResourceService,
                            getContents: () => _contentsController.text,
                            setContents: (contents) {
                              setState(() {
                                _contentsController.text = contents;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: LoadingIconButton(
                    icon: Icons.send,
                    iconSize: 18.0,
                    label: "Publish Post",
                    loading: loading,
                    onPressed: _attemptToCreate,
                    textSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
