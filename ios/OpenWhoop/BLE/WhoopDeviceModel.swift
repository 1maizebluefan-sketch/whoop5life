import Foundation

enum WhoopDeviceModel: String, CaseIterable {
    case gen4 = "WHOOP 4.0"
    case gen5 = "WHOOP 5.0"
    case mg = "WHOOP MG"
    case life = "WHOOP Life"
    case unknown = "WHOOP"

    var supportsCustomProtocol: Bool {
        switch self {
        case .gen4:
            return true
        case .gen5, .mg, .life, .unknown:
            return false
        }
    }

    static func infer(from name: String?) -> WhoopDeviceModel {
        let n = (name ?? "").lowercased()
        if n.contains("life") { return .life }
        if n.contains("mg") { return .mg }
        if n.contains("5.0") || n.contains("whoop 5") { return .gen5 }
        if n.contains("4.0") || n.contains("whoop 4") { return .gen4 }
        return n.contains("whoop") ? .unknown : .unknown
    }
}
