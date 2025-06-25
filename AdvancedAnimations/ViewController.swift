import UIKit

final class ViewController: UIViewController {
	override func loadView() {
		super.loadView()
		view.backgroundColor = .systemBackground
		let label = UILabel()
		label.text = "hello"
		label.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)
		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}
}
