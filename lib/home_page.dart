import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationController2;
  late Animation<Offset> _stoneAnimation;
  late Animation<Offset> _pikachuAnimation;

  bool isJumping = false;
  bool hasStarted = false;

  GlobalKey _pikachuKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _stoneAnimation = Tween<Offset>(
      begin: const Offset(-0.3, -0.6),
      end: const Offset(0.3, -0.6),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pikachuAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -0.7),
    ).animate(CurvedAnimation(
      parent: _animationController2,
      curve: Curves.decelerate,
    ));

    _animationController.addListener(() {
      final RenderBox pikachuRB =
          _pikachuKey.currentContext!.findRenderObject() as RenderBox;
      Offset widgetOffset = pikachuRB.localToGlobal(Offset.zero);
      print("X: ${widgetOffset.dx}");
      print("Y: ${widgetOffset.dy}");
      setState(() {});
    });
    // _animationController.repeat(reverse: true);

    // Animate stone to move repeatedly
    _animationController.repeat(reverse: true);

    _animationController2.addListener(() {
      setState(() {});
    });

    // _animationController2.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  // Make Pikachu jump
  void jump() {
    // Change image from stay to jump
    setState(() {
      isJumping = true;
      hasStarted = true;
    });

    // // Animate stone to move repeatedly
    // _animationController.repeat(reverse: true);

    // Animate image to go up only once
    _animationController2.forward().whenComplete(() {
      _animationController2.reverse().whenComplete(() => setState(() {
            isJumping = false;
          }));
    });

    // Check if pikachu collides with stone or not
  }

  void stay() {
    // Change image from jump to stay
    setState(() {
      isJumping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Score: 0',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 200,
          ),
          SlideTransition(
            position: _pikachuAnimation,
            child: Container(
              width: 150,
              height: 150,
              key: _pikachuKey,
              child: isJumping
                  ? Image.asset('assets/jump.png')
                  : Image.asset(
                      'assets/stay.png',
                    ),
            ),
          ),
          SlideTransition(
            position: _stoneAnimation,
            child: Container(
                width: 110,
                height: 110,
                child: Image.asset(
                  'assets/stone.png',
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
                onPressed: () {
                  jump();
                },
                child: const Text('Jump')),
          )
        ],
      ),
    );
  }
}
