import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/g_code_generation_methods.dart';

class GcodeView extends StatelessWidget {
  final Function(int) onSaveCallback;
  const GcodeView({super.key, required this.onSaveCallback});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit1): const GoToTabIntent(0),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit2): const GoToTabIntent(1),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit3): const GoToTabIntent(2),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit4): const GoToTabIntent(3),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          //GoToTabIntent: GoToTabAction((index) => ),
        },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: FutureBuilder<List<String>>(
          future: generateGCode(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                );
              },
            );
          },
        ),
      ),),
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