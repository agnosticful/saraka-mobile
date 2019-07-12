import 'package:flutter/material.dart' show DefaultMaterialLocalizations;
import 'package:flutter/widgets.dart';

class Application extends StatefulWidget {
  @override
  State<Application> createState() => _ApplicationState();

  Application({
    Key key,
    this.title,
    this.color,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowWidgetInspector = false,
    this.debugShowCheckedModeBanner = true,
    this.inspectorSelectButtonBuilder,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final String title;

  final Color color;

  final bool showPerformanceOverlay;

  final bool checkerboardRasterCacheImages;

  final bool checkerboardOffscreenLayers;

  final bool showSemanticsDebugger;

  final bool debugShowWidgetInspector;

  final bool debugShowCheckedModeBanner;

  final InspectorSelectButtonBuilder inspectorSelectButtonBuilder;

  final Widget child;
}

class _ApplicationState extends State<Application>
    implements WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() async => false;

  @override
  Future<bool> didPushRoute(String route) async => false;

  @override
  void didChangeLocales(List<Locale> locales) {}

  @override
  void didChangeAccessibilityFeatures() {
    setState(() {});
  }

  @override
  void didChangeMetrics() {
    setState(() {});
  }

  @override
  void didChangeTextScaleFactor() {
    setState(() {});
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget inner = widget.child;
    PerformanceOverlay performanceOverlay;

    if (widget.showPerformanceOverlay ||
        WidgetsApp.showPerformanceOverlayOverride) {
      performanceOverlay = PerformanceOverlay.allEnabled(
        checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
      );
    } else if (widget.checkerboardRasterCacheImages ||
        widget.checkerboardOffscreenLayers) {
      performanceOverlay = PerformanceOverlay(
        checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
      );
    }

    if (performanceOverlay != null) {
      inner = Stack(children: <Widget>[
        inner,
        Positioned(top: 0.0, left: 0.0, right: 0.0, child: performanceOverlay),
      ]);
    }

    if (widget.showSemanticsDebugger) {
      inner = SemanticsDebugger(child: inner);
    }

    if (widget.debugShowWidgetInspector ||
        WidgetsApp.debugShowWidgetInspectorOverride) {
      inner = WidgetInspector(
        child: inner,
        selectButtonBuilder: widget.inspectorSelectButtonBuilder,
      );
    }

    if (widget.debugShowCheckedModeBanner &&
        WidgetsApp.debugAllowBannerOverride) {
      inner = CheckedModeBanner(child: inner);
    }

    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: Localizations(
        locale: Locale('en'),
        delegates: [
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        child: Title(
          title: widget.title,
          color: widget.color,
          child: inner,
        ),
      ),
    );
  }
}
