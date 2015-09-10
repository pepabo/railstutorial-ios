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
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        submitButton.enabled = checkValidForm()
        return false
    }

    // MARK: -
    func moveToLoginView() {
        let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        loginView.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(loginView, animated: true, completion: nil)
    }

    func sendResetEmail(email: String) {
        let params = [
            "email": email
        ]

        emailTextField.resignFirstResponder()
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)

        Alamofire.request(Router.PostPasswordResetEmail(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                self.moveToLoginView()
            } else{
                SVProgressHUD.showErrorWithStatus(json["messages"]["notice"][0].stringValue)
            }
        }
    }

    private func checkValidForm() -> Bool {
        return emailTextField.hasText()
    }
}
