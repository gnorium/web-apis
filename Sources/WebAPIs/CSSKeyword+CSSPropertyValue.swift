#if os(WASI)

import WebTypes

extension CSSKeyword.None: CSSPropertyValueProtocol {
	public var rawValue: StaticString {
		switch self {
		case .none: return "none"
		}
	}
}

extension CSSKeyword.Auto: CSSPropertyValueProtocol {
	public var rawValue: StaticString {
		switch self {
		case .auto: return "auto"
		}
	}
}

extension CSSKeyword.Global: CSSPropertyValueProtocol {
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
