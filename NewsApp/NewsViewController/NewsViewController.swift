import UIKit

class NewsViewController: UIViewController {
  // MARK: - Properties:
  
  // MARK: - Private Properties:
  private lazy var newsTable: UITableView = {
    let table = UITableView()
    table.backgroundColor = .clear
    table.separatorStyle = .none
    table.allowsMultipleSelection = false
    table.dataSource = self
    table.delegate = self
    table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reuseID)
    table.showsVerticalScrollIndicator = false
    
    return table
  }()
  
  // MARK: - LifeCycle:
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.background
    configureNavbar()
    setupLayout()
    setupConstraints()
  }
}

// MARK: - Private Methods:
extension NewsViewController {
  private func configureNavbar() {
    if navigationController?.navigationBar != nil {
      self.title = "News"
      let navBarAppearance = UINavigationBarAppearance()
      navBarAppearance.configureWithOpaqueBackground()
      navBarAppearance.backgroundColor = .clear
      navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.blackAndWhite]
      navigationController?.navigationBar.standardAppearance = navBarAppearance
      navigationController?.navigationItem.standardAppearance = navBarAppearance
      navigationItem.compactAppearance = navBarAppearance
    }
  }
  
  private func setupLayout() {
    [newsTable].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      newsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      newsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      newsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      newsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - Objc-Methods:
extension NewsViewController {
  
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    250
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20 ))
    headerView.backgroundColor = .clear
    let label = UILabel(frame: CGRect(x: 12, y: 0, width: headerView.bounds.width - 12, height: headerView.bounds.height))
    label.textAlignment = .left
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = .blackAndWhite
    label.text = "Section"
    headerView.addSubview(label)
    
    return headerView
  }
  
}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseID, for: indexPath) as? CustomTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCell(with: NewsModel(title: "Hello! My name is Ruslan Khalilulin. I'm an iOS developer. I'm trying to find a jib in IT. I Will be very good developer and always one of the best wherever I' work in", imageName: "myImage"))
    
    return cell
  }
}
