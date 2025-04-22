import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/shared/components/app_button.dart';
import 'package:mybookstore/shared/controllers/auth_controller.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthController>().getUserLogged();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColorsTheme.primary,
                      child: Text(
                        user!.name.substring(0, 2).toUpperCase(),
                        style: AppTextThemeStyleTheme.bold18.textStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Nome
                    Text(
                      user.name,
                      style: AppTextThemeStyleTheme.bold20.textStyle.copyWith(
                        color: AppColorsTheme.headerWeak,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Loja
                    Text(
                      user.store!.name,
                      style: AppTextThemeStyleTheme.regular16.textStyle,
                    ),
                    const SizedBox(height: 4),
                    // Slogan
                    Text(
                      user.store!.slogan,
                      style: AppTextThemeStyleTheme.regular14.textStyle
                          .copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          AppButton(
                            text: 'Editar',
                            onPressed: () {},
                            backgroundColor: Colors.white,
                            textColor: AppColorsTheme.primary,
                            borderColor: AppColorsTheme.line,
                            icon: AppIconsTheme.edit,
                          ),
                          const SizedBox(height: 16),
                          if (user.isAdmin)
                            AppButton(
                              text: 'Mais acessados',
                              onPressed: () {},
                              backgroundColor: Colors.white,
                              textColor: AppColorsTheme.primary,
                              borderColor: AppColorsTheme.line,
                              icon: AppIconsTheme.fire,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
