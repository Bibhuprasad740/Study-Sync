import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TermsPrivacyLinks extends StatelessWidget {
  final bool isAgreed;
  final Function(bool?) onChanged;

  const TermsPrivacyLinks({
    Key? key,
    required this.isAgreed,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 6.w,
              height: 6.w,
              child: Checkbox(
                value: isAgreed,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged.call(!isAgreed),
                child: RichText(
                  text: TextSpan(
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => _showTermsOfService(context),
                          child: Text(
                            'Terms of Service',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => _showPrivacyPolicy(context),
                          child: Text(
                            'Privacy Policy',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showTermsOfService(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLegalDocumentSheet(
        context,
        'Terms of Service',
        _getTermsOfServiceContent(),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLegalDocumentSheet(
        context,
        'Privacy Policy',
        _getPrivacyPolicyContent(),
      ),
    );
  }

  Widget _buildLegalDocumentSheet(
      BuildContext context, String title, String content) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Text(
                content,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTermsOfServiceContent() {
    return '''
STUDYSYNC TERMS OF SERVICE

Last Updated: August 25, 2025

1. ACCEPTANCE OF TERMS
By creating an account and using StudySync, you agree to be bound by these Terms of Service and our Privacy Policy.

2. DESCRIPTION OF SERVICE
StudySync is an educational productivity application that helps users organize study materials and schedule revisions using spaced repetition techniques.

3. USER ACCOUNTS
- You must provide accurate information when creating your account
- You are responsible for maintaining the security of your account
- You must be at least 13 years old to use this service

4. SUBSCRIPTION PLANS
- Free Plan: Limited to 2 topics per day and 1 revision per day
- Premium Plan: Unlimited topics and revisions for \$9.99/month
- Subscriptions auto-renew unless cancelled

5. USER CONTENT
- You retain ownership of your study materials and notes
- You grant us permission to store and process your content to provide the service
- You are responsible for the accuracy and legality of your content

6. PROHIBITED USES
- Do not use the service for any illegal purposes
- Do not share copyrighted materials without permission
- Do not attempt to reverse engineer or hack the application

7. PRIVACY
Your privacy is important to us. Please review our Privacy Policy to understand how we collect and use your information.

8. LIMITATION OF LIABILITY
StudySync is provided "as is" without warranties. We are not liable for any damages arising from your use of the service.

9. TERMINATION
We may terminate your account for violations of these terms. You may cancel your subscription at any time.

10. CHANGES TO TERMS
We may update these terms occasionally. Continued use of the service constitutes acceptance of new terms.

Contact us at support@studysync.com for questions about these terms.
''';
  }

  String _getPrivacyPolicyContent() {
    return '''
STUDYSYNC PRIVACY POLICY

Last Updated: August 25, 2025

1. INFORMATION WE COLLECT
- Account information (name, email, educational background)
- Study data (goals, subjects, topics, revision history)
- Usage analytics (app interactions, feature usage)
- Device information (device type, operating system)

2. HOW WE USE YOUR INFORMATION
- To provide and improve our educational services
- To send revision reminders and notifications
- To analyze usage patterns and optimize the app
- To process subscription payments

3. INFORMATION SHARING
We do not sell your personal information. We may share data with:
- Service providers who help us operate the app
- Analytics services to improve our product
- Legal authorities when required by law

4. DATA SECURITY
- We use encryption to protect your data in transit and at rest
- Regular security audits and updates
- Limited access to personal data by our team
- Secure payment processing through trusted providers

5. YOUR RIGHTS
- Access your personal data
- Correct inaccurate information
- Delete your account and data
- Export your study data
- Opt out of marketing communications

6. DATA RETENTION
- Account data: Retained while your account is active
- Study data: Retained for 30 days after account deletion
- Analytics data: Anonymized and retained for service improvement

7. COOKIES AND TRACKING
We use cookies and similar technologies to:
- Remember your preferences
- Analyze app usage
- Provide personalized experiences

8. CHILDREN'S PRIVACY
We do not knowingly collect personal information from children under 13. If we discover such collection, we will delete the information immediately.

9. INTERNATIONAL TRANSFERS
Your data may be processed in countries other than your own. We ensure appropriate safeguards are in place.

10. CHANGES TO PRIVACY POLICY
We will notify you of significant changes to this policy via email or app notification.

Contact us at privacy@studysync.com for privacy-related questions or to exercise your rights.
''';
  }
}
