// The first Swift examples: wrapping arithmetic and Euclid's algorithm.

@_cdecl("swift_add3")
public func add3(_ a: UInt64, _ b: UInt64, _ c: UInt64) -> UInt64 {
  return a &+ b &+ c
}

@_cdecl("swift_gcd")
public func gcd(_ a0: UInt64, _ b0: UInt64) -> UInt64 {
  var a = a0
  var b = b0
  while b != 0 {
    let t = a % b
    a = b
    b = t
  }
  return a
}

@_cdecl("swift_min")
public func min2(_ a: UInt64, _ b: UInt64) -> UInt64 {
  return a < b ? a : b
}
