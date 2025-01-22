import Foundation
import RealityKit

struct Point: Identifiable {
    let id : UInt64
    var localPosition: SIMD3<Float>
    var worldPosition: SIMD3<Float>
    var initialWorldPosition: SIMD3<Float>
    var initialLocalPosition: SIMD3<Float>
}
