import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ethio_wallet/features/auth/controller/auth_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

class ProfilePage extends StatelessWidget {
  final AuthController _authController = AuthController();
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background as per image
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.editProfile),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Profile Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(
                      0xFFFFE0B2,
                    ), // Skin tone background from image
                    child: Text(
                      "😜",
                      style: TextStyle(fontSize: 40),
                    ), // Emoji or Image
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Donye Collins',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Iamcollinsdonye@gmail.com',
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Menu Container (The large greyish card)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF3E414E), // Dark blue-grey background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person_rounded,
                        title: 'My Account',
                        onTap: () => context.push(AppRoutes.editProfile),
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Help Center',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.phone_in_talk_rounded,
                        title: 'Contact',
                        onTap: () {},
                      ),
                      // Optional: Add Log out here or keep it as a menu item
                      _buildMenuItem(
                        icon: Icons.logout_rounded,
                        title: 'Log out',
                        onTap: () {
                          _authController.logout();
                          context.go('/sign-in');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8EAF6), // Light purple/blue icon background
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: const Color(0xFF5C6BC0), size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1A1D21), // Dark text as per image
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Color(0xFF1A1D21),
        size: 18,
      ),
    );
  }
}
