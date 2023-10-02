import 'package:flutter/material.dart';

import 'grid_number_widget.dart';

class GridNumbers extends StatelessWidget {
  const GridNumbers({
    super.key,
    required this.width,
    required this.size,
    required this.height,
  });

  final double width;
  final Size size;
  final double height;

  @override
  Widget build(BuildContext context) {
    final appbarHeight = Scaffold.of(context).appBarMaxHeight ?? 0.0;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (width / size.width).floor()),
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GridNumberWidget(
          size: size,
          index: index,
        );
      },
      itemCount: (width / size.width).floor() *
          ((height - appbarHeight) / size.height).floor(),
    );
  }
}
