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
    
    var timeZones = [TimeZone]()
    var selectedTimeZone = 0
    
    var nameTableCell: TextTableViewCell? {
        let indexPath = IndexPath(row: 0, section: 0)
        return tableView.cellForRow(at: indexPath) as? TextTableViewCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let identifiers = TimeZone.knownTimeZoneIdentifiers
        for identifier in identifiers {
            if let timeZone = TimeZone(identifier: identifier) {
                timeZones.append(timeZone)
            }
        }
        
        let now = Date()
        timeZones.sort {
            let ourDifference = $0.secondsFromGMT(for: now)
            let otherDifference = $1.secondsFromGMT(for: now)
            
            if ourDifference == otherDifference {
                return $0.identifier < $1.identifier
            }
            return ourDifference < otherDifference
        }
        
        selectedTimeZone = timeZones.firstIndex(of: friend.timeZone) ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if the section if for the friend name, return 1 otherwise return the number
        // of time zones
        
        return section == 0 ? 1 : timeZones.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Name of Your Friend" : "Select Their Time Zone"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath) as? TextTableViewCell else {
                fatalError("Couldn't get the table cell to cast.")
            }
            
            cell.textField.text = friend.name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZone", for: indexPath)
            let timeZone = timeZones[indexPath.row]
            cell.textLabel?.text = timeZone.identifier.replacingOccurrences(of: "_", with: " ")
            let timeDifference = timeZone.secondsFromGMT(for: Date())
            cell.detailTextLabel?.text = timeDifference.timeString()
            if indexPath.row == selectedTimeZone {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            startEditingTextCell()
        } else {
            selectRow(at: indexPath)
        }
    }

    func startEditingTextCell() {
        nameTableCell?.textField.becomeFirstResponder()
    }
    
    func selectRow(at indexPath: IndexPath) {
        nameTableCell?.textField.resignFirstResponder()
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        
        selectedTimeZone = indexPath.row
        friend.timeZone = timeZones[selectedTimeZone]
        let selected = tableView.cellForRow(at: indexPath)
        selected?.accessoryType = .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateFriend(friend)
    }

    @IBAction func nameChanged(_ sender: UITextField) {
        friend.name = sender.text ?? ""
    }
}
