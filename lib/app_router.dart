import 'package:go_router/go_router.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/history/service_history_screen.dart';
import 'features/incidents/incidents_screen.dart';
import 'features/services/environment_form_screen.dart';
import 'features/services/new_service_screen.dart';
import 'features/services/services_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/webhooks/webhooks_screen.dart';
import 'shared/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (_, __) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/services',
          builder: (_, __) => const ServicesScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (_, __) => const NewServiceScreen(),
            ),
            GoRoute(
              path: ':id/environments/new',
              builder: (_, state) => EnvironmentFormScreen(
                serviceId: int.parse(state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              path: ':id/environments/:envId',
              builder: (_, state) => EnvironmentFormScreen(
                serviceId: int.parse(state.pathParameters['id']!),
                environmentId: int.parse(state.pathParameters['envId']!),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/incidents',
          builder: (_, __) => const IncidentsScreen(),
        ),
        GoRoute(
          path: '/webhooks',
          builder: (_, __) => const WebhooksScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/history/:serviceId',
          builder: (_, state) => ServiceHistoryScreen(
            serviceId: int.parse(state.pathParameters['serviceId']!),
            initialEnvId:
                int.tryParse(state.uri.queryParameters['env'] ?? ''),
          ),
        ),
      ],
    ),
  ],
);
