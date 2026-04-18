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
        border: Border.all(
          color: AppColors.blue.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.blue.withValues(alpha: 0.3),
          ),
          _buildStatusRows(),
        
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
              Text(
                'ONLINE',
                style: AppTextStyles.label.copyWith(
                  color: const Color(0xFF00FF88),
                ),
              ),
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
          _buildRow('University', 'NWU - BSc IT'),
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


}
