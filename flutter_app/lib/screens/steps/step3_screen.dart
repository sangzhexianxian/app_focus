import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/goal_provider.dart';

class Step3Screen extends StatelessWidget {
  const Step3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('第三步：最终选出3个'),
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
            value: 0.6,
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
                      '💡 提示：这可能是最痛苦的一步。问自己：哪3个目标实现后，会让2026年无憾？',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 选择计数
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667eea).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '已选择 ${goalProvider.top3Goals.where((g) => g.selected).length} / 3',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667eea),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 目标列表
                  _buildGoalList(goalProvider),

                  const SizedBox(height: 20),

                  // 下一步按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        goalProvider.goToStep4();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        '下一步',
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

  Widget _buildGoalList(GoalProvider goalProvider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goalProvider.top3Goals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final goal = goalProvider.top3Goals[index];
        final isSelected = goal.selected;

        return GestureDetector(
          onTap: () {
            final selectedCount =
                goalProvider.top3Goals.where((g) => g.selected).length;
            if (!isSelected && selectedCount >= 3) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('最多只能选择3个目标')),
              );
              return;
            }
            goalProvider.toggleStep3Goal(goal.id);
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF667eea).withOpacity(0.1)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? const Color(0xFF667eea) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // 复选框
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF667eea) : Colors.grey,
                      width: 2,
                    ),
                    color: isSelected ? const Color(0xFF667eea) : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),

                const SizedBox(width: 12),

                // 目标文本
                Expanded(
                  child: Text(
                    goal.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? const Color(0xFF667eea)
                          : Colors.grey[700],
                    ),
                  ),
                ),

                // 图标
                Text(
                  goal.icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
