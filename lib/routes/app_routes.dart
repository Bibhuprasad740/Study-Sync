import 'package:flutter/material.dart';
import '../presentation/revisions_tab/revisions_tab.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/studies_tab/studies_tab.dart';
import '../presentation/subjects_view/subjects_view.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/profile_tab/profile_tab.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String revisionsTab = '/revisions-tab';
  static const String login = '/login-screen';
  static const String studiesTab = '/studies-tab';
  static const String subjectsView = '/subjects-view';
  static const String registration = '/registration-screen';
  static const String profileTab = '/profile-tab';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    revisionsTab: (context) => const RevisionsTab(),
    login: (context) => const LoginScreen(),
    studiesTab: (context) => const StudiesTab(),
    subjectsView: (context) => const SubjectsView(),
    registration: (context) => const RegistrationScreen(),
    profileTab: (context) => ProfileTab(),
    // TODO: Add your other routes here
  };
}