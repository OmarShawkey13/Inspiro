import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspiro/core/theme/colors.dart';
import 'package:inspiro/core/theme/text_styles.dart';
import 'package:inspiro/core/utils/constants/spacing.dart';
import 'package:inspiro/features/home/presentation/logic/home_cubit.dart';
import 'package:inspiro/features/home/presentation/logic/home_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        final isLoading = state is HomeLoadingState;
        final hasError = state is HomeErrorState;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Inspiro'),
            actions: [
              IconButton(
                icon: Icon(cubit.isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: cubit.changeThemeMode,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : hasError
                  ? Text(
                      (state).error,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (cubit.quote != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '"${cubit.quote!.quote}"',
                                style: TextStylesManager.bold20(context)
                                    .copyWith(
                                      color: cubit.isDark
                                          ? ColorsManager.textColorDark
                                          : ColorsManager.textColor,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              verticalSpace12,
                              Text(
                                '- ${cubit.quote!.author}',
                                style:
                                    TextStylesManager.regular16(
                                      context,
                                    ).copyWith(
                                      color: cubit.isDark
                                          ? ColorsManager.subtitleColorDark
                                          : ColorsManager.subtitleColor,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        else
                          Text(
                            'اضغط على الزر للحصول على اقتباس ✨',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: cubit.getQuote,
                            icon: const Icon(Icons.refresh),
                            label: const Text('اقتباس جديد'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
