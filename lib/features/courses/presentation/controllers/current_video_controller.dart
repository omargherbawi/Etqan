import 'package:get/get.dart';

class CurrentVideoController extends GetxController {
  final currentVideoUrl = Rxn<String>();

  final currentVideoId = RxnInt();

  void changeCurrentVideoUrl({required String video, int? id}) {
    if (video == currentVideoUrl.value) {
      return;
    }

    if (video.contains("store") && !video.startsWith("http")) {
      currentVideoUrl(video);
      currentVideoId(id);
    } else {
      currentVideoUrl(video);
      currentVideoId(id);
    }
  }

  void toggleVideoWatchedStatus(bool value) {}

  @override
  void onClose() {
    currentVideoUrl.close();
    currentVideoId.close();

    super.onClose();
  }
}
