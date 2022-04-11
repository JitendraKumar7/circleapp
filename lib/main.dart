import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:circle/app/app.dart';

import 'modal/modal.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Bloc.observer = AppBlocObserver();
  await Firebase.initializeApp();



  final auth = await AuthenticationRepository();

  runApp(MultiProvider(child: App(repository: auth), providers: [
    ChangeNotifierProvider<ProfileModal>(create: (_) => ProfileModal()),
    FutureProvider<List<QueryDocumentSnapshot<CircleModal>>>(
      initialData: [],
      create: (context) async {
        var db = FirestoreService();
        var profile = context.read<ProfileModal>();
        print('FutureProviderProfileModal ${profile.id}');

        var circle = await db.circle
            .where('members', arrayContains: profile.phoneNumber)
            .get();

        print('FutureProviderProfileModal ${circle.size}');
        return circle.docs;
      },
    ),
  ]));
  //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
}
