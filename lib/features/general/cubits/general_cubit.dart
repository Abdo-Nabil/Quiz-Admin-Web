import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_admin/features/general/services/general_local_data.dart';
import 'package:quiz_admin/features/general/services/general_remote_data.dart';
import '../../../resources/app_strings.dart';
import 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  final GeneralLocalData generalLocalData;
  final GeneralRemoteData generalRemoteData;
  GeneralCubit(
      {required this.generalLocalData, required this.generalRemoteData})
      : super(GeneralInitial());

  static GeneralCubit getIns(BuildContext context) {
    return BlocProvider.of<GeneralCubit>(context);
  }

  late Widget selectedScreen;

  Future setInitialScreen(String routeName) async {
    await generalLocalData.setString(
      AppStrings.storedRoute,
      routeName,
    );
  }
}
