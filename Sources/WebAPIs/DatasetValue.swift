#if os(WASI)

public protocol DatasetValue {
	var rawValue: StaticString { get }
}

#endif
