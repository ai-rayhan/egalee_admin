class FireStoreCallerReturnObject {
  bool success;
  dynamic returnValue;
  String errorMessage;

  FireStoreCallerReturnObject(
      {required this.errorMessage,
      required this.returnValue,
      required this.success,
      });
}
