import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_tracker/core/di/injection_container.dart';
import 'package:wallet_tracker/screens/auth/blocs/login/login_cubit.dart';
import 'package:wallet_tracker/screens/auth/blocs/sign_up/sign_up_cubit.dart';
import 'package:wallet_tracker/screens/auth/views/login_screen.dart';
import 'package:wallet_tracker/screens/auth/views/sign_up_screen.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(20, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-2.7, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.3,
                  width: MediaQuery.of(context).size.width / 1.3,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(2.7, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.3,
                  width: MediaQuery.of(context).size.width / 1.3,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container()),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: TabBar(
                          controller: _tabController,
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          labelColor:
                              Theme.of(context).colorScheme.onSurface,
                          tabs: const [
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Sign up',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: MultiBlocProvider(
                        providers: [
                          BlocProvider(
                              create: (context) => locator<LoginCubit>()),
                          BlocProvider(
                              create: (context) => locator<SignUpCubit>()),
                        ],
                        child: TabBarView(
                            controller: _tabController,
                            children: const [
                              LoginScreen(),
                              SignUpScreen(),
                            ]),
                      ))
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: Center(
                      child: Text(
                        'Welcome back!',
                        style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
