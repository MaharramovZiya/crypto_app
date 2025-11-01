import 'package:crypto_app/ui/base/base_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/core/constants/app_colors.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[ Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
               const BaseText(
              'Current Balance',
              style: TextStyle(
                color: Color.fromRGBO(42, 42, 42, 1),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            // Current Balance label
            SizedBox(height: 10),
         Row(children: [
          
            const SizedBox(height: 8),
            // Balance amount
            const Text(
              '\$87,430.12',
              style: TextStyle(
                color: AppColors.cardBackground,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
               Row(
              children: [
                const Icon(
                  Icons.arrow_upward,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                const Text(
                  '10.2%',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
   
         ],),
            // Increase percentage
         
            const SizedBox(height: 24),
            // Deposit and Withdraw buttons
      
            //Duymeler
        
          ],
          
        ),
      ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Deposit action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.balanceTextLight,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const BaseText(
                        'Deposit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Withdraw action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        
                        foregroundColor: AppColors.balanceTextLight,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: AppColors.balanceTextLight,
                            width: 1,
                          ),
                        ),
                      ),
                      child: const BaseText(
                        'Withdraw',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
    ]);
  }
}

