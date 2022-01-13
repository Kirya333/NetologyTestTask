import Foundation

// 03 Вариант
// Метода перенесенные из ViewControlller по прежнему слишком большие
// и их можно декомпозировать на более мелкие и легкие для понимания.
// В дальнейшем процесс рефакторинга можно продолжить, в частности выделить
// в отдельные сущности работу с сетевыми запросами и работу с файловой системой.

struct ViewModel03 {

    private var localPostURL: URL {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectoryURL.appendingPathComponent("post.json")
    }

    private var remotePostURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
    }

    func getPost(completion: @escaping (Post?) -> Void) {
        if let post = getLocalPost() {
            completion(post)
        } else {
            getRemotePost(completion: completion)
        }
    }

    private func getLocalPost() -> Post? {
        guard let data = try? Data(contentsOf: localPostURL),
              let post = try? JSONDecoder().decode(Post.self, from: data) else { return nil }
        return post
    }

    private func getRemotePost(completion: @escaping (Post?) -> Void) {
        getData(from: remotePostURL) { (data) in
            guard let post = try? JSONDecoder().decode(Post.self, from: data!),
                  let postData = try? JSONEncoder().encode(post) else { return }
            try? postData.write(to: localPostURL)
            completion(post)
        }
    }

    private func getData(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async { completion(data) }
        }.resume()
    }

}
