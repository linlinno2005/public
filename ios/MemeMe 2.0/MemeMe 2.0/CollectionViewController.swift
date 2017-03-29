//
//  CollectionViewController.swift
//  MemeMe 2.0
//
//  Created by linlinno on 2017/3/16.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var memes:[Meme]!

    override func viewDidLoad() {
        print("CollectionViewController-viewDidLoad")
        super.viewDidLoad()

//        let space:CGFloat = 3.0
//        let dimension = (view.frame.size.width - (2 * space)) / 3.0
//        
//        flowLayout.minimumInteritemSpacing = space
//        flowLayout.minimumLineSpacing = space
//        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("CollectionViewController-viewWillAppear")
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        self.collectionView?.reloadData()
        print("memes:" + String(memes.count))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let row = self.memes[indexPath.row]
        cell.imageView.image = row.memedImage
        cell.nameLable.text = row.topText+"..."+row.bottomText
        return cell
    }
    
    
    @IBAction func addMeme(_ sender: Any) {
        print("CollectionViewController-addMeme")
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")as!ViewController
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
}
