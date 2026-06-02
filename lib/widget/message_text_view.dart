import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageTextView extends StatelessWidget {
  const MessageTextView({super.key, required this.message, required this.textStyle, this.color});

  final String message;
  final TextStyle textStyle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // return SelectableText.rich(
    //   _buildTextSpan(message),
    // );
    return RichText(text: _buildTextSpan(message));
  }

  TextSpan _buildTextSpan(String text) {
    final urlRegex = RegExp(r'((https?|ftp)://[^\s/$.?#].[^\s]*)');
    final emailRegex = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b');
    final RegExp phoneRegex = RegExp(r'((\+84|0)(3[2-9]|5[2689]|7[06-9]|8[1-9]|9\d)\d{7})');

    List<TextSpan> spans = [];
    text.splitMapJoin(
      RegExp('${urlRegex.pattern}|${emailRegex.pattern}|${phoneRegex.pattern}'),
      onMatch: (match) {
        String matchedText = match[0]!;
        if (urlRegex.hasMatch(matchedText)) {
          spans.add(
            TextSpan(
              text: matchedText,
              style: textStyle.copyWith(decoration: .underline, decorationColor: color),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final url = Uri.parse(matchedText);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
            ),
          );
        } else if (emailRegex.hasMatch(matchedText)) {
          spans.add(
            TextSpan(
              text: matchedText,
              style: textStyle.copyWith(decoration: .underline, decorationColor: color),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(Uri.parse('mailto:$matchedText'));
                },
            ),
          );
        } else if (phoneRegex.hasMatch(matchedText)) {
          spans.add(
            TextSpan(
              text: matchedText,
              style: textStyle.copyWith(decoration: .underline, decorationColor: color),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(Uri.parse('tel:$matchedText'));
                },
            ),
          );
        }
        return matchedText;
      },
      onNonMatch: (text) {
        spans.add(TextSpan(text: text, style: textStyle));
        return text;
      },
    );

    return TextSpan(children: spans);
  }
}
