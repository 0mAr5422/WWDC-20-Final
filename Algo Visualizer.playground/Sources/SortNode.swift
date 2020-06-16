import UIKit

public class SortNode : Hashable,Comparable {
    public static func < (lhs: SortNode, rhs: SortNode) -> Bool {
        return lhs.value<rhs.value
    }
    
    
    
    
    let color : UIColor
    let value : Int
    private let identifier = UUID()
    
    public init(value : Int , maxValue : Int) {
        self.value = value
        let hue = CGFloat(value) / CGFloat(maxValue)
        self.color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        
    }
    
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: SortNode, rhs: SortNode) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
}
