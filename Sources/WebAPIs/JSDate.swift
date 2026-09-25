#if CLIENT
  /// ECMAScript `Date`, for what only the browser knows: the time now and the
  /// reader's time zone. Read-only; the local fields follow the reader's zone,
  /// as `getFullYear()`, `getMonth()`, `getDate()` and `getDay()` do.
  public struct JSDate: Sendable {
    /// Milliseconds since the epoch, as `Date.prototype.getTime()`.
    public let time: Double

    /// The time now.
    public init() {
      self.time = date_now()
    }

    public init(time: Double) {
      self.time = time
    }

    /// `Date.now()`.
    public static func now() -> Double {
      date_now()
    }

    /// `getFullYear()`: the year in the reader's zone.
    public var fullYear: Int { Int(date_getLocalField(time, 0)) }
    /// `getMonth()`: the month in the reader's zone, 0 for January.
    public var month: Int { Int(date_getLocalField(time, 1)) }
    /// `getDate()`: the day of the month in the reader's zone, from 1.
    public var date: Int { Int(date_getLocalField(time, 2)) }
    /// `getDay()`: the weekday in the reader's zone, 0 for Sunday.
    public var day: Int { Int(date_getLocalField(time, 3)) }
    /// `getTimezoneOffset()`: minutes from local time to UTC.
    public var timezoneOffset: Int { Int(date_getLocalField(time, 4)) }
  }

  @_extern(wasm, module: "env", name: "date_now")
  private func date_now() -> Double

  @_extern(wasm, module: "env", name: "date_getLocalField")
  private func date_getLocalField(_ time: Double, _ field: Int32) -> Int32
#endif
