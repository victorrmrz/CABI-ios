//
//  VerBicicleta.swift
//  CABI
//
//  Created by Víctor Manuel Hernández Ramírez on 21/11/18.
//  Copyright © 2018 Socket Power. All rights reserved.
//

import UIKit
import Firebase

class VerBicicleta: UIViewController {

    var ref: DatabaseReference!
    var bicicleta: String?
    @IBOutlet weak var marca: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var rodada: UILabel!
    @IBOutlet weak var imagenQR: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generarQR()
        
        ref = Database.database().reference()
        
        let userId = Auth.auth().currentUser?.uid
        let busqueda = ref.child("bicicletas").child(userId!).queryOrdered(byChild: "id").queryEqual(toValue: bicicleta)
        busqueda.observe(.value) { (snapshot) in
            for x in snapshot.children {
                let snap = x as! DataSnapshot
                let bicicleta = snap.value as! [String: Any]
                let color = bicicleta["color"] as! String
                let marca = bicicleta["marca"] as! String
                let rodada = bicicleta["rodada"] as! Int
                self.color.text = color
                self.marca.text = marca
                self.rodada.text = String(rodada)
            }
        }
        
    }
    
    func generarQR(){
        let data = bicicleta?.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
        imagenQR.image = processedImage
    }
    


}
