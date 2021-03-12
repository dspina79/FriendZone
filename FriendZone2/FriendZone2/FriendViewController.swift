//
//  FriendViewController.swift
//  FriendZone2
//
//  Created by Dave Spina on 3/11/21.
//

import UIKit

class FriendViewController: UITableViewController {
    weak var delegate: ViewController?
    var friend: Friend!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func nameChanged(_ sender: UITextField) {
    }
}
