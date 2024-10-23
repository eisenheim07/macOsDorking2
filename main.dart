import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (icon) {
              return Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:
                  Colors.primaries[icon.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(icon, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  final List<T> items;
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T> extends State<Dock<T>> {
  late List<T> _items;  /*list to ICONS*/
  int? _draggedIndex;   /*getting DRAGGED_ITEM INDEX*/

  @override
  void initState() {
    super.initState();
    _items = widget.items.toList();
  }

  /*method to get the INDEX of item that user wants to DRAG*/
  void _onDragStarted(int index) {
    setState(() {
      _draggedIndex = index;
    });
  }

  /*method to get the INDEX of item that user wants to STOP*/
  void _onDragEnded() {
    setState(() {
      _draggedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.asMap().entries.map((entry) {
          final index = entry.key;
          final icon = entry.value;

          /*recieve the DRAGGED_ELEMENT index*/
          return DragTarget<int>(
            onWillAccept: (draggedIndex) => draggedIndex != index,
            onAccept: (draggedIndex) {
              setState(() {
                final movedItem = _items[draggedIndex];
                _items[draggedIndex] = _items[index];
                _items[index] = movedItem;
              });
            },
            /*STARTING, ENDING, the particular element/icon/index DRAGGING*/
            builder: (context, candidateData, rejectedData) {
              return Draggable<int>(
                data: index,
                feedback: Material(
                  color: Colors.transparent,
                  child: _buildIcon(icon, 48, isDragging: true),
                ),
                childWhenDragging: Container(),
                onDragStarted: () => _onDragStarted(index),
                onDraggableCanceled: (velocity, offset) => _onDragEnded(),
                onDragEnd: (details) => _onDragEnded(),
                child: _buildIcon(icon, 48, isDragging: _draggedIndex == index),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  /*method user to ANIMATE and FADE the DRAGGING INDEX*/
  Widget _buildIcon(T icon, double size, {bool isDragging = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isDragging
            ? Colors.grey.withOpacity(0.5)
            : Colors.primaries[icon.hashCode % Colors.primaries.length],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Opacity(
        opacity: isDragging ? 0.8 : 1.0,
        child: Center(
          child: Icon(icon as IconData, color: Colors.white, size: size),
        ),
      ),
    );
  }
}
