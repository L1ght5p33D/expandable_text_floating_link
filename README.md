


## Features

expandable_text_floating_link adds a position option to `ExpandableText` so the link is more visible and aligned to content

### Usage

---
```dart
ExpandableText(
                  "This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text",
                  separateLink: true,
                  separateLinkAlignment: SeparateLinkAlignment.center
                )

```


### Customization

---

You can customize all the attributes from ExpandableText like trimType lines or characters, the link text and style, an onPressed callback and more

```dart
ExpandableText(
                     "This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text This is a long text",
                     style: TextStyle(
                         fontSize: 30.0,
                         color: Colors.black
                     ),
                     trimType: TrimType.lines,
                     trim: 2,
                     readLessText: 'Less',
                     readMoreText: 'Tap for more',
                     linkTextStyle:  TextStyle(
                         color: Colors.black,
                         fontSize: ss.width*.03,
                         fontWeight: FontWeight.bold),
                     onLinkPressed: (expanded) {
                       setState(() {
                         textExpanded=true;
                       });
                     },
                     separateLink: true,
                     separateLinkPosition: SeparateLinkPosition.center
                   )

```

### Support the Library

You can support the library by staring in on Github and reporting any bugs you encounter.

