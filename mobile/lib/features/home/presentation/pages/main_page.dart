import 'package:flutter/material.dart';

/// Halaman utama setelah login, berisi 4 tab dengan BottomNavigationBar
/// sesuai desain Figma (frame "Nav - Destination count: 4").
///
/// Isi tiap tab masih placeholder. Pemilik fitur mengganti widget
/// di [_tabs] dengan halaman aslinya.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  static const _tabs = <_TabItem>[
    // Beranda: kegiatan (Ibnu, M3) dan skor keaktifan (Daniartha, S3)
    _TabItem(
      label: 'Beranda',
      icon: Icons.home_rounded,
      page: _TabPlaceholder(title: 'Beranda', icon: Icons.home_rounded),
    ),
    // Riwayat kehadiran (Daniartha, M6)
    _TabItem(
      label: 'Riwayat',
      icon: Icons.history_rounded,
      page: _TabPlaceholder(title: 'Riwayat', icon: Icons.history_rounded),
    ),
    // Manajemen kelompok (Khalifa, M2)
    _TabItem(
      label: 'Kelompok',
      icon: Icons.groups_rounded,
      page: _TabPlaceholder(title: 'Kelompok', icon: Icons.groups_rounded),
    ),
    // Profil pengguna (Affan, M1)
    _TabItem(
      label: 'Profil',
      icon: Icons.person_outline_rounded,
      page: _TabPlaceholder(
        title: 'Profil',
        icon: Icons.person_outline_rounded,
      ),
    ),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Tombol back di tab selain Beranda kembali ke Beranda dulu,
    // baru keluar aplikasi jika ditekan lagi di Beranda.
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onTabTapped(0);
      },
      child: Scaffold(
        backgroundColor: _pageBackground,
        // IndexedStack menjaga state tiap tab saat berpindah tab.
        body: IndexedStack(
          index: _currentIndex,
          children: [for (final tab in _tabs) tab.page],
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: _navBorder)),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: _navInactive,
            iconSize: 28,
            selectedFontSize: 13,
            unselectedFontSize: 13,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            items: [
              for (final tab in _tabs)
                BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, required this.icon, required this.page});

  final String label;
  final IconData icon;
  final Widget page;
}

/// Isi sementara sebuah tab sampai halaman aslinya dibuat.
class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: _navInactive.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Halaman ini sedang dikembangkan',
              style: textTheme.bodyMedium?.copyWith(color: _navInactive),
            ),
          ],
        ),
      ),
    );
  }
}

// Warna dari desain Figma; dipindah ke core/theme saat tema bersama tersedia.
const Color _pageBackground = Color(0xFFF8FAFC);
const Color _navInactive = Color(0xFF374151);
const Color _navBorder = Color(0xFFE5E7EB);
