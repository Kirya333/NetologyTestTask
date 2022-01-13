import UIKit

// Задание: При старте приложения проверить, есть ли на диске сохраненный файл,
// если есть декодировать его и показать на экране, если нет, то загрузить данные,
// сохранить на файл, и показать на экране

// 02 Вариант
// Самое простое что можно сделать для улучшения - это разделить логику из метода
// viewDidLoad на несколько отдельных методов, первая группа будет отвечать за
// отрисовку UI, вторая группа будет отвечать за работу с данными.
// Теперь код более легко читать и понимать, сразу ясно какую часть надо менять,
// если например изменяться правила сохранения кода, или способ отображение
// Дальше смотри ViewController03

class ViewController02: UIViewController {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateData()
    }

    // MARK: - UI

    private func configureUI() {
        view.backgroundColor = .white
        addStackView()
        configureStackView()
    }

    private func addStackView() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: stackView.topAnchor),
            view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }

    private func configureStackView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
    }

    private func update(with post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }

    // MARK: - Data

    private func updateData() {
        if let post = getLocalPost() {
            update(with: post)
        } else {
            updateFromRemote()
        }
    }

    private func getLocalPost() -> Post? {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectoryURL.appendingPathComponent("post.json")

        guard let data = try? Data(contentsOf: fileURL),
              let post = try? JSONDecoder().decode(Post.self, from: data) else { return nil }
        return post
    }

    private func updateFromRemote() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let post = try? JSONDecoder().decode(Post.self, from: data!),
                  let postData = try? JSONEncoder().encode(post) else { return }
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentDirectoryURL.appendingPathComponent("post.json")
            try? postData.write(to: fileURL)
            DispatchQueue.main.async { [weak self] in
                self?.update(with: post)
            }
        }.resume()
    }

}

