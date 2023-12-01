import 'package:digit_easy_pay_flutter/src/common/inherited_l10n.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_l10n.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/change_insets_detector.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/flexible_bottom_sheet_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// The signature of a method that provides a [BuildContext] and
/// [ScrollController] for building a widget that may overflow the draggable
/// [Axis] of the containing FlexibleDraggableScrollSheet.
///
/// Users should apply the [scrollController] to a [ScrollView] subclass, such
/// as a [SingleChildScrollView], [ListView] or [GridView], to have the whole
/// sheet be draggable.
///
/// [bottomSheetOffset] - fractional value of offset.
typedef FlexibleDraggableScrollableWidgetBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
  double bottomSheetOffset,
);

/// The signature of the method that provides [BuildContext]
/// and [bottomSheetOffset] for determining the position of the BottomSheet
/// relative to the upper border of the screen.
/// [bottomSheetOffset] - fractional value of offset.
typedef FlexibleDraggableScrollableHeaderWidgetBuilder = Widget Function(
  BuildContext context,
  double bottomSheetOffset,
);

/// The signature of a method that provides a [BuildContext]
/// and [bottomSheetOffset] for determining the position of the BottomSheet
/// relative to the upper border of the screen.
/// [bottomSheetOffset] - fractional value of offset.
typedef FlexibleDraggableScrollableWidgetBodyBuilder = SliverChildDelegate
    Function(
  BuildContext context,
  double bottomSheetOffset,
);

/// Flexible and scrollable bottom sheet.
///
/// This bottom sheet resizing between min and max size, and when size become
/// max start scrolling content. Reduction size available when content
/// scrolled to 0 offset.
///
/// [minHeight], [maxHeight] are limits of
/// bounds this widget. For example:
/// - you can set  [maxHeight] to 1;
/// - you can set [minHeight] to 0.5;
///
/// [isCollapsible] make possible collapse widget and remove from the screen,
/// but you must be carefully to use it, set it to true only if you show this
/// widget with like showFlexibleBottomSheet() case, because it will be removed
/// by Navigator.pop(). If you set [isCollapsible] true, [minHeight]
/// must be 0.
///
/// The [draggableScrollableController] that allow programmatically control bottom sheet.
///
/// The [animationController] that controls the bottom sheet's entrance and
/// exit animations.
/// The FlexibleBottomSheet widget will manipulate the position of this
/// animation, it is not just a passive observer.
///
/// [initHeight] - relevant height for init bottom sheet
///
/// [keyboardBarrierColor] - color for the space behind the keyboard
///
/// [isExpand] - should your bottom sheet expand. By default, [isExpand] is true,
/// which means that the bottom sheet will have the height you specify
/// ([initHeight] and [maxHeight]) regardless of the height of the content in it.
/// If [isExpand] is false, [maxHeight] and [initHeight] must be equal,
/// in which case the bottom sheet will calculate its height based on the content,
/// but no more than [maxHeight] and [initHeight]. [anchors] in this case must be null.
/// ShrinkWrap content widget must be true.
///
/// [bottomSheetColor] - bottom sheet color. If you want to make rounded edges,
/// pass a [Colors.transparent] here, and set the color and border radius of
/// the bottom sheet in the [decoration].
class FlexibleBottomSheet<T> extends StatefulWidget {
  final double minHeight;
  final double initHeight;
  final double maxHeight;
  final FlexibleDraggableScrollableWidgetBuilder? builder;
  final FlexibleDraggableScrollableHeaderWidgetBuilder? headerBuilder;
  final FlexibleDraggableScrollableWidgetBodyBuilder? bodyBuilder;
  final bool isCollapsible;
  final bool isExpand;
  final DraggableScrollableController? draggableScrollableController;
  final AnimationController? animationController;
  final List<double>? anchors;
  final double? minHeaderHeight;
  final double? maxHeaderHeight;
  final Decoration? decoration;
  final VoidCallback? onDismiss;
  final Color? keyboardBarrierColor;
  final Color? bottomSheetColor;
  final PopupRoute<T>? route;
  final bool useRootScaffold;
  final BorderRadiusGeometry? bottomSheetBorderRadius;
  final List<SingleChildWidget> providers;
  final L10n? l10n;

  FlexibleBottomSheet({
    super.key,
    this.route,
    this.minHeight = 0,
    this.initHeight = 0.5,
    this.maxHeight = 1,
    this.builder,
    this.headerBuilder,
    this.bodyBuilder,
    this.isCollapsible = false,
    this.isExpand = true,
    this.animationController,
    this.anchors,
    this.minHeaderHeight,
    this.maxHeaderHeight,
    this.decoration,
    this.onDismiss,
    this.keyboardBarrierColor,
    this.bottomSheetColor,
    this.bottomSheetBorderRadius,
    this.draggableScrollableController,
    this.useRootScaffold = true,
    this.providers =  const [],
    this.l10n,
  })  : assert(minHeight >= 0 && minHeight <= 1),
        assert(maxHeight > 0 && maxHeight <= 1),
        assert(maxHeight > minHeight),
        assert(!isCollapsible || minHeight == 0),
        assert(anchors == null || !anchors.any((anchor) => anchor > maxHeight)),
        assert(anchors == null || !anchors.any((anchor) => anchor < minHeight)),
        assert(isExpand || maxHeight == initHeight && anchors == null);

  FlexibleBottomSheet.collapsible({
    required PopupRoute<T> route,
    Key? key,
    double initHeight = 0.5,
    double maxHeight = 1,
    DraggableScrollableController? draggableScrollableController,
    FlexibleDraggableScrollableWidgetBuilder? builder,
    FlexibleDraggableScrollableHeaderWidgetBuilder? headerBuilder,
    FlexibleDraggableScrollableWidgetBodyBuilder? bodyBuilder,
    List<SingleChildWidget> providers = const [],
    bool isExpand = true,
    AnimationController? animationController,
    List<double>? anchors,
    double? minHeaderHeight,
    double? maxHeaderHeight,
    Decoration? decoration,
    Color? keyboardBarrierColor,
    Color? bottomSheetColor,
    bool useRootScaffold = true,
    BorderRadiusGeometry? bottomSheetBorderRadius,
  }) : this(
          route: route,
          key: key,
          maxHeight: maxHeight,
          draggableScrollableController: draggableScrollableController,
          builder: builder,
          headerBuilder: headerBuilder,
          bodyBuilder: bodyBuilder,
          minHeight: 0,
          initHeight: initHeight,
          isCollapsible: true,
          isExpand: isExpand,
          animationController: animationController,
          anchors: anchors,
          minHeaderHeight: minHeaderHeight,
          maxHeaderHeight: maxHeaderHeight,
          decoration: decoration,
          keyboardBarrierColor: keyboardBarrierColor,
          bottomSheetColor: bottomSheetColor,
          useRootScaffold: useRootScaffold,
          bottomSheetBorderRadius: bottomSheetBorderRadius,
          providers: providers
        );

  @override
  State<FlexibleBottomSheet<T>> createState() => _FlexibleBottomSheetState();
}

class _FlexibleBottomSheetState<T> extends State<FlexibleBottomSheet<T>> {
  late final DraggableScrollableController _controller;

  late final WidgetsBinding _widgetBinding;
  late double _initialChildSize = widget.initHeight;
  late double _currentMaxChildSize = widget.maxHeight;

  bool _isClosing = false;
  bool _isAnimatingToMaxHeight = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.draggableScrollableController ?? DraggableScrollableController();
    _widgetBinding = WidgetsBinding.instance;
    widget.animationController?.addStatusListener(_animationStatusListener);
  }

  // Method will be called when scrolling.
  bool _scrolling(DraggableScrollableNotification notification) {
    /// Force widget rebuild to change bottomSheetOffset value
    setState(() {});

    if (_isClosing) return false;

    _initialChildSize = notification.extent;

    _checkNeedCloseBottomSheet(notification.extent);

    return false;
  }

  // Make bottom sheet max height.
  void _animateToMaxHeight() {
    final currPosition = _controller.size;
    if (currPosition != widget.maxHeight && !_isAnimatingToMaxHeight) {
      _isAnimatingToMaxHeight = true;
      _controller
          .animateTo(
            widget.maxHeight,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
          )
          .whenComplete(
            () => _isAnimatingToMaxHeight = false,
          );
    }
  }

  // Scroll to focused widget.
  void _animateToFocused(ScrollController controller) {
    if (FocusManager.instance.primaryFocus == null || _isClosing) return;

    _widgetBinding.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
      final widgetHeight = FocusManager.instance.primaryFocus!.size.height;
      final widgetOffset = FocusManager.instance.primaryFocus!.offset.dy;
      final screenHeight = MediaQuery.sizeOf(context).height;

      final targetWidgetOffset =
          screenHeight - keyboardHeight - widgetHeight - 20;
      final valueToScroll = widgetOffset - targetWidgetOffset;
      final currentOffset = controller.offset;
      if (valueToScroll > 0) {
        controller.animateTo(
          currentOffset + valueToScroll,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    });
  }

  // Checking if the bottom sheet needs to be closed.
  void _checkNeedCloseBottomSheet(double extent) {
    if (widget.isCollapsible && !_isClosing) {
      if (extent - widget.minHeight <= 0.005) {
        _isClosing = true;
        _dismiss();
      }
    }
  }

  // Method that listens for changing AnimationStatus, to track the closing of
  // the bottom sheet by clicking above it.
  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.reverse ||
        status == AnimationStatus.dismissed) {
      _isClosing = true;
    }
  }

  void _dismiss() {
    if (widget.isCollapsible) {
      widget.onDismiss?.call();
      Navigator.maybePop(context);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => widget.route?.changedInternalState());
    }
  }

  void _changeInitAndMaxHeight(double height) {
    if (!widget.isExpand) {
      final screenHeight = MediaQuery.sizeOf(context).height;

      final fractionalValue = height / screenHeight;
      if (fractionalValue < _currentMaxChildSize) {
        setState(
          () {
            _initialChildSize = fractionalValue;
            _currentMaxChildSize = fractionalValue;
          },
        );
      }
    }
  }

  double _calculateCacheExtent(double bottomInset) {
    const defaultExtent = RenderAbstractViewport.defaultCacheExtent;
    if (bottomInset > defaultExtent) {
      return bottomInset;
    } else {
      return defaultExtent;
    }
  }

  @override
  void dispose() {
    widget.animationController?.removeStatusListener(_animationStatusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSheetThemeBackground =
        Theme.of(context).bottomSheetTheme.backgroundColor;
    final colorSchemeBackground = Theme.of(context).colorScheme.background;

    final bottomSheetColor = widget.bottomSheetColor ??
        bottomSheetThemeBackground ??
        colorSchemeBackground;
    final contentDecoration = widget.decoration ??
        BoxDecoration(
          color: widget.bottomSheetColor ??
              bottomSheetThemeBackground ??
              colorSchemeBackground,
        );

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: _scrolling,
      child: DraggableScrollableSheet(
        maxChildSize: _currentMaxChildSize,
        minChildSize: widget.minHeight,
        initialChildSize: _initialChildSize,
        snap: widget.anchors != null,
        controller: _controller,
        snapSizes: widget.anchors,
        expand: widget.isExpand,
        builder: (
          context,
          controller,
        ) {
          return ChangeInsetsDetector(
            handler: (change) {
              final inset = change.currentInset;
              final delta = change.delta;

              if (delta > 0 && !_isClosing) {
                _animateToMaxHeight();
                _widgetBinding.addPostFrameCallback(
                  (_) {
                    _animateToFocused(controller);
                  },
                );
              }
              // Checking for openness of the keyboard before opening the sheet.
              if (delta == 0 && inset > 0) {
                _widgetBinding.addPostFrameCallback(
                  (_) {
                    setState(
                      () {
                        _initialChildSize = widget.maxHeight;
                      },
                    );
                  },
                );
              }
            },
            child: InheritedL10n(
              l10n: widget.l10n??const L10nFr(),
              child: Material(
                type: MaterialType.transparency,
                color: bottomSheetColor,
                borderRadius: widget.bottomSheetBorderRadius,
                clipBehavior: widget.bottomSheetBorderRadius != null
                    ? Clip.antiAlias
                    : Clip.none,
                child: _RegisterScaffold(
                  useRootScaffold: widget.useRootScaffold,
                  backgroundColor: bottomSheetColor,
                  child: _Content(
                    builder: widget.builder,
                    decoration: contentDecoration,
                    bodyBuilder: widget.bodyBuilder,
                    headerBuilder: widget.headerBuilder,
                    minHeaderHeight: widget.minHeaderHeight,
                    maxHeaderHeight: widget.maxHeaderHeight,
                    providers: widget.providers,
                    currentExtent: _controller.isAttached
                        ? _controller.size
                        : widget.initHeight,
                    scrollController: controller,
                    cacheExtent: _calculateCacheExtent(
                      MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    getContentHeight:
                        !widget.isExpand ? _changeInitAndMaxHeight : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Register [Scaffold] for [FlexibleBottomSheet].
class _RegisterScaffold extends StatelessWidget {
  final bool useRootScaffold;
  final Widget child;
  final Color backgroundColor;

  const _RegisterScaffold({
    required this.useRootScaffold,
    required this.child,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return useRootScaffold
        ? Scaffold(
            backgroundColor: backgroundColor,
            body: child,
          )
        : ColoredBox(
            color: backgroundColor,
            child: child,
          );
  }
}

/// Content for [FlexibleBottomSheet].
class _Content extends StatefulWidget {
  final FlexibleDraggableScrollableWidgetBuilder? builder;
  final Decoration? decoration;
  final FlexibleDraggableScrollableHeaderWidgetBuilder? headerBuilder;
  final FlexibleDraggableScrollableWidgetBodyBuilder? bodyBuilder;
  final double? minHeaderHeight;
  final double? maxHeaderHeight;
  final double currentExtent;
  final ScrollController scrollController;
  final Function(double)? getContentHeight;
  final double cacheExtent;
  final List<SingleChildWidget> providers;

  const _Content({
    required this.currentExtent,
    required this.scrollController,
    required this.cacheExtent,
    this.providers =  const [],
    this.builder,
    this.decoration,
    this.headerBuilder,
    this.bodyBuilder,
    this.minHeaderHeight,
    this.maxHeaderHeight,
    this.getContentHeight,
  });

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final _contentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.getContentHeight != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          final renderContent =
              _contentKey.currentContext!.findRenderObject()! as RenderBox;
          widget.getContentHeight!(renderContent.size.height);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null && widget.providers.isNotEmpty) {
      return Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: widget.decoration ?? const BoxDecoration(),
          child: SizedBox(
            key: _contentKey,
            child: MultiProvider(
                providers: widget.providers,
              child: widget.builder!(
                context,
                widget.scrollController,
                widget.currentExtent,
              ),
            ),
          ),
        ),
      );
    }

    if (widget.builder != null) {
      return Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: widget.decoration ?? const BoxDecoration(),
          child: SizedBox(
            key: _contentKey,
            child: widget.builder!(
              context,
              widget.scrollController,
              widget.currentExtent,
            ),
          ),
        ),
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: DecoratedBox(
        decoration: widget.decoration ?? const BoxDecoration(),
        child: MultiProvider(
          providers: widget.providers,
          child: CustomScrollView(
            cacheExtent: widget.cacheExtent,
            key: _contentKey,
            controller: widget.scrollController,
            slivers: <Widget>[
              if (widget.headerBuilder != null)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: FlexibleBottomSheetHeaderDelegate(
                    minHeight: widget.minHeaderHeight ?? 0.0,
                    maxHeight: widget.maxHeaderHeight ?? 1.0,
                    child: widget.headerBuilder!(context, widget.currentExtent),
                  ),
                ),
              if (widget.bodyBuilder != null)
                SliverList(
                  delegate: widget.bodyBuilder!(
                    context,
                    widget.currentExtent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
