// public methods for validating barcodes

// determine type of barcode
  String determineBarcodeType(String barcode) {
    final digitsOnly = RegExp(r'^\d+$');
    final cleanedBarcode = barcode.trim();

    if (digitsOnly.hasMatch(cleanedBarcode)) {
      if (cleanedBarcode.length == 13 && isValidEan13(cleanedBarcode)) {
        return 'ean13';
      }
      if (cleanedBarcode.length == 8 && isValidEan8(cleanedBarcode)) {
        return 'ean8';
      }
    }

    return 'code128'; // most general fallback
  }

// validate EAN-8
bool isValidEan8(String code) {
  if (code.length != 8 || !RegExp(r'^\d{8}$').hasMatch(code)) return false;
  int sum = 0;
  for (int i = 0; i < 7; i++) {
    int digit = int.parse(code[i]);
    sum += i.isEven ? digit * 3 : digit;
  }
  int check = (10 - (sum % 10)) % 10;
  return check == int.parse(code[7]);
}

// validate EAN-13
bool isValidEan13(String code) {
  if (code.length != 13 || !RegExp(r'^\d{13}$').hasMatch(code)) return false;
  int sum = 0;
  for (int i = 0; i < 12; i++) {
    int digit = int.parse(code[i]);
    sum += i.isEven ? digit : digit * 3;
  }
  int check = (10 - (sum % 10)) % 10;
  return check == int.parse(code[12]);
}