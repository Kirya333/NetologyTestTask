import UIKit

// Задание: При старте приложения проверить, есть ли на диске сохраненный файл,
// если есть декодировать его и показать на экране, если нет, то загрузить данные,
// сохранить на файл, и показать на экране

// 03 Вариант
// В дальнейшем можно выделить логику получения данных в отдельный класс
// и оставить во ViewController только работу с отображением данных.
// Это еще больше облегчит понимание кода и внесение изменений.
// Помимо этого можно будет переиспользовать ViewModel с разными ViewController,
// в случае, когда надо по разному отображать одни и те же данные.
// Дальше см. ViewModel03

class ViewController03: UIViewController {

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

    private let viewModel = ViewModel03()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.getPost { [weak self] post in
            self?.update(with: post)
        }
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

    private func update(with post: Post?) {
        titleLabel.text = post?.title
        bodyLabel.text = post?.body
    }

}

