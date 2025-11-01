import 'package:flutter/material.dart';
import '../../models/ranking_model.dart';
import '../../services/ranking_service/ranking_service.dart';
import '../home/widgets/app_theme.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final RankingService _rankingService = RankingService();
  List<RankingModel> rankings = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRankings();
  }

  Future<void> _loadRankings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _rankingService.getRanking();
      if (mounted) {
        setState(() {
          rankings = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.mainBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (errorMessage != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: AppColors.errorRed),
                        const SizedBox(height: 16),
                        Text(
                          'Không thể tải bảng xếp hạng',
                          style: AppTextStyles.cardTitle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage!,
                          style: AppTextStyles.smallText,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadRankings,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Thử lại'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.coursesBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadRankings,
                    child: CustomScrollView(
                      slivers: [
                        // Top 3 podium
                        if (rankings.length >= 3)
                          SliverToBoxAdapter(child: _buildPodium()),

                        // Danh sách xếp hạng
                        SliverPadding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final player = rankings[index];
                                return _buildRankingCard(player, index);
                              },
                              childCount: rankings.length,
                            ),
                          ),
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
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.cardBackgroundGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
          const SizedBox(width: AppSpacing.sm),
          const Text('Bảng Xếp Hạng', style: AppTextStyles.header),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.white10,
              borderRadius: AppRadius.small,
            ),
            child: Text(
              '${rankings.length} người chơi',
              style: AppTextStyles.badge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium() {
    final top3 = rankings.take(3).toList();
    if (top3.isEmpty) return const SizedBox();

    // Sắp xếp: 2nd - 1st - 3rd
    final List<RankingModel?> podiumOrder = [
      top3.length > 1 ? top3[1] : null, // 2nd
      top3[0], // 1st
      top3.length > 2 ? top3[2] : null, // 3rd
    ];

    final heights = [140.0, 180.0, 120.0];
    final colors = [
      Colors.grey.shade400,
      Colors.amber.shade400,
      Colors.brown.shade400,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (index) {
          final player = podiumOrder[index];
          if (player == null) return const SizedBox(width: 100);

          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Column(
              children: [
                // Avatar
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: index == 1 ? 80 : 64,
                      height: index == 1 ? 80 : 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            colors[index],
                            colors[index].withOpacity(0.6)
                          ],
                        ),
                        border: Border.all(color: colors[index], width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: colors[index].withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          player.initials,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: index == 1 ? 28 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Crown for 1st place
                    if (index == 1)
                      Positioned(
                        top: -10,
                        child: Icon(
                          Icons.workspace_premium,
                          color: Colors.amber.shade300,
                          size: 32,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Name
                Text(
                  player.fullName,
                  style: AppTextStyles.smallText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // Stats
                Text(
                  '${player.totalLessonsCompleted} bài',
                  style: AppTextStyles.tinyText.copyWith(
                    color: AppColors.white70,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Podium
                Container(
                  height: heights[index],
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colors[index], colors[index].withOpacity(0.3)],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    border: Border.all(color: colors[index], width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          index == 0
                              ? Icons.looks_two
                              : index == 1
                                  ? Icons.looks_one
                                  : Icons.looks_3,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          player.formattedLearningTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRankingCard(RankingModel player, int index) {
    final isTop3 = index < 3;
    final medalColors = [
      Colors.amber.shade400,
      Colors.grey.shade400,
      Colors.brown.shade400,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: isTop3
            ? LinearGradient(
                colors: [
                  medalColors[index].withOpacity(0.2),
                  AppColors.primaryGrey900,
                ],
              )
            : AppColors.cardBackgroundGradient,
        borderRadius: AppRadius.medium,
        border: Border.all(
          color:
              isTop3 ? medalColors[index].withOpacity(0.5) : AppColors.white10,
          width: isTop3 ? 2 : 1,
        ),
        boxShadow: isTop3
            ? [
                BoxShadow(
                  color: medalColors[index].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Rank number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isTop3 ? medalColors[index] : AppColors.white10,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#${player.ranking}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: isTop3 ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _getLevelGradient(player.levelName),
              border: Border.all(color: AppColors.white30, width: 2),
            ),
            child: Center(
              child: Text(
                player.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.fullName,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildLevelBadge(player.levelName),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Icons.school, color: AppColors.white50, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${player.totalLessonsCompleted} bài',
                      style: AppTextStyles.smallText,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stats
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.timer, color: AppColors.practiceOrange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    player.formattedLearningTime,
                    style: AppTextStyles.smallText.copyWith(
                      color: AppColors.white90,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (player.streakDays > 0)
                Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: AppColors.streakOrange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${player.streakDays} ngày',
                      style: AppTextStyles.smallText,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(String level) {
    final colors = _getLevelColors(level);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: AppRadius.small,
      ),
      child: Text(
        level,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Color> _getLevelColors(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return [Colors.green.shade600, Colors.green.shade800];
      case 'intermediate':
        return [Colors.blue.shade600, Colors.blue.shade800];
      case 'advanced':
        return [Colors.purple.shade600, Colors.purple.shade800];
      default:
        return [Colors.grey.shade600, Colors.grey.shade800];
    }
  }

  LinearGradient _getLevelGradient(String level) {
    final colors = _getLevelColors(level);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }
}
