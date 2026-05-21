import UIKit

class ViewController: UIViewController {
    
    private var isStarted: Bool = false
    private var buttonCenterYConstraint: NSLayoutConstraint!
    private var buttonBottomConstraint: NSLayoutConstraint!
    

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonCenterYConstraint = button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        buttonBottomConstraint = button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonCenterYConstraint,
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func startButtonTapped() {
        isStarted.toggle()
        
        button.setTitle(isStarted ? "Stop" : "Started", for: .normal)
        buttonCenterYConstraint.isActive = isStarted ? false : true
        buttonBottomConstraint.isActive = isStarted ? true : false
       
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

