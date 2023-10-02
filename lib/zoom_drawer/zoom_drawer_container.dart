import 'package:cookbook/zoom_drawer/pages/zoom_drawer_about.dart';
import 'package:cookbook/zoom_drawer/pages/zoom_drawer_help.dart';
import 'package:cookbook/zoom_drawer/pages/zoom_drawer_notification.dart';
import 'package:cookbook/zoom_drawer/pages/zoom_drawer_payment.dart';
import 'package:cookbook/zoom_drawer/pages/zoom_drawer_promos.dart';
import 'package:cookbook/zoom_drawer/pages/zoom_drawer_rate.dart';
import 'package:cookbook/zoom_drawer/zoom_drawer.dart';
import 'package:cookbook/zoom_drawer/pages/zoom_drawer_home.dart';
import 'package:cookbook/zoom_drawer/zoom_drawer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZoomDrawerContainer extends StatelessWidget {
  const ZoomDrawerContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocSelector<ZoomDrawerCubit, ZoomDrawerState, IconData>(
        selector: (state) => state.page,
        bloc: zoomDrawerCubit,
        builder: (context, state) {
          switch (state) {
            case Icons.payment:
              return const ZoomDrawerPayment();
            case Icons.card_giftcard:
              return const ZoomDrawerPromos();
            case Icons.notifications:
              return const ZoomDrawerNotification();
            case Icons.help:
              return const ZoomDrawerHelp();
            case Icons.info:
              return const ZoomDrawerAboutUs();
            case Icons.star_rate_outlined:
              return const ZoomDrawerRateUs();
            default:
              return const ZoomDrawerHome();
          }
        },
      ),
      appBar: AppBar(
        title: const Text('Zoom Drawer Home page'),
        actions: [
          IconButton(
            onPressed: () {
              zoomDrawerCubit.toggleDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
    );
  }
}
