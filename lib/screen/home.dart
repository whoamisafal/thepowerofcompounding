import 'package:flutter/material.dart';
import 'package:powerofcompounding/model/home_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void initController() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget _widgetMenus() {
    HomeProvider provider = context.watch<HomeProvider>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          itemCount: provider.widgets.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        initController();
                        provider.setShow(index);
                      },
                      child: SizedBox(
                        height: 75,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: Text(
                                        provider.widgets[index].title,
                                        softWrap: true,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation:
                                        Tween<double>(begin: 0, end: 1).animate(
                                      CurvedAnimation(
                                        parent: _controller,
                                        curve: Curves.easeInOut,
                                      ),
                                    ),
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle:
                                            _controller.value * math.pi * 180,
                                        child: child,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(provider.widgets[index].isShow
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      )),
                  if (provider.widgets[index].isShow)
                    provider.widgets[index].screen,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 2,
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              title: const Text(
                'The Power of Compounding',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              _widgetMenus(),
              const SizedBox(
                height: 15,
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class WidgetHelperItem {
  final String title;
  final Widget screen;
  bool isShow;

  WidgetHelperItem(this.title, this.screen, this.isShow);
}
