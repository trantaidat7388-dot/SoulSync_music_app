import 'package:flutter/material.dart';
import '../screens/chat_bot_screen.dart';

class DraggableChatBot extends StatefulWidget {
  const DraggableChatBot({super.key});

  @override
  State<DraggableChatBot> createState() => _DraggableChatBotState();
}

class _DraggableChatBotState extends State<DraggableChatBot> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation nhấp nháy nhẹ
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive positioning
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Tính toán vị trí right dựa trên kích thước màn hình
    final rightPosition = screenWidth > 600 ? 32.0 : 20.0;
    
    // Bottom: cao hơn để tránh mini player và nav bar
    final bottomPosition = 240.0 + bottomPadding;
    
    return Positioned(
      right: rightPosition,
      bottom: bottomPosition,
      child: _buildChatBotButton(),
    );
  }

  Widget _buildChatBotButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatBotScreen()),
              );
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF9B54),
                    Color(0xFFF47B3C),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF47B3C).withOpacity(0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Shine effect overlay
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
                  // Fox Emoji
                  const Center(
                    child: Text(
                      '🦊',
                      style: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ),
                  
                  // Online badge
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
