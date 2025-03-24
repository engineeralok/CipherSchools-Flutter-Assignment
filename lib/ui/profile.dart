import 'package:cipherschools_flutter_assignment/core/assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../prov/auth.dart';
import '../prov/navigation.dart';
import '../ui/onboarding.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var navigationProvider = context.read<NavigationProvider>();
    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF7E3DFF),
                        width: 2,
                      ), // Border width & color
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/profile_image.png',
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          color: Color(0xFF90909F),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Khushi Sharma',
                        style: TextStyle(
                          color: Color(0xFF161719),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Image.asset(Assets.editIcon.path),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    image: Assets.accountIcon.path,
                    title: 'Account',
                    onTap: () {},
                  ),
                  Divider(),
                  _buildMenuItem(
                    image: Assets.settingsIcon.path,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  Divider(),
                  _buildMenuItem(
                    image: Assets.exportDataIcon.path,
                    title: 'Export Data',
                    onTap: () {},
                  ),
                  Divider(),
                  _buildMenuItem(
                    image: Assets.logOutIcon.path,
                    title: 'Logout',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Are you sure you want to logout?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await context.read<AuthProvider>().signOut(
                                      navigationProvider,
                                    );
                                    if (context.mounted) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const WalkthroughScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    IconData? icon,
    String? image,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
      leading: image != null ? Image.asset(image) : Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF292B2D),
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
