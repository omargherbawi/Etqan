import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../../../core/services/analytics.service.dart';
import '../../data/models/faq_questions_model.dart';

import '../../data/datasources/account_remote_datasource.dart';

class HelpCenterController extends GetxController {
  final _accountRemoteDataSource = Get.find<AccountRemoteDatasource>();

  final List<FaqQuestion> _cachedFaqs = [];
  final List<FaqTypes> _faqTypes = [];
  List<FaqQuestion> _allFaqs = [];
  final String updateFaqs = "updateFaqs";

  List<FaqQuestion> get allFaqs => _allFaqs;

  List<FaqTypes> get faqTypes => _faqTypes;

  final isLoading = false.obs;
  final RxInt _selectedFaq = 0.obs;

  int get selectedFaq => _selectedFaq.value;

  set selectedFaq(int index) {
    _selectedFaq.value = index;
    filterFaqType();
  }

  @override
  void onInit() {
    super.onInit();
    fetchFaqTypes();
    filterFaqType();
  }

  Future<void> fetchFaqTypes() async {
    isLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    final res = await _accountRemoteDataSource.getFaqTypes();
    res.fold(
      (l) {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'fetchFaqType',
          className: 'help_center_controller',
          parameters: {"error": l.toString(), 'message': l.message},
        );
        ToastUtils.showError(l.message);
      },
      (r) {
        faqTypes.clear();
        faqTypes.addAll(r);

        _selectedFaq.value = -1;
        fetchFaqs();
      },
    );
  }

  Future<void> fetchFaqs() async {
    await Future.delayed(const Duration(seconds: 1));
    final res = await _accountRemoteDataSource.getFaqQuestions();
    res.fold((l) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'fetchFaq',
        className: 'help_center_controller',
        parameters: {"error": l.toString(), 'message': l.message},
      );
      ToastUtils.showError(l.message);
    }, (r) {
      _cachedFaqs.clear();
      _cachedFaqs.addAll(r);

      _allFaqs = List.from(_cachedFaqs);
      selectedFaq = 0;
    });
    isLoading(false);
  }

  void filterFaqType() {
    if (selectedFaq == 0) {
      _allFaqs = List.from(_cachedFaqs);
    } else {
      _allFaqs =
          _cachedFaqs
              .where((element) => element.typeId == selectedFaq)
              .toList();
    }
    update([updateFaqs]);
  }
}
