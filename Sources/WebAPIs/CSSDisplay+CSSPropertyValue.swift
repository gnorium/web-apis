#if os(WASI)

import WebTypes

extension CSSDisplay.Outside: CSSPropertyValueProtocol {
	public var rawValue: StaticString {
		switch self {
			case .block: return "block"
			case .inline: return "inline"
		}
	}
}

extension CSSDisplay.Box: CSSPropertyValueProtocol {
	public var rawValue: StaticString {
		switch self {
			case .contents: return "contents"
		}
	}
}

extension CSSDisplay.Inside: CSSPropertyValueProtocol {
	public var rawValue: StaticString {
		switch self {
			case .flow: return "flow"
			case .flowRoot: return "flow-root"
			case .table: return "table"
			case .flex: return "flex"
			case .grid: return "grid"
			case .ruby: return "ruby"
		}
	}
}

extension CSSDisplay.ListItem: CSSPropertyValueProtocol {
	public var rawValue: StaticString {
		switch self {
			case .listItem: return "list-item"
		}
	}
}

extension CSSDisplay.Legacy: CSSPropertyValueProtocol {
	public var rawValue: StaticString {
		switch self {
			case .inlineBlock: return "inline-block"
			case .inlineTable: return "inline-table"
			case .inlineFlex: return "inline-flex"
			case .inlineGrid: return "inline-grid"
		}
	}
}

#endif
