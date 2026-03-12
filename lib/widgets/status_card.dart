import 'package:flutter/material.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const _Divider(),
          _buildStatusRows(),
          const _Divider(),
          _buildSkillBars(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('SYSTEM STATUS', style: AppTextStyles.label),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF00FF88),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text('ONLINE', style: AppTextStyles.label.copyWith(color: const Color(0xFF00FF88))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRows() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          _buildRow('Developer', 'Flutter / Full Stack'),
          _buildRow('University', 'NWU — BSc IT'),
          _buildRow('Experience', '3+ Years'),
          _buildRow('Location', 'South Africa'),
          _buildRow('Remote', 'Available'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.label),
          Text(value, style: AppTextStyles.label.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSkillBars() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('STACK', style: AppTextStyles.label),
          const SizedBox(height: 8),
          _buildBar('Flutter', 0.95),
          _buildBar('Firebase', 0.80),
          _buildBar('Docker', 0.60),
          _buildBar('Python', 0.70),
          _buildBar('Unity', 0.50),
        ],
      ),
    );
  }

  Widget _buildBar(String skill, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(skill, style: AppTextStyles.label),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '${(value * 100).toInt()}%',
              style: AppTextStyles.label,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.blue.withValues(alpha: 0.3),
    );
  }
}