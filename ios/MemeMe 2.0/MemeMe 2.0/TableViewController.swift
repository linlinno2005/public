//
//  TableViewController.swift
//  MemeMe 2.0
//
//  Created by linlinno on 2017/3/16.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var memes:[Meme]!

    override func viewDidLoad() {
        print("TableViewController-viewDidLoad")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("TableViewController-viewWillAppear")
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        self.tableView.reloadData()
        print("memes:" + String(memes.count))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let row = self.memes[indexPath.row]
        cell.imageView?.image = row.memedImage
        cell.textLabel?.text = row.topText+"..."+row.bottomText
        
        print(row.topText+row.bottomText)
        
        return cell
    }
    
    @IBAction func addMeme(_ sender: Any) {
        print("TableViewController-addMeme")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")as!ViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
