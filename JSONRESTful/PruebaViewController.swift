import UIKit

struct Restaurante:Decodable{
    var id:Int
    var usuario:Int
    var DNI:Int
    var nombre_rest:String
    var contacto:Int
    var creado:String
    var descripcion:String
    var direccion:String
    var latitude:String
    var longitude:String
    var puntuacion:String
    var ubicacion:String
    var vista:String
    
    /*init(){
        
    }*/
}

class PruebaViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tabla1: UITableView!
    @IBOutlet weak var tabla2: UITableView!
    
    var restaurantes:[Restaurante] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantes.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla1.delegate = self
        tabla1.dataSource = self
        tabla2.delegate = self
        tabla2.dataSource = self
        let ruta = "https://www.tecfood.club/74054946816/api/Restaurante/"
        obtenerRestaurantes(ruta: ruta){
            self.tabla1.reloadData()
            self.tabla2.reloadData()
            print(self.restaurantes)
        }
    }
    
    func obtenerRestaurantes(ruta: String ,completed: @escaping () -> ()){
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!){ (data, response, error) in
            if error == nil{
                do{
                    let datos = try JSONDecoder().decode([Restaurante].self, from: data!)
                    self.restaurantes = datos
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("Error en JSON")
                }
                /*do{
                    let datos = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any]
                    for dato in datos!{
                        let info = dato as? [String: Any]
                        print(info!)
                        let restaurante = Restaurante()
                        restaurante.DNI = String(info!["DNI"] as! Int)
                        restaurante.nombre = info!["nombre_rest"] as! String
                        
                        self.restaurantes.append(restaurante)
                    }
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("Error en JSON")
                }*/
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tabla1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")!
            cell.textLabel?.text = String(restaurantes[indexPath.row].DNI)
            return cell
        }else if tableView == tabla2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
            cell.textLabel?.text = String(restaurantes[indexPath.row].DNI)
            return cell
        }
        
        return UITableViewCell()
    }

}
