import UIKit

class ViewController: UIViewController {
    
    private var isStarted: Bool = false
    private var timer: Timer?
    private var lightIndex: Int = 0
    
    private var buttonCenterYConstraint: NSLayoutConstraint!
    private var buttonBottomConstraint: NSLayoutConstraint!
    private var buttonHeightConstraint: NSLayoutConstraint!
    private var buttonWidthConstraint: NSLayoutConstraint!
    
    private let lightSize: CGFloat = 100
    private let containerPadding: CGFloat = 24
    private let lightSpacing: CGFloat = 16
    private let innerPadding: CGFloat = 32
   
    private let redLight = UIView()
    private let yellowLight = UIView()
    private let greenLight = UIView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Traffic Light"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .darkGray
        label.alpha = 1
        return label
    }()
    
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
        
        setupButton()
        setupLabel()
        setupTrafficLight()
        setupLights()
    }
    
    private func setupLabel() {
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -innerPadding)
        ])
    }
    
    private func setupButton() {
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(startButtonTapped),
            for: .touchUpInside)
        
        buttonCenterYConstraint = button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        buttonBottomConstraint = button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -innerPadding)
        buttonWidthConstraint = button.widthAnchor.constraint(equalToConstant: 100)
        buttonHeightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
    
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonCenterYConstraint,
            buttonWidthConstraint,
            buttonHeightConstraint
        ])
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
        setupLight(redLight, color: .systemRed)
        setupLight(yellowLight, color: .systemYellow)
        setupLight(greenLight, color: .systemGreen)
    }
    
    private func setupLight(_ light: UIView, color: UIColor) {
        light.backgroundColor = color.withAlphaComponent(0.25)
        light.layer.cornerRadius = lightSize / 2
        light.clipsToBounds = true
        light.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            light.widthAnchor.constraint(equalToConstant: lightSize),
            light.heightAnchor.constraint(equalToConstant: lightSize)
        ])
    }
    
    @objc private func startButtonTapped() {
        isStarted.toggle()
        isStarted ? startTrafficLightAnimation() : stopTrafficLightAnimation()
        
        updateUI(animated: true)
    }
    
    private func updateUI(animated: Bool) {
        updateButton()
        animateUIChangesIfNeeded(animated)
    }
    
    private func updateButton() {
        button.setTitle(isStarted ? "■" : "Start", for: .normal)
        button.backgroundColor = isStarted ? .systemRed : .systemBlue
        button.layer.cornerRadius = isStarted ? 25 : 10
        
        buttonWidthConstraint.constant = isStarted ? 50 : 100
        buttonHeightConstraint.constant = 50
        
        NSLayoutConstraint.deactivate([
            buttonCenterYConstraint,
            buttonBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            isStarted ? buttonBottomConstraint : buttonCenterYConstraint
        ])
    }
    
    private func animateUIChangesIfNeeded(_ animated: Bool) {
        let animations = {
            self.updateTrafficLightVisibilityState()
            self.label.alpha = self.isStarted ? 0 : 1
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                options: [.curveEaseInOut],
                animations: animations)
        } else {
            animations()
        }
    }

    private func updateTrafficLightVisibilityState() {
        trafficLightContainer.alpha = isStarted ? 1 : 0
        trafficLightContainer.transform = isStarted
            ? .identity
            : CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    private func startTrafficLightAnimation() {
        timer?.invalidate()
        lightIndex = 0
        updateLightColor()
        
        timer = Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(trafficLightTick),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopTrafficLightAnimation() {
        timer?.invalidate()
        timer = nil
        
        redLight.backgroundColor = .systemRed.withAlphaComponent(0.25)
        yellowLight.backgroundColor = .systemYellow.withAlphaComponent(0.25)
        greenLight.backgroundColor = .systemGreen.withAlphaComponent(0.25)
        lightIndex = 0
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func updateLightColor() {
        UIView.animate(withDuration: 0.4) {
            self.redLight.backgroundColor = self.lightIndex == 0
                ? .systemRed
                : .systemRed.withAlphaComponent(0.25)
            
            self.yellowLight.backgroundColor = self.lightIndex == 1
                ? .systemYellow
            : .systemYellow.withAlphaComponent(0.25)
            
            self.greenLight.backgroundColor = self.lightIndex == 2
                ? .systemGreen
                : .systemGreen.withAlphaComponent(0.25)
        }
    }
    
    @objc private func trafficLightTick() {
        lightIndex = (lightIndex + 1) % 3
        updateLightColor()
    }
    
}
