import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/error_dialog.dart';

class EditListPage extends ConsumerWidget {
  const EditListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      // backgroundColor: const Color(0xFFEE9AD2),
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          Align(
            alignment: Alignment.center,
            child: CustomButton(
              width: 200,
              height: 50,
              color: Colors.blue,
              child: Center(
                  child: Text('New Board', style: lightTextTheme.bodyLarge)),
              onTap: () {
                try {
                  // ref
                  //     .read(editPageViewModelProvider.notifier)
                  //     .createNewBoard();
                  context.go('/edit');
                } catch (e) {
                  ErrorDialog.show(context, e.toString());
                }
              },
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.3),
            child: CustomButton(
              width: 200,
              height: 50,
              color: Colors.orange,
              child: Center(
                  child: Text('My Board', style: lightTextTheme.bodyLarge)),
              onTap: () async {
                try {
                  ref
                      .read(editPageViewModelProvider.notifier)
                      .setSelectedBoardId(
                          '0996ec38-d300-4dd4-9e8b-1a887954c275');
                  context.go('/edit');
                } catch (e) {
                  ErrorDialog.show(context, e.toString());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
