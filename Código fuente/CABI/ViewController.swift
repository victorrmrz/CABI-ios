//
//  ViewController.swift
//  CABI
//
//  Created by Víctor Manuel Hernández Ramírez on 29/10/18.
//  Copyright © 2018 Socket Power. All rights reserved.
//

import UIKit
import Firebase


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




class ViewController: UIViewController {
    
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var recordarSwitch: UISwitch!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func camposVacios() -> Bool{
        let correo = correoTextField.text
        let pass = passTextField.text
        if (correo?.isEmpty)! || (pass?.isEmpty)!{
            return true
        }else{
        return false
        }
    }


    @IBAction func acceder(_ sender: Any) {
        if (camposVacios()){
            
        }else{
            Auth.auth().signIn(withEmail: correoTextField.text!, password: passTextField.text!) { (user, error) in
                if let u = user {
                    
                    //Código si se encontró el usuario, aquí se va a mandar a la pantalla indicada
                    //let userID = Auth.auth().currentUser?.uid
                    self.ref.child("usuarios").child(u.uid).child("tipoCuenta").observe(.value, with: { (snapshot) in
                        if let valor = snapshot.value as? String{
                            if valor == "USUARIO" {
                                self.performSegue(withIdentifier: "goToUsuario", sender: self)
                            }else if valor == "DASU" {
                                self.performSegue(withIdentifier: "goToDASU", sender: self)
                            }
                        }
                    })
                    
                    
                }else{
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    
    
}

