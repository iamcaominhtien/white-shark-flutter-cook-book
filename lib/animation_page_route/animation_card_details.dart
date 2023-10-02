import 'package:cookbook/main.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class AnimationCardDetails1 extends StatefulWidget {
  const AnimationCardDetails1({super.key});

  @override
  State<AnimationCardDetails1> createState() => _AnimationCardDetails1State();
}

class _AnimationCardDetails1State extends State<AnimationCardDetails1> {
  final image =
      'https://images.unsplash.com/photo-1695132823558-1e27b91e34ee?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHx8&auto=format&fit=crop&w=400&q=60';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Card Details'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        itemBuilder: (context, index) {
          final title = faker.animal.name();
          final subtitle = faker.lorem.sentence();
          final color = randomColor();
          final heroTag = UniqueKey().toString();
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onTap: () {
                Navigator.of(context).push(
                  createRoute(
                    AnimationCardDetails2(
                      color: color,
                      child: CardChild(
                        image: image,
                        imageHeight: 300,
                        title: title,
                        subtitle: subtitle,
                        color: color,
                        heroTag: heroTag,
                        borderRadius: 10,
                        expand: true,
                      ),
                    ),
                  ),
                );
              },
              child: CardChild(
                  image: image,
                  title: title,
                  subtitle: subtitle,
                  imageHeight: 100,
                  color: color,
                  heroTag: heroTag,
                  borderRadius: 10),
            ),
          );
        },
        itemCount: 15,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
      ),
    );
  }
}

class CardChild extends StatelessWidget {
  const CardChild({
    super.key,
    required this.image,
    this.imageHeight = 100,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.borderRadius,
    required this.heroTag,
    this.expand = false,
  });

  final Color color;
  final String image;
  final double imageHeight;
  final double imageDuration = 0;
  final String title;
  final String subtitle;
  final double borderRadius;
  final String heroTag;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      elevation: expand ? 0 : 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: 'image$heroTag',
            child: Container(
              height: imageHeight,
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10))),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (expand)
            Expanded(child: buildHeroText(context))
          else
            buildHeroText(context)
        ],
      ),
    );
  }

  Hero buildHeroText(BuildContext context) {
    return Hero(
      tag: 'text$heroTag',
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (expand)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Pop screen')),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Route<Object?> createRoute(Widget page) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Center(child: page),
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          alignment: Alignment.center,
          scale: animation,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 50 * (1 - animation.value),
                vertical: 50 * (1 - animation.value)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10 * (1 - animation.value)),
              clipBehavior: Clip.hardEdge,
              child: child,
            ),
          ),
        );
      },
      barrierDismissible: true,
      opaque: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      reverseTransitionDuration: const Duration(milliseconds: 700));
}

class AnimationCardDetails2 extends StatelessWidget {
  const AnimationCardDetails2(
      {super.key, required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      backgroundColor: Colors.transparent,
    );
  }
}
