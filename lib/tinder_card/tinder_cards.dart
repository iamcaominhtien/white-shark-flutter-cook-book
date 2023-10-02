import 'package:cookbook/tinder_card/tinder_cubit.dart';
import 'package:flutter/material.dart';

import 'tinder_card.dart';

final cubit = TinderCardsCubit();

class TinderCards extends StatefulWidget {
  const TinderCards({super.key});

  @override
  State<TinderCards> createState() => _TinderCardsState();
}

class _TinderCardsState extends State<TinderCards> {
  late final List<TinderCard> _arr = List.generate(4, (index) => tinderCard());
  int match = 0;
  int unMatch = 0;

  TinderCard tinderCard() {
    return TinderCard(
      key: GlobalKey(),
      callBack: (key, isMatch) {
        _arr.removeLast();
        // _arr = [tinderCard(),..._arr];
        _arr.insert(0, tinderCard());
        if (isMatch) {
          match++;
        } else {
          unMatch++;
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tinder cards'),
      ),
      extendBody: true,
      extendBodyBehindAppBar: false,
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 75),
            Stack(
              clipBehavior: Clip.none,
              children: [
                for (int index = 0; index < _arr.length; index++)
                  if (index == 0)
                    _arr[index]
                  else
                    Positioned.fill(
                      top: -12.0 * index,
                      bottom: 12.0 * index,
                      child: Transform.scale(
                        scale: 1.00 + 0.02 * index,
                        child: _arr[index],
                      ),
                    )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        cubit
                            .removeWidget((key: _arr.last.key, isMatch: false));
                      },
                      icon: const Icon(
                        Icons.heart_broken_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.pink.withOpacity(0.5)),
                    ),
                    Text(unMatch.toString())
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        cubit.removeWidget((key: _arr.last.key, isMatch: true));
                      },
                      icon: const Icon(
                        Icons.heart_broken,
                        size: 40,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(backgroundColor: Colors.pink),
                    ),
                    Text(match.toString())
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
