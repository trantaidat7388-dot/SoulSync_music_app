import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimations = List.generate(
      4,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.15,
            0.4 + (index * 0.15),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      4,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.15,
            0.4 + (index * 0.15),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Background Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.secondary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                FadeTransition(
                  opacity: _fadeAnimations[0],
                  child: SlideTransition(
                    position: _slideAnimations[0],
                    child: const _Header(),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        FadeTransition(
                          opacity: _fadeAnimations[1],
                          child: SlideTransition(
                            position: _slideAnimations[1],
                            child: const _SearchBar(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FadeTransition(
                          opacity: _fadeAnimations[2],
                          child: SlideTransition(
                            position: _slideAnimations[2],
                            child: const _FilterChips(),
                          ),
                        ),
                        const SizedBox(height: 32),
                        FadeTransition(
                          opacity: _fadeAnimations[3],
                          child: SlideTransition(
                            position: _slideAnimations[3],
                            child: const _DiscoverSection(),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Search',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surfaceLight, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD4zTvs1ZSng5Zs-6SN5e6BY4THURyLABqJuRzTseMfznR7cdc845lQnuxW_Byz_ueROCw2Hi8LXbQB_UR16NDwRAkvGIQGq4UYgSDdkZwtqAhbJSSR0LO4GYw1U9XAcqiEZUIrpVEOh07cioPqi1a42PawaVEWvSbkbqTmdUHo7oM-W1uR3o5oWQZPdph52lmM_rZAKUB2TtCdBP82GoLoClCKT7MmwfYAq0qdj7O6Unr5NCwYW8o4kMrGa1m_DtQjKdF2xDxXSw',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.search,
              color: AppColors.textMuted,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Artists, Songs, Lyrics and more',
                hintStyle: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: AppColors.textMain,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.mic,
              color: AppColors.textMuted,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatefulWidget {
  const _FilterChips();

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  int _selectedIndex = 0;
  final List<String> _filters = ['Top', 'Songs', 'Artists', 'Albums', 'Playlists', 'Genres'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: AnimatedScale(
              scale: isSelected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.25)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: isSelected ? 12 : 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textMuted,
                    ),
                    child: Text(_filters[index]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DiscoverSection extends StatelessWidget {
  const _DiscoverSection();

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'title': 'Chill\nVibes',
        'bgColor': const Color(0xFFFFD8D8).withOpacity(0.6),
        'textColor': const Color(0xFF8B4848),
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD9fxCh6ix0aWLgour1YPDsqEAdkSI_q85A_PQ-r-IpV15bFAnCSroUA2hJvtpfEecrMtv6AED61ldXvgn4uH-IiRnElltY4h_YrxbBlPx3BnrGwXGEC9aE1okxT9imLOMmawLxC-IYRS_ABtMvc3IXv7FwqF2kmLHHLjcq9SxUET6r8oSBK48CJcInyPnZPeWVO9owgW3QrGXXfzWiJtRErdJyzR2cQ_vRGO1JqxYeoT2y70dxJyRIhCrL-u-OB3Ed4A9wPIaxQw',
      },
      {
        'title': 'Pop\nHits',
        'bgColor': const Color(0xFFD8E6FF).withOpacity(0.6),
        'textColor': const Color(0xFF485E8B),
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD4zTvs1ZSng5Zs-6SN5e6BY4THURyLABqJuRzTseMfznR7cdc845lQnuxW_Byz_ueROCw2Hi8LXbQB_UR16NDwRAkvGIQGq4UYgSDdkZwtqAhbJSSR0LO4GYw1U9XAcqiEZUIrpVEOh07cioPqi1a42PawaVEWvSbkbqTmdUHo7oM-W1uR3o5oWQZPdph52lmM_rZAKUB2TtCdBP82GoLoClCKT7MmwfYAq0qdj7O6Unr5NCwYW8o4kMrGa1m_DtQjKdF2xDxXSw',
      },
      {
        'title': 'Focus\nFlow',
        'bgColor': const Color(0xFFE6FFD8).withOpacity(0.6),
        'textColor': const Color(0xFF538B48),
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAmtFifzozcQm7xAGiCL7_6Icz5OfmgQWrbVoM4jjIdaOwTrkGuVQBLHWYPVVl9KRG_eGN6qkbhIRxMzltH10xZUD1QvtBeAwFhEMq66Mk7TPZUgzzMy9oj9_OTYdmYXISguXLBSZp4MDLLhyrM7XuBFnhroFY7-npxaToy02371fr_CCidrCgPkI6CeLJPaz0JXvkLQR52PbbKa83XvoNM2l4F5Z0FYd3xtzsQF5Wj-ydFhTa2lHb92aaWFpkPlJAzR_1vTDVaVQ',
      },
      {
        'title': 'Jazz\nClub',
        'bgColor': const Color(0xFFFFF4D8).withOpacity(0.6),
        'textColor': const Color(0xFF8B7848),
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC0twC4bcYkDO_Ks18aY0qp5CTNDlfne1DHEy86WFtTl5AGTHEcFCOIBANtP_w1AmYviNfj9jrQ4svLAER01_WSQ9mTnYs4199WII8b2ASOEJp2SPHkjL88UbfbXPsHM85vqFl3uDkzkGQ6BvMzTbp6RqE0jWYOE2z7Ppsq_MfOCjK84lhjE0oBxxPbnnGLNw9WjIDH6fCXfMqWe43k0EmAHbLqNZXgLGDXaPXnk6QSWMI2rcRmPPHoavM7RqKKPYmpV4-2KLxUGg',
      },
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Discover',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'SEE ALL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(
              title: category['title'] as String,
              bgColor: category['bgColor'] as Color,
              textColor: category['textColor'] as Color,
              imageUrl: category['image'] as String,
            );
          },
        ),
      ],
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String title;
  final Color bgColor;
  final Color textColor;
  final String imageUrl;

  const _CategoryCard({
    required this.title,
    required this.bgColor,
    required this.textColor,
    required this.imageUrl,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {},
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.02 : 0.05),
                blurRadius: _isPressed ? 5 : 10,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                    height: 1.1,
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                right: -8,
                child: Transform.rotate(
                  angle: 0.26, // ~15 degrees
                  child: Container(
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
