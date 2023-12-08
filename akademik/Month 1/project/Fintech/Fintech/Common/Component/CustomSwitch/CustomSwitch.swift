import UIKit

// MARK: - CustomSwitchDelegate

protocol CustomSwitchDelegate: AnyObject {
    func switchValueChanged(isOn: Bool)
}

// MARK: - CustomSwitch

class CustomSwitch: UIControl {

    // MARK: - Properties

    private var backgroundView: UIView!
    private var thumbView: UIView!

    private var isOn = false {
        didSet {
            sendActions(for: .valueChanged)
            delegate?.switchValueChanged(isOn: isOn)
        }
    }

    weak var delegate: CustomSwitchDelegate?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupGesture()
    }

    // MARK: - Private Methods

    private func setupViews() {
        backgroundView = UIView(frame: bounds)
        backgroundView.layer.cornerRadius = bounds.height / 2
        backgroundView.backgroundColor = UIColor.systemGray5
        addSubview(backgroundView)

        thumbView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height))
        thumbView.layer.cornerRadius = bounds.height / 2
        thumbView.backgroundColor = UIColor.white
        addSubview(thumbView)
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        toggleSwitch()
    }

    // MARK: - Public Methods

    func setOn(_ isOn: Bool, animated: Bool) {
        self.isOn = isOn
        self.backgroundView.backgroundColor = isOn ? UIColor(named: ColorName.background4) : UIColor.systemGray5

        let newThumbCenterX = isOn ? backgroundView.frame.width - backgroundView.frame.height / 2 : backgroundView.frame.height / 2

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.thumbView.center.x = newThumbCenterX
            }
        } else {
            thumbView.center.x = newThumbCenterX
        }
    }

    func toggleSwitch() {
        setOn(!isOn, animated: true)
    }
}
