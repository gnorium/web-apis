#if os(WASI)

public protocol DatasetValueProtocol {
	var rawValue: StaticString { get }
}

#endif
