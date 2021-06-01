import 'package:flutter/material.dart';

@immutable
class PhotoWithFilter extends StatefulWidget {
  _PhotoWithFilterState createState() => _PhotoWithFilterState();
}

class _PhotoWithFilterState extends State<PhotoWithFilter> {
  final List<Color> _filters = [
    Colors.white,
    ...List.generate(
      Colors.primaries.length,
      (index) => Colors.primaries[(index % 4) % Colors.primaries.length],
    )
  ];

  final _filterColor = ValueNotifier<Color>(Colors.white);
  void _onFilterChanged(Color value) {
    _filterColor.value = value;
  }

  Widget _buildPhotoFilter() {
    return ValueListenableBuilder(
      valueListenable: _filterColor,
      builder: (context, value, child) {
        final color = value as Color;
        return Image.network(
          'https://flutter.dev/docs/cookbook/img-files/effects/instagram-buttons/millenial-dude.jpg',
          color: color.withOpacity(0.5),
          colorBlendMode: BlendMode.color,
          fit: BoxFit.cover,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _buildPhotoFilter()),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: FilterSelector(
              filters: _filters,
              onFilterChanged: _onFilterChanged,
            ),
          )
        ],
      ),
    );
  }
}

@immutable
class FilterSelector extends StatefulWidget {
  FilterSelector({
    Key? key,
    required this.filters,
    required this.onFilterChanged,
    this.padding = const EdgeInsets.symmetric(vertical: 24),
  }) : super(key: key);

  final EdgeInsets padding;
  final void Function(Color selectedColor) onFilterChanged;
  final List<Color> filters;
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  static const double _filtersPerScreen = 5;
  static const double _viewportFractionItem = 1.0 / _filtersPerScreen;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: _viewportFractionItem,
    );
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    widget.onFilterChanged(widget.filters[page]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFilterTapped(int index) {
    _controller.animateToPage(index,
        duration: Duration(milliseconds: 450), curve: Curves.ease);
  }

  Color _itemColor(int index) => widget.filters[index % widget.filters.length];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final itemSize = constraint.maxWidth * _viewportFractionItem;

        return Stack(
          alignment: Alignment.center,
          children: [
            _buildShadowGradient(itemSize),
            _buildCarousel(itemSize),
            _buildSelectionRing(itemSize),
          ],
        );
      },
    );
  }

  Widget _buildShadowGradient(double itemSize) {
    return SizedBox(
      height: itemSize * 2 + widget.padding.vertical,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  Widget _buildSelectionRing(double itemSize) {
    return IgnorePointer(
      child: Padding(
        padding: widget.padding,
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(width: 6.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(double itemSize) {
    return Container(
      height: itemSize,
      margin: widget.padding,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.filters.length,
        itemBuilder: (context, index) {
          return Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (!_controller.hasClients ||
                    !_controller.position.hasContentDimensions)
                  return SizedBox();

                final _selectedIndex = _controller.page!.roundToDouble();
                final _pageScrollAmount = _controller.page! - _selectedIndex;
                final _maxScrollDistance = _filtersPerScreen / 2;
                final _pageDistanceFromSelected =
                    (_selectedIndex - index + _pageScrollAmount).abs();
                final _percentFromCenter =
                    1.0 - _pageDistanceFromSelected / _maxScrollDistance;

                final _itemScale = 0.3 + (_percentFromCenter * 0.5);
                return Transform.scale(
                  scale: _itemScale,
                  child: FilterItem(
                    color: _itemColor(index),
                    onFilterSelected: () => _onFilterTapped(index),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

@immutable
class FilterItem extends StatelessWidget {
  FilterItem({Key? key, required this.color, required this.onFilterSelected})
      : super(key: key);

  final Color color;
  final VoidCallback? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ClipOval(
          child: Image.network(
            'https://flutter.dev/docs/cookbook/img-files/effects/instagram-buttons/millenial-texture.jpg',
            color: color.withOpacity(0.5),
            colorBlendMode: BlendMode.hardLight,
          ),
        ),
      ),
    );
  }
}
