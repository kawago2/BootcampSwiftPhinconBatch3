//
//  TimesheetCell.swift
//  Attendance
//
//  Created by Phincon on 16/11/23.
//

import UIKit

class TimesheetCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initData(date: String, clock: String, position: String, task: String) {
        dateLabel.text = date
        clockLabel.text = clock
        positionLabel.text = position
        taskLabel.text = task
    }
    

}
