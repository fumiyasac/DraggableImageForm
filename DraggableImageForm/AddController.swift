//
//  AddController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/03.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import Photos

//画像のバリデーション時のメッセージ
enum PhotoValidateMessage : String {
    case notlimited = "※ アップロードできる写真は6つまでになります。"
    case limited    = "※ アップロードできる写真数を超えています。"
    
    //enumの値を返す
    func returnValue() -> String {
        return self.rawValue
    }
}

class AddController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {

    //画像のバリデーションカウント
    fileprivate let validaionCount: Int = 6
    
    //PhotoLibraryで取得した画像を格納する配列
    var photoAssetLists: [PHAsset] = []
    
    //メッセージ入力用のテキストビュー
    @IBOutlet weak var messagetextView: UITextView!
    
    //フォトライブラリの画像一覧コレクションビュー
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    //衝突検知用のビューエリア
    @IBOutlet weak var conflictRectangle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionViewのデリゲート
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        //textViewのデリゲート
        messagetextView.delegate = self
        
        //画像のセルを定義する
        let nibPhotoCell: UINib = UINib(nibName: "PhotoCell", bundle: nil)
        photoCollectionView.register(nibPhotoCell, forCellWithReuseIdentifier: "PhotoCell")
        
        //画像をフォトライブラリから読み込む
        dispatchPhotoLibraryAndReload()
    }

    // (UICollectionViewDelegate)
    
    //このコレクションビューのセクション数を決める
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // (UICollectionViewDataSource)
    
    //このコレクションビューのセル数を決める
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssetLists.count
    }
    
    //このコレクションビューのセル内へ写真の配置を行う
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell
        
        cell?.photoImageView.image = convertAssetThumbnail(asset: photoAssetLists[indexPath.row], rectSize: 100)

        return cell!
    }
    
    //このコレクションビューのセルをタップした際の写真を選択する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //選択したセル要素を取得する
        //let selectedCell = collectionView.cellForItem(at: indexPath) as? PhotoCell
    }
    
    /* (instance function) */
    
    /* (fileprivate functions) */
    
    //フォトライブラリから画像を非同期で読み込む処理
    fileprivate func dispatchPhotoLibraryAndReload() {
        
        //データの取得はサブスレッドで行う
        DispatchQueue.global().async {
            self.photoCollectionView.isUserInteractionEnabled = false
            self.getPHAssetsForImageLibrary()
            
            //テーブルビューのリロードはメインスレッドで行う
            DispatchQueue.main.async {
                self.photoCollectionView.isUserInteractionEnabled = true
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    //PHAssetクラスを使用して画像を取得する
    fileprivate func getPHAssetsForImageLibrary() {
        
        //データの並べ替え条件
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        //Photoライブラリから画像を取得する
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: options)
        assets.enumerateObjects( { (asset, index, stop) -> Void in
            self.photoAssetLists.append(asset as PHAsset)
        })
        photoAssetLists.reverse()
    }
    
    //PHAsset型のデータを表示用に変換する
    fileprivate func convertAssetThumbnail(asset: PHAsset, rectSize: Int) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: rectSize, height: rectSize), contentMode: .aspectFill, options: option, resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
