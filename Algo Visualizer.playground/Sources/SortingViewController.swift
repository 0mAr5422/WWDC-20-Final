import UIKit

public class SortingViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    public static var chosenAlgo : Algorithms! = nil
    static var nodeSize = CGSize(width: 16, height: 32)
    static var algorithmSpeed : Float = 0
    static let reuseIdentifier = "cell-id"
    
    var collectionView : UICollectionView! = nil
    var dataSource : UICollectionViewDiffableDataSource<SortingArray , SortNode>! = nil
    var isSorting = false
    var isSorted = false
    var delayInMillieSeconds = 225
    
    
    
    
    public enum Algorithms {
        case bubbleSort , selectionSort , insertionSort , mergeSort ,shellSort , heapSort
    }
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        switch SortingViewController.chosenAlgo {
        case .insertionSort :
            title = "Insertion Sort"
            break
        case .bubbleSort :
            title = "Bubble Sort"
            break;
        case .selectionSort :
            title = "Selection Sort"
            break;
        case .mergeSort :
            title = "Merge Sort"
        case .shellSort :
            title = "Shell Sort"
            break;
        case .heapSort :
            title  = "Heap Sort"
        default :
            break
        }
        
        configureCollectionView()
        configureDataSource()
        configureNavItem()
        
        
    }
    
}
extension SortingViewController {
    
    func configureNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isSorting ? "Stop" : "Sort",
                                                            style: .plain, target: self,
                                                            action: #selector(toggleSort))
    }
    
    @objc func toggleSort() {
        isSorting.toggle()
        if isSorting {
            
            performSortStep()
            
        }
        configureNavItem()
    }
    
    
    
    func performSortStep() {
            if !isSorting {
                return
            }

            var sectionsToSort = 0

            var updatedSnapshot = dataSource.snapshot()

            updatedSnapshot.sectionIdentifiers.forEach {
                let section = $0
                if !section.isSorted {

                    section.sortNext()
                    let items = section.values

                    updatedSnapshot.deleteItems(items)
                    updatedSnapshot.appendItems(items, toSection: section)

                    sectionsToSort += 1
                }
            }

            var shouldReset = false
            delayInMillieSeconds = 225
            if sectionsToSort > 0 {
                dataSource.apply(updatedSnapshot)
            } else {
                delayInMillieSeconds = 1000
                shouldReset = true
            }
            let bounds = collectionView.bounds
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delayInMillieSeconds)) {
                if shouldReset {
                    let snapshot = self.randomizedSnapshot(for: bounds)
                    self.dataSource.apply(snapshot, animatingDifferences: false)
                }
                self.performSortStep()
            }
        }
        
}

extension SortingViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: SortingViewController.reuseIdentifier)
    }
    
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SortingArray , SortNode>(collectionView : self.collectionView) {
            (collectionView : UICollectionView , indexPath : IndexPath , sortNode : SortNode) in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SortingViewController.reuseIdentifier,
                    for: indexPath)
            
                cell.backgroundColor = sortNode.color
                return cell
            
        }
        
        let bounds = collectionView.bounds
        let snapshot = randomizedSnapshot(for: bounds)
        dataSource.apply(snapshot)
    }
    
    private func randomizedSnapshot(for bounds : CGRect) -> NSDiffableDataSourceSnapshot
    <SortingArray , SortNode>{
        var snapshot = NSDiffableDataSourceSnapshot<SortingArray, SortNode>()
        let rowCount = numberOfRows(for: bounds)
        let columnCount = numberOfCols(for: bounds)
        for _ in 0..<rowCount {
            let section = SortingArray(count: columnCount, algo: SortingViewController.chosenAlgo)
            snapshot.appendSections([section])
            snapshot.appendItems(section.values)
        }
        return snapshot
    }
    
    private func numberOfRows(for bounds: CGRect) -> Int {
        return Int(bounds.height / SortingViewController.nodeSize.height)
    }
    private func numberOfCols(for bounds: CGRect) -> Int {
        return Int(bounds.width / SortingViewController.nodeSize.width)
    }
    
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
           (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
           let contentSize = layoutEnvironment.container.effectiveContentSize
           let columns = Int(contentSize.width / SortingViewController.nodeSize.width)
           let rowHeight = SortingViewController.nodeSize.height
           let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
           let item = NSCollectionLayoutItem(layoutSize: size)
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(rowHeight))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
           let section = NSCollectionLayoutSection(group: group)
           return section
       }
       return layout
       
    }
}
