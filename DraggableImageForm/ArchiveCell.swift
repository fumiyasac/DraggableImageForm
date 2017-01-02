//
//  ArchiveCell.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2017/01/02.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class ArchiveCell: UITableViewCell {

    //ArchiveRecipeController.swiftへ処理内容を引き渡すためのクロージャーを設定
    var showGalleryClosure: (() -> ())?
    var deleteArchiveClosure: (() -> ())?

    //UIパーツの配置
    @IBOutlet weak var archiveImageView: UIImageView!
    @IBOutlet weak var archiveDate: UILabel!
    @IBOutlet weak var archiveMemo: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /* (Button Actions) */

    //「レシピ一覧へ」ボタン押下時のアクション
    @IBAction func showRecipeGalleryAction(_ sender: UIButton) {
        showGalleryClosure!()
    }

    //「削除する」ボタン押下時のアクション
    @IBAction func deleteRecipeAction(_ sender: UIButton) {
        deleteArchiveClosure!()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
