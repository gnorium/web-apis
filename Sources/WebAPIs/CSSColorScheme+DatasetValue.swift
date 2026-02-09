#if os(WASI)

import WebTypes

extension CSSColorScheme: DatasetValueProtocol {
	public var rawValue: StaticString {
		staticRawValue
	}
}

#endif
