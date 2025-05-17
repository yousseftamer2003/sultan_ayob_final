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
  dynamic delivery;
  PaymentMethod? paymentMethod;

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
    this.orderDate,
    this.statusPayment,
    this.delivery,
    this.paymentMethod,
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
        orderDate: json['order_date'],
        statusPayment: json['status_payment'],
        delivery: json['delivery'],
        paymentMethod: json['payment_method'] != null
            ? PaymentMethod.fromJson(json['payment_method'])
            : null,
      );
}

class OrderDetail {
  List<AddonWrapper>? addons;
  List<ProductWrapper>? product;

  OrderDetail({
    this.addons,
    this.product,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        addons: json['addons'] != null
            ? List<AddonWrapper>.from(
                json['addons'].map((x) => AddonWrapper.fromJson(x)))
            : [],
        product: json['product'] != null
            ? List<ProductWrapper>.from(
                json['product'].map((x) => ProductWrapper.fromJson(x)))
            : [],
      );
}

class AddonWrapper {
  Addon? addon;
  int? count;

  AddonWrapper({this.addon, this.count});

  factory AddonWrapper.fromJson(Map<String, dynamic> json) => AddonWrapper(
        addon:
            json['addon'] != null ? Addon.fromJson(json['addon']) : null,
        count: json['count'],
      );
}

class ProductWrapper {
  Product? product;
  int? count;
  String? notes;

  ProductWrapper({this.product, this.count, this.notes});

  factory ProductWrapper.fromJson(Map<String, dynamic> json) =>
      ProductWrapper(
        product:
            json['product'] != null ? Product.fromJson(json['product']) : null,
        count: json['count'],
        notes: json['notes'],
      );
}

class Product {
  int? id;
  String? name;
  String? description;
  String? image;
  double? price;
  double? priceAfterDiscount;
  double? priceAfterTax;
  List<Addon>? addons;
  String? imageLink;

  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.priceAfterDiscount,
    this.priceAfterTax,
    this.addons,
    this.imageLink,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        price: (json['price'] as num?)?.toDouble(),
        priceAfterDiscount: (json['price_after_discount'] as num?)?.toDouble(),
        priceAfterTax: (json['price_after_tax'] as num?)?.toDouble(),
        imageLink: json['image_link'],
        addons: json['addons'] != null
            ? List<Addon>.from(json['addons'].map((x) => Addon.fromJson(x)))
            : [],
      );
}

class Addon {
  int? id;
  String? name;
  double? price;
  double? priceAfterTax;
  int? taxId;
  Tax? tax;

  Addon({
    this.id,
    this.name,
    this.price,
    this.priceAfterTax,
    this.taxId,
    this.tax,
  });

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
        id: json['id'],
        name: json['name'],
        price: (json['price'] as num?)?.toDouble(),
        priceAfterTax: (json['price_after_tax'] as num?)?.toDouble(),
        taxId: json['tax_id'],
        tax: json['tax'] != null ? Tax.fromJson(json['tax']) : null,
      );
}

class Tax {
  int? id;
  String? name;
  String? type;
  double? amount;

  Tax({this.id, this.name, this.type, this.amount});

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        amount: (json['amount'] as num?)?.toDouble(),
      );
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

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
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
