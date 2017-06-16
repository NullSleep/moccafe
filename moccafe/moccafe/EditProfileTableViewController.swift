//
//  EditProfileTableViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 6/1/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Field {
    var title: String?
    var value: String?
    var placeHolder: String?
}

class EditProfileTableViewController: UITableViewController {
    
    var fields = [Field]()
    
    let request = APICall()

    var doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneEditing))

    var profileDataCopy: JSON = [:]
    
    var profileData: JSON = [:] {
        didSet {
            profileDataCopy = profileData
            fields = [Field(title: "NAME", value: profileData["name"].string, placeHolder: "Insert Name"),
                      Field(title: "LAST NAME", value: profileData["last_name"].string, placeHolder: "Insert Last Name"),
                      Field(title: "ABOUT ME", value: profileData["info"].string, placeHolder: "About me"),
                      Field(title: "EMAIL", value: profileData["email"].string, placeHolder: "Insert Email"),
                      Field(title: "CITY", value: profileData["city"].string, placeHolder: "Insert City"),
                      Field(title: "MOBILE", value: profileData["mobile"].string, placeHolder: "Insert Mobile"),
                      Field(title: "ADDRESS", value: profileData["address"].string, placeHolder: "Insert Address"),
                      Field(title: "PHONE", value: profileData["phone"].string, placeHolder: "Insert Phone"),
                      Field(title: "SHIPPING ADDRESS", value: profileData["shipping"].string, placeHolder: "Insert Shipping Address")]
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.doneButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if profileData.count == 0 {
            let alert = UIAlertController(title: "Error", message: "Could not retrieve profile data", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){ Void in self.navigationController?.popViewController(animated: true) }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? EditProfileTableViewCell

        cell?.fieldTitle.text = fields[indexPath.row].title
        cell?.fieldTextField.text = fields[indexPath.row].value
        cell?.fieldTextField.placeholder = fields[indexPath.row].placeHolder

        return cell!
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func doneEditing() {
        
        profileDataCopy["name"].string = getCellValue(index: 0)
        profileDataCopy["last_name"].string = getCellValue(index: 1)
        profileDataCopy["info"].string = getCellValue(index: 2)
        profileDataCopy["email"].string = getCellValue(index: 3)
        profileDataCopy["city"].string = getCellValue(index: 4)
        profileDataCopy["mobile"].string = getCellValue(index: 5)
        profileDataCopy["address"].string = getCellValue(index: 6)
        profileDataCopy["phone"].string = getCellValue(index: 7)
        profileDataCopy["shipping"].string = getCellValue(index: 8)
        
        request.postProfile(json: profileDataCopy) {
            json, error in
            print("profile response \(self.profileData)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCellValue(index: Int) -> String {
        
        if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? EditProfileTableViewCell {
            return cell.fieldTextField.text ?? ""
        }
        return ""
        
    }

}
