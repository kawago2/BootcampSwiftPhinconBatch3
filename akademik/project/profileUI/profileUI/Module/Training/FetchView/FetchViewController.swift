import UIKit

class FetchViewController: UIViewController {
    // Buat variabel untuk menyimpan data todos
    var todos: [ToDo] = []
    
    // Buat table view
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tambahkan table view ke tampilan utama
        view.addSubview(tableView)
        
        // Atur delegate dan dataSource table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Daftarkan sel untuk table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Buat layout constraints untuk table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Panggil fungsi untuk mengambil data dari API
        fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: BaseConstant.baseUrl) else {
            return
        }
        
        URLSession.shared.fetchData(for: url) { (result: Result<[ToDo], Error>) in
            switch result {
            case .success(let fetchedTodos):
                // Mengisi data todos dengan hasil yang diambil dari API
                self.todos = fetchedTodos
                
                // Memperbarui tampilan setelah data diambil
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
 
}

extension FetchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = "\(todo.id). \(todo.title)"
        return cell
    }
}
