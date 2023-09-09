import 'package:timed_shaker/presentation/phone/_classes/model_streaming_presenter_abstract.dart';
import 'package:vibration/vibration.dart';
import 'edit_sleep_type_view_model.dart';

class EditSleepTypePresenter extends ModelStreamingPresenter<EditSleepTypeViewModel, void> {
  @override
  EditSleepTypeViewModel build(args) {
    return EditSleepTypeViewModel();
  }
}
