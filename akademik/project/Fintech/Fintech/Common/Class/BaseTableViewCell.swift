import UIKit
import RxSwift


class BaseTableViewCell : UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
