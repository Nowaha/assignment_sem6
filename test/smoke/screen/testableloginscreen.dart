import 'package:assignment_sem6/data/dao/impl/memoryuserdao.dart';
import 'package:assignment_sem6/data/dao/userdao.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/repo/impl/userrepositoryimpl.dart';
import 'package:assignment_sem6/data/repo/userrepository.dart';
import 'package:assignment_sem6/data/service/impl/userserviceimpl.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/screens/login/login.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/widgets/loadingiconbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../widget/testwithservicemixin.dart';

class TestableLoginScreen
    with TestWithService<User, UserDao, UserRepository, UserService> {
  late final AuthState authState;

  Finder? usernameFinder;
  Finder? passwordFinder;
  Finder? submitFinder;
  Finder? loggedInTextFinder;

  TestableLoginScreen({required WidgetTester tester}) {
    this.tester = tester;
    authState = AuthState();
    dao = MemoryUserDao();
    repo = UserRepositoryImpl(dao: dao);
    service = UserServiceImpl(repository: repo);
  }

  Future<void> pump() async {
    await pumpWithService(
      child: MaterialApp(home: LoginPage()),
      other: [ChangeNotifierProvider<AuthState>.value(value: authState)],
    );

    usernameFinder = find.byType(TextField).first;
    passwordFinder = find.byType(TextField).last;
    submitFinder = find.byType(LoadingIconButton);
    loggedInTextFinder = find.text("Logged in");
  }

  Future<User> createUser({
    required String username,
    required String plainTextPassword,
    String firstName = "Test",
    String lastName = "User",
    String email = "example@example.com",
  }) async {
    final user = User.newUser(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      plainTextPassword: plainTextPassword,
    );
    await dao.insert(user);
    return user;
  }

  Future<void> enterUsername(String username) async =>
      tester.enterText(usernameFinder!, username);

  Future<void> enterPassword(String password) async =>
      tester.enterText(passwordFinder!, password);

  Future<void> tapSubmit() async {
    await tester.tap(submitFinder!);
    await tester.pumpAndSettle();
  }

  Future<void> expectErrorText(String text) async =>
      expect(find.text(text), findsOneWidget);

  Future<void> expectNoErrorText(String text) async =>
      expect(find.text(text), findsNothing);
}
