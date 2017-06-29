//
//  EditProfileTableViewCell.swift
//  moccafe
//
//  Created by Valentina Henao on 6/1/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: ProfileActionsDelegate?
    var index = Int()

    @IBOutlet var fieldTitle: UILabel!
    @IBOutlet var fieldTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fieldTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.modifyFields(index: self.index, value: fieldTextField.text ?? "")
    }

}
