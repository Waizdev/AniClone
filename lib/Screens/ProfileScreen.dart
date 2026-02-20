import 'package:flutter/material.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({
    super.key,
    required this.accentColor,
  });

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = colorScheme.surfaceContainerHighest.withValues(alpha: .7);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign in to synchronize your anime',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.25,
                    color: colorScheme.onSurface.withValues(alpha: .9),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      disabledBackgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _ProfileMenuItem(
            icon: Icons.play_circle_outline,
            title: 'Player Settings',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.subtitles_outlined,
            title: 'Subtitle settings',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.info_outline,
            title: 'Help center',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: colorScheme.onSurface,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 30,
              color: colorScheme.onSurface.withValues(alpha: .9),
            ),
          ],
        ),
      ),
    );
  }
}
