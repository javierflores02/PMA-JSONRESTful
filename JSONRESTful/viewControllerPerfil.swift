import UIKit

class viewControllerPerfil: UIViewController {
    
    var user:Users? = nil
    var anteriorVC:viewControllerBuscar? = nil
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    @IBOutlet weak var txtRepContraseña: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Usuario: \(user)")
        txtUsuario.text = user!.nombre
        txtEmail.text = user!.email
    }
    
    func metodoPATCH(ruta:String, datos:[String:Any]){
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "PATCH"
        
        let params = datos
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        }catch{
            
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {(data,respomse,error) in
            if(data != nil){
                do{
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: Any?]
                    self.anteriorVC!.user?.clave = dict["clave"] as! String
                    self.anteriorVC!.user?.email = dict["email"] as! String
                    self.anteriorVC!.user?.nombre = dict["nombre"] as! String
                    print(dict)
                }catch{
                    
                }
            }
        })
        task.resume()
    }

    @IBAction func btnActualizar(_ sender: Any) {
        let nombre = txtUsuario.text!
        let contraseña = txtContraseña.text!
        let repcontraseña = txtRepContraseña.text!
        let email = txtEmail.text!
        var datos = ["nombre": "\(nombre)","email": "\(email)"] as Dictionary<String,Any>
        if contraseña.count > 0 || repcontraseña.count > 0{
            if contraseña == repcontraseña {
                datos = ["nombre": "\(nombre)","email": "\(email)","clave": "\(contraseña)"] as Dictionary<String,Any>
            }else{
                let alerta = UIAlertController(title: "Error", message: "Las contraseñas ingresadas no coinciden", preferredStyle: .alert)
                let btnCANCELOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alerta.addAction(btnCANCELOK)
                present(alerta, animated: true, completion: nil)
            }
            /*let ruta = "http://localhost:3000/peliculas/\(pelicula!.id)"
            metodoPATCH(ruta: ruta, datos: datos)
            navigationController?.popViewController(animated: true)*/
        }
        print("Los datos son: \(datos)")
        let ruta = "http://localhost:3000/usuarios/\(user!.id)"
        metodoPATCH(ruta: ruta, datos: datos)
        navigationController?.popViewController(animated: true)
    }
}
