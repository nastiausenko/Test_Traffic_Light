import UIKit

class ViewController: UIViewController {
    
    private var isStarted: Bool = false
    
    private var buttonCenterYConstraint: NSLayoutConstraint!
    private var buttonBottomConstraint: NSLayoutConstraint!
    
    private let lightSize: CGFloat = 100
    private let containerPadding: CGFloat = 16
    private let lightSpacing: CGFloat = 16
   
    private let redLight = UIView()
    private let yellowLight = UIView()
    private let greenLight = UIView()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let trafficLightContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.alpha = 0
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            redLight,
            yellowLight,
            greenLight
        ])
        stackView.axis = .vertical
        stackView.spacing = lightSpacing
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
       
        buttonCenterYConstraint = button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        buttonBottomConstraint = button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
                
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonCenterYConstraint,
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        setupTrafficLight()
        setupLights()
    }

    @objc private func startButtonTapped() {
        isStarted.toggle()
        
        isStarted ? showTrafficLight() : hideTrafficLight()
        button.setTitle(isStarted ? "Stop" : "Start", for: .normal)
        buttonCenterYConstraint.isActive = isStarted ? false : true
        buttonBottomConstraint.isActive = isStarted ? true : false
       
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()

        }
    }
  
    private func showTrafficLight() {
        UIView.animate(withDuration: 0.35) {
            self.trafficLightContainer.alpha = 1
            self.trafficLightContainer.transform = .identity
        }
    }
    
    private func hideTrafficLight() {
        UIView.animate(withDuration: 0.35) {
            self.trafficLightContainer.alpha = 0
            self.trafficLightContainer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    private func setupTrafficLight() {
        view.addSubview(trafficLightContainer)
        trafficLightContainer.addSubview(stackView)
        
        trafficLightContainer.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trafficLightContainer.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            trafficLightContainer.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
    
            stackView.topAnchor.constraint(
                equalTo: trafficLightContainer.topAnchor,
                constant: containerPadding),
            stackView.leadingAnchor.constraint(
                equalTo: trafficLightContainer.leadingAnchor,
                constant: containerPadding),
            stackView.trailingAnchor.constraint(
                equalTo: trafficLightContainer.trailingAnchor,
                constant: -containerPadding),
            stackView.bottomAnchor.constraint(
                equalTo: trafficLightContainer.bottomAnchor,
                constant: -containerPadding)
        ])
    }
    
    private func setupLights() {
        setupLight(light: redLight, color: .systemRed)
        setupLight(light: yellowLight, color: .systemYellow)
        setupLight(light: greenLight, color: .systemGreen)
    }
    
    private func setupLight(light: UIView, color: UIColor) {
        light.backgroundColor = color
        light.layer.cornerRadius = lightSize / 2
        light.clipsToBounds = true
        light.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            light.widthAnchor.constraint(equalToConstant: lightSize),
            light.heightAnchor.constraint(equalToConstant: lightSize)
        ])
    }
}

