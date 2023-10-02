import 'package:cookbook/zoom_drawer/zoom_drawer.dart';
import 'package:cookbook/zoom_drawer/zoom_drawer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu(this.menuWidthScale, this.scaleY, {super.key});

  final double scaleY;
  final double menuWidthScale;

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: widget.scaleY * MediaQuery.of(context).size.height / 2 + 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * widget.menuWidthScale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(radius: 45),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: IconButton(
                        onPressed: () {
                          zoomDrawerCubit.toggleDrawer();
                        },
                        style: IconButton.styleFrom(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        icon: Icon(
                          Icons.menu,
                          size: 30,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 30, bottom: 20),
                child: Text(
                  'Cao Minh Tiến',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const ZoomDrawerListTile(icon: Icons.home, title: "Home"),
                    const ZoomDrawerListTile(
                        icon: Icons.payment, title: "Payment"),
                    const ZoomDrawerListTile(
                        icon: Icons.card_giftcard, title: "Promos"),
                    const ZoomDrawerListTile(
                        icon: Icons.notifications, title: "Notification"),
                    const ZoomDrawerListTile(icon: Icons.help, title: "Help"),
                    const ZoomDrawerListTile(
                        icon: Icons.info, title: "About us"),
                    const ZoomDrawerListTile(
                        icon: Icons.star_rate_outlined, title: "Rate us"),
                    Padding(
                      padding: const EdgeInsets.only(left: 28, top: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  width: 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Logout",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ZoomDrawerListTile extends StatelessWidget {
  const ZoomDrawerListTile({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocSelectorImmutableChild<ZoomDrawerCubit, ZoomDrawerState,
        IconData>(
      selector: (state) => state.page,
      builder: (context, state, child) => Material(
        color: state == icon
            ? Theme.of(context).colorScheme.primary.withRed(0)
            : Theme.of(context).colorScheme.primary,
        child: child,
      ),
      bloc: zoomDrawerCubit,
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w700),
        ),
        leading: Icon(icon,
            color: Theme.of(context).colorScheme.onPrimary, size: 30),
        contentPadding: const EdgeInsets.only(left: 30),
        onTap: () {
          if (zoomDrawerCubit.state.page != icon) {
            zoomDrawerCubit.changePage(icon);
            zoomDrawerCubit.toggleDrawer();
          }
        },
      ),
    );
  }
}

class BlocSelectorImmutableChild<B extends StateStreamable<S>, S, T>
    extends StatelessWidget {
  const BlocSelectorImmutableChild(
      {super.key,
      required this.selector,
      required this.builder,
      this.bloc,
      required this.child});

  final T Function(S bloc) selector;
  final Widget Function(BuildContext context, T state, Widget child) builder;
  final B? bloc;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, T>(
      selector: selector,
      builder: (context, state) => builder(context, state, child),
      bloc: bloc,
    );
  }
}
