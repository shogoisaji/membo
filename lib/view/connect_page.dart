import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/view_model/connect_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:membo/widgets/thumbnail_card.dart';

class ConnectPage extends HookConsumerWidget {
  final String? uuid;
  const ConnectPage({super.key, this.uuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final textController = useTextEditingController();
    final focusNode = useFocusNode();
    final connectPageState = ref.watch(connectPageViewModelProvider);

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    void handleCancel() {
      ref.read(connectPageViewModelProvider.notifier).clearBoard();
    }

    void handleCardView() {
      context.go('/view', extra: connectPageState.board!.boardId);
    }

    void handleCodeSearch() {
      //
    }

    void checkBoard() async {
      if (uuid == null) return;
      try {
        await ref
            .read(connectPageViewModelProvider.notifier)
            .checkBoardExist(uuid!);
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, "$e");
        }
      }
    }

    useEffect(() {
      checkBoard();
      return null;
    }, [uuid]);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 36),
            onPressed: () {
              context.go('/');
            },
          ),
          title: Text('コネクト', style: lightTextTheme.titleLarge),
        ),
        body: Stack(
          children: [
            BgPaint(width: w, height: h),
            SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'ボードID',
                                  style: lightTextTheme.bodyLarge!.copyWith(),
                                ),
                              ),
                              TextFormField(
                                // autofocus: true,
                                focusNode: focusNode,
                                controller: textController,
                                style: lightTextTheme.bodyMedium,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    counterText: '',
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: MyColor.greenText),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: MyColor.greenText),
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '入力欄が空です';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              CustomButton(
                                width: 170,
                                height: 45,
                                color: MyColor.greenDark,
                                child: Center(
                                    child: Text(
                                  '検索',
                                  style: lightTextTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                                )),
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    handleCodeSearch();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: MyColor.greenText,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'or',
                              style: lightTextTheme.bodyLarge,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: MyColor.greenText,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          width: 170,
                          height: 45,
                          color: MyColor.blue,
                          child: Center(
                              child: Text(
                            'QRスキャン',
                            style: lightTextTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                          )),
                          onTap: () {
                            context.go('/qr-scan');
                          },
                        ),
                        const SizedBox(height: 40),

                        /// scanned board
                        connectPageState.board == null
                            ? const SizedBox.shrink()
                            : ThumbnailCard(
                                boardModel: connectPageState.board!,
                                onCancelTap: handleCancel,
                                onViewTap: handleCardView),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
