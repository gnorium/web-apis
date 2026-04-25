#if CLIENT
  import EmbeddedSwiftUtilities

  public struct LogMessage: ExpressibleByStringInterpolation {
    let staticMessage: StaticString?
    let runtimeMessage: String?

    public struct StringInterpolation: StringInterpolationProtocol {
      var output: String = ""

      public init(literalCapacity: Int, interpolationCount: Int) {
        output.reserveCapacity(literalCapacity + interpolationCount * 10)
      }

      public mutating func appendLiteral(_ literal: StaticString) {
        literal.withUTF8Buffer { buffer in
          var bytes: [UInt8] = []
          for byte in buffer {
            bytes.append(byte)
          }
          output.append(String(decoding: bytes, as: UTF8.self))
        }
      }

      public mutating func appendInterpolation(_ value: String) {
        output.append(value)
      }

      public mutating func appendInterpolation(_ value: Int) {
        output.append(intToString(value))
      }

      public mutating func appendInterpolation(_ value: Int32) {
        output.append(intToString(Int(value)))
      }

      public mutating func appendInterpolation(_ value: Double) {
        output.append(doubleToString(value))
      }

      public mutating func appendInterpolation(_ value: Bool) {
        output.append(value ? "true" : "false")
      }
    }

    public init(stringLiteral value: StaticString) {
      self.staticMessage = value
      self.runtimeMessage = nil
    }

    public init(stringInterpolation: StringInterpolation) {
      self.staticMessage = nil
      self.runtimeMessage = stringInterpolation.output
    }
  }
#endif
