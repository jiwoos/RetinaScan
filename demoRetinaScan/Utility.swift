import Foundation
import CoreGraphics
import SceneKit

//------------------------------
// MARK: - SCNVector3 Extensions
//------------------------------

extension SCNVector3{

    ///Get The Length Of Our Vector
    func length() -> Float { return sqrtf(x * x + y * y + z * z) }

    ///Allow Us To Subtract Two SCNVector3's
    static func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 { return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z) }
}

