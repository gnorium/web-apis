#if os(WASI)

import WebTypes

public struct ScrollIntoViewOptions: Sendable {
    public let behavior: String
	public let block: String
	public let inline: String

    public enum Behavior: String, Sendable {
        case auto
        case smooth
        case instant
    }

    public enum Block: String, Sendable {
        case start
        case center
        case end
        case nearest
    }

    public enum Inline: String, Sendable {
        case start
        case center
        case end
        case nearest
    }

	public init(behavior: Behavior = .auto, block: Block = .start, inline: Inline = .nearest) {
        self.behavior = behavior.rawValue
		self.block = block.rawValue
		self.inline = inline.rawValue
	}

    // Backwards compatibility for string-based init
    public init(block: String, inline: String) {
        self.behavior = "\(CSSKeyword.Auto.auto.rawValue)"
        self.block = block
        self.inline = inline
    }

	public static var nearest: String { "nearest" }
}

#endif
