import 'package:assignment_sem6/data/entity/impl/group.dart';
import 'package:assignment_sem6/data/service/data/groupview.dart';
import 'package:assignment_sem6/data/service/groupservice.dart';
import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/table/textdatacell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<StatefulWidget> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  bool _isLoading = false;
  final Map<String, GroupView> _groups = {};

  void _refresh() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _groups.clear();
    });

    final service = context.read<GroupService>();
    final newGroups = await service.getAllLinked();
    setState(() {
      _groups.addAll(newGroups);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: Text("Group List"),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              DataTable(
                columnSpacing: 24.0,
                columns: [
                  DataColumn(
                    label: Text("ID"),
                    numeric: false,
                    columnWidth: const FixedColumnWidth(100),
                  ),
                  DataColumn(label: Text("Name"), numeric: false),
                  DataColumn(label: Text("Color"), numeric: false),
                  DataColumn(label: Text("Members"), numeric: true),
                  DataColumn(label: Text("Creation"), numeric: false),
                  DataColumn(label: Text("Actions"), numeric: false),
                ],
                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) =>
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                rows: [
                  for (final item in _groups.values)
                    DataRow(
                      cells: [
                        TextDataCell(item.group.uuid),
                        TextDataCell(item.group.name),
                        DataCell(
                          Container(
                            width: 16,
                            height: 16,
                            color: item.group.color,
                          ),
                        ),
                        TextDataCell(
                          item.group.uuid == Group.everyoneUUID
                              ? "Everyone"
                              : item.members.length.toString(),
                        ),
                        TextDataCell(
                          DateUtil.formatDateTimeShort(
                            item.group.creationTimestamp,
                            false,
                          ),
                        ),
                        DataCell(
                          item.group.uuid == Group.everyoneUUID
                              ? SizedBox.shrink()
                              : Row(
                                spacing: 8.0,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.edit),
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),
                ],
              ),
              // Table(
              //   border: TableBorder.all(
              //     color: Theme.of(context).colorScheme.onPrimaryContainer,
              //   ),
              //   columnWidths: const {
              //     0: FixedColumnWidth(100),
              //     1: FlexColumnWidth(2),
              //     2: FixedColumnWidth(32),
              //     3: FlexColumnWidth(1),
              //     4: FlexColumnWidth(1),
              //   },
              //   children: [
              //     TableRow(
              //       decoration: BoxDecoration(
              //         color: Theme.of(context).colorScheme.primaryContainer,
              //       ),
              //       children: [
              //         Cell.text("ID"),
              //         Cell.text("Name"),
              //         Cell.text("Color"),
              //         Cell.text("Members"),
              //         Cell.text("Actions"),
              //       ],
              //     ),
              //     for (final item in _groups.values)
              //       TableRow(
              //         children: [
              //           Cell.text(item.group.uuid),
              //           Cell.text(item.group.name),
              //           Cell(
              //             child: SizedBox(
              //               width: 16,
              //               height: 16,
              //               child: Container(
              //                 width: 16,
              //                 height: 16,
              //                 color: item.group.color,
              //               ),
              //             ),
              //           ),
              //           Cell(child: Text(item.members.length.toString())),
              //           Cell(child: Text("actions")),
              //         ],
              //       ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
