#if CLIENT
  import EmbeddedSwiftUtilities

  // MARK: - External Math Function Declarations

  @_extern(wasm, module: "env", name: "math_sin")
  func math_sin(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_cos")
  func math_cos(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_tan")
  func math_tan(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_sqrt")
  func math_sqrt(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_pow")
  func math_pow(_ base: Double, _ exponent: Double) -> Double

  @_extern(wasm, module: "env", name: "math_abs")
  func math_abs(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_floor")
  func math_floor(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_ceil")
  func math_ceil(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_round")
  func math_round(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_random")
  func math_random() -> Double

  @_extern(wasm, module: "env", name: "math_min")
  func math_min(_ a: Double, _ b: Double) -> Double

  @_extern(wasm, module: "env", name: "math_max")
  func math_max(_ a: Double, _ b: Double) -> Double

  @_extern(wasm, module: "env", name: "math_log")
  func math_log(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_exp")
  func math_exp(_ x: Double) -> Double

  @_extern(wasm, module: "env", name: "math_atan2")
  func math_atan2(_ y: Double, _ x: Double) -> Double

  // MARK: - Public Math Functions

  /// Sine of angle in radians
  public func sin(_ x: Double) -> Double {
    math_sin(x)
  }

  /// Cosine of angle in radians
  public func cos(_ x: Double) -> Double {
    math_cos(x)
  }

  /// Tangent of angle in radians
  public func tan(_ x: Double) -> Double {
    math_tan(x)
  }

  /// Square root
  public func sqrt(_ x: Double) -> Double {
    math_sqrt(x)
  }

  /// Power - base raised to exponent
  public func pow(_ base: Double, _ exponent: Double) -> Double {
    math_pow(base, exponent)
  }

  /// Absolute value
  public func abs(_ x: Double) -> Double {
    math_abs(x)
  }

  /// Floor - rounds down to nearest integer
  public func floor(_ x: Double) -> Double {
    math_floor(x)
  }

  /// Ceil - rounds up to nearest integer
  public func ceil(_ x: Double) -> Double {
    math_ceil(x)
  }

  /// Round to nearest integer
  public func round(_ x: Double) -> Double {
    math_round(x)
  }

  /// Random number between 0 and 1
  public func random() -> Double {
    math_random()
  }

  /// Minimum of two values
  public func min(_ a: Double, _ b: Double) -> Double {
    math_min(a, b)
  }

  /// Maximum of two values
  public func max(_ a: Double, _ b: Double) -> Double {
    math_max(a, b)
  }

  /// Natural logarithm
  public func log(_ x: Double) -> Double {
    math_log(x)
  }

  /// Exponential (e^x)
  public func exp(_ x: Double) -> Double {
    math_exp(x)
  }

  /// Arctangent of y/x (returns angle in radians)
  public func atan2(_ y: Double, _ x: Double) -> Double {
    math_atan2(y, x)
  }

  // MARK: - Constants

  public let PI: Double = 3.14159265358979323846
  public let E: Double = 2.71828182845904523536
#endif
