//
//  ViewController.swift
//  News
//
//  Created by Gadia, Rohit on 7/31/18.
//  Copyright © 2018 Gadia, Rohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        searchBar.text = searchString
        
        self.searchButton.addTarget(self, action: #selector(self.onSearch(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onSearch(_ button : UIButton){
        
        if(self.searchBar.text != nil){
            searchString = searchBar.text!
            self.navigate()
        }
        
    }
    
    func navigate() {
        performSegue(withIdentifier: "NewsListSegue", sender: self)
    }

}

