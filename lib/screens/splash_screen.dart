import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Butonla geçilecek ekran

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    
    // Eğer ilk açılış değilse direkt ana sayfaya yönlendir
    if (!isFirstLaunch && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Loading durumunda loading göster
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF2F8FF),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan görseli
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              'assets/images/background.png', // arka plan görseli buraya eklenecek
              fit: BoxFit.cover,
            ),
          ),

          // Siyah yarı saydam katman (görseli karartmak için)
          Container(
            height: size.height,
            width: size.width,
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.4),
          ),

          // İçerik
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // EVISTAL Yazısı
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      children: [
                        TextSpan(text: 'EVI', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'S', style: TextStyle(color: Color(0xFF000DFF))),
                        TextSpan(text: 'TAL', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Alt Başlık
                  const Text(
                    'SMARTHOME APPLICATION',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'CHANGE YOUR LIFE FOR BETTER LIFE',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),

                  const Spacer(),

                  // "Let Get Started" Butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        // İlk açılış işaretini false olarak kaydet
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isFirstLaunch', false);
                        
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text(
                        'LET GET STARTED',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
