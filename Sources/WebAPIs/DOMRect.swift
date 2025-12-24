#if os(WASI)

public struct DOMRect: Sendable {
	public let x: Double
	public let y: Double
	public let width: Double
	public let height: Double
	public let top: Double
	public let right: Double
	public let bottom: Double
	public let left: Double

	public init(x: Double, y: Double, width: Double, height: Double, top: Double, right: Double, bottom: Double, left: Double) {
		self.x = x
		self.y = y
		self.width = width
		self.height = height
		self.top = top
		self.right = right
		self.bottom = bottom
		self.left = left
	}
}

#endif
