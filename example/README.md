# Multi app view example

Example for the Multi App View package

## Getting Started

```dart

  @override
  Widget build(BuildContext context) {
    return MavFrameWidget(
      mavFrame: widget.frame,
      itemBuilder: (MavItem item) {
        // return const NoRouting();
        return MyApp(item: item);
      },
    );
  }
  
```

