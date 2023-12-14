import UIKit

class StackedBarsView: UIView {

    var barCount: Int = 0 {
        didSet {
            updateBars()
        }
    }

    var selectedBarIndex: Int = -1 {
        didSet {
            updateBarSelection()
        }
    }

    private var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStackView()
    }

    private func setupStackView() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updateBars() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for _ in 0..<barCount {
            let barView = UIView()
            barView.backgroundColor = .white
            barView.layer.cornerRadius = 5
            stackView.addArrangedSubview(barView)
        }
    }

    private func updateBarSelection() {
        for (index, barView) in stackView.arrangedSubviews.enumerated() {
            if index == selectedBarIndex {
                barView.backgroundColor = UIColor.white
            } else {
                barView.backgroundColor = UIColor.white.withAlphaComponent(0.24)
            }
        }
    }
}
