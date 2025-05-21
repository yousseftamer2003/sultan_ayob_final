class OrdersResponse {
  List<Order>? orders;
  String? cancelTime;

  OrdersResponse({this.orders, this.cancelTime});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => OrdersResponse(
        orders: json['orders'] != null
            ? List<Order>.from(json['orders'].map((x) => Order.fromJson(x)))
            : null,
        cancelTime: json['cancel_time'],
      );
}

class Order {
  int? id;
  String? date;
  int? userId;
  int? branchId;
  double? amount;
  String? orderStatus;
  String? orderType;
  String? paymentStatus;
  double? totalTax;
  double? totalDiscount;
  String? address;
  String? createdAt;
  String? updatedAt;
  int? pos;
  int? deliveryId;
  int? addressId;
  String? notes;
  double? couponDiscount;
  String? orderNumber;
  int? paymentMethodId;
  String? receipt;
  String? status;
  int? points;
  List<OrderDetail>? orderDetails;
  String? rejectedReason;
  int? transactionId;
  String? customerCancelReason;
  String? adminCancelReason;
  int? captainId;
  int? tableId;
  int? cashierManId;
  int? cashierId;
  String? shift;
  int? adminId;
  String? operationStatus;
  int? secheduleSlotId;
  double? deliveryPrice;
  String? branchName;
  String? addressName;
  String? orderDate;
  String? statusPayment;
  dynamic delivery;
  PaymentMethod? paymentMethod;
  Branch? branch;

  Order({
    this.id,
    this.date,
    this.userId,
    this.branchId,
    this.amount,
    this.orderStatus,
    this.orderType,
    this.paymentStatus,
    this.totalTax,
    this.totalDiscount,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.pos,
    this.deliveryId,
    this.addressId,
    this.notes,
    this.couponDiscount,
    this.orderNumber,
    this.paymentMethodId,
    this.receipt,
    this.status,
    this.points,
    this.orderDetails,
    this.rejectedReason,
    this.transactionId,
    this.customerCancelReason,
    this.adminCancelReason,
    this.captainId,
    this.tableId,
    this.cashierManId,
    this.cashierId,
    this.shift,
    this.adminId,
    this.operationStatus,
    this.secheduleSlotId,
    this.deliveryPrice,
    this.branchName,
    this.addressName,
    this.orderDate,
    this.statusPayment,
    this.delivery,
    this.paymentMethod,
    this.branch,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        date: json['date'],
        userId: json['user_id'],
        branchId: json['branch_id'],
        amount: (json['amount'] as num?)?.toDouble(),
        orderStatus: json['order_status'],
        orderType: json['order_type'],
        paymentStatus: json['payment_status'],
        totalTax: (json['total_tax'] as num?)?.toDouble(),
        totalDiscount: (json['total_discount'] as num?)?.toDouble(),
        address: json['address'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        pos: json['pos'],
        deliveryId: json['delivery_id'],
        addressId: json['address_id'],
        notes: json['notes'],
        couponDiscount: (json['coupon_discount'] as num?)?.toDouble(),
        orderNumber: json['order_number'],
        paymentMethodId: json['payment_method_id'],
        receipt: json['receipt'],
        status: json['status'],
        points: json['points'],
        orderDetails: json['order_details'] != null
            ? List<OrderDetail>.from(
                json['order_details'].map((x) => OrderDetail.fromJson(x)))
            : [],
        rejectedReason: json['rejected_reason'],
        transactionId: json['transaction_id'],
        customerCancelReason: json['customer_cancel_reason'],
        adminCancelReason: json['admin_cancel_reason'],
        captainId: json['captain_id'],
        tableId: json['table_id'],
        cashierManId: json['cashier_man_id'],
        cashierId: json['cashier_id'],
        shift: json['shift'],
        adminId: json['admin_id'],
        operationStatus: json['operation_status'],
        secheduleSlotId: json['sechedule_slot_id'],
        deliveryPrice: (json['delivery_price'] as num?)?.toDouble(),
        branchName: json['branch_name'],
        addressName: json['address_name'],
        orderDate: json['order_date'],
        statusPayment: json['status_payment'],
        delivery: json['delivery'],
        paymentMethod: json['payment_method'] != null
            ? PaymentMethod.fromJson(json['payment_method'])
            : null,
        branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      );
}

class OrderDetail {
  List<dynamic>? extras;
  List<AddonWrapper>? addons;
  List<dynamic>? excludes;
  List<ProductWrapper>? product;
  List<dynamic>? variations;

  OrderDetail({
    this.extras,
    this.addons,
    this.excludes,
    this.product,
    this.variations,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        extras:
            json['extras'] != null ? List<dynamic>.from(json['extras']) : [],
        addons: json['addons'] != null
            ? List<AddonWrapper>.from(
                json['addons'].map((x) => AddonWrapper.fromJson(x)))
            : [],
        excludes: json['excludes'] != null
            ? List<dynamic>.from(json['excludes'])
            : [],
        product: json['product'] != null
            ? List<ProductWrapper>.from(
                json['product'].map((x) => ProductWrapper.fromJson(x)))
            : [],
        variations: json['variations'] != null
            ? List<dynamic>.from(json['variations'])
            : [],
      );
}

class AddonWrapper {
  Addon? addon;
  int? count;

  AddonWrapper({this.addon, this.count});

  factory AddonWrapper.fromJson(Map<String, dynamic> json) => AddonWrapper(
        addon: json['addon'] != null ? Addon.fromJson(json['addon']) : null,
        count: json['count'],
      );
}

class ProductWrapper {
  Product? product;
  int? count;
  String? notes;

  ProductWrapper({this.product, this.count, this.notes});

  factory ProductWrapper.fromJson(Map<String, dynamic> json) => ProductWrapper(
        product:
            json['product'] != null ? Product.fromJson(json['product']) : null,
        count: json['count'],
        notes: json['notes'],
      );
}

class Product {
  int? id;
  List<dynamic>? allExtras;
  String? taxes;
  String? name;
  String? description;
  String? image;
  int? categoryId;
  dynamic subCategoryId;
  String? itemType;
  String? stockType;
  dynamic number;
  double? price;
  double? priceAfterDiscount;
  double? priceAfterTax;
  int? productTimeStatus;
  dynamic from;
  dynamic to;
  dynamic discountId;
  dynamic taxId;
  int? status;
  int? recommended;
  int? points;
  String? imageLink;
  int? ordersCount;
  dynamic discount;
  dynamic tax;
  List<Addon>? addons;
  List<dynamic>? extra;
  List<dynamic>? variations;
  bool? favourite;
  String? createdAt;
  String? updatedAt;

  Product({
    this.id,
    this.allExtras,
    this.taxes,
    this.name,
    this.description,
    this.image,
    this.categoryId,
    this.subCategoryId,
    this.itemType,
    this.stockType,
    this.number,
    this.price,
    this.priceAfterDiscount,
    this.priceAfterTax,
    this.productTimeStatus,
    this.from,
    this.to,
    this.discountId,
    this.taxId,
    this.status,
    this.recommended,
    this.points,
    this.imageLink,
    this.ordersCount,
    this.discount,
    this.tax,
    this.addons,
    this.extra,
    this.variations,
    this.favourite,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        allExtras: json['allExtras'] != null
            ? List<dynamic>.from(json['allExtras'])
            : [],
        taxes: json['taxes'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        categoryId: json['category_id'],
        subCategoryId: json['sub_category_id'],
        itemType: json['item_type'],
        stockType: json['stock_type'],
        number: json['number'],
        price: (json['price'] as num?)?.toDouble(),
        priceAfterDiscount: (json['price_after_discount'] as num?)?.toDouble(),
        priceAfterTax: (json['price_after_tax'] as num?)?.toDouble(),
        productTimeStatus: json['product_time_status'],
        from: json['from'],
        to: json['to'],
        discountId: json['discount_id'],
        taxId: json['tax_id'],
        status: json['status'],
        recommended: json['recommended'],
        points: json['points'],
        imageLink: json['image_link'],
        ordersCount: json['orders_count'],
        discount: json['discount'],
        tax: json['tax'],
        addons: json['addons'] != null
            ? List<Addon>.from(json['addons'].map((x) => Addon.fromJson(x)))
            : [],
        extra: json['extra'] != null ? List<dynamic>.from(json['extra']) : [],
        variations: json['variations'] != null
            ? List<dynamic>.from(json['variations'])
            : [],
        favourite: json['favourite'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class Addon {
  int? id;
  String? name;
  double? price;
  double? priceAfterTax;
  int? taxId;
  int? quantityAdd;
  Tax? tax;
  String? createdAt;
  String? updatedAt;

  Addon({
    this.id,
    this.name,
    this.price,
    this.priceAfterTax,
    this.taxId,
    this.quantityAdd,
    this.tax,
    this.createdAt,
    this.updatedAt,
  });

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
        id: json['id'],
        name: json['name'],
        price: (json['price'] as num?)?.toDouble(),
        priceAfterTax: (json['price_after_tax'] as num?)?.toDouble(),
        taxId: json['tax_id'],
        quantityAdd: json['quantity_add'],
        tax: json['tax'] != null ? Tax.fromJson(json['tax']) : null,
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class Tax {
  int? id;
  String? name;
  String? type;
  double? amount;
  String? createdAt;
  String? updatedAt;

  Tax(
      {this.id,
      this.name,
      this.type,
      this.amount,
      this.createdAt,
      this.updatedAt});

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        amount: (json['amount'] as num?)?.toDouble(),
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class PaymentMethod {
  int? id;
  String? name;
  String? description;
  String? logo;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;
  String? type;
  int? order;
  String? logoLink;

  PaymentMethod({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.order,
    this.logoLink,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        logo: json['logo'],
        status: json['status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        type: json['type'],
        order: json['order'],
        logoLink: json['logo_link'],
      );
}

class Branch {
  int? id;
  String? name;
  String? address;
  String? email;
  String? phone;
  String? image;
  String? coverImage;
  String? foodPreparionTime;
  int? latitude;
  String? longitude;
  String? coverage;
  int? status;
  dynamic emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? cityId;
  int? main;
  String? role;
  String? imageLink;
  String? coverImageLink;
  String? map;

  Branch({
    this.id,
    this.name,
    this.address,
    this.email,
    this.phone,
    this.image,
    this.coverImage,
    this.foodPreparionTime,
    this.latitude,
    this.longitude,
    this.coverage,
    this.status,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.cityId,
    this.main,
    this.role,
    this.imageLink,
    this.coverImageLink,
    this.map,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        email: json['email'],
        phone: json['phone'],
        image: json['image'],
        coverImage: json['cover_image'],
        foodPreparionTime: json['food_preparion_time'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        coverage: json['coverage'],
        status: json['status'],
        emailVerifiedAt: json['email_verified_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        cityId: json['city_id'],
        main: json['main'],
        role: json['role'],
        imageLink: json['image_link'],
        coverImageLink: json['cover_image_link'],
        map: json['map'],
      );
}
