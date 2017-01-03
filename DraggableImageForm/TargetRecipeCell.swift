//
//  TargetRecipeCell.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/31.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class TargetRecipeCell: UITableViewCell {

    //UIパーツの配置
    @IBOutlet weak var recipeMiniImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
