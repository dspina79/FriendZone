//
//  ViewController.swift
//  FriendZone2
//
//  Created by Dave Spina on 3/10/21.
//

import UIKit

class ViewController: UITableViewController {
    static var DATA_SOURCE: String = "FriendData"
    var friends = [Friend]()
    
    var selectedFriend: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        title = "FriendsZone"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let friend = friends[indexPath.row]
        cell.textLabel?.text = friend.name
        
        let formatter = DateFormatter()
        formatter.timeZone = friend.timeZone
        formatter.timeStyle = .short
        
        
        cell.detailTextLabel?.text = formatter.string(from: Date())
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        configure(friend: friends[indexPath.row], position: indexPath.row)
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        guard let savedData = defaults.data(forKey: Self.DATA_SOURCE) else { return }
        if let decodedData = try? JSONDecoder().decode([Friend].self, from: savedData) {
            friends = decodedData
        }
    }
    
    func saveData() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        guard let savedData = try? encoder.encode(friends) else {
            fatalError("Unble to encode friends")
        }
        defaults.set(savedData, forKey: Self.DATA_SOURCE)
    }
    
    @objc func addFriend() {
        let friend = Friend()
        friends.append(friend)
        tableView.insertRows(at: [IndexPath(row: friends.count - 1, section: 0)], with: .automatic)
        saveData()
        
        configure(friend: friend, position: friends.count - 1)
    }
    
    func configure(friend: Friend, position: Int) {
        guard let vc = storyboard?.instantiateViewController(identifier: "FriendViewController") as? FriendViewController else {
            fatalError("Unable to create FriendViewController")
        }
        selectedFriend = position
        vc.delegate = self;
        vc.friend = friend
        navigationController?.pushViewController(vc, animated: true)
    }

    
    func updateFriend(_ friend: Friend) {
        guard let selectedFriend = selectedFriend else { return }
        
        friends[selectedFriend] = friend
        saveData()
        tableView.reloadData()
    }
}

