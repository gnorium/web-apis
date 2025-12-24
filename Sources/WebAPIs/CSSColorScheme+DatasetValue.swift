#if os(WASI)

import WebTypes

extension CSSColorScheme: DatasetValue {
	public var rawValue: StaticString {
		staticRawValue
	}
}

#endif
