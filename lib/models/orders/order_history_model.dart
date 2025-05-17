class OrdersHistory {
  List<OrderHistoryModel>? orders;

  OrdersHistory({this.orders});

  factory OrdersHistory.fromJson(Map<String, dynamic> json) {
    return OrdersHistory(
      orders: json['orders'] != null
          ? List<OrderHistoryModel>.from(
              json['orders'].map((x) => OrderHistoryModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders?.map((x) => x.toJson()).toList(),
    };
  }
}

class OrderHistoryModel {
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
  String? createdAt;
  String? updatedAt;
  int? pos;
  int? deliveryId;
  int? addressId;
  String? notes;
  int? couponDiscount;
  String? orderNumber;
  int? paymentMethodId;
  String? receipt;
  String? status;
  int? points;
  List<OrderDetail>? orderDetails;
  String? rejectedReason;
  String? transactionId;
  String? customerCancelReason;
  String? adminCancelReason;
  int? captainId;
  int? tableId;
  int? cashierManId;
  int? cashierId;
  String? shift;
  String? orderDate;
  String? statusPayment;
  PaymentMethod? paymentMethod;

  OrderHistoryModel({
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
    this.orderDate,
    this.statusPayment,
    this.paymentMethod,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pos: json['pos'],
      deliveryId: json['delivery_id'],
      addressId: json['address_id'],
      notes: json['notes'],
      couponDiscount: json['coupon_discount'],
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
      orderDate: json['order_date'],
      statusPayment: json['status_payment'],
      paymentMethod: json['payment_method'] != null
          ? PaymentMethod.fromJson(json['payment_method'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'user_id': userId,
      'branch_id': branchId,
      'amount': amount,
      'order_status': orderStatus,
      'order_type': orderType,
      'payment_status': paymentStatus,
      'total_tax': totalTax,
      'total_discount': totalDiscount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pos': pos,
      'delivery_id': deliveryId,
      'address_id': addressId,
      'notes': notes,
      'coupon_discount': couponDiscount,
      'order_number': orderNumber,
      'payment_method_id': paymentMethodId,
      'receipt': receipt,
      'status': status,
      'points': points,
      'order_details': orderDetails?.map((x) => x.toJson()).toList(),
      'rejected_reason': rejectedReason,
      'transaction_id': transactionId,
      'customer_cancel_reason': customerCancelReason,
      'admin_cancel_reason': adminCancelReason,
      'captain_id': captainId,
      'table_id': tableId,
      'cashier_man_id': cashierManId,
      'cashier_id': cashierId,
      'shift': shift,
      'order_date': orderDate,
      'status_payment': statusPayment,
      'payment_method': paymentMethod?.toJson(),
    };
  }
}

class OrderDetail {
  List<ProductWrapper>? product;

  OrderDetail({this.product});

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      product: json['product'] != null
          ? List<ProductWrapper>.from(
              json['product'].map((x) => ProductWrapper.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product?.map((x) => x.toJson()).toList(),
    };
  }
}

class ProductWrapper {
  Product? product;
  int? count;
  String? notes;

  ProductWrapper({this.product, this.count, this.notes});

  factory ProductWrapper.fromJson(Map<String, dynamic> json) {
    return ProductWrapper(
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
      count: json['count'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product?.toJson(),
      'count': count,
      'notes': notes,
    };
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  String? image;
  int? categoryId;
  String? itemType;
  String? stockType;
  double? price;
  double? priceAfterDiscount;
  double? priceAfterTax;
  int? productTimeStatus;
  int? status;
  int? recommended;
  int? points;
  String? imageLink;
  List<Addon>? addons;

  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.categoryId,
    this.itemType,
    this.stockType,
    this.price,
    this.priceAfterDiscount,
    this.priceAfterTax,
    this.productTimeStatus,
    this.status,
    this.recommended,
    this.points,
    this.imageLink,
    this.addons,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      categoryId: json['category_id'],
      itemType: json['item_type'],
      stockType: json['stock_type'],
      price: (json['price'] as num?)?.toDouble(),
      priceAfterDiscount: (json['price_after_discount'] as num?)?.toDouble(),
      priceAfterTax: (json['price_after_tax'] as num?)?.toDouble(),
      productTimeStatus: json['product_time_status'],
      status: json['status'],
      recommended: json['recommended'],
      points: json['points'],
      imageLink: json['image_link'],
      addons: json['addons'] != null
          ? List<Addon>.from(json['addons'].map((x) => Addon.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'category_id': categoryId,
      'item_type': itemType,
      'stock_type': stockType,
      'price': price,
      'price_after_discount': priceAfterDiscount,
      'price_after_tax': priceAfterTax,
      'product_time_status': productTimeStatus,
      'status': status,
      'recommended': recommended,
      'points': points,
      'image_link': imageLink,
      'addons': addons?.map((x) => x.toJson()).toList(),
    };
  }
}

class Addon {
  int? id;
  String? name;
  double? price;
  double? priceAfterTax;
  int? taxId;
  int? quantityAdd;
  Tax? tax;

  Addon({
    this.id,
    this.name,
    this.price,
    this.priceAfterTax,
    this.taxId,
    this.quantityAdd,
    this.tax,
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num?)?.toDouble(),
      priceAfterTax: (json['price_after_tax'] as num?)?.toDouble(),
      taxId: json['tax_id'],
      quantityAdd: json['quantity_add'],
      tax: json['tax'] != null ? Tax.fromJson(json['tax']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'price_after_tax': priceAfterTax,
      'tax_id': taxId,
      'quantity_add': quantityAdd,
      'tax': tax?.toJson(),
    };
  }
}

class Tax {
  int? id;
  String? name;
  String? type;
  double? amount;

  Tax({
    this.id,
    this.name,
    this.type,
    this.amount,
  });

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount,
    };
  }
}

class PaymentMethod {
  int? id;
  String? name;
  String? description;
  String? logo;
  int? status;
  String? type;
  int? order;
  String? logoLink;

  PaymentMethod({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.status,
    this.type,
    this.order,
    this.logoLink,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
      status: json['status'],
      type: json['type'],
      order: json['order'],
      logoLink: json['logo_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'status': status,
      'type': type,
      'order': order,
      'logo_link': logoLink,
    };
  }
}
