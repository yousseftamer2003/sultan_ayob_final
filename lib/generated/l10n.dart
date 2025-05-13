// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Choose\nYour Favorite Food`
  String get choose_your_favorite_food {
    return Intl.message(
      'Choose\nYour Favorite Food',
      name: 'choose_your_favorite_food',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Points`
  String get points {
    return Intl.message('Points', name: 'points', desc: '', args: []);
  }

  /// `See All`
  String get see_all {
    return Intl.message('See All', name: 'see_all', desc: '', args: []);
  }

  /// `Deals`
  String get deals {
    return Intl.message('Deals', name: 'deals', desc: '', args: []);
  }

  /// `Discount`
  String get discount {
    return Intl.message('Discount', name: 'discount', desc: '', args: []);
  }

  /// `Popular Food`
  String get popular_food {
    return Intl.message(
      'Popular Food',
      name: 'popular_food',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get select_language {
    return Intl.message(
      'Select Language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get English {
    return Intl.message('English', name: 'English', desc: '', args: []);
  }

  /// `Arabic`
  String get Arabic {
    return Intl.message('Arabic', name: 'Arabic', desc: '', args: []);
  }

  /// `No discount items available`
  String get no_discount_items_available {
    return Intl.message(
      'No discount items available',
      name: 'no_discount_items_available',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `No favorites yet!`
  String get no_favorites_yet {
    return Intl.message(
      'No favorites yet!',
      name: 'no_favorites_yet',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Profile`
  String get Profile {
    return Intl.message('Profile', name: 'Profile', desc: '', args: []);
  }

  /// `Welcome,`
  String get Welcome {
    return Intl.message('Welcome,', name: 'Welcome', desc: '', args: []);
  }

  /// `Personal Info`
  String get personal_info {
    return Intl.message(
      'Personal Info',
      name: 'personal_info',
      desc: '',
      args: [],
    );
  }

  /// `Addresses`
  String get addresses {
    return Intl.message('Addresses', name: 'addresses', desc: '', args: []);
  }

  /// `My Orders`
  String get my_orders {
    return Intl.message('My Orders', name: 'my_orders', desc: '', args: []);
  }

  /// `Log Out`
  String get log_out {
    return Intl.message('Log Out', name: 'log_out', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Redeeem points`
  String get redeeem_points {
    return Intl.message(
      'Redeeem points',
      name: 'redeeem_points',
      desc: '',
      args: [],
    );
  }

  /// `No offers available`
  String get no_offers_available {
    return Intl.message(
      'No offers available',
      name: 'no_offers_available',
      desc: '',
      args: [],
    );
  }

  /// `Cart Details`
  String get cart_details {
    return Intl.message(
      'Cart Details',
      name: 'cart_details',
      desc: '',
      args: [],
    );
  }

  /// `No items in cart yet`
  String get no_items_in_cart {
    return Intl.message(
      'No items in cart yet',
      name: 'no_items_in_cart',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Add to cart`
  String get add_to_cart {
    return Intl.message('Add to cart', name: 'add_to_cart', desc: '', args: []);
  }

  /// `Total Food`
  String get total_food {
    return Intl.message('Total Food', name: 'total_food', desc: '', args: []);
  }

  /// `Delivery Fee`
  String get delivery_fee {
    return Intl.message(
      'Delivery Fee',
      name: 'delivery_fee',
      desc: '',
      args: [],
    );
  }

  /// `Total Tax`
  String get total_tax {
    return Intl.message('Total Tax', name: 'total_tax', desc: '', args: []);
  }

  /// `EGP`
  String get Egp {
    return Intl.message('EGP', name: 'Egp', desc: '', args: []);
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Ingredients`
  String get ingredients {
    return Intl.message('Ingredients', name: 'ingredients', desc: '', args: []);
  }

  // skipped getter for the 'extra_&_excludes' key

  /// `Add on order`
  String get add_on_order {
    return Intl.message(
      'Add on order',
      name: 'add_on_order',
      desc: '',
      args: [],
    );
  }

  /// `No extras available`
  String get no_extras_available {
    return Intl.message(
      'No extras available',
      name: 'no_extras_available',
      desc: '',
      args: [],
    );
  }

  /// `Item added to cart`
  String get item_added_to_cart {
    return Intl.message(
      'Item added to cart',
      name: 'item_added_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueee {
    return Intl.message('Continue', name: 'continueee', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Ongoing`
  String get ongoing {
    return Intl.message('Ongoing', name: 'ongoing', desc: '', args: []);
  }

  /// `No order history`
  String get no_order_history {
    return Intl.message(
      'No order history',
      name: 'no_order_history',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'you_haven\'t_made_any_purchase_yet' key

  /// `Explore Menu`
  String get explore_menu {
    return Intl.message(
      'Explore Menu',
      name: 'explore_menu',
      desc: '',
      args: [],
    );
  }

  /// `Redeem In Restaurant?`
  String get redeem_in_restaurant {
    return Intl.message(
      'Redeem In Restaurant?',
      name: 'redeem_in_restaurant',
      desc: '',
      args: [],
    );
  }

  /// `Scan the code in the restaurant within 3 miniutes`
  String get scan_the_code_in_the_restaurant_within_3_mins {
    return Intl.message(
      'Scan the code in the restaurant within 3 miniutes',
      name: 'scan_the_code_in_the_restaurant_within_3_mins',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Redeem`
  String get redeem {
    return Intl.message('Redeem', name: 'redeem', desc: '', args: []);
  }

  /// `Order Summary`
  String get order_summary {
    return Intl.message(
      'Order Summary',
      name: 'order_summary',
      desc: '',
      args: [],
    );
  }

  /// `Choose Pickup or Delivery`
  String get Choose_Pickup_or_Delivery {
    return Intl.message(
      'Choose Pickup or Delivery',
      name: 'Choose_Pickup_or_Delivery',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load profile data`
  String get failed_to_load_profile {
    return Intl.message(
      'Failed to load profile data',
      name: 'failed_to_load_profile',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `FULL NAME`
  String get full_name {
    return Intl.message('FULL NAME', name: 'full_name', desc: '', args: []);
  }

  /// `EMAIL`
  String get email {
    return Intl.message('EMAIL', name: 'email', desc: '', args: []);
  }

  /// `PHONE NUMBER`
  String get phone_number {
    return Intl.message(
      'PHONE NUMBER',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load profile data`
  String get failed_to_load {
    return Intl.message(
      'Failed to load profile data',
      name: 'failed_to_load',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Addresses`
  String get appBarTitle {
    return Intl.message('Addresses', name: 'appBarTitle', desc: '', args: []);
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `No addresses found!`
  String get noAddressesFound {
    return Intl.message(
      'No addresses found!',
      name: 'noAddressesFound',
      desc: '',
      args: [],
    );
  }

  /// `Delete Address`
  String get deleteAddress {
    return Intl.message(
      'Delete Address',
      name: 'deleteAddress',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this address? This action cannot be undone.`
  String get deleteAddressWarning {
    return Intl.message(
      'Are you sure you want to delete this address? This action cannot be undone.',
      name: 'deleteAddressWarning',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Add Address`
  String get add_address {
    return Intl.message('Add Address', name: 'add_address', desc: '', args: []);
  }

  /// `Your Location`
  String get your_location {
    return Intl.message(
      'Your Location',
      name: 'your_location',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Building Number`
  String get building_number {
    return Intl.message(
      'Building Number',
      name: 'building_number',
      desc: '',
      args: [],
    );
  }

  /// `Floor Number`
  String get floor_number {
    return Intl.message(
      'Floor Number',
      name: 'floor_number',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Selected Address`
  String get selected_address {
    return Intl.message(
      'Selected Address',
      name: 'selected_address',
      desc: '',
      args: [],
    );
  }

  /// `Select Zone`
  String get select_zone {
    return Intl.message('Select Zone', name: 'select_zone', desc: '', args: []);
  }

  /// `Street`
  String get street {
    return Intl.message('Street', name: 'street', desc: '', args: []);
  }

  /// `Building No.`
  String get building_no {
    return Intl.message(
      'Building No.',
      name: 'building_no',
      desc: '',
      args: [],
    );
  }

  /// `Floor No.`
  String get floor_no {
    return Intl.message('Floor No.', name: 'floor_no', desc: '', args: []);
  }

  /// `Apartment`
  String get apartment {
    return Intl.message('Apartment', name: 'apartment', desc: '', args: []);
  }

  /// `Additional Data`
  String get additional_data {
    return Intl.message(
      'Additional Data',
      name: 'additional_data',
      desc: '',
      args: [],
    );
  }

  /// `Save Address`
  String get save_address {
    return Intl.message(
      'Save Address',
      name: 'save_address',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Work`
  String get work {
    return Intl.message('Work', name: 'work', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Please select a zone`
  String get please_select_zone {
    return Intl.message(
      'Please select a zone',
      name: 'please_select_zone',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get field_required {
    return Intl.message(
      'This field is required',
      name: 'field_required',
      desc: '',
      args: [],
    );
  }

  /// `My Order`
  String get myOrder {
    return Intl.message('My Order', name: 'myOrder', desc: '', args: []);
  }

  /// `No Order History`
  String get noOrderHistory {
    return Intl.message(
      'No Order History',
      name: 'noOrderHistory',
      desc: '',
      args: [],
    );
  }

  /// `You haven't made any purchase yet`
  String get noOrders {
    return Intl.message(
      'You haven\'t made any purchase yet',
      name: 'noOrders',
      desc: '',
      args: [],
    );
  }

  /// `Explore Menu`
  String get exploreMenu {
    return Intl.message(
      'Explore Menu',
      name: 'exploreMenu',
      desc: '',
      args: [],
    );
  }

  /// `Order Actions`
  String get order_actions {
    return Intl.message(
      'Order Actions',
      name: 'order_actions',
      desc: '',
      args: [],
    );
  }

  /// `Choose an action for your order.`
  String get choose_action {
    return Intl.message(
      'Choose an action for your order.',
      name: 'choose_action',
      desc: '',
      args: [],
    );
  }

  /// `Track Order`
  String get track_order {
    return Intl.message('Track Order', name: 'track_order', desc: '', args: []);
  }

  /// `Cancel Order`
  String get cancel_order {
    return Intl.message(
      'Cancel Order',
      name: 'cancel_order',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation Time Expired`
  String get cancellation_time_expired {
    return Intl.message(
      'Cancellation Time Expired',
      name: 'cancellation_time_expired',
      desc: '',
      args: [],
    );
  }

  /// `Order #{id}`
  String order_number(Object id) {
    return Intl.message(
      'Order #$id',
      name: 'order_number',
      desc: '',
      args: [id],
    );
  }

  /// `{amount} £`
  String order_amount(Object amount) {
    return Intl.message(
      '$amount £',
      name: 'order_amount',
      desc: '',
      args: [amount],
    );
  }

  /// `Paid by {paidBy}`
  String paid_by(Object paidBy) {
    return Intl.message(
      'Paid by $paidBy',
      name: 'paid_by',
      desc: '',
      args: [paidBy],
    );
  }

  /// `Status: {status}`
  String order_status(Object status) {
    return Intl.message(
      'Status: $status',
      name: 'order_status',
      desc: '',
      args: [status],
    );
  }

  /// `Order Tracking`
  String get order_tracking {
    return Intl.message(
      'Order Tracking',
      name: 'order_tracking',
      desc: '',
      args: [],
    );
  }

  /// `Delivery time: unknown`
  String get delivery_time {
    return Intl.message(
      'Delivery time: unknown',
      name: 'delivery_time',
      desc: '',
      args: [],
    );
  }

  /// `Time Difference: {minutes} minutes`
  String time_difference(Object minutes) {
    return Intl.message(
      'Time Difference: $minutes minutes',
      name: 'time_difference',
      desc: '',
      args: [minutes],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `accapted`
  String get preparing {
    return Intl.message('accapted', name: 'preparing', desc: '', args: []);
  }

  /// `Out for Delivery`
  String get out_for_delivery {
    return Intl.message(
      'Out for Delivery',
      name: 'out_for_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Error: {error}`
  String error_loading_data(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'error_loading_data',
      desc: '',
      args: [error],
    );
  }

  /// `No data found`
  String get no_data_found {
    return Intl.message(
      'No data found',
      name: 'no_data_found',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message('Filter', name: 'filter', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Loading categories...`
  String get loadingCategories {
    return Intl.message(
      'Loading categories...',
      name: 'loadingCategories',
      desc: '',
      args: [],
    );
  }

  /// `Pick Up`
  String get pick_up {
    return Intl.message('Pick Up', name: 'pick_up', desc: '', args: []);
  }

  /// `Dine In`
  String get dine_in {
    return Intl.message('Dine In', name: 'dine_in', desc: '', args: []);
  }

  /// `Delivery`
  String get delivery {
    return Intl.message('Delivery', name: 'delivery', desc: '', args: []);
  }

  /// `Payment Method`
  String get payment_method {
    return Intl.message(
      'Payment Method',
      name: 'payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Recieving Time`
  String get recieving_time {
    return Intl.message(
      'Recieving Time',
      name: 'recieving_time',
      desc: '',
      args: [],
    );
  }

  /// `building num:`
  String get building_num {
    return Intl.message(
      'building num:',
      name: 'building_num',
      desc: '',
      args: [],
    );
  }

  /// `floor num:`
  String get floor_num {
    return Intl.message('floor num:', name: 'floor_num', desc: '', args: []);
  }

  /// `apartment:`
  String get apartement {
    return Intl.message('apartment:', name: 'apartement', desc: '', args: []);
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `Upload Receipt`
  String get upload_reciept {
    return Intl.message(
      'Upload Receipt',
      name: 'upload_reciept',
      desc: '',
      args: [],
    );
  }

  /// `Pay to`
  String get PayTo {
    return Intl.message('Pay to', name: 'PayTo', desc: '', args: []);
  }

  /// `Receipt uploaded successfully.`
  String get receipt_uploaded_successfully {
    return Intl.message(
      'Receipt uploaded successfully.',
      name: 'receipt_uploaded_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Add a note (e.g., delivery instructions)`
  String get add_note {
    return Intl.message(
      'Add a note (e.g., delivery instructions)',
      name: 'add_note',
      desc: '',
      args: [],
    );
  }

  /// `Select recieving time`
  String get select_recieving_time {
    return Intl.message(
      'Select recieving time',
      name: 'select_recieving_time',
      desc: '',
      args: [],
    );
  }

  /// `Please select a payment method and delivery option`
  String get Please_select_a_payment_method_and_delivery_option {
    return Intl.message(
      'Please select a payment method and delivery option',
      name: 'Please_select_a_payment_method_and_delivery_option',
      desc: '',
      args: [],
    );
  }

  /// `Please select an address to procced the order`
  String get Please_select_an_address_to_procced_the_order {
    return Intl.message(
      'Please select an address to procced the order',
      name: 'Please_select_an_address_to_procced_the_order',
      desc: '',
      args: [],
    );
  }

  /// `Please select an branch to procced the order`
  String get Please_select_an_branch_to_procced_the_order {
    return Intl.message(
      'Please select an branch to procced the order',
      name: 'Please_select_an_branch_to_procced_the_order',
      desc: '',
      args: [],
    );
  }

  /// `Please select a delivery time`
  String get Please_select_a_delivery_time {
    return Intl.message(
      'Please select a delivery time',
      name: 'Please_select_a_delivery_time',
      desc: '',
      args: [],
    );
  }

  /// `try anothe rpayment please`
  String get try_another_payment_please {
    return Intl.message(
      'try anothe rpayment please',
      name: 'try_another_payment_please',
      desc: '',
      args: [],
    );
  }

  /// `Place Order`
  String get place_order {
    return Intl.message('Place Order', name: 'place_order', desc: '', args: []);
  }

  /// `You have to login first`
  String get you_have_to_login_first {
    return Intl.message(
      'You have to login first',
      name: 'you_have_to_login_first',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all the required fields`
  String get please_fill_required_fields {
    return Intl.message(
      'Please fill all the required fields',
      name: 'please_fill_required_fields',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get Result {
    return Intl.message('Result', name: 'Result', desc: '', args: []);
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Login to view cart`
  String get login_to_view_cart {
    return Intl.message(
      'Login to view cart',
      name: 'login_to_view_cart',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
