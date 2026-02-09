#if os(WASI)

public protocol CSSPropertyValueProtocol {
	var rawValue: StaticString { get }
}

#endif
