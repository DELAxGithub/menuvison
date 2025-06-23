import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('About'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.paddingStandard),
          children: [
            const Text(
              'MenuVision',
              style: AppTextStyles.heading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingStandard),
            const Text(
              'Version 1.0.0',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.marginBetweenSections),
            const Text(
              'A camera OCR app for scanning menus and searching for dish images.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.marginBetweenSections),
            const Divider(),
            const SizedBox(height: AppSpacing.marginBetweenSections),
            const Text(
              'License',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppSpacing.paddingSmall),
            const Text(
              'This app is inspired by MenuScan',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.paddingSmall),
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingStandard),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: const Text(
                '© 2023 recursiverob\n'
                'MenuScan - MIT License\n'
                'https://github.com/recursiverob/MenuScan\n\n'
                'Permission is hereby granted, free of charge, to any person obtaining a copy '
                'of this software and associated documentation files (the "Software"), to deal '
                'in the Software without restriction, including without limitation the rights '
                'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell '
                'copies of the Software, and to permit persons to whom the Software is '
                'furnished to do so, subject to the following conditions:\n\n'
                'The above copyright notice and this permission notice shall be included in all '
                'copies or substantial portions of the Software.\n\n'
                'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR '
                'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, '
                'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.',
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}