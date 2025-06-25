import UIKit

final class PhotoViewController: UIViewController {
	override func loadView() {
		super.loadView()
		view.backgroundColor = .systemBackground

		let imageView = UIImageView(image: UIImage(named: "Luna’s Photo"))
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true

		imageView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(imageView)

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
		])
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Luna’s Photo"
	}
}
