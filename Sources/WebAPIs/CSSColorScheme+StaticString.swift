#if os(WASI)

import WebTypes

extension CSSColorScheme {
	public var staticRawValue: StaticString {
		switch self {
		case .normal:
			return "normal"
		case .light:
			return "light"
		case .dark:
			return "dark"
		case .onlyLight:
			return "only light"
		case .inherit:
			return "inherit"
		case .initial:
			return "initial"
		case .revert:
			return "revert"
		case .revertLayer:
			return "revert-layer"
		case .unset:
			return "unset"
		}
	}
}

#endif
