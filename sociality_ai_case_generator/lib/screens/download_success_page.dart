import 'package:flutter/material.dart';

import '../widgets/how_it_works_overlay.dart';

class DownloadSuccessPage extends StatelessWidget {
  const DownloadSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/app-background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFA66936).withValues(alpha: 0.48),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showHowItWorksOverlay(context),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: 33,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(48),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x60000000),
                            blurRadius: 8,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 30, 18, 18),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                'Download\nsuccessful!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall
                                    ?.copyWith(
                                      color: const Color(0xFFE02D91),
                                      fontSize: 62,
                                      fontWeight: FontWeight.w700,
                                      height: 1.06,
                                    ),
                              ),
                              const SizedBox(height: 26),
                              Text(
                                'Your case has been downloaded\nsuccessfully. You can now use it in\nyour educational programs.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: const Color(0xFF6E6E6E),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      height: 1.14,
                                    ),
                              ),
                              const SizedBox(height: 46),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(
                                  18,
                                  18,
                                  18,
                                  20,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD7DCB1),
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x42000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Try your case!',
                                      style: TextStyle(
                                        color: Color(0xFF101010),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Test your generated case in an\ninteractive simulation to see how it\nworks in practice.',
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 21,
                                        height: 1.13,
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 66,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFE02D91,
                                          ),
                                          foregroundColor: Colors.white,
                                          elevation: 5,
                                          shadowColor: const Color(0x55000000),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Start case simulation',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 66,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).popUntil((route) => route.isFirst);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE02D91),
                                    foregroundColor: Colors.white,
                                    elevation: 5,
                                    shadowColor: const Color(0x55000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  child: const Text(
                                    'Generate another case',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
