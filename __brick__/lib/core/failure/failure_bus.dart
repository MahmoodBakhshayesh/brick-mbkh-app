class FailureBus {
  FailureBus._();
  static final I = FailureBus._();

  void emitMsg(String message) {
    // Hook your global error UI here.
  }
}
