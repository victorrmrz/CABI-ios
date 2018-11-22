//
//  PerfilUsuarioTabBar.swift
//  CABI
//
//  Created by Víctor Manuel Hernández Ramírez on 21/11/18.
//  Copyright © 2018 Socket Power. All rights reserved.
//

import UIKit
import Firebase

class PerfilUsuarioTabBar: UIViewController {
    var ref: DatabaseReference!

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var correo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        let busqueda = ref.child("usuarios").queryOrdered(byChild: "uid").queryEqual(toValue: userId)
        busqueda.observe(.value) { (snapshot) in
            for x in snapshot.children {
                let snap = x as! DataSnapshot
                let usuario = snap.value as! [String: Any]
                let nombre = usuario["nombre"] as! String
                let aP = usuario["aP"] as! String
                let aM = usuario["aM"] as! String
                let correo = usuario["email"] as! String
                self.nombre.text = nombre + " " + aP + " " + aM
                self.correo.text = correo
            }
        }
        

    }
    

    @IBAction func cerrarSesion(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Se cerró la sesión")
            self.performSegue(withIdentifier: "goToLogin", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    

}
