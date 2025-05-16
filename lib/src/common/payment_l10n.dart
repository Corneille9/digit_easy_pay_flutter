import 'package:flutter/material.dart';

/// Base class for localization in the payment processing UI.
///
/// This abstract class defines all the translatable strings used
/// throughout the payment flow.
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
  final String paymentWaitingValidation;
  final String paymentFailed;
  final String cancelPayment;
  final String wantToCancel;
  final String anErrorOccurCheckConnection;
  final String retry;

  final String anErrorOccur;
  final String selectYourPreferredPaymentMethod;
  final String noPaymentMethod;
  final String processingPayment;

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
    required this.paymentWaitingValidation,
    required this.paymentFailed,
    required this.cancelPayment,
    required this.wantToCancel,
    required this.anErrorOccurCheckConnection,
    required this.retry,
    required this.anErrorOccur,
    required this.selectYourPreferredPaymentMethod,
    required this.noPaymentMethod,
    required this.processingPayment,
  });
}

/// English localization
@immutable
class L10nEn extends L10n {
  const L10nEn({
    super.firstname = "First Name",
    super.lastname = "Last Name",
    super.middleName = "Middle Name",
    super.email = "Email",
    super.phoneNumber = "Phone Number",
    super.title = "Title",
    super.country = "Country",
    super.city = "City",
    super.department = "Department",
    super.neighborhood = "Neighborhood",
    super.address = "Address",
    super.postalCode = "Postal Code",
    super.buildingNumber = "Building Number",
    super.pay = "Pay",
    super.bankCard = "Bank Card",
    super.totalToPay = "Total to Pay",
    super.invalidField = "Please fill out this field correctly",
    super.invalidEmail = "Please enter a valid email address",
    super.invalidPhone = "Please enter a valid phone number",
    super.yes = "Yes",
    super.no = "No",
    super.paymentSuccessfully = "Payment was successful",
    super.paymentWaitingValidation =
    "Your payment is pending validation. Thank you for your patience.",
    super.paymentFailed = "Your payment failed. Please try again.",
    super.cancelPayment = "Cancel Payment",
    super.wantToCancel = "Are you sure you want to cancel this payment?",
    super.anErrorOccurCheckConnection = "An error occurred. Please check your connection and retry",
    super.retry = "Retry",
    super.anErrorOccur = "An error occurred while processing your payment. Please try again.",
    super.selectYourPreferredPaymentMethod = "Select your preferred payment method",
    super.noPaymentMethod = "No payment method available",
    super.processingPayment = "Processing payment",
  });
}

/// French localization
@immutable
class L10nFr extends L10n {
  const L10nFr({
    super.firstname = "Prénom",
    super.lastname = "Nom",
    super.middleName = "Second prénom",
    super.email = "Adresse e-mail",
    super.phoneNumber = "Numéro de téléphone",
    super.title = "Titre",
    super.country = "Pays",
    super.city = "Ville",
    super.department = "Département",
    super.neighborhood = "Quartier",
    super.address = "Adresse",
    super.postalCode = "Code postal",
    super.buildingNumber = "Numéro de bâtiment",
    super.pay = "Payer",
    super.bankCard = "Carte bancaire",
    super.totalToPay = "Montant total à payer",
    super.invalidField = "Veuillez remplir ce champ correctement",
    super.invalidEmail = "Veuillez saisir une adresse e-mail valide",
    super.invalidPhone = "Veuillez saisir un numéro de téléphone valide",
    super.yes = "Oui",
    super.no = "Non",
    super.paymentSuccessfully = "Paiement effectué avec succès",
    super.paymentWaitingValidation =
    "Votre paiement est en attente de validation. Merci pour votre patience.",
    super.paymentFailed = "Votre paiement a échoué. Veuillez réessayer.",
    super.cancelPayment = "Annuler le paiement",
    super.wantToCancel = "Êtes-vous sûr de vouloir annuler ce paiement ?",
    super.anErrorOccurCheckConnection =
    "Une erreur est survenue. Veuillez vérifier votre connexion et réessayer",
    super.retry = "Réessayer",
    super.anErrorOccur = "Une erreur est survenue lors du traitement de votre paiement. Veuillez réessayer.",
    super.selectYourPreferredPaymentMethod = "Sélectionnez votre méthode de paiement préférée",
    super.noPaymentMethod = "Aucune méthode de paiement disponible",
    super.processingPayment = "Traitement du paiement en cours",
  });
}

/// Chinese localization
@immutable
class L10nCn extends L10n {
  const L10nCn({
    super.firstname = "名字",
    super.lastname = "姓",
    super.middleName = "中间名",
    super.email = "电子邮件",
    super.phoneNumber = "电话号码",
    super.title = "标题",
    super.country = "国家",
    super.city = "城市",
    super.department = "部门",
    super.neighborhood = "社区",
    super.address = "地址",
    super.postalCode = "邮政编码",
    super.buildingNumber = "楼号",
    super.pay = "支付",
    super.bankCard = "银行卡",
    super.totalToPay = "支付总额",
    super.invalidField = "请正确填写此字段",
    super.invalidEmail = "请输入有效的电子邮件地址",
    super.invalidPhone = "请输入有效的电话号码",
    super.yes = "是",
    super.no = "否",
    super.paymentSuccessfully = "付款成功",
    super.paymentWaitingValidation = "您的付款正在等待验证。感谢您的耐心。",
    super.paymentFailed = "付款失败，请重试",
    super.cancelPayment = "取消付款",
    super.wantToCancel = "您确定要取消付款吗？",
    super.anErrorOccurCheckConnection = "发生错误，请检查您的连接并重试",
    super.retry = "重试",
    super.anErrorOccur = "处理您的付款时发生错误。请重试。",
    super.selectYourPreferredPaymentMethod = "选择您的首选支付方式",
    super.noPaymentMethod = "没有可用的支付方式",
    super.processingPayment = "正在处理付款",
  });
}

/// Spanish localization
@immutable
class L10nEs extends L10n {
  const L10nEs({
    super.firstname = "Nombre",
    super.lastname = "Apellido",
    super.middleName = "Segundo nombre",
    super.email = "Correo electrónico",
    super.phoneNumber = "Número de teléfono",
    super.title = "Título",
    super.country = "País",
    super.city = "Ciudad",
    super.department = "Departamento",
    super.neighborhood = "Barrio",
    super.address = "Dirección",
    super.postalCode = "Código postal",
    super.buildingNumber = "Número de edificio",
    super.pay = "Pagar",
    super.bankCard = "Tarjeta bancaria",
    super.totalToPay = "Total a pagar",
    super.invalidField = "Por favor, complete este campo correctamente",
    super.invalidEmail = "Por favor, introduzca una dirección de correo electrónico válida",
    super.invalidPhone = "Por favor, introduzca un número de teléfono válido",
    super.yes = "Sí",
    super.no = "No",
    super.paymentSuccessfully = "El pago se ha realizado con éxito",
    super.paymentWaitingValidation =
    "Su pago está pendiente de validación. Gracias por su paciencia.",
    super.paymentFailed = "Su pago ha fallado. Por favor, inténtelo de nuevo.",
    super.cancelPayment = "Cancelar pago",
    super.wantToCancel = "¿Está seguro de que desea cancelar este pago?",
    super.anErrorOccurCheckConnection =
    "Se ha producido un error. Por favor, compruebe su conexión e inténtelo de nuevo",
    super.retry = "Reintentar",
    super.anErrorOccur = "Se ha producido un error al procesar su pago. Por favor, inténtelo de nuevo.",
    super.selectYourPreferredPaymentMethod = "Seleccione su método de pago preferido",
    super.noPaymentMethod = "No hay métodos de pago disponibles",
    super.processingPayment = "Procesando pago",
  });
}

/// Portuguese localization
@immutable
class L10nPt extends L10n {
  const L10nPt({
    super.firstname = "Nome",
    super.lastname = "Sobrenome",
    super.middleName = "Nome do meio",
    super.email = "E-mail",
    super.phoneNumber = "Número de telefone",
    super.title = "Título",
    super.country = "País",
    super.city = "Cidade",
    super.department = "Departamento",
    super.neighborhood = "Bairro",
    super.address = "Endereço",
    super.postalCode = "Código postal",
    super.buildingNumber = "Número do edifício",
    super.pay = "Pagar",
    super.bankCard = "Cartão bancário",
    super.totalToPay = "Total a pagar",
    super.invalidField = "Por favor, preencha este campo corretamente",
    super.invalidEmail = "Por favor, insira um endereço de e-mail válido",
    super.invalidPhone = "Por favor, insira um número de telefone válido",
    super.yes = "Sim",
    super.no = "Não",
    super.paymentSuccessfully = "Pagamento realizado com sucesso",
    super.paymentWaitingValidation =
    "Seu pagamento está aguardando validação. Obrigado pela sua paciência.",
    super.paymentFailed = "Seu pagamento falhou. Por favor, tente novamente.",
    super.cancelPayment = "Cancelar pagamento",
    super.wantToCancel = "Tem certeza de que deseja cancelar este pagamento?",
    super.anErrorOccurCheckConnection =
    "Ocorreu um erro. Por favor, verifique sua conexão e tente novamente",
    super.retry = "Tentar novamente",
    super.anErrorOccur = "Ocorreu um erro ao processar seu pagamento. Por favor, tente novamente.",
    super.selectYourPreferredPaymentMethod = "Selecione seu método de pagamento preferido",
    super.noPaymentMethod = "Nenhum método de pagamento disponível",
    super.processingPayment = "Processando pagamento",
  });
}

/// Arabic localization
@immutable
class L10nAr extends L10n {
  const L10nAr({
    super.firstname = "الاسم الأول",
    super.lastname = "اسم العائلة",
    super.middleName = "الاسم الأوسط",
    super.email = "البريد الإلكتروني",
    super.phoneNumber = "رقم الهاتف",
    super.title = "العنوان",
    super.country = "البلد",
    super.city = "المدينة",
    super.department = "القسم",
    super.neighborhood = "الحي",
    super.address = "العنوان",
    super.postalCode = "الرمز البريدي",
    super.buildingNumber = "رقم المبنى",
    super.pay = "دفع",
    super.bankCard = "بطاقة مصرفية",
    super.totalToPay = "المبلغ الإجمالي للدفع",
    super.invalidField = "يرجى ملء هذا الحقل بشكل صحيح",
    super.invalidEmail = "يرجى إدخال عنوان بريد إلكتروني صالح",
    super.invalidPhone = "يرجى إدخال رقم هاتف صالح",
    super.yes = "نعم",
    super.no = "لا",
    super.paymentSuccessfully = "تم الدفع بنجاح",
    super.paymentWaitingValidation =
    "دفعتك في انتظار التحقق. شكرا لصبرك.",
    super.paymentFailed = "فشلت عملية الدفع. يرجى المحاولة مرة أخرى.",
    super.cancelPayment = "إلغاء الدفع",
    super.wantToCancel = "هل أنت متأكد أنك تريد إلغاء هذا الدفع؟",
    super.anErrorOccurCheckConnection =
    "حدث خطأ. يرجى التحقق من اتصالك والمحاولة مرة أخرى",
    super.retry = "إعادة المحاولة",
    super.anErrorOccur = "حدث خطأ أثناء معالجة الدفع الخاص بك. يرجى المحاولة مرة أخرى.",
    super.selectYourPreferredPaymentMethod = "اختر طريقة الدفع المفضلة لديك",
    super.noPaymentMethod = "لا توجد طرق دفع متاحة",
    super.processingPayment = "جاري معالجة الدفع",
  });
}

/// German localization
@immutable
class L10nDe extends L10n {
  const L10nDe({
    super.firstname = "Vorname",
    super.lastname = "Nachname",
    super.middleName = "Zweiter Vorname",
    super.email = "E-Mail",
    super.phoneNumber = "Telefonnummer",
    super.title = "Titel",
    super.country = "Land",
    super.city = "Stadt",
    super.department = "Abteilung",
    super.neighborhood = "Stadtteil",
    super.address = "Adresse",
    super.postalCode = "Postleitzahl",
    super.buildingNumber = "Gebäudenummer",
    super.pay = "Bezahlen",
    super.bankCard = "Bankkarte",
    super.totalToPay = "Gesamtbetrag",
    super.invalidField = "Bitte füllen Sie dieses Feld korrekt aus",
    super.invalidEmail = "Bitte geben Sie eine gültige E-Mail-Adresse ein",
    super.invalidPhone = "Bitte geben Sie eine gültige Telefonnummer ein",
    super.yes = "Ja",
    super.no = "Nein",
    super.paymentSuccessfully = "Zahlung erfolgreich",
    super.paymentWaitingValidation =
    "Ihre Zahlung wartet auf Bestätigung. Vielen Dank für Ihre Geduld.",
    super.paymentFailed = "Ihre Zahlung ist fehlgeschlagen. Bitte versuchen Sie es erneut.",
    super.cancelPayment = "Zahlung abbrechen",
    super.wantToCancel = "Sind Sie sicher, dass Sie diese Zahlung abbrechen möchten?",
    super.anErrorOccurCheckConnection =
    "Ein Fehler ist aufgetreten. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut",
    super.retry = "Wiederholen",
    super.anErrorOccur = "Bei der Verarbeitung Ihrer Zahlung ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.",
    super.selectYourPreferredPaymentMethod = "Wählen Sie Ihre bevorzugte Zahlungsmethode",
    super.noPaymentMethod = "Keine Zahlungsmethode verfügbar",
    super.processingPayment = "Zahlung wird verarbeitet",
  });
}