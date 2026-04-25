#if CLIENT
  import DOMBuilder
  import WebTypes

  public struct MouseEvent: @unchecked Sendable {
    public let event: CallbackString

    public init(_ event: CallbackString) {
      self.event = event
    }

    public init(_ event: Event) {
      self.event = event.payload
    }

    public var target: Element? {
      event.target
    }

    public var relatedTarget: Element? {
      event.relatedTarget
    }

    public var clientX: Double {
      event.clientX
    }

    public var clientY: Double {
      event.clientY
    }

    public func preventDefault() {
      event.preventDefault()
    }

    public func stopPropagation() {
      event.stopPropagation()
    }
  }
#endif
