
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_tracker/config/app_colors.dart';
import 'package:wallet_tracker/screens/add_expense/blocs/get_categories/get_categories_cubit.dart';
import 'package:wallet_tracker/screens/auth/blocs/logout/logout_cubit.dart';
import 'package:wallet_tracker/screens/home/blocs/delete_all_records/delete_all_records_cubit.dart';
import 'package:wallet_tracker/screens/home/blocs/get_expenses/get_expenses_cubit.dart';
import 'package:wallet_tracker/screens/home/blocs/get_incomes/get_incomes_cubit.dart';
import 'package:wallet_tracker/screens/home/blocs/get_user/get_user_cubit.dart';


class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProfileAvatar(context),
          const SizedBox(width: 16),
          _buildUserInfo(context),
          const Spacer(),
          _buildActionMenu(context),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.transparent,
        child: Icon(
          CupertinoIcons.person_fill,
          color: Colors.white,
          size: 32,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome!',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        BlocBuilder<GetUserCubit, GetUserState>(
          builder: (context, state) {
            final userName = state is GetUserSuccess
                ? state.user.name
                : 'User';

            return Text(
              userName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black87,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return BlocListener<DeleteAllRecordsCubit, DeleteAllRecordsState>(
      listener: (context, state) {
        if (state is DeleteAllRecordsSuccess) {
          context.read<GetExpensesCubit>().getExpenses();
          context.read<GetCategoriesCubit>().getCategories();
          context.read<GetIncomesCubit>().getIncomes();
        }
      },
      child: PopupMenuButton<int>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        elevation: 4,
        offset: const Offset(0, 50),
        onSelected: (value) async {
          switch (value) {
            case 0:
              context.read<LogoutCubit>().logout();
              break;
            case 1:
              _showDeleteRecordsDialog(context);
              break;
          }
        },
        itemBuilder: (context) => [
          _buildPopupMenuItem(
            icon: Icons.logout,
            text: 'Logout',
            value: 0,
          ),
          _buildPopupMenuItem(
            icon: Icons.delete,
            text: 'Delete All Records',
            value: 1,
          ),
        ],
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
      ),
    );
  }

  PopupMenuItem<int> _buildPopupMenuItem({
    required IconData icon,
    required String text,
    required int value,
  }) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.black87),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteRecordsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Are you sure? All records will be deleted!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          content: Text(
            'This action cannot be undone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<DeleteAllRecordsCubit>().deleteAllRecords();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          actionsPadding: const EdgeInsets.all(16),
        );
      },
    );
  }
}