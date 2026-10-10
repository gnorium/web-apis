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

    /// A callback the browser calls once (a frame, a timeout, a fetch's
    /// reply): it leaves the registry as it runs. Without this every
    /// `requestAnimationFrame` kept its closure forever—a loop at 60 frames
    /// a second grew the registry by 216,000 closures an hour.
    public static func registerOnce(_ closure: @escaping @Sendable (CallbackString) -> Void) -> Int32 {
      let id = shared.nextID
      shared.nextID += 1
      shared.closures[id] = { eventKey in
        shared.closures.removeValue(forKey: id)
        closure(eventKey)
      }
      return id
    }

    public static func invoke(_ id: Int32, _ eventKey: CallbackString) {
      guard let closure = shared.closures[id] else { return }
      closure(eventKey)
    }

    public static func unregister(_ id: Int32) {
      shared.closures.removeValue(forKey: id)
    }
  }

  public func dispatchCallback(
    _ id: Int32, _ eventKeyPointer: UnsafePointer<CChar>, _ eventKeyLen: Int32
  ) {
    let eventKey = CallbackString(ptr: eventKeyPointer, len: Int(eventKeyLen))
    CallbackRegistry.invoke(id, eventKey)
  }

#endif
