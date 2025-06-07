class CardModel {
  final String cardholder;
  final String number;
  final String expiry;
  final String cvv;

  CardModel({required this.cardholder, required this.number, required this.expiry, required this.cvv});

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      cardholder: map['cardholder'],
      number: map['number'],
      expiry: map['expiry'],
      cvv: map['cvv'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardholder': cardholder,
      'number': number,
      'expiry': expiry,
      'cvv': cvv,
    };
  }
}
