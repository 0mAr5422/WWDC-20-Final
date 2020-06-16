import UIKit

public class AlgorithmCardCell : UICollectionViewCell {
    
    public static let reuseIdentifier = "algorithm-card-cell-reuse-identifier"
    
    
    
    public let algoName = UILabel()
    public let algoInfo = UITextView()
    public let algoCharacteristics = UILabel()
    public let timeAndSpaceComplexity = UILabel()
       
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContentView()
        
    }
    
    required init?(coder: NSCoder) {
           fatalError("can't initialize algo card  cell");
       }
    
}

extension AlgorithmCardCell {
    
    private func configureContentView() {
        
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowRadius = 20
        contentView.layer.shadowOffset = .zero
        contentView.backgroundColor = .white
        
        configureAlgoCharacteristicsLabel()
        configureNameLabel()
        configureComplexityLabel()
        configureAlgoInfoTextView()
        
    }
    
    private func configureAlgoCharacteristicsLabel() {
        contentView.addSubview(algoCharacteristics)
        algoCharacteristics.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            algoCharacteristics.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            algoCharacteristics.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            algoCharacteristics.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            
        ])
        algoCharacteristics.text = "Unstable - inplace"
        algoCharacteristics.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private func configureNameLabel() {
        contentView.addSubview(algoName)
        algoName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            algoName.topAnchor.constraint(equalTo: algoCharacteristics.bottomAnchor, constant: 5),
            algoName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            algoName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)

        ])
        algoName.font = UIFont.boldSystemFont(ofSize: 22)
        
        algoName.textColor = .black
        
        
       
    }
    private func configureComplexityLabel() {
        contentView.addSubview(timeAndSpaceComplexity)
        timeAndSpaceComplexity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeAndSpaceComplexity.topAnchor.constraint(equalTo: algoName.bottomAnchor, constant: 5),
            timeAndSpaceComplexity.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            timeAndSpaceComplexity.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        
        ])
        timeAndSpaceComplexity.text = "O(N^2) , O(N)"
        timeAndSpaceComplexity.textColor = .darkText
        timeAndSpaceComplexity.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private func configureAlgoInfoTextView() {
        contentView.addSubview(algoInfo)
        algoInfo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            algoInfo.topAnchor.constraint(equalTo: timeAndSpaceComplexity.bottomAnchor, constant: 5),
            algoInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            algoInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            algoInfo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)



        ])
        algoInfo.isUserInteractionEnabled = false
        algoInfo.textAlignment = .left
        algoInfo.font = UIFont.systemFont(ofSize: 18)
        algoInfo.backgroundColor = .clear
        algoInfo.textColor = .black
    }
    
}

