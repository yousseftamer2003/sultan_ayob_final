class BusinessSetup {
  final bool login;
  final bool loginDelivery;
  final double minOrder;
  final String today;
  final CompanyInfo companyInfo;
  final bool openFlag;

  BusinessSetup({
    required this.login,
    required this.loginDelivery,
    required this.minOrder,
    required this.today,
    required this.companyInfo,
    required this.openFlag,
  });

  factory BusinessSetup.fromJson(Map<String, dynamic> json) {
    return BusinessSetup(
      login: json['login_customer'],
      loginDelivery: json['login_delivery'],
      minOrder: json['min_order'].toDouble(),
      today: json['today'],
      companyInfo: CompanyInfo.fromJson(json['company_info']),
      openFlag: json['open_flag'],
    );
  }
}

class CompanyInfo {
  final String name;
  final int id;
  final String? logoLink;
  final int currencyId;
  final String currencyPosition;
  final Currency currency;

  CompanyInfo(
      {required this.name,
      required this.id,
      required this.logoLink,
      required this.currencyId,
      required this.currencyPosition,
      required this.currency});

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      name: json['name'],
      id: json['id'],
      logoLink: json['logo_link'] ?? 'No image',
      currencyId: json['currency_id'],
      currencyPosition: json['currency_position'],
      currency: Currency(
        id: json['currency']['id'],
        name: json['currency']['currancy_name'],
      ),
    );
  }
}

class Currency {
  final int id;
  final String name;

  Currency({required this.id, required this.name});
}
