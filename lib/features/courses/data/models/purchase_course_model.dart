import 'course_model.dart';
import '../../../auth/data/models/user_model.dart';

class PurchaseCourseModel {
  int? id;

  ////////////////////////////////////////////////
  // String? thumbnail;
  String? image;
  String? classSemester;

  // String? status;
  String? label;
  String? title;

  // String? description;
  String? type;
  String? link;

  bool? isFavorite;

  // bool? expired;
  // int? expireOn;
  String? priceString;

  // String? bestTicketString;
  int? price;

  // int? tax;
  // int? taxWithDiscount;
  // var bestTicketPrice;
  int? discountPercent;

  // int? coursePageTax;
  num? priceWithDiscount;
  int? discountAmount;

  // ActiveSpecialOffer? activeSpecialOffer;
  int? duration;
  UserModel? teacher;
  int? studentsCount;
  String? rate;
  RateType? rateType;

  int? isPrivate;

  PurchaseCourseModel({
    this.id,

    ////////////////////
    this.classSemester,
    this.image,

    this.label,
    this.title,
    // this.description,
    this.type,
    this.link,
    // this.accessDays,
    // this.salesCountNumber,
    // this.liveWebinarStatus,
    // this.authHasBought,
    // this.sales,
    this.isFavorite,
    // this.expired,
    // this.expireOn,
    this.priceString,
    // this.bestTicketString,
    this.price,
    // this.tax,
    // this.taxWithDiscount,
    // this.bestTicketPrice,
    this.discountPercent,
    // this.coursePageTax,
    this.priceWithDiscount,
    this.discountAmount,
    // this.activeSpecialOffer,
    this.duration,
    this.teacher,
    this.studentsCount,
    this.rate,
    this.rateType,
  });

  PurchaseCourseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // sellerId = json['seller_id'];
    // buyerId = json['buyer_id'];
    // orderId = json['order_id'];
    // webinarId = json['webinar_id'];
    // bundleId = json['bundle_id'];
    // meetingId = json['meeting_id'];
    // meetingTimeId = json['meeting_time_id'];
    // subscribeId = json['subscribe_id'];
    // ticketId = json['ticket_id'];
    // promotionId = json['promotion_id'];
    // productOrderId = json['product_order_id'];
    // registrationPackageId = json['registration_package_id'];
    // installmentPaymentId = json['installment_payment_id'];
    // giftId = json['gift_id'];
    // paymentMethod = json['payment_method'];
    // type = json['type'];
    // amount = json['amount'];
    // tax = json['tax'];
    // commission = json['commission'];
    // discount = json['discount'];
    // totalAmount = json['total_amount'];
    // productDeliveryFee = int.tryParse(
    //   json['product_delivery_fee']?.toString() ?? '0',
    // );
    // manualAdded = json['manual_added'];
    // accessToPurchasedItem = json['access_to_purchased_item'];
    // createdAt = json['created_at'];
    // refundAt = json['refund_at'];
    // expired = json['expired'];
    // expiredAt = json['expired_at'];
    // webinar =
    //     json['webinar'] != null ? CourseModel.fromJson(json['webinar']) : null;
    // bundle =
    //     json['bundle'] != null ? CourseModel.fromJson(json['bundle']) : null;
    //////////////////////////////////////
    image = json['image'];
    // auth = json['auth'];
    // can = json['can'] != null ? Can.fromJson(json['can']) : null;
    // canViewError = json['can_view_error'];
    // status = json['status'];
    label = json['label'];
    title = json['title'];

    // description = json['description'] ?? "";

    type = json['type'];
    link = json['link'];
    // accessDays = json['access_days'];

    // salesCountNumber = json['sales_count_number'] ?? 0;

    // liveWebinarStatus = json['live_webinar_status'];
    // authHasBought = json['auth_has_bought'];
    // sales = json['sales'] != null ? Sales.fromJson(json['sales']) : null;
    isFavorite = json['is_favorite'];
    //
    // expired = json['expired'] ?? false;
    // expireOn = json['expire_on'] ?? 0;

    priceString = json['price_string'];
    // bestTicketString = json['best_ticket_string'];
    price = (json['price'] as num?)?.toInt();
    // tax = json['tax'];
    // taxWithDiscount = json['tax_with_discount'];
    // bestTicketPrice = json['best_ticket_price'];
    discountPercent = json['discount_percent'] ?? 0;
    // coursePageTax = json['course_page_tax'];
    priceWithDiscount = json['price_with_discount'];
    discountAmount = json['discount_amount'];
    // activeSpecialOffer =
    //     json['active_special_offer'] != null
    //         ? ActiveSpecialOffer.fromJson(json['active_special_offer'])
    //         : null;
    duration = (json['duration'] as num?)?.toInt();
    teacher =
    json['teacher'] != null ? UserModel.fromJson(json['teacher']) : null;
    studentsCount = json['students_count'] ?? 0;
    rate = json['rate'].toString();
    rateType =
    json['rate_type'] != null ? RateType.fromJson(json['rate_type']) : null;
    // createdAt = (json['created_at'] as num?)?.toInt();
    // startDate = json['start_date'];
    // purchasedAt = json['purchased_at'];
    // reviewsCount = json['reviews_count'];
    // points = json['points'];
    // progress = (json['progress'] as num?)?.toInt();
    // progressPercent = (json['progress_percent'] as num?)?.toInt();
    // category =
    //     json['category'].runtimeType == String
    //         ? json['category']
    //         : json['category']?['slug'];
    // capacity = json['capacity'];
    classSemester = json['class_semester'];
    // reservedMeeting = json['reserved_meeting'] ?? "";
    // reservedMeetingUserTimeZone = json['reserved_meeting_user_time_zone'] ?? "";
    isPrivate = json['isPrivate'] ?? 0;
    // lessons = json['lessons'] ?? 0;
    // teacherList = json['teacherList'] ?? [];

    // if (json['translations'] != null) {
    //   translations = <Translations>[];
    //   json['translations'].forEach((v) {
    //     translations!.add(Translations.fromJson(v));
    //   });
    // }

    // if (json['badges'] != null) {
    //   badges = <CustomBadges>[];
    //   json['badges'].forEach((v) {
    //     badges!.add(CustomBadges.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // data['seller_id'] = sellerId;
    // data['buyer_id'] = buyerId;
    // data['order_id'] = orderId;
    // data['webinar_id'] = webinarId;
    // data['bundle_id'] = bundleId;
    // data['meeting_id'] = meetingId;
    // data['meeting_time_id'] = meetingTimeId;
    // data['subscribe_id'] = subscribeId;
    // data['ticket_id'] = ticketId;
    // data['promotion_id'] = promotionId;
    // data['product_order_id'] = productOrderId;
    // data['registration_package_id'] = registrationPackageId;
    // data['installment_payment_id'] = installmentPaymentId;
    // data['gift_id'] = giftId;
    // data['payment_method'] = paymentMethod;
    // data['type'] = type;
    // data['amount'] = amount;
    // data['tax'] = tax;
    // data['commission'] = commission;
    // data['discount'] = discount;
    // data['total_amount'] = totalAmount;
    // data['product_delivery_fee'] = productDeliveryFee;
    // data['manual_added'] = manualAdded;
    // data['access_to_purchased_item'] = accessToPurchasedItem;
    // data['created_at'] = createdAt;
    // data['refund_at'] = refundAt;
    // data['expired'] = expired;
    // if (webinar != null) {
    //   data['webinar'] = webinar!.toJson();
    // }
    // data['bundle'] = bundle?.toJson();
    // return data;

    ///////////////////////////////
    // data['thumbnail'] = thumbnail;
    data['image'] = image;
    // data['auth'] = auth;
    // if (can != null) {
    //   data['can'] = can!.toJson();
    // }
    // data['can_view_error'] = canViewError;
    // data['status'] = status;
    data['label'] = label;
    data['title'] = title;
    // data['description'] = description;
    data['type'] = type;
    data['link'] = link;
    // data['access_days'] = accessDays;
    // data['sales_count_number'] = salesCountNumber;
    // data['live_webinar_status'] = liveWebinarStatus;
    // data['auth_has_bought'] = authHasBought;
    // if (sales != null) {
    // data['sales'] = sales!.toJson();
    // }
    data['is_favorite'] = isFavorite;
    // data['expired'] = expired;
    // data['expire_on'] = expireOn;
    data['price_string'] = priceString;
    // data['best_ticket_string'] = bestTicketString;
    data['price'] = price;
    // data['tax'] = tax;
    // data['tax_with_discount'] = taxWithDiscount;
    // data['best_ticket_price'] = bestTicketPrice;
    data['discount_percent'] = discountPercent;
    // data['course_page_tax'] = coursePageTax;
    data['price_with_discount'] = priceWithDiscount;
    data['discount_amount'] = discountAmount;
    // if (activeSpecialOffer != null) {
    //   data['active_special_offer'] = activeSpecialOffer!.toJson();
    // }
    data['duration'] = duration;
    if (teacher != null) {
      data['teacher'] = teacher!.toJson();
    }
    data['students_count'] = studentsCount;
    data['rate'] = rate;
    if (rateType != null) {
      data['rate_type'] = rateType!.toJson();
    }
    // data['created_at'] = createdAt;
    // data['start_date'] = startDate;
    // data['purchased_at'] = purchasedAt;
    // data['reviews_count'] = reviewsCount;
    // data['points'] = points;
    // data['progress'] = progress;
    // data['progress_percent'] = progressPercent;
    // data['category'] = category;
    data['class_semester'] = classSemester;
    // data['capacity'] = capacity;
    // data['reserved_meeting'] = reservedMeeting;
    // data['reserved_meeting_user_time_zone'] = reservedMeetingUserTimeZone;
    data['isPrivate'] = isPrivate;
    // data['lessons'] = lessons;

    // if (translations != null) {
    //   data['translations'] = translations!.map((v) => v.toJson()).toList();
    // }

    // if (badges != null) {
    //   data['badges'] = badges!.map((v) => v.toJson()).toList();
    // }

    return data;
  }
}
