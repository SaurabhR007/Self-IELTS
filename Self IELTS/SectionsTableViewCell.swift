//
//  SectionsTableViewCell.swift
//  Self IELTS
//
//  Created by Saurabh TheRockStar on 18/09/17.
//  Copyright © 2017 saurabhrode@gmail.com. All rights reserved.
//

import UIKit

class SectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var durationTF: UITextField?
   
    @IBOutlet weak var startingQuetionTF: UITextField?
    
    @IBOutlet weak var lastQuetionTF: UITextField?
    
    @IBOutlet weak var sectionTF: UILabel?
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
