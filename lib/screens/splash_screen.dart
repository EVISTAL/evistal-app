import 'package:flutter/material.dart';
import 'home_screen.dart'; // Butonla geçilecek ekran

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
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
