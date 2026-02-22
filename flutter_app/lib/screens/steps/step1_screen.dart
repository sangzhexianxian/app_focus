import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/goal_provider.dart';

class Step1Screen extends StatelessWidget {
  const Step1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('第一步：倒出所有目标'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 进度条
          LinearProgressIndicator(
            value: 0.2,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF667eea),
            ),
          ),

          // 内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 提示框
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(
                        left: BorderSide(color: Color(0xFF667eea), width: 4),
                      ),
                    ),
                    child: const Text(
                      '💡 提示：不要筛选，不要排序，把脑子里所有想做的事情都写下来。',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 说明文字
                  Text(
                    '把你2026年想做的所有事情都写下来，不限数量，不用排序。让大脑清空。',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 输入框
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: '在这里输入你的目标，按回车键确认...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF667eea)),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                    ),
                    maxLines: 3,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        goalProvider.addGoal(value);
                        controller.clear();
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  // 快捷按钮
                  TextButton.icon(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        goalProvider.addGoal(controller.text);
                        controller.clear();
                      }
                    },
                    icon: const Icon(Icons.add, color: Color(0xFF667eea)),
                    label: const Text(
                      '添加目标',
                      style: TextStyle(color: Color(0xFF667eea)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 目标计数
                  Center(
                    child: Text(
                      '已记录 ${goalProvider.allGoals.length} 个目标',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 目标卡片列表
                  if (goalProvider.allGoals.isEmpty)
                    _buildEmptyState()
                  else
                    _buildGoalCards(goalProvider),

                  const SizedBox(height: 20),

                  // 挑战模式入口
                  _buildChallengeModeSelector(context, goalProvider),

                  const SizedBox(height: 30),

                  // 下一步按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: goalProvider.allGoals.isEmpty
                          ? null
                          : () {
                              goalProvider.goToStep2();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        '我写完了，下一步',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const Text('✨', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 10),
          Text(
            '在上面输入框中写下你的第一个目标',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCards(GoalProvider goalProvider) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: goalProvider.allGoals.map((goal) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFF667eea)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {
              goalProvider.toggleGoalSelection(goal.id);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(goal.icon, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    goal.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF667eea),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChallengeModeSelector(
    BuildContext context,
    GoalProvider goalProvider,
  ) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 20),
        Center(
          child: Text(
            '🎯 想挑战不同专注模式？',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildChallengeButton(
              context,
              '📅 一天1件事',
              ChallengeMode.daily1,
              goalProvider,
            ),
            _buildChallengeButton(
              context,
              '📅 一天3件事',
              ChallengeMode.daily3,
              goalProvider,
            ),
            _buildChallengeButton(
              context,
              '📆 一周3件事',
              ChallengeMode.weekly3,
              goalProvider,
            ),
            _buildChallengeButton(
              context,
              '🗓️ 一月3件事',
              ChallengeMode.monthly3,
              goalProvider,
            ),
            _buildChallengeButton(
              context,
              '🎯 2026年3件事',
              ChallengeMode.yearly3,
              goalProvider,
            ),
            _buildChallengeButton(
              context,
              '⭐ 一生1件事',
              ChallengeMode.oneLife,
              goalProvider,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChallengeButton(
    BuildContext context,
    String text,
    ChallengeMode mode,
    GoalProvider goalProvider,
  ) {
    final isSelected = goalProvider.challengeMode == mode;

    return OutlinedButton(
      onPressed: () {
        goalProvider.setChallengeMode(mode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已切换到 $text 模式'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF667eea) : null,
        foregroundColor: isSelected ? Colors.white : null,
        side: BorderSide(
          color: isSelected ? const Color(0xFF667eea) : Colors.grey[300]!,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }
}
