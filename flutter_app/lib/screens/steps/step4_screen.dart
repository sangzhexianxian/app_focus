import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/goal_provider.dart';

class Step4Screen extends StatelessWidget {
  const Step4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('第四步：分配权重'),
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
            value: 0.8,
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
                      '💡 提示：权重代表你的精力分配。50%的目标要投入一半的时间和注意力。',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    '给这3个目标分配权重，总和必须是100%。',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 权重滑块列表
                  ...List.generate(
                    goalProvider.top3Goals.length,
                    (index) => _buildWeightSlider(goalProvider, index),
                  ),

                  const SizedBox(height: 20),

                  // 权重总和显示
                  _buildWeightTotal(goalProvider),

                  const SizedBox(height: 20),

                  // 生成专注卡按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: goalProvider.isWeightValid()
                          ? () {
                              goalProvider.generateCard();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        '生成专注卡',
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

  Widget _buildWeightSlider(GoalProvider goalProvider, int index) {
    final goal = goalProvider.top3Goals[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 目标名称
          Text(
            goal.text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // 滑块
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF667eea),
              inactiveTrackColor: Colors.grey[200],
              thumbColor: const Color(0xFF667eea),
              overlayColor: const Color(0xFF667eea).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: goal.weight.toDouble(),
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: (value) {
                goalProvider.updateWeight(index, value.toInt());
              },
            ),
          ),

          const SizedBox(height: 10),

          // 权重显示
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${goal.weight}%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667eea),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightTotal(GoalProvider goalProvider) {
    final total = goalProvider.getTotalWeight();
    final isValid = total == 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isValid ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isValid ? Colors.green[300]! : Colors.red[300]!,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.warning,
            color: isValid ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(width: 10),
          Text(
            '当前总和：$total%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isValid ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
