#if CLIENT
  public protocol EventTargeting: Sendable {
    func addEventListener(
      _ event: StaticString,
      _ handler: @escaping @Sendable (Event) -> Void,
      capture: Bool,
      passive: Bool?
    ) -> Int32
    func removeEventListener(_ event: StaticString, _ callbackID: Int32)
    func dispatchEvent(_ event: StaticString)
    func dispatchEvent(_ event: CustomEvent)
  }
  public extension EventTargeting {
    @discardableResult
    func addEventListener(
      _ event: StaticString,
      _ handler: @escaping @Sendable (Event) -> Void,
      capture: Bool = false,
      passive: Bool? = nil
    ) -> Int32 {
      return addEventListener(event, handler, capture: capture, passive: passive)
    }

    @discardableResult
    func addEventListener(
      _ type: Event.`Type`,
      _ handler: @escaping @Sendable (Event) -> Void,
      capture: Bool = false,
      passive: Bool? = nil
    ) -> Int32 {
      return addEventListener(type.staticString, handler, capture: capture, passive: passive)
    }
  }
#endif
