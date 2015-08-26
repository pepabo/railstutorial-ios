import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        checkValidLoginForm()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        loginButton.enabled = false
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        checkValidLoginForm()
        return true
    }
    
    func checkValidLoginForm() {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        loginButton.enabled = !email.isEmpty && !password.isEmpty
    }
}
