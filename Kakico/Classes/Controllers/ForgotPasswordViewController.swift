import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        submitButton.enabled = checkValidForm()
    }

    // MARK: - Actions
    @IBAction func touchSubmitButton(sender: UIButton) {
        sendResetEmail(emailTextField.text)
    }

    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        submitButton.enabled = checkValidForm()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        submitButton.enabled = checkValidForm()
        return false
    }

    // MARK: -
    func moveToLoginView() {
        let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        loginView.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(loginView, animated: true, completion: nil)
        loginView.checkEmailPlease("Please check your email to reset your password.")
    }

    func sendResetEmail(email: String) {
        emailTextField.resignFirstResponder()
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)

        let params = [
            "email": email
        ]

        Alamofire.request(Router.PostPasswordResetEmail(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                self.moveToLoginView()
            } else{
                SVProgressHUD.showErrorWithStatus(json["messages"]["notice"].array!.first?.stringValue)
            }
        }
    }

    private func checkValidForm() -> Bool {
        return emailTextField.hasText()
    }
}
