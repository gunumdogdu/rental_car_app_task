import 'package:lottie/lottie.dart';
import 'package:overlay_kit/overlay_kit.dart';

class LoadingProgress {
  LoadingProgress.start() {
    OverlayLoadingProgress.start(widget: LottieBuilder.asset('assets/gifs/splash.json'));
  }

  LoadingProgress.stop() {
    OverlayLoadingProgress.stop();
  }
}
