import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/supabase/db/supabase_repository.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:uuid/uuid.dart';

class EditListPage extends ConsumerWidget {
  const EditListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 171, 255),
        title: const Text('Edit List'),
      ),
      // backgroundColor: const Color(0xFFEE9AD2),
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              height: h,
              width: double.infinity,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return SvgPicture.asset(
                    'assets/svg/texture.svg',
                    // width: w / 2,
                    // fit: BoxFit.fill,
                  );
                },
              ),
              // Row(
              //   children: [
              //     Column(
              //       children: [
              //         Expanded(
              //           child: SvgPicture.asset(
              //             'assets/svg/texture.svg',
              //             width: w / 2,
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //         Expanded(
              //           child: SvgPicture.asset(
              //             'assets/svg/texture.svg',
              //             width: w / 2,
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //         Expanded(
              //           child: SvgPicture.asset(
              //             'assets/svg/texture.svg',
              //             width: w / 2,
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //       ],
              //     ),
              //     Column(
              //       children: [
              //         Expanded(
              //           child: SvgPicture.asset(
              //             'assets/svg/texture.svg',
              //             width: w / 2,
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //         Expanded(
              //           child: SvgPicture.asset(
              //             'assets/svg/texture.svg',
              //             width: w / 2,
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //         Expanded(
              //           child: SvgPicture.asset(
              //             'assets/svg/texture.svg',
              //             width: w / 2,
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ),
            Align(
              alignment: Alignment.center,
              child: CustomButton(
                width: 200,
                height: 50,
                color: Colors.blue,
                child: Center(
                    child: Text('New Edit', style: lightTextTheme.bodyLarge)),
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
              alignment: const Alignment(0, 0.5),
              child: CustomButton(
                width: 200,
                height: 50,
                color: Colors.orange,
                child: Center(
                    child: Text('setId', style: lightTextTheme.bodyLarge)),
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
            Align(
              alignment: const Alignment(0, -0.3),
              child: CustomButton(
                width: 200,
                height: 50,
                color: Colors.red,
                child:
                    Center(child: Text('add', style: lightTextTheme.bodyLarge)),
                onTap: () {
                  try {
                    final newObject = ObjectModel(
                      objectId: const Uuid().v4(),
                      type: ObjectType.text,
                      positionX: Random().nextInt(1000).toDouble(),
                      positionY: Random().nextInt(1000).toDouble(),
                      angle: Random().nextDouble(),
                      scale: Random().nextDouble() * 100,
                      text: '123Hello',
                      creatorId: '1',
                      createdAt: DateTime.now(),
                      bgColor: '0xFF000000',
                    );
                    ref
                        .read(editPageViewModelProvider.notifier)
                        .addObject(newObject);
                  } catch (e) {
                    ErrorDialog.show(context, e.toString());
                  }
                },
              ),
            ),
            Align(
                alignment: const Alignment(-0.53, -0.8),
                child: Text(ref
                    .watch(editPageViewModelProvider)
                    .selectedBoardId
                    .toString())),
          ],
        ),
      ),
    );
  }
}
