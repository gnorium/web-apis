#if os(WASI)

import WebTypes

extension CSSKeyword.None: CSSPropertyValue {
	public var rawValue: StaticString {
		switch self {
		case .none: return "none"
		}
	}
}

extension CSSKeyword.Auto: CSSPropertyValue {
	public var rawValue: StaticString {
		switch self {
		case .auto: return "auto"
		}
	}
}

extension CSSKeyword.Global: CSSPropertyValue {
	public var rawValue: StaticString {
		switch self {
		case .inherit: return "inherit"
		case .initial: return "initial"
		case .revert: return "revert"
		case .revertLayer: return "revert-layer"
		case .unset: return "unset"
		}
	}
}

#endif
