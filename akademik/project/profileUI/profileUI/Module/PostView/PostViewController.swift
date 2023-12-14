import UIKit

class PostViewController: UIViewController {
    // Buat variabel untuk menyimpan data posts
    var posts: [Post] = []

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
        postData()

    }

    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }

        URLSession.shared.fetchData(for: url) { (result: Result<[Post], Error>) in
            switch result {
            case .success(let fetchedPosts):
                // Mengisi data posts dengan hasil yang diambil dari API
                self.posts = fetchedPosts

                // Memperbarui tampilan setelah data diambil
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func postData() {
        // Define the data you want to send in the POST request
        let postData = Post(userId: 1, id: 0, title: "Sample Post Title", body: "This is the body of the sample post.")
        
        // Replace the URL with the actual API endpoint URL where you want to create a new post
        guard let postURL = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }

        URLSession.shared.postData(to: postURL, with: postData) { (result: Result<Post, Error>) in
            switch result {
            case .success(let response):
                // Handle the response data here
                print("Response: \(response)")
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
            }
        }
    }

}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
}

// Post struct yang digunakan untuk dekode data dari API
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
