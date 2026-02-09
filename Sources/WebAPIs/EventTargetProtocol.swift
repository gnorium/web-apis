#if os(WASI)

public protocol EventTargetProtocol: Sendable {
	@discardableResult
	func addEventListener(_ event: StaticString, _ handler: @escaping @Sendable (CallbackString) -> Void) -> Self
	func removeEventListener(_ event: StaticString)
	func dispatchEvent(_ event: StaticString)
	func dispatchEvent(_ event: CustomEvent)
}

#endif
