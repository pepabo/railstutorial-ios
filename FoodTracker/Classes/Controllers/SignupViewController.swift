import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet weak var nameTexeField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet var textFields: [UITextField]!
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        for textField : UITextField in textFields {
            textField.resignFirstResponder()
        }
    }
}
