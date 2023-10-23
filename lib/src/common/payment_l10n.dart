import 'package:flutter/material.dart';

@immutable
abstract class L10n {
  final String firstname;
  final String lastname;
  final String middleName;
  final String email;
  final String phoneNumber;
  final String title;
  final String country;
  final String city;
  final String department;
  final String neighborhood;
  final String address;
  final String postalCode;
  final String buildingNumber;

  final String pay;
  final String bankCard;
  final String totalToPay;

  final String invalidField;
  final String invalidEmail;
  final String invalidPhone;

  final String yes;
  final String no;

  final String paymentSuccessfully;
  final String paymentFailed;
  final String cancelPayment;
  final String wantToCancel;
  final String anErrorOccurCheckConnection;
  final String retry;

  const L10n({
    required this.firstname,
    required this.lastname,
    required this.middleName,
    required this.email,
    required this.phoneNumber,
    required this.title,
    required this.country,
    required this.city,
    required this.department,
    required this.neighborhood,
    required this.address,
    required this.postalCode,
    required this.buildingNumber,
    required this.pay,
    required this.bankCard,
    required this.totalToPay,
    required this.invalidField,
    required this.invalidEmail,
    required this.invalidPhone,
    required this.yes,
    required this.no,
    required this.paymentSuccessfully,
    required this.paymentFailed,
    required this.cancelPayment,
    required this.wantToCancel,
    required this.anErrorOccurCheckConnection,
    required this.retry,
  });
}

@immutable
class L10nEn extends L10n {
  const L10nEn({
    String firstname = "First Name",
    String lastname = "Last Name",
    String middleName = "Middle Name",
    String email = "Email",
    String phoneNumber = "Phone Number",
    String title = "Title",
    String country = "Country",
    String city = "City",
    String department = "Department",
    String neighborhood = "Neighborhood",
    String address = "Address",
    String postalCode = "Postal Code",
    String buildingNumber = "Building Number",
    String pay = "Pay",
    String bankCard = "Bank Card",
    String totalToPay = "Total to Pay",
    String invalidField = "Please fill out this field correctly",
    String invalidEmail = "Please enter a valid email address",
    String invalidPhone = "Please enter a valid phone number",
    String yes = "Yes",
    String no = "No",
    String paymentSuccessfully = "Payment was successful",
    String paymentFailed = "Payment failed. Please try again or contact support",
    String cancelPayment = "Cancel Payment",
    String wantToCancel = "Are you sure you want to cancel the payment?",
    String anErrorOccurCheckConnection = "An error occurred. Please check your connection and retry",
    String retry = "Retry",
  }) : super(
    firstname: firstname,
    lastname: lastname,
    middleName: middleName,
    email: email,
    phoneNumber: phoneNumber,
    title: title,
    country: country,
    city: city,
    department: department,
    neighborhood: neighborhood,
    address: address,
    postalCode: postalCode,
    buildingNumber: buildingNumber,
    pay: pay,
    bankCard: bankCard,
    totalToPay: totalToPay,
    invalidField: invalidField,
    invalidEmail: invalidEmail,
    invalidPhone: invalidPhone,
    yes: yes,
    no: no,
    paymentSuccessfully: paymentSuccessfully,
    paymentFailed: paymentFailed,
    cancelPayment: cancelPayment,
    wantToCancel: wantToCancel,
    anErrorOccurCheckConnection: anErrorOccurCheckConnection,
    retry: retry,
  );
}


@immutable
class L10nFr extends L10n {
  const L10nFr({
    String firstname = "Prénom",
    String lastname = "Nom de famille",
    String middleName = "Deuxième prénom",
    String email = "Email",
    String phoneNumber = "Numéro de téléphone",
    String title = "Titre",
    String country = "Pays",
    String city = "Ville",
    String department = "Département",
    String neighborhood = "Quartier",
    String address = "Adresse",
    String postalCode = "Code postal",
    String buildingNumber = "Numéro de bâtiment",
    String pay = "Payer",
    String bankCard = "Carte bancaire",
    String totalToPay = "Montant total à payer",
    String invalidField = "Veuillez remplir ce champ correctement",
    String invalidEmail = "Veuillez entrer une adresse email valide",
    String invalidPhone = "Veuillez entrer un numéro de téléphone valide",
    String yes = "Oui",
    String no = "Non",
    String paymentSuccessfully = "Le paiement a été effectué avec succès",
    String paymentFailed = "Le paiement a échoué. Veuillez réessayer ou contacter le support",
    String cancelPayment = "Annuler le paiement",
    String wantToCancel = "Êtes-vous sûr de vouloir annuler le paiement ?",
    String anErrorOccurCheckConnection = "Une erreur s'est produite. Veuillez vérifier votre connexion et réessayer",
    String retry = "Réessayer",
  }) : super(
    firstname: firstname,
    lastname: lastname,
    middleName: middleName,
    email: email,
    phoneNumber: phoneNumber,
    title: title,
    country: country,
    city: city,
    department: department,
    neighborhood: neighborhood,
    address: address,
    postalCode: postalCode,
    buildingNumber: buildingNumber,
    pay: pay,
    bankCard: bankCard,
    totalToPay: totalToPay,
    invalidField: invalidField,
    invalidEmail: invalidEmail,
    invalidPhone: invalidPhone,
    yes: yes,
    no: no,
    paymentSuccessfully: paymentSuccessfully,
    paymentFailed: paymentFailed,
    cancelPayment: cancelPayment,
    wantToCancel: wantToCancel,
    anErrorOccurCheckConnection: anErrorOccurCheckConnection,
    retry: retry,
  );
}

@immutable
class L10nCn extends L10n {
  const L10nCn({
    String firstname = "名字",
    String lastname = "姓",
    String middleName = "中间名",
    String email = "电子邮件",
    String phoneNumber = "电话号码",
    String title = "标题",
    String country = "国家",
    String city = "城市",
    String department = "部门",
    String neighborhood = "社区",
    String address = "地址",
    String postalCode = "邮政编码",
    String buildingNumber = "楼号",
    String pay = "支付",
    String bankCard = "银行卡",
    String totalToPay = "支付总额",
    String invalidField = "请正确填写此字段",
    String invalidEmail = "请输入有效的电子邮件地址",
    String invalidPhone = "请输入有效的电话号码",
    String yes = "是",
    String no = "否",
    String paymentSuccessfully = "付款成功",
    String paymentFailed = "付款失败，请重试或联系客服",
    String cancelPayment = "取消付款",
    String wantToCancel = "您确定要取消付款吗？",
    String anErrorOccurCheckConnection = "发生错误，请检查您的连接并重试",
    String retry = "重试",
  }) : super(
    firstname: firstname,
    lastname: lastname,
    middleName: middleName,
    email: email,
    phoneNumber: phoneNumber,
    title: title,
    country: country,
    city: city,
    department: department,
    neighborhood: neighborhood,
    address: address,
    postalCode: postalCode,
    buildingNumber: buildingNumber,
    pay: pay,
    bankCard: bankCard,
    totalToPay: totalToPay,
    invalidField: invalidField,
    invalidEmail: invalidEmail,
    invalidPhone: invalidPhone,
    yes: yes,
    no: no,
    paymentSuccessfully: paymentSuccessfully,
    paymentFailed: paymentFailed,
    cancelPayment: cancelPayment,
    wantToCancel: wantToCancel,
    anErrorOccurCheckConnection: anErrorOccurCheckConnection,
    retry: retry,
  );
}

