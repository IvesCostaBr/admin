import 'package:core_dashboard/controllers/auth.dart';
import 'package:core_dashboard/controllers/config.dart';
import 'package:core_dashboard/providers/user.dart';
import 'package:core_dashboard/shared/constants/config.dart';
import 'package:core_dashboard/shared/constants/defaults.dart';
import 'package:core_dashboard/shared/constants/extensions.dart';
import 'package:core_dashboard/shared/constants/ghaps.dart';
import 'package:core_dashboard/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final authService = Get.find<AuthService>();
  final configController = Get.find<ConfigController>();
  final userProvider = Get.find<UserProvider>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await authService.login(_emailController.text, _passwordController.text);
        await authService.fetchUserData();
        final userData = userProvider.userData;
        if (userData!["is_admin"] == false || userData["consumer_id"] == null){
          throw Exception("Usuário não autenticado");
        }
        Get.offAllNamed('/home');
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 296,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDefaults.padding * 1.5,
                        ),
                        child: Image.asset(AppConfig.logo),
                      ),
                      Text(
                        'Sign In',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      Text(
                        'Digite o seu email',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      gapH16,
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/mail_light.svg',
                            height: 16,
                            width: 20,
                            fit: BoxFit.none,
                          ),
                          suffixIcon: SvgPicture.asset(
                            'assets/icons/check_filled.svg',
                            width: 17,
                            height: 11,
                            fit: BoxFit.none,
                            colorFilter: AppColors.success.toColorFilter,
                          ),
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'digite seu email';
                          }
                          return null;
                        },
                      ),
                      gapH16,
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/lock_light.svg',
                            height: 16,
                            width: 20,
                            fit: BoxFit.none,
                          ),
                          hintText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      gapH16,
                      Obx(() {
                        return authService.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: 296,
                              child: ElevatedButton(
                                onPressed: _login,
                                child: const Text('Sign in'),
                              ),
                            );
                      }),
                      gapH16,
                      Obx(() {
                        return authService.errorMessage.value.isNotEmpty
                          ? Text(
                              authService.errorMessage.value,
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox.shrink();
                      }),
                      gapH24,
                      Text(
                        'This site is protected by reCAPTCHA and the Google Privacy Policy.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
