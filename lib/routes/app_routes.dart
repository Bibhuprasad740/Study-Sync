import 'package:flutter/material.dart';

import '../presentation/login_screen/login_screen.dart';
import '../presentation/notifications_tab/notifications_tab.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/profile_tab/profile_tab.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/revisions_tab/revisions_tab.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/statistics_dashboard/statistics_dashboard.dart';
import '../presentation/studies_tab/studies_tab.dart';
import '../presentation/subjects_view/subjects_view.dart';
import '../presentation/topic_detail_modal/topic_detail_modal.dart';
import '../presentation/topics_view/topics_view.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String revisionsTab = '/revisions-tab';
  static const String login = '/login-screen';
  static const String studiesTab = '/studies-tab';
  static const String subjectsView = '/subjects-view';
  static const String registration = '/registration-screen';
  static const String profileTab = '/profile-tab';
  static const String topicsView = '/topics-view';
  static const String notificationsTab = '/notifications-tab';
  static const String topicDetailModal = '/topic-detail-modal';
  static const String statisticsDashboard = '/statistics-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    revisionsTab: (context) => const RevisionsTab(),
    login: (context) => const LoginScreen(),
    studiesTab: (context) => const StudiesTab(),
    subjectsView: (context) => const SubjectsView(),
    registration: (context) => const RegistrationScreen(),
    profileTab: (context) => ProfileTab(),
    topicsView: (context) => const TopicsView(),
    notificationsTab: (context) => const NotificationsTab(),
    topicDetailModal: (context) => const TopicDetailModal(),
    statisticsDashboard: (context) => const StatisticsDashboard(),
  };
}