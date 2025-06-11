import 'package:assignment_sem6/state/authstate.dart';
import 'package:provider/provider.dart';

final authProviders = [ChangeNotifierProvider(create: (_) => AuthState())];
