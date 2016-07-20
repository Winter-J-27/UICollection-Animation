//
//  MainViewController.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/5.
//  Copyright © 2016年 Ian. All rights reserved.
//


import UIKit

class MainViewController: UITableViewController {
    
    private let identifier = "mainCell"
    lazy private var textArr : [String] = ["自定义转场一","自定义转场二","相册效果一","相册效果二"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
}

// MARK:- UITableViewDataSource&UITableViewDelegate
extension MainViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArr.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        cell?.textLabel?.text = textArr[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0 :
            navigationController?.pushViewController(TheFirstViewController(collectionViewLayout : TheFirstLayout()), animated: true)
            
        case 1 :
            
            let ViewController = TheFirstViewController(collectionViewLayout: TheFirstLayout())
            ViewController.isMask = true
            navigationController?.pushViewController(ViewController, animated: true)
            
        case 2 :
            
            navigationController?.pushViewController(AlbumViewController(), animated: true)
        case 3 :
            let albumViewController = AlbumViewController()
            albumViewController.albumType = .Vertical
            
            navigationController?.pushViewController(albumViewController, animated: true)
            break
        default : break
        }
    }
}
