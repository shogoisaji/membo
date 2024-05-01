import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/error_dialog.dart';

class EditListPage extends ConsumerWidget {
  const EditListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit List'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 18),

            /// New Edit
            CustomButton(
              width: 200,
              height: 50,
              color: Colors.blue,
              child: Center(
                  child: Text('New Edit', style: lightTextTheme.bodyLarge)),
              onTap: () {
                try {
                  ref.read(editPageViewModelProvider.notifier).createNewBoard();
                  context.go('/edit');
                } catch (e) {
                  ErrorDialog.show(context, e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
