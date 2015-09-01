import UIKit

class PasswordResetViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!

    // MARK: - Actions
    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
    }
}
