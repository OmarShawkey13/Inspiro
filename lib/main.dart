import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspiro/core/network/local/cache_helper.dart';
import 'package:inspiro/core/network/remote/dio_helper.dart';
import 'package:inspiro/core/theme/theme.dart';
import 'package:inspiro/core/utils/constants/routes.dart';
import 'package:inspiro/core/utils/my_bloc_observer.dart';
import 'package:inspiro/features/home/presentation/logic/home_cubit.dart';
import 'package:inspiro/features/home/presentation/logic/home_states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();
  final bool? isDark = await CacheHelper.getData(key: 'isDark');
  runApp(
    MyApp(
      isDark: isDark,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool? isDark;

  const MyApp({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..getQuote()
        ..changeThemeMode(fromShared: isDark),
      child: BlocBuilder<HomeCubit, HomeStates>(
        builder: (BuildContext context, HomeStates state) {
          final cubit = HomeCubit.get(context);
          return MaterialApp(
            routes: Routes.routes,
            initialRoute: Routes.home,
            debugShowCheckedModeBanner: false,
            theme: ThemesManager.lightTheme(context),
            darkTheme: ThemesManager.darkTheme(context),
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
