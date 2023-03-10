import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_admin/core/extensions/string_extension.dart';
import 'package:quiz_admin/features/home_screen/presentation/components/available_quizzes.dart';
import '../../../core/shared/components/background_image.dart';
import '../../../core/shared/components/error_bloc.dart';
import '../../../core/util/dialog_helper.dart';
import '../../../core/util/toast_helper.dart';
import '../../authentication/services/models/user_model.dart';
import '../../../core/shared/components/build_app_bar.dart';
import '../cubits/home_screen_cubit.dart';
import 'components/body.dart';

//
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  late UserModel userData;
  @override
  void initState() {
    ToastHelper.initializeToast(context);
    initHomeScreenWithData();
    super.initState();
  }

  initHomeScreenWithData() async {
    await HomeScreenCubit.getIns(context).getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<HomeScreenCubit, HomeScreenState>(
        listener: (context, state) {
          if (state is HomeEndLoadingWithFailureState) {
            // Navigator.pop(context);
            DialogHelper.messageDialogWithRetry(
              context,
              state.text.tr(context),
              () {
                HomeScreenCubit.getIns(context).getData();
              },
            );
          }

          //
        },
        builder: (context, state) {
          if (state is HomeScreenGetData) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: buildAppBar(
                  context: context, centerTitle: true, showAddMinus: false),
              body: Stack(
                // fit: StackFit.expand,
                children: [
                  const BackgroundImage(),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 500,
                          ),
                          child: Column(
                            children: [
                              AvailableQuizzes(state.quizzes.length),
                              Body(
                                quizzes: state.quizzes,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          //
          else if (state is HomeLoadingState) {
            return Scaffold(
              body: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  const BackgroundImage(),
                  Container(
                    color: Colors.black54,
                    child: const LoadingDialog(),
                  )
                ],
              ),
            );
          }
          //
          else if (state is HomeEndLoadingWithFailureState) {
            return Scaffold(
              body: Stack(
                children: const [
                  BackgroundImage(),
                ],
              ),
            );
          }
          //
          return const Scaffold(body: ErrorBloc());
        },
      ),
    );
  }
}
