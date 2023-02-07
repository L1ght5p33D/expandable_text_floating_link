import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum TrimType { lines, characters }
enum SeparateLinkAlignment {left, center, right }

class ExpandableText extends StatefulWidget {
  /// Text to show
  final String text;

  /// Clickable text to display that expands text
  final String readMoreText;

  /// Clickable text to display that collapses text
  final String readLessText;

  /// [TextStyle] for both [readMoreText] and [readLessText]
  final TextStyle? linkTextStyle;

  /// [TextStyle] for [text]
  final TextStyle? style;

  /// For [TrimType.lines] this represents the maximum amount of lines allowable
  /// before the text is collapsed
  ///
  /// For [TrimType.characters] this represents the number of characters
  /// allowable before the text is collapsed
  final int trim;

  /// Whether to trim [text] by lines or characters in [text]
  final TrimType trimType;

  final TextAlign textAlign;

  final TextDirection textDirection;

  final bool separateLink;

  final SeparateLinkAlignment separateLinkAlignment;

  /// Callback function when a link is pressed
  ///
  /// Returns a boolean [true] is expanded and [false] is collapsed
  final void Function(bool expanded)? onLinkPressed;

  const ExpandableText(
      this.text, {
        Key? key,
        this.readLessText = 'read less',
        this.readMoreText = 'read more',
        this.linkTextStyle,
        this.style,
        this.trim = 2,
        this.trimType = TrimType.lines,
        this.textAlign = TextAlign.left,
        this.textDirection = TextDirection.ltr,
        this.onLinkPressed,
        this.separateLink = false,
        this.separateLinkAlignment = SeparateLinkAlignment.left
      }) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late TextSpan _text;
  late TextSpan _linkText;
  late TextSpan _ellipsisText;
  late TextPainter _textPainter;
  bool _isExpanded = false;

  @override
  void initState() {
    _textPainter = TextPainter(
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      ellipsis: '...',
      maxLines: widget.trim,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _linkText = TextSpan(
      text: _isExpanded ? widget.readLessText : widget.readMoreText,
      style: widget.linkTextStyle ??
          const TextStyle(
            color: Colors.blue,
            fontSize: 12,
          ),
      recognizer: TapGestureRecognizer()..onTap = _onLinkTextPressed,
    );
    _text = TextSpan(
      text: widget.text,
      style: widget.style ??
          const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
    );
    _ellipsisText = TextSpan(
      text: _isExpanded ? '  ' : '... ',
      style: _text.style,
    );
    return LayoutBuilder(
      builder: ((context, constraints) {
        assert(
        constraints.hasBoundedWidth,
        'Parent width unbouded. A bounded width is required. Try wrapping '
            'this widget with a Flexible or Expanded or use a Container with '
            'a defined width.',
        );
        _textPainter.maxLines = widget.trim;

        // layout and get size for link text
        _textPainter.text = _linkText;
        _textPainter.layout(
          minWidth: constraints.minWidth,
          maxWidth: constraints.maxWidth,
        );
        final linkSize = _textPainter.size;

        // layout and get size for ellipsis text
        _textPainter.text = _ellipsisText;
        _textPainter.layout(
          minWidth: constraints.minWidth,
          maxWidth: constraints.maxWidth,
        );
        final ellipsisSize = _textPainter.size;

        // layout and get size for text data
        _textPainter.text = _text;
        _textPainter.layout(
          minWidth: constraints.minWidth,
          maxWidth: constraints.maxWidth,
        );
        final textSize = _textPainter.size;

        late final TextSpan textSpan;
        bool hasOverflow = false;
        int endIndex = 0;

        switch (widget.trimType) {
          case TrimType.lines:
          // get the position of the data text minus the size of the link text
          // minus ellipsis text size
            final pos = _textPainter.getPositionForOffset(
              Offset(
                textSize.width - linkSize.width - ellipsisSize.width,
                textSize.height,
              ),
            );
            if (_textPainter.didExceedMaxLines) {
              // get the index of the last 'seeable' character of the data text
              endIndex = _textPainter.getOffsetBefore(pos.offset) ?? 0;
              hasOverflow = true;
            }
            break;
          case TrimType.characters:
            if (widget.text.length >= widget.trim.abs()) {
              endIndex = widget.trim;
              hasOverflow = true;
            }
            break;
        }


        TextSpan no_link_text = TextSpan();

        if (hasOverflow) {
          // if (widget.separateLink == false) {
          textSpan = TextSpan(
            children: [
              TextSpan(
                text: _isExpanded
                    ? widget.text
                    : widget.text.substring(
                  0,
                  endIndex,
                ),
                style: _text.style,
              ),
              _ellipsisText,
              widget.separateLink ?
              no_link_text
                  : _linkText,
            ],
          );

        } else {
          textSpan = _text;
        }
        if (widget.separateLink == false) {
          return RichText(
            text: textSpan,
          );
        }
        else{
          MainAxisAlignment separateLinkAlignment;
          switch (widget.separateLinkAlignment){
            case SeparateLinkAlignment.left:{
              separateLinkAlignment = MainAxisAlignment.start;}
              break;
            case SeparateLinkAlignment.center:{
              separateLinkAlignment = MainAxisAlignment.center;}
              break;
            case SeparateLinkAlignment.right:{
              separateLinkAlignment = MainAxisAlignment.end;}
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(text: textSpan),
              Row(
                mainAxisAlignment: separateLinkAlignment,
                children: [
                  RichText(text: _linkText)
                ],)
            ],);
        }

      }),
    );
  }

  Future<void> _onLinkTextPressed() async {
    setState(() => _isExpanded = !_isExpanded);
    if (widget.onLinkPressed != null) {
      widget.onLinkPressed!(_isExpanded);
    }
  }
}
