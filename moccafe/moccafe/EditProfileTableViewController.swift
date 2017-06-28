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

class EditProfileTableViewController: UITableViewController, ProfileActionsDelegate {
    
    var fields = [Field]()
    
    let request = APICall()

    var doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(doneEditing))

    var profileDataCopy: JSON = [:]
    
    var profileData: JSON = [:] {
        didSet {
            profileDataCopy = profileData
            fields = [Field(title: NSLocalizedString("NAME", comment: ""), value: profileData["name"].string, placeHolder: NSLocalizedString("Insert Name", comment: "")),
                      Field(title: NSLocalizedString("LAST NAME", comment: ""), value: profileData["last_name"].string, placeHolder: NSLocalizedString("Insert Last Name", comment: "")),
                      Field(title: NSLocalizedString("ABOUT ME", comment: ""), value: profileData["info"].string, placeHolder: NSLocalizedString("About me", comment: "")),
                      Field(title: NSLocalizedString("EMAIL", comment: ""), value: profileData["email"].string, placeHolder: NSLocalizedString("Insert Email", comment: "")),
                      Field(title: NSLocalizedString("CITY", comment: ""), value: profileData["city"].string, placeHolder: NSLocalizedString("Insert City", comment: "")),
                      Field(title: NSLocalizedString("MOBILE", comment: ""), value: profileData["mobile"].string, placeHolder: NSLocalizedString("Insert Mobile", comment: "")),
                      Field(title: NSLocalizedString("ADDRESS", comment: ""), value: profileData["address"].string, placeHolder: NSLocalizedString("Insert Address", comment: "")),
                      Field(title: NSLocalizedString("PHONE", comment: ""), value: profileData["phone"].string, placeHolder: NSLocalizedString("Insert Phone", comment: "")),
                      Field(title: NSLocalizedString("SHIPPING ADDRESS", comment: ""), value: profileData["shipping"].string, placeHolder: NSLocalizedString("Insert Shipping Address", comment: ""))]
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.doneButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if profileData.count == 0 {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Could not retrieve profile data", comment: ""), preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default){ Void in self.navigationController?.popViewController(animated: true) }
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

        cell?.delegate = self
        cell?.index = indexPath.row
        cell?.fieldTitle.text = fields[indexPath.row].title
        cell?.fieldTextField.text = fields[indexPath.row].value
        cell?.fieldTextField.placeholder = fields[indexPath.row].placeHolder

        return cell!
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func doneEditing() {
        
        for cell in tableView.visibleCells as! [EditProfileTableViewCell] {
            cell.textFieldDidEndEditing(cell.fieldTextField)
        }
        profileDataCopy["name"].string = fields[0].value
        profileDataCopy["last_name"].string = fields[1].value
        profileDataCopy["info"].string = fields[2].value
        profileDataCopy["email"].string = fields[3].value
        profileDataCopy["city"].string = fields[4].value
        profileDataCopy["mobile"].string = fields[5].value
        profileDataCopy["address"].string = fields[6].value
        profileDataCopy["phone"].string = fields[7].value
        profileDataCopy["shipping"].string = fields[8].value
        
        request.postProfile(json: profileDataCopy) {
            json, error in
            if json != nil {
                print("profile response \(self.profileDataCopy)")

                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func modifyFields(index: Int, value: String) {
        fields[index].value = value
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        modifyFields(index: indexPath.row, value: (cell as! EditProfileTableViewCell).fieldTextField.text ?? "")
    }
    

}
