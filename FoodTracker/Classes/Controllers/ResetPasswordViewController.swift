import UIKit
import SVProgressHUD

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var updateButton: UIButton!

    // MARK: - View Events
    override func viewDidLoad() {
        updateButton.enabled = checkPresenceField()
    }

    // MARK: - Actions
    @IBAction func touchUpdateButton(sender: UIButton) {
        resetPassword()
    }

    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        hideKeyboard()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        updateButton.enabled = checkPresenceField()
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 2 {
            textField.resignFirstResponder()
        } else {
            textFields[textField.tag].becomeFirstResponder()
        }
        return false
    }

    // MARK: -
    private func resetPassword() {
        hideKeyboard()
        SVProgressHUD.showWithStatus("", maskType: .Black)
        if checkPresenceField() {
            SVProgressHUD.showSuccessWithStatus("", maskType: .Black)
        } else {
            SVProgressHUD.showErrorWithStatus("", maskType: .Black)
        }
    }

    func checkPresenceField() -> Bool{
        var result = true
        for textField : UITextField in textFields {
            result = result && textField.hasText()
        }
        return result
    }

    private func hideKeyboard() {
        for textField : UITextField in textFields {
        textField.resignFirstResponder()
        }
    }
}
