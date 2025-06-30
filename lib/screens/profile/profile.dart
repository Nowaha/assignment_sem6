import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/screens/post/postlist.dart';
import 'package:assignment_sem6/screens/profile/grouplist.dart';
import 'package:assignment_sem6/widgets/dataholderstate.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String userUUID;

  const Profile({super.key, required this.userUUID});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends DataHolderState<Profile, User> {
  @override
  Widget content(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Profile of ${data?.firstName ?? "Unknown"} ${data?.lastName ?? ""}",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      SizedBox(height: 8),
      Text("Username: ${data?.username ?? "Unknown"}"),
      Text("Role: ${data?.role.name ?? "Unknown"}"),
      SizedBox(height: 16),
      Text("Groups", style: Theme.of(context).textTheme.headlineSmall),
      SizedBox(height: 8),
      GroupList.ofUser(userUUID: widget.userUUID),
      SizedBox(height: 16),
      Text("Posts", style: Theme.of(context).textTheme.headlineSmall),
      SizedBox(height: 8),
      PostList.ofCreator(creatorUUID: widget.userUUID),
    ],
  );

  @override
  Future<User?> getDataFromSource() async {
    final userService = context.read<UserService>();
    return await userService.getByUUID(widget.userUUID);
  }

  @override
  Widget build(BuildContext context) => Screen.scroll(
    title: Text(
      data != null ? "${data!.firstName} ${data!.lastName}" : "Loading...",
    ),
    alignment: isLoading || data == null ? Alignment.center : Alignment.topLeft,
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 960),
        child: getChild(context),
      ),
    ),
  );
}
