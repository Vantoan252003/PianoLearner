import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/models/achievements_model.dart';
import 'package:pianist_vip_pro/services/achievements/achievements_service.dart'
    as achievement_service;

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  final achievement_service.CoursesService _achievementsService =
      achievement_service.CoursesService();

  List<Achievement> _achievements = [];
  bool _isLoading = true;
  String? _error;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAchievements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    try {
      final achievements = await _achievementsService.getAchievements();
      setState(() {
        _achievements = achievements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshAchievements() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await _loadAchievements();
  }

  IconData _getIconFromType(String? type) {
    switch (type?.toLowerCase()) {
      case 'streak':
        return Icons.local_fire_department;
      case 'lessons':
        return Icons.school;
      case 'practice':
        return Icons.fitness_center;
      case 'score':
        return Icons.stars;
      case 'songs':
        return Icons.music_note;
      default:
        return Icons.emoji_events;
    }
  }

  Color _getColorFromIndex(int index) {
    final colors = [
      Colors.amber,
      Colors.orange,
      Colors.yellow,
      Colors.deepOrange,
      Colors.amber.shade700,
    ];
    return colors[index % colors.length];
  }

  List<Achievement> _getAchievementsByCategory(String category) {
    switch (category) {
      case 'practice':
        return _achievements
            .where((a) =>
                a.requirementType?.toLowerCase() == 'practice' ||
                a.requirementType?.toLowerCase() == 'streak')
            .toList();
      case 'learning':
        return _achievements
            .where((a) =>
                a.requirementType?.toLowerCase() == 'lessons' ||
                a.requirementType?.toLowerCase() == 'score')
            .toList();
      default:
        return _achievements;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Thành tích',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade700,
                            Colors.amber.shade900,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_achievements.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.shade600,
                        Colors.amber.shade800,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  tabs: const [
                    Tab(
                      text: 'Tất cả',
                      icon: Icon(Icons.grid_view, size: 20),
                    ),
                    Tab(
                      text: 'Luyện tập',
                      icon: Icon(Icons.fitness_center, size: 20),
                    ),
                    Tab(
                      text: 'Học tập',
                      icon: Icon(Icons.school, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      )
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade300,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Không thể tải thành tích',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _error!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _refreshAchievements,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Thử lại'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildAchievementList('all'),
                              _buildAchievementList('practice'),
                              _buildAchievementList('learning'),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementList(String category) {
    final achievements = _getAchievementsByCategory(category);

    if (achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category == 'practice'
                  ? Icons.fitness_center_outlined
                  : category == 'learning'
                      ? Icons.school_outlined
                      : Icons.emoji_events_outlined,
              color: Colors.white.withOpacity(0.3),
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              category == 'practice'
                  ? 'Chưa có thành tích luyện tập'
                  : category == 'learning'
                      ? 'Chưa có thành tích học tập'
                      : 'Chưa có thành tích nào',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy hoàn thành các nhiệm vụ để mở khóa!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshAchievements,
      color: Colors.amber,
      backgroundColor: Colors.grey.shade900,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final color = _getColorFromIndex(index);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _AchievementCard(
              achievement: achievement,
              icon: _getIconFromType(achievement.requirementType),
              color: color,
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class _AchievementCard extends StatefulWidget {
  final Achievement achievement;
  final IconData icon;
  final Color color;
  final int index;

  const _AchievementCard({
    required this.achievement,
    required this.icon,
    required this.color,
    required this.index,
  });

  @override
  State<_AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<_AchievementCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600 + (widget.index * 100)),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    widget.color.withOpacity(0.2),
                    Colors.grey.shade900.withOpacity(0.8),
                    widget.color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: widget.color.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon Section
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.color.withOpacity(0.6),
                          widget.color.withOpacity(0.2),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: 36,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Content Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.achievement.achievementName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Description
                        if (widget.achievement.description != null &&
                            widget.achievement.description!.isNotEmpty)
                          Text(
                            widget.achievement.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                        const SizedBox(height: 12),

                        // Requirement & EXP Row
                        Row(
                          children: [
                            // Requirement Badge
                            if (widget.achievement.requirementType != null &&
                                widget.achievement.requirementValue != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${widget.achievement.requirementType}: ${widget.achievement.requirementValue}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                            const Spacer(),

                            // EXP Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.color.withOpacity(0.4),
                                    widget.color.withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.stars,
                                    color: widget.color,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${widget.achievement.expReward}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: widget.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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
