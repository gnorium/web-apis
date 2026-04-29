#if CLIENT
  public class CallbackRegistry: @unchecked Sendable {
    private static let shared = CallbackRegistry()
    private var closures: [Int32: @Sendable (CallbackString) -> Void] = [:]
    private var nextID: Int32 = 0

    private init() {}

    public static func register(_ closure: @escaping @Sendable (CallbackString) -> Void) -> Int32 {
      let id = shared.nextID
      shared.nextID += 1
      shared.closures[id] = closure
      return id
    }

    public static func invoke(_ id: Int32, _ eventKey: CallbackString) {
      shared.closures[id]?(eventKey)
    }

    public static func unregister(_ id: Int32) {
      shared.closures.removeValue(forKey: id)
    }
  }

  @_expose(wasm, "invokeCallback")
  public func invokeCallback(
    _ id: Int32, _ eventKeyPointer: UnsafePointer<CChar>, _ eventKeyLen: Int32
  ) {
    let eventKey = CallbackString(ptr: eventKeyPointer, len: Int(eventKeyLen))
    CallbackRegistry.invoke(id, eventKey)
  }
#endif
