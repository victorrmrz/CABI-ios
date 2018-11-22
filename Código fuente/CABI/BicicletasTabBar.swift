//
//  BicicletasTabBar.swift
//  CABI
//
//  Created by Víctor Manuel Hernández Ramírez on 17/11/18.
//  Copyright © 2018 Socket Power. All rights reserved.
//

import UIKit
import Firebase

class BicicletasTabBar: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var ref: DatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    
    var bicicletas = [String]()
    var modelos = [String]()
    var colores = [String]()
    var rodadas = [Int]()

    var biciAEnviar: String?
    //var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        let userId = Auth.auth().currentUser?.uid
        
        let busqueda = ref.child("bicicletas").child(userId!)
        busqueda.observe(.value) { (snapshot) in
            self.vaciarArreglos()
            for x in snapshot.children {
                let snap = x as! DataSnapshot
                let bicicleta = snap.value as! [String: Any]
                let idBicicleta = bicicleta["id"] as! String
                let modelo = bicicleta["marca"] as! String
                let color = bicicleta["color"] as! String
                let rodada = bicicleta["rodada"] as! Int

                self.bicicletas.append(idBicicleta)
                self.modelos.append(modelo)
                self.colores.append(color)
                self.rodadas.append(rodada)
                self.tableView.reloadData()
                
            }
        }

        tableView.delegate = self
        tableView.dataSource = self
    }
    

    func vaciarArreglos(){
        self.bicicletas.removeAll()
        self.modelos.removeAll()
        self.colores.removeAll()
        self.rodadas.removeAll()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let bici = self.bicicletas[indexPath.row]
        self.biciAEnviar = bici
        self.performSegue(withIdentifier: "goToVerBicicleta", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bicicletas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellBicicleta")
        cell?.textLabel?.text = modelos[indexPath.row]
        cell?.detailTextLabel?.text = colores[indexPath.row] + " rodada " + String(rodadas[indexPath.row])
        return cell!
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToVerBicicleta") {
            let vc = segue.destination as! VerBicicleta
            vc.bicicleta = self.biciAEnviar
        }
    }

}
