#if CLIENT
  public protocol EventTargeting: Sendable {
    @discardableResult
    func addEventListener(_ event: StaticString, _ handler: @escaping @Sendable (Event) -> Void)
      -> Self
    func removeEventListener(_ event: StaticString)
    func dispatchEvent(_ event: StaticString)
    func dispatchEvent(_ event: CustomEvent)
  }
#endif
