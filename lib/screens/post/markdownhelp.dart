import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';

class MarkdownHelp extends StatelessWidget {
  const MarkdownHelp({super.key});

  /* 
    Markdown Syntax Guide
    Here are some common Markdown syntax examples to help you format your text:

    Headers
    # Header 1
    ## Header 2
    ### Header 3

    Text Formatting
    Italic text:   *Italic* or _Italic_
    Bold text:   **Bold** or __Bold__
    Bold and Italic text:   ***Bold and Italic*** or ___Bold and Italic___
    Strikethrough:   ~~Strikethrough~~
    Inline code:   `code`
    Links:   [Link text](https://example.com)

    Lists
    - Unordered list item
    1. Numbered list item

    Other
    Blockquotes:   > This is a blockquote
    Divider:   ---
  */

  @override
  Widget build(BuildContext context) {
    return Screen.scroll(
      title: Text("Markdown Syntax Guide"),
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Here are some common Markdown syntax examples to help you format your text:",
            ),
            SizedBox(height: 8.0),
            Text("Headers", style: Theme.of(context).textTheme.headlineSmall),
            Text(
              "# Header 1\n## Header 2\n### Header 3",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 2),
            ),
            SizedBox(height: 16.0),
            Text(
              "Text Formatting",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            RichText(
              text: TextSpan(
                text: "",
                style: TextStyle(height: 2),
                children: [
                  TextSpan(
                    text: "Italic ",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  TextSpan(text: "text:   *Italic* or _Italic_\n"),
                  TextSpan(
                    text: "Bold ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "text:   **Bold** or __Bold__\n"),
                  TextSpan(
                    text: "Bold and Italic ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text:
                        "text:   ***Bold and Italic*** or ___Bold and Italic___\n",
                  ),
                  TextSpan(
                    text: "Strikethrough",
                    style: TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                  TextSpan(text: ":   ~Strikethrough~\n"),
                  TextSpan(
                    text: "Monospace:  ",
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                  TextSpan(text: "`monospace`\n"),
                  TextSpan(
                    text: "Links",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: ":   [Link text](https://example.com)"),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text("Lists", style: Theme.of(context).textTheme.headlineSmall),
            Text(
              "- Unordered list item\n1. Numbered list item",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 2),
            ),
            SizedBox(height: 16.0),
            Text("Other", style: Theme.of(context).textTheme.headlineSmall),
            Text(
              "> This is a blockquote\nDivider: ---",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 2),
            ),
          ],
        ),
      ),
    );
  }
}
