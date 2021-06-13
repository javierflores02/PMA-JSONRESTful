import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    var users = [Users]()
    var user:Users? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func validarUsuario(ruta: String, completed: @escaping () -> ()){
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!){ (data, response, error) in
            if error == nil{
                do{
                    self.users = try JSONDecoder().decode([Users].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("Error en JSON")
                }
            }
        }.resume()
    }
    
    @IBAction func Logear(_ sender: Any) {
        let ruta = "http://localhost:3000/usuarios?"
        let usuario = txtUsuario.text!
        let contrasena = txtContraseña.text!
        let url = ruta + "nombre=\(usuario)&clave=\(contrasena)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        validarUsuario(ruta: crearURL){
            if self.users.count <= 0{
                print("Nombre de usuario y/o contraseña es incorrecto")
            }else{
                print("Logeo Exitoso")
                
                for data in self.users{
                    self.user = Users(id: data.id, nombre: data.nombre, clave: data.clave, email: data.email)
                    print("id:\(data.id),nombre:\(data.nombre),email:\(data.email)")
                }
                self.performSegue(withIdentifier: "segueLogeo", sender: self.user)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLogeo"{
            let destVC = segue.destination as! UINavigationController
            let siguienteVC = destVC.topViewController as! viewControllerBuscar
            siguienteVC.user = sender as? Users
        }
    }

}

