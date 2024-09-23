import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sm_automation/animations.dart';
import 'package:sm_automation/widgets/animated_floating_action_button.dart';
import 'package:sm_automation/widgets/disappearing_bottom_navigation_bar.dart';
import 'package:sm_automation/widgets/disappearing_navigation_rail.dart';
import 'package:sm_automation/widgets/gcode_view.dart';
import 'package:sm_automation/widgets/graph_view.dart';

import 'utils/g_code_generation_methods.dart';
import 'widgets/canvas_settings.dart';
import 'widgets/job_settings.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: const SMAutomationApp(),
    );
  }
}

class SMAutomationApp extends StatefulWidget {
  const SMAutomationApp({super.key});

  @override
  State<SMAutomationApp> createState() => _SMAutomationAppState();
}

class _SMAutomationAppState extends State<SMAutomationApp>
    with SingleTickerProviderStateMixin {
  
  static final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);
  late final _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1250),
      value: 0,
      vsync: this);
  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);
  late final _barAnimation = BarAnimation(parent: _controller);

  //int selectedIndex = 0;
  bool controllerInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = _controller.status;
    if (width > 600) {
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      _controller.value = width > 600 ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex.value = index;
    });
  }

  Future<void> onTapFloatingButton() async {
    if (selectedIndex.value == 3) {
      saveGCode(false).then((value) {
        String message = 'File saved successfully!';
        if (!value) {
          message = 'Something went wrong';
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      });
    }
  }

  Icon? floatingButtonIcon() {
    if (selectedIndex.value == 3) {
      return const Icon(Icons.download);
    }
    return null;
  }

  Widget? floatingActionButton(animation) {
    if (selectedIndex.value == 3) {
      return AnimatedFloatingActionButton(
        animation: animation,
        onPressed: () async {
          await onTapFloatingButton();
        },
        child: floatingButtonIcon(),
      );
    }
    return null;
  }

  Widget _buildCenterWidget() {
    switch (selectedIndex.value) {
      case 0:
        return const GraphView();
      case 1:
        return CanvasSettings(
          onSaveCallback: (int index) {
            updateSelectedIndex(index);
          }
        );
      case 2:
        return const JobSettings();
      case 3:
        return GcodeView(
          onSaveCallback: (int index) {
            updateSelectedIndex(index);
          }
        );
      default:
        return const GraphView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit0): const GoToTabIntent(0),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit2): const GoToTabIntent(1),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit3): const GoToTabIntent(2),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit4): const GoToTabIntent(3),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          GoToTabIntent: GoToTabAction((index) => updateSelectedIndex(index)),
        },
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Scaffold(
              body: Row(
                children: [
                  DisappearingNavigationRail(
                    railAnimation: _railAnimation,
                    railFabAnimation: _railFabAnimation,
                    selectedIndex: selectedIndex.value,
                    backgroundColor: _backgroundColor,
                    onDestinationSelected: (index) {
                      setState(() {
                        selectedIndex.value = index;
                      });
                    },
                    floatingActionButton: floatingActionButton(_railFabAnimation),
                  ),
                  Flexible(
                      flex: 5,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildCenterWidget(),
                        ),
                      )),
                ],
              ),
              floatingActionButton: floatingActionButton(_barAnimation),
              bottomNavigationBar: DisappearingBottomNavigationBar(
                barAnimation: _barAnimation,
                selectedIndex: selectedIndex.value,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedIndex.value = index;
                  });
                },
              ),
            );
          }
        ),
      ),
    );
  }
}

class GoToTabIntent extends Intent {
  final int tabIndex;
  const GoToTabIntent(this.tabIndex);
}

class GoToTabAction extends Action<GoToTabIntent> {
  final void Function(int index) onSelectTab;

  GoToTabAction(this.onSelectTab);

  @override
  void invoke(covariant GoToTabIntent intent) {
    onSelectTab(intent.tabIndex);
  }
}