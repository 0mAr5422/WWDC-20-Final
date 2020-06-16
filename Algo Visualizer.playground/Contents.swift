// this playground will help people get more information about sorting algorithms and visualize them working
// SortNode class is used from the apple project from WWDC19 about UICOllectionviewDiffableDataSource



import UIKit
import PlaygroundSupport

class MainViewController : UIViewController {
    enum Section {
        case main
    }
    var collectionView : UICollectionView! = nil
    var dataSource : UICollectionViewDiffableDataSource<Section,AlgorithmItem>! = nil
    
    
    class AlgorithmItem: Hashable {
           let title: String
           let info : String
           let timeComplexity : String;
           let characteristics : String
           let algorithmViewController: UIViewController.Type?
           let algorithm : SortingViewController.Algorithms

           init(algorithm : SortingViewController.Algorithms,title: String,
                timeComplexity:String,
                characteristics : String,
                info: String,
                viewController: UIViewController.Type? = nil){
               self.algorithm = algorithm
               self.title = title
               self.info = info
               self.timeComplexity = timeComplexity
               self.characteristics = characteristics
               self.algorithmViewController = viewController
           }
           func hash(into hasher: inout Hasher) {
               hasher.combine(identifier)
           }
           static func == (lhs: AlgorithmItem, rhs: AlgorithmItem) -> Bool {
               return lhs.identifier == rhs.identifier
           }
           var isGroup: Bool {
               return self.algorithmViewController == nil
           }
           private let identifier = UUID()
       }
    
    
    
    private lazy var algorithms : [AlgorithmItem] = [
        
         AlgorithmItem(algorithm: .bubbleSort, title: "Bubble  Sort",timeComplexity: "Time: O(N^2) , Space: O(1)",characteristics: "Stable - Inplace", info: "Bubble sort is the simplest sorting algorithm that works by repeatedly swapping elements so that at each iteration the largest element in the unsorted partition will be in it's correct place in the actual array", viewController: SortingViewController.self),
        AlgorithmItem(algorithm: .selectionSort, title: "Selection Sort",timeComplexity: "Time: O(N^2) ,Space: O(1)",characteristics: "Unstable - Inplace" ,info: "Selection sort works by dividing the array (Virtually) in a sorted and unsorted sub arrays and at every iteration it finds the minimum item and place it at the end of the sorted sub-array", viewController: SortingViewController.self),
        AlgorithmItem(algorithm: .insertionSort, title: "Insertion Sort",timeComplexity: "Time: O(N^2) , Space: O(1)",characteristics: "Stable - Inplace", info: "Insertion sort sorts the array the same way we sort cards in our hands , we imagine that the first item is sorted and this will divide the array (VIRTUALLY) then we choose the first element from the unsorted array and place it in it's correct place in the actual array", viewController: SortingViewController.self),
        AlgorithmItem(algorithm: .shellSort, title: "Shell sort ",timeComplexity: "Time: O(N^2) , Space: O(1)",characteristics: "Un-Stable - Inplace", info: "Shell sort is a variation of Insertion Sort , in Insertion sort we move items only by one index so when an element need to be moved to a far index a lot of swaps are needed so in Shell Sort we move items by a gap so less and less swaps are needed", viewController: SortingViewController.self),
        AlgorithmItem(algorithm: .mergeSort, title: "Merge sort ",timeComplexity: "Time: O(NLog(N)) , Space: O(N)",characteristics: "Stable - not Inplace", info: "Merge sort falls behind the category of (DIVIDE AND CONQUER) algorithms that works by breaking the array into two subarrays and every subarrays in two until every subarray only contains 1 element and then it starts merging them back ", viewController: SortingViewController.self),
        AlgorithmItem(algorithm: .heapSort, title: "Heap sort ",timeComplexity: "Time: O(NLog(N)) , Space: O(1)",characteristics: "Un-Stable - Inplace", info: "Heap Sort is a comparison based sorting algorithm based on the Binary Heap data structure we first find the maximum element and place it at the end of the array and do this again for each element until the array is sorted", viewController: SortingViewController.self)
        

        
       
        
    
    ]
    
       
    
    override func viewDidLoad() {
        title = "Algo Visualizer"
        configureCollectionView()
        configureDataSource()
        
       
        
        
    }
    
    
    
}

extension MainViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(AlgorithmCardCell.self, forCellWithReuseIdentifier: AlgorithmCardCell.reuseIdentifier)
    }
    
    private func  configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource
            <Section, AlgorithmItem>(collectionView: self.collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AlgorithmItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AlgorithmCardCell.reuseIdentifier,
                for: indexPath) as? AlgorithmCardCell else { fatalError("Could not dequeue algorithm card cell") }
                cell.algoName.text = item.title
                cell.algoInfo.text = item.info
                cell.timeAndSpaceComplexity.text = item.timeComplexity
                cell.algoCharacteristics.text = item.characteristics
                
                
            return cell
        }

        // load our initial data
        let snapshot = snapshotForCurrentState()
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AlgorithmItem>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, AlgorithmItem>()
        snapshot.appendSections([Section.main])
        func addItems(_ menuItem: AlgorithmItem) {
            snapshot.appendItems([menuItem])
            
        }
        self.algorithms.forEach { addItems($0) }
        return snapshot
        
    }
    
    private func layout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
               widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
               heightDimension: NSCollectionLayoutDimension.fractionalHeight(1)
               )
               let item = NSCollectionLayoutItem(layoutSize: size)
               item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 30, bottom: 5, trailing: 30)
               
               
               let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.555))
               let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
               
               
               let section = NSCollectionLayoutSection(group: group)
               section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)

           
               let layout = UICollectionViewCompositionalLayout(section: section)
               return layout
    }
}

extension MainViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlgorithmCardCell else {return}
        guard let algoItem = dataSource.itemIdentifier(for: indexPath) else {return}
        
        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        
        if let viewController = algoItem.algorithmViewController  {
            let navController = UINavigationController(rootViewController: viewController.init())
            SortingViewController.chosenAlgo = algoItem.algorithm
            present(navController, animated: true)
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            }
        }
            
        }
    
}


let navigationController = UINavigationController(rootViewController: MainViewController())
PlaygroundPage.current.liveView = navigationController
