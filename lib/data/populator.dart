import 'dart:math';

import 'package:assignment_sem6/data/dao/commentdao.dart';
import 'package:assignment_sem6/data/dao/groupdao.dart';
import 'package:assignment_sem6/data/dao/postdao.dart';
import 'package:assignment_sem6/data/dao/userdao.dart';
import 'package:assignment_sem6/data/entity/impl/group.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/groupservice.dart';
import 'package:assignment_sem6/util/generate.dart';
import 'package:assignment_sem6/util/password.dart';
import 'package:assignment_sem6/util/role.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:assignment_sem6/util/uuid.dart';
import 'package:flutter/material.dart';

class Populator {
  static final Random rand = Random();
  static final User testAdminUser = User(
    uuid: "2ff4e446-504e-4d5d-90e2-ce708f94d20e",
    creationTimestamp: Time.nowAsTimestamp(),
    username: "Admin",
    firstName: "Admin",
    lastName: "To Test",
    email: "admin@pm.me",
    hashedPassword: Password.hash("123456"),
    role: Role.administrator,
  );

  final UserDao userDao;
  final GroupService groupService;
  final PostDao postDao;
  final CommentDao commentDao;

  Populator({
    required this.userDao,
    required this.groupService,
    required this.postDao,
    required this.commentDao,
  });

  void populate() async {
    final GroupDao groupDao = groupService.repository.dao;
    await userDao.insert(testAdminUser);

    for (int i = 0; i < 25; i++) {
      final first = Generate.firstName();
      final last = Generate.lastName();
      final username = Generate.username(first: first, last: last);
      final user = User(
        uuid: UUIDv4.generate(),
        creationTimestamp: Time.nowAsTimestamp(),
        role: rand.nextInt(100) > 80 ? Role.moderator : Role.regular,
        hashedPassword: Password.hash("password$i"),
        username: username,
        firstName: first,
        lastName: last,
        email: "$username@example.com",
      );
      await userDao.insert(user);
    }

    await groupDao.insert(Group.create(name: "Lead", color: Colors.red));
    await groupDao.insert(
      Group.create(name: "Researcher", color: Colors.purple),
    );
    await groupDao.insert(Group.create(name: "Field", color: Colors.green));
    await groupDao.insert(Group.create(name: "Lab", color: Colors.white));
    await groupDao.insert(
      Group.create(name: "Geologist", color: Colors.yellow),
    );
    await groupDao.insert(Group.create(name: "Operations", color: Colors.blue));
    await groupDao.insert(
      Group.create(name: "Seismologist", color: Colors.orange),
    );
    await groupDao.insert(Group.create(name: "Guest", color: Colors.grey));
    await groupDao.insert(
      Group.create(name: "External", color: Colors.grey[800]!),
    );

    final Iterable<User> users = await userDao.findAll();
    final Iterable<Group> groups = await groupDao.findAll();
    for (final user in users) {
      Group group1;
      do {
        group1 = groups.elementAt(rand.nextInt(groups.length));
      } while (group1.uuid == Group.everyoneUUID);

      Group group2;
      do {
        group2 = groups.elementAt(rand.nextInt(groups.length));
      } while (group2.uuid == Group.everyoneUUID || group2.uuid == group1.uuid);

      await groupService.addMember(group1.uuid, user.uuid);
      await groupService.addMember(group2.uuid, user.uuid);
    }

    final DateTime startTime = DateTime.now().subtract(
      const Duration(days: 30),
    );
    final DateTime endTime = DateTime.now();
    await postDao.insert(
      Post.create(
        creatorUUID: testAdminUser.uuid,
        startTimestamp: startTime.millisecondsSinceEpoch,
        endTimestamp: startTime.millisecondsSinceEpoch + (1000 * 60 * 5),
        title: "Example post to start",
        postContents: Generate.paragraph(20),
        tags: ["welcome", "introduction"],
        latLng: Generate.location(),
      ),
    );

    for (
      int i = startTime.millisecondsSinceEpoch;
      i < endTime.millisecondsSinceEpoch;
      i += 1000 * 60 * 30
    ) {
      await postDao.insert(
        Post.create(
          creatorUUID: users.elementAt(rand.nextInt(users.length)).uuid,
          startTimestamp: i.toInt(),
          endTimestamp: i.toInt() + (1000 * 60 * (15 + (5 * rand.nextInt(10)))),
          title: Generate.sentence(rand.nextInt(5) + 5),
          postContents: Generate.paragraph(rand.nextInt(10) + 10),
          tags: ["example", Generate.word()],
          groups: [Group.everyoneUUID],
          latLng: Generate.location(),
        ),
      );
    }
  }
}
