import 'package:flame/components.dart' as C;
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Button extends SpriteComponent with C.Draggable {
  Button({required this.button, this.marginLeft, this.marginTop})
      : super(size: Vector2.all(16));
  final String button;
  double? marginLeft;
  double? marginTop;
  bool state = false;
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(button);
    size = Vector2(50, 50);
    position = Vector2(marginLeft ?? 0, marginTop ?? 0);
  }

  @override
  bool onDragStart(DragStartInfo info) {
    // TODO: implement onDragStart
    state = true;
    return super.onDragStart(info);
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    // TODO: implement onDragEnd
    state = false;
    return super.onDragEnd(info);
  }
}
