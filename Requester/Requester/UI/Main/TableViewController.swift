//
//  TableViewController.swift
//  Requester
//
//  Created by Anton Martsenyuk on 22.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import UIKit
import Alamofire


class TableViewController: UITableViewController {
    
    lazy var requestProvider: RequestProvider = {
        return APIClient.shared
    }()
    
    lazy var dic: [Character : Int] = {
        let characters = (65...122).map({ Character(UnicodeScalar($0)) })
        return Dictionary(characters.map { ($0, 0) } , uniquingKeysWith: +)
    }()
    
    lazy var sortDictionaryKey: [Character] = {
        return Array(self.dic.keys).sorted(by: <)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTextRequest(token: KeyChain.loadToken()!)
    }

    func getTextRequest(token: String) {
        requestProvider.getText(token: token) { text in
            guard let text = text.data else { return }
            self.computeSymbol(string: text)
            self.tableView.reloadData()
        }
    }
    
    func computeSymbol(string: String) {
        string.forEach({
            if dic[$0] != nil {
                dic[$0]! += 1
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dic.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersCell", for: indexPath)
        
        let key = sortDictionaryKey[indexPath.row]
        cell.textLabel?.text = "Character: " + "\(key)"
        
        if let value = dic[key] {
            cell.detailTextLabel?.text = "Count: " + "\(value)"

        }
        return cell
    }
}
