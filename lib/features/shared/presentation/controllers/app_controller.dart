import '../../../auth/data/models/country_code_model.dart';
import '../../enums/country_enum.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final currentLocation = CountryEnum.syria.obs;
  late final Rx<CountryCode> countryCode = Rx<CountryCode>(
    CountryCode(code: 'SY', dialCode: '+963', name: 'syria'),
  );

  final isReviewing = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchCurrentLocation();
    // react to location changes:
    // ever(currentLocation, (_) {
    // countryCode.value =
    // currentLocation.value == CountryEnum.syria
    // ?
    CountryCode(code: 'SY', dialCode: '+963', name: 'syria');
    // : CountryCode(code: 'IQ', dialCode: '+964', name: 'Iraq');
  }

  // fetchIsReviewing();
}

  // void fetchCurrentLocation() async {
  //   final country = await LocationUtils.getCurrentCountry();
  //   currentLocation.value =
  //       country == "syria"
  //           ? CountryEnum.syria
  //           : country == "Iraq"
  //           ? CountryEnum.iraq
  //           : CountryEnum.syria;
  // }

  // void fetchIsReviewing() async {
  //   isReviewing.value = await _sharedRemoteDatasources.isReviewing();
  // }

