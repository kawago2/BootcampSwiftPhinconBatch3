import UIKit
import RxGesture
import RxSwift

protocol InsightCellDelegate: AnyObject {
    func didImageTapped(index: Int?)
}

class InsightCell: UITableViewCell {

    @IBOutlet weak var userView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    private var index: Int?
    weak var delegate: InsightCellDelegate?
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupEvent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        selectionStyle = .none
        titleLabel.lineBreakMode = .byTruncatingTail
        userView.setCircleWithBorder(borderColor: UIColor(named: ColorName.primary) ?? .black)
    }
    
    private func setupEvent() {
        userView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.delegate?.didImageTapped(index: self.index)
        }).disposed(by: disposeBag)
    }
    
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func passData(index: Int) {
        self.index = index
    }
    
}
