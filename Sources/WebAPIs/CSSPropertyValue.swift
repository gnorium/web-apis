#if os(WASI)

public protocol CSSPropertyValue {
	var rawValue: StaticString { get }
}

#endif
