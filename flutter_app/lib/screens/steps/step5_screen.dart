import 'dart:ui';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/points_provider.dart';
import '../../models/goal.dart';

class Step5Screen extends StatelessWidget {
  Step5Screen({super.key});

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    final pointsProvider = Provider.of<PointsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('你的专注卡'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 进度条
            LinearProgressIndicator(
              value: 1.0,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF667eea),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 说明文字
                  Text(
                    '把这张卡保存为手机壁纸，每天提醒自己：只做这三件事。',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 专注卡预览
                  Screenshot(
                    controller: screenshotController,
                    child: _buildFocusCard(goalProvider.challengeMode),
                  ),

                  const SizedBox(height: 20),

                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final image = await screenshotController.capture();
                            await _saveImage(image!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('专注卡已保存到相册')),
                              );
                            }
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('保存到相册'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final image = await screenshotController.capture();
                            await _shareImage(image!, context);
                            pointsProvider.shareCard();
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('分享'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667eea),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 积分信息
                  _buildPointsInfo(pointsProvider, context),

                  const SizedBox(height: 20),

                  // 小提示
                  _buildTip(),

                  const SizedBox(height: 20),

                  // 分享链接
                  _buildShareSection(pointsProvider, context),

                  const SizedBox(height: 30),

                  // 底部按钮
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            goalProvider.goBackToStep(1);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('重新选择'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showResetDialog(context, goalProvider);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('全部清空'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
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
    );
  }

  Widget _buildFocusCard(ChallengeMode mode) {
    final modeConfig = {
      ChallengeMode.daily1: '一天1件事',
      ChallengeMode.daily3: '一天3件事',
      ChallengeMode.weekly3: '一周3件事',
      ChallengeMode.monthly3: '一月3件事',
      ChallengeMode.yearly3: '2026年3件事',
      ChallengeMode.oneLife: '一生1件事',
    };

    final goals = Provider.of<GoalProvider>(
      Get.context!,
      listen: false,
    ).top3Goals;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          // 年份/标题
          Text(
            '2026',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            modeConfig[mode] ?? '专注目标',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
          const Divider(
            color: Colors.white30,
            height: 40,
            thickness: 1,
          ),

          // 目标列表
          ...List.generate(goals.length, (index) {
            final goal = goals[index];
            return _buildGoalCard(goal, index);
          }),
        ],
      ),
    );
  }

  Widget _buildGoalCard(WeightGoal goal, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // 权重标签
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${goal.weight}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 15),

          // 目标文本
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  goal.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsInfo(PointsProvider provider, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        children: [
          const Text(
            '💰 我的积分',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '${provider.points.totalPoints}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const Text(
                    '总积分',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'LV${provider.points.level}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const Text(
                    '等级',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '连续${provider.points.streak}天',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const Text(
                    '签到',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            '💡 小提示',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '把这张专注卡设为手机壁纸，每天睁开眼就能看到，时刻提醒自己',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareSection(PointsProvider provider, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            '📤 分享给你的朋友',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '让更多人用减法思维规划2026',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(
                  const ClipboardData(
                    text: 'https://sangzhexianxian.github.io/focus/',
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check, color: Colors.white),
                        SizedBox(width: 10),
                        Text('链接已复制'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.link),
              label: const Text('复制链接'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '分享获得 +15 积分',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage(Uint8List imageBytes) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/focus_card.png');
    await file.writeAsBytes(imageBytes);

    await ImageGallerySaver.saveImage(imageBytes, quality: 100);
  }

  Future<void> _shareImage(Uint8List imageBytes, BuildContext context) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/focus_card.png');
    await file.writeAsBytes(imageBytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: '我在用 FOCUS 做目标管理，只做最重要的事！',
    );
  }

  void _showResetDialog(BuildContext context, GoalProvider goalProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清空'),
        content: const Text('确定要清空所有目标吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              goalProvider.reset();
              Navigator.pop(context);
            },
            child: const Text(
              '确定',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
