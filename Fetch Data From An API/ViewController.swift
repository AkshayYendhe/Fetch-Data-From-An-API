//
//  ViewController.swift
//  Fetch Data From An API
//
//  Created by Akshay Yendhe on 07/02/23.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var todos = [Todo]()
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var enterMessageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      //  return 90
    //}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        cell.titleLabel.text = todo.todo
        cell.checkmarkImageView.isHidden = !todo.completed
        return cell
    }
    
    func getData(){
        
        let url = URL(string: "https://dummyjson.com/todos")
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data,response,error) in
            guard let data = data , error == nil else{
                print(error?.localizedDescription ?? "No Data")
                return
            }
            do{
                let model = try JSONDecoder().decode(TodoModel.self, from: data)
                self.todos = model.todos
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                }
                print(model.todos)
            }
            catch let error
            {
                print("Error Decoding JSON \(error.localizedDescription)")
            }
            
        })
        task.resume()
    }
    
    func postData(){
        
        let url = URL(string: "https://dummyjson.com/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let message = enterMessageTextField.text {
            let todo = ["todo": "\(message)","completed": false, "userId": 6] as [String : Any]
            request.httpBody = try! JSONSerialization.data(withJSONObject: todo)
        }
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data,response,error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else{
                print("No data received from server")
                return
            }
            do{
                let responseJSON = try! JSONSerialization.data(withJSONObject: data,options: [])
                print(responseJSON)
            }
            catch{
                print(error)
            }
            
        }).resume()
    }

    
    
    @IBAction func addNewMessageButtonAction(_ sender: Any) {
       // postData()
    }
    
}

