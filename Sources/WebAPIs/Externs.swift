#if CLIENT
  import EmbeddedSwiftUtilities

  @_extern(wasm, module: "env", name: "element_getTagName")
  func element_getTagName(
    _ elementID: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "element_setAttribute")
  func element_setAttribute(
    _ elementID: Int32, _ namePointer: UnsafePointer<CChar>, _ nameLen: Int32,
    _ valuePointer: UnsafePointer<CChar>, _ valueLen: Int32)

  @_extern(wasm, module: "env", name: "element_setInnerHTML")
  func element_setInnerHTML(_ elementID: Int32, _ pointer: UnsafePointer<CChar>, _ len: Int32)

  @_extern(wasm, module: "env", name: "element_setStyleProperty")
  func element_setStyleProperty(
    _ elementID: Int32, _ propPointer: UnsafePointer<CChar>, _ propLen: Int32,
    _ valPointer: UnsafePointer<CChar>, _ valLen: Int32)

  @_extern(wasm, module: "env", name: "element_removeStyleProperty")
  func element_removeStyleProperty(
    _ elementID: Int32, _ propPointer: UnsafePointer<CChar>, _ propLen: Int32)

  @_extern(wasm, module: "env", name: "element_getStyleProperty")
  func element_getStyleProperty(
    _ elementID: Int32, _ propPointer: UnsafePointer<CChar>, _ propLen: Int32,
    _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "element_addClass")
  func element_addClass(_ elementID: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)

  @_extern(wasm, module: "env", name: "element_removeClass")
  func element_removeClass(
    _ elementID: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)

  @_extern(wasm, module: "env", name: "element_toggleClass")
  func element_toggleClass(
    _ elementID: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)
#endif
