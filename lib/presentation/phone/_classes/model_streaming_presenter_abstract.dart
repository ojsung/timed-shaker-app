import 'dart:async';

abstract class ModelStreamingPresenter<Model, BuildArgs extends Object?> {
  static final Finalizer<StreamController> _finalizer = Finalizer((controller) => controller.sink.close());
  StreamController<Model>? __streamController;
  StreamController<Model> get _streamController {
    final StreamController<Model> controller;
    if (__streamController == null) {
      controller = __streamController ??= StreamController.broadcast();
      _finalizer.attach(this, controller, detach: controller);
    } else {
      controller = __streamController ??= StreamController.broadcast();
    }
    return controller;
  }

  StreamSink<Model> get sink => _streamController.sink;
  Stream<Model> get stream => _streamController.stream;

  Model build(BuildArgs args);
}
