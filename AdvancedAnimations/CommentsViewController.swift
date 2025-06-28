import UIKit

final class CommentsViewController: UIViewController {
	override func loadView() {
		super.loadView()
		view.backgroundColor = .systemBackground
		view.directionalLayoutMargins = .init(top: 20, leading: 20, bottom: 20, trailing: 20)

		let label = UILabel()
		label.text = "Comments"
		label.font = .preferredFont(forTextStyle: .headline)
		label.adjustsFontForContentSizeCategory = true

		label.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)

		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
			label.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
			label.topAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
		])
	}
}
