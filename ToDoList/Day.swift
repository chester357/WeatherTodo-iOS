import Foundation

public enum Day {
    case Today
    case Tomorrow
    case ThreePlus
    
    func toString() -> String {
        switch self {
        case .Today:
            return "Today"
        case .Tomorrow:
            return "Tomorrow"
        default:
            return ""
        }
    }
}