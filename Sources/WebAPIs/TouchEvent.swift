#if CLIENT
  import DOMBuilder
  import WebTypes

  public struct TouchEvent: @unchecked Sendable {
    public let event: CallbackString

    public init(_ event: CallbackString) {
      self.event = event
    }

    public init(_ event: Event) {
      self.event = event.payload
    }

    public var target: DOM.Element? {
      event.target
    }

    // Coordinates of the first touch point (touches[0] / changedTouches[0]).
    // The JS bridge already resolves these from the touch list — see loader.js event_clientX.
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
