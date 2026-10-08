#if CLIENT
  /// ECMAScript `Date`, for what only the browser knows: the time now and the
  /// reader's time zone. Read-only; the local fields follow the reader's zone,
  /// as `getFullYear()`, `getMonth()`, `getDate()`, `getDay()`, `getHours()`
  /// and `getMinutes()` do.
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

    /// `new Date(year, monthIndex, day, hours, minutes)`: a moment given in
    /// the reader's zone. `month` is 0 for January; out-of-range fields roll
    /// over as the constructor's do.
    public init(localYear year: Int, month: Int, day: Int, hours: Int = 0, minutes: Int = 0) {
      self.time = date_localTime(Int32(year), Int32(month), Int32(day), Int32(hours), Int32(minutes))
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
    /// `getHours()`: the hour in the reader's zone, 0 to 23.
    public var hours: Int { Int(date_getLocalField(time, 5)) }
    /// `getMinutes()`: the minute in the reader's zone.
    public var minutes: Int { Int(date_getLocalField(time, 6)) }

    /// `Intl.DateTimeFormat().resolvedOptions().timeZone`: the reader's zone
    /// by its IANA name ("Asia/Kolkata"); empty where the browser names none.
    public static var resolvedTimeZone: String {
      var buffer = [UInt8](repeating: 0, count: 128)
      let length = buffer.withUnsafeMutableBufferPointer { pointer in
        intl_resolvedTimeZone(pointer.baseAddress!, Int32(pointer.count))
      }
      guard length > 0 else { return "" }
      return String(decoding: buffer[0..<Int(length)], as: UTF8.self)
    }
  }

  @_extern(wasm, module: "env", name: "date_localTime")
  private func date_localTime(_ year: Int32, _ month: Int32, _ day: Int32, _ hours: Int32, _ minutes: Int32) -> Double

  @_extern(wasm, module: "env", name: "intl_resolvedTimeZone")
  private func intl_resolvedTimeZone(_ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "date_now")
  private func date_now() -> Double

  @_extern(wasm, module: "env", name: "date_getLocalField")
  private func date_getLocalField(_ time: Double, _ field: Int32) -> Int32
#endif
