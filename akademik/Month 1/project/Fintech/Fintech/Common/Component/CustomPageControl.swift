import UIKit

public class CustomPageControl: UIPageControl {
    // MARK: - Private Properties
    private var selectedIndex: Int = 0
    private var remainingDecimal: CGFloat = 0
    private var selectedColor: UIColor = .clear {
        didSet {
            reset()
        }
    }
    private var unselectedColor: UIColor = .clear {
        didSet {
            reset()
        }
    }
    
    // MARK: - Public Properties
    public var dotRadius: CGFloat = 4 {
           didSet {
               reset()
           }
       }
       public var dotSpacings: CGFloat = 4 {
           didSet {
               reset()
           }
       }
       public var selectedDotHeight: CGFloat = 20 {
           didSet {
               reset()
           }
       }
       public var normalDotHeight: CGFloat = 10 {
           didSet {
               reset()
           }
       }
    
    
    /// Currently selected page.
    /// The first page is 1 and not 0.
    public override var currentPage: Int {
        didSet {
            reset()
        }
    }
    public override var pageIndicatorTintColor: UIColor? {
        set {
            unselectedColor = newValue ?? .clear
        }
        get {
            .clear
        }
    }
    public override var currentPageIndicatorTintColor: UIColor? {
        set {
            selectedColor = newValue ?? .clear
        }
        get {
            return .clear
        }
    }
    // MARK: - Public Functions
    public override func draw(_ rect: CGRect) {
            guard numberOfPages > 0 else { return }

            let totalWidth = CGFloat(numberOfPages) * (dotRadius * 2 + dotSpacings) - dotSpacings
            var startX = (rect.width - totalWidth) / 2.0

            for index in 0 ..< numberOfPages {
                let height = (index == selectedIndex) ? selectedDotHeight : normalDotHeight
                let originY = (rect.height - height) / 2.0
                let barColor = (index == selectedIndex) ? selectedColor : unselectedColor

                barColor.setFill()
                let bezierPath = UIBezierPath(roundedRect: .init(x: startX,
                                                                 y: originY,
                                                                 width: dotRadius * 2,
                                                                 height: height),
                                              cornerRadius: dotRadius)
                bezierPath.fill()

                startX += dotRadius * 2 + dotSpacings
            }
        }

    
    public override var intrinsicContentSize: CGSize {
        return .init(width: super.intrinsicContentSize.width, height: max(selectedDotHeight, normalDotHeight))
    }
    
    public func setOffset(_ offset: CGFloat, width: CGFloat) {
        selectedIndex = Int(offset / width)
        remainingDecimal = offset / width - CGFloat(selectedIndex)
        setNeedsDisplay()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setOffset(scrollView.contentOffset.x, width: scrollView.bounds.width)
    }
    
    // MARK: - Private Functions
    private func reset() {
        self.invalidateIntrinsicContentSize()
        self.setNeedsDisplay()
    }
    
    private func between(_ color1: UIColor, and color2: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 100), 0)
        switch percentage {
        case 0: return color1
        case 1: return color2
        default:
            var (red1, green1, blue1, alpha1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (red2, green2, blue2, alpha2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1) else { return color1 }
            guard color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2) else { return color2 }
            return UIColor(red: CGFloat(red1 + (red2 - red1) * percentage),
                           green: CGFloat(green1 + (green2 - green1) * percentage),
                           blue: CGFloat(blue1 + (blue2 - blue1) * percentage),
                           alpha: CGFloat(alpha1 + (alpha2 - alpha1) * percentage))
        }
    }
}
