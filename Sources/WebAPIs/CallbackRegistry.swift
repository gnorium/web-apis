#if os(WASI)

public class CallbackRegistry: @unchecked Sendable {
	private static let shared = CallbackRegistry()
	private var closures: [Int: @Sendable (CallbackString) -> Void] = [:]
	private var nextId = 0

	private init() {}

	public static func register(_ closure: @escaping @Sendable (CallbackString) -> Void) -> Int {
		let id = shared.nextId
		shared.nextId += 1
		shared.closures[id] = closure
		return id
	}

	public static func invoke(_ id: Int, _ eventKey: CallbackString) {
		shared.closures[id]?(eventKey)
	}

	public static func unregister(_ id: Int) {
		shared.closures.removeValue(forKey: id)
	}
}

@_expose(wasm, "invokeCallback")
public func invokeCallback(_ id: Int, _ eventKeyPointer: UnsafePointer<CChar>, _ eventKeyLen: Int32) {
	let eventKey = CallbackString(ptr: eventKeyPointer, len: Int(eventKeyLen))
	CallbackRegistry.invoke(id, eventKey)
}

#endif
