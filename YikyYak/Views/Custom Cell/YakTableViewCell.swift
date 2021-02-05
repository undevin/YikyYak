//
//  YakTableViewCell.swift
//  YikyYak
//
//  Created by Devin Flora on 2/4/21.
//

import UIKit

class YakTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var yakLabel: UILabel!
    @IBOutlet weak var yakScoreLabel: UILabel!
    
    
    //MARK: - Properties
    var yak: Yak? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Actions
    @IBAction func upVoteButtonTapped(_ sender: Any) {
        guard let yak = yak else {return}
        yak.score += 1
        YakController.shared.updateYak(yak: yak) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let yak):
                    self.yakScoreLabel.text = String(yak.score)
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
    }
    
    @IBAction func downVoteButtonTapped(_ sender: Any) {
        guard let yak = yak else {return}
        yak.score -= 1
        YakController.shared.updateYak(yak: yak) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let yak):
                    self.yakScoreLabel.text = String(yak.score)
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
    }
    
    //MARK: - Methods
    func updateViews() {
        guard let yak = yak else {return}
        yakLabel.text = "\(yak.text) \n\n\t~\(yak.author)"
        yakScoreLabel.text = String(yak.score)
    }
}//End of Class
