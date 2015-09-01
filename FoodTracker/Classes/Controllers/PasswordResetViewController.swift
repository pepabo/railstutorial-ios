import UIKit
import SVProgressHUD

class PasswordResetViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        submitButton.enabled = checkValidForm()
    }

    // MARK: - Actions
    @IBAction func touchSubmitButton(sender: UIButton) {
        resetPassword()
    }

    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        submitButton.enabled = checkValidForm()
        return false
    }

    // MARK: -
    private func resetPassword() {
        emailTextField.resignFirstResponder()
        SVProgressHUD.showWithStatus("", maskType: .Black)
        if checkValidForm() {
            SVProgressHUD.showSuccessWithStatus("", maskType: .Black)
        } else {
            SVProgressHUD.showErrorWithStatus("", maskType: .Black)
        }
    }

    private func checkValidEmail(email: String) -> Bool{
        let regex = "^[\\w+\\-.]+@[a-z\\d\\-]+(\\.[a-z\\d\\-]+)*\\.[a-z]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluateWithObject(email)
    }

    private func checkValidForm() -> Bool {
        return emailTextField.hasText() && checkValidEmail(emailTextField.text)
    }
}
