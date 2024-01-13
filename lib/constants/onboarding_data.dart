// This is the data class for the onboarding screen
import 'package:school_management/models/onboarding.dart';

class OnboardingData {
  static List<OnboardingModel> data = [
    OnboardingModel(
      animUrl: 'assets/lottie/dashboard.json',
      title: 'Welcome to SchoolHub',
      description:
          'Welcome to SchoolHub, where administrate your school is just one tap away!',
    ),
    OnboardingModel(
      animUrl: 'assets/lottie/manage.json',
      title: 'Tailored to Your Needs',
      description:
          'Manage all data through a friendly user interface with best user experience!',
    ),
    OnboardingModel(
        animUrl: 'assets/lottie/bus.json',
        title: 'Stay Ahead, Stay Organized',
        description:
            'Say goodbye to physical data. With SchoolHub, you\'ll manage school data more efficiently!')
  ];
}
