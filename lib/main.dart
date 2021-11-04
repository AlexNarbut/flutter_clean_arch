import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clear_arch/presentation/bloc/find_person_bloc/find_bloc.dart';
import 'package:flutter_clear_arch/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:flutter_clear_arch/presentation/di/di_service.dart' as di;
import 'package:flutter_clear_arch/presentation/pages/person_list_screen.dart';
import 'package:flutter_clear_arch/presentation/resources/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonListCubit>(
            create: (context) => di.sl<PersonListCubit>()),
        BlocProvider<PersonFindBloc>(
            create: (context) => di.sl<PersonFindBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          backgroundColor: AppColors.mainBackground,
          scaffoldBackgroundColor: AppColors.mainBackground,
        ),
        home: PersonListScreen(),
      ),
    );
  }
}
