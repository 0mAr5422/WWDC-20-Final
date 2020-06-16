//
//  SortingArray.swift
//  Algo Visualizer
//
//  Created by omar on 3/29/20.
//  Copyright © 2020 omar. All rights reserved.
//

import UIKit


public class SortingArray : Hashable {
    
   
   public var values: [SortNode] {
        return nodes
    }
    public var isSorted: Bool {
        return isSortedInternal
    }
    public func setValues (array : [SortNode]){
        nodes=array
    }
    
    func sortNext() {
        switch chosenAlgo {
        case .bubbleSort:
            if !didCall {
                currentIndex = 0;
                didCall.toggle()
            }
            performNextBubbleSortStep()
            break
        case .selectionSort:
            if !didCall {
                currentIndex = 0;
                didCall.toggle()
            }
            performNextSelectionSortStep()
            break
        case .insertionSort:
            if !didCall {
                currentIndex = 1;
                didCall.toggle()
            }
            performNextInsertionSortStep()
            break
        case .mergeSort:
            if !didCall {
                currentIndex = 1;
                didCall.toggle()
            }
            performBottomUpMergeSort()
            
            break
        case .shellSort:
            
            if !didCall {
                currentIndex = nodes.count / 2;
                shellSortIndex = currentIndex
                didCall.toggle()
            }
            
            performNextShellSortStep()
            break
        case .heapSort:
            if !didCall {
                currentIndex = nodes.count-1
                buildMaxHeap(n:nodes.count)
                didCall.toggle()
            }
            
            performHeapSort()
            break;
        }
    }
    public init(count: Int , algo : SortingViewController.Algorithms) {
        nodes = (0..<count).map { SortNode(value: $0, maxValue: count) }.shuffled()
        chosenAlgo = algo
       
    }
   
   public let chosenAlgo : SortingViewController.Algorithms

    
    private var currentIndex = 0;
    private var didCall = false
    private var isSortedInternal = false
    private var nodes: [SortNode]
    private let identifier = UUID();
    private var shellSortIndex = 0;
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: SortingArray, rhs: SortingArray) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    
}

extension SortingArray {
    

    public func swap(num1 : Int, num2 : Int) {
        let temp = nodes[num1]
        nodes[num1] = nodes[num2]
        nodes[num2] = temp
    }
    
    fileprivate func performNextBubbleSortStep() {
        if isSortedInternal {
            return
        }
        if nodes.count == 1 {
            isSortedInternal = true
            return
        }
        
        for i in 0..<nodes.count-currentIndex-1 {
            if nodes[i] > nodes[i+1] {
                swap(num1: i, num2: i+1)
            }
        }
        currentIndex+=1
        if currentIndex >= nodes.count {
            isSortedInternal = true
            return
        }
    }
    
    
    fileprivate func performNextInsertionSortStep() {
        if isSortedInternal {
            return
        }
        if nodes.count == 1 {
            isSortedInternal = true
            return
        }

        var index = currentIndex
        let currentNode = nodes[index]
        index -= 1
        while index >= 0 && currentNode.value < nodes[index].value {
            let tmp = nodes[index]
            nodes[index] = currentNode
            nodes[index + 1] = tmp
            index -= 1
        }
        currentIndex += 1
        if currentIndex >= nodes.count {
            isSortedInternal = true
            return
            
        }
    }
    
    fileprivate func performNextSelectionSortStep() {
        if isSortedInternal {
            return
        }
        if nodes.count <= 1 {
            isSortedInternal = true
            return
        }
        
        var smallest = currentIndex;
        
        for j in currentIndex+1..<nodes.count {
            if nodes[j] < nodes[smallest] {
                smallest = j;
            }
        }
        swap(num1:smallest , num2:currentIndex)
        currentIndex += 1
        
        if currentIndex >= nodes.count {
            isSortedInternal = true
            return
        }
        
    }
    
    
    fileprivate func performNextShellSortStep() {
        if isSortedInternal {
            return
        }
        if nodes.count == 1 {
            isSortedInternal = true;
            return
            
        }
        
        if shellSortIndex < nodes.count{
            let temp = nodes[shellSortIndex]
            var j = shellSortIndex
            while  j >= currentIndex && nodes[j-currentIndex] > temp{
                nodes[j] = nodes[j-currentIndex]
                j -= currentIndex
            }
              
            nodes[j] = temp
            shellSortIndex+=1
        }
        
        else {
            currentIndex /= 2
            shellSortIndex = currentIndex
        }
        
        
        
        
        if currentIndex <= 0{
            isSortedInternal = true
            return
        }
    }
    
    
    
    
    private func performBottomUpMergeSort() {
        if isSortedInternal {
            return
        }
        if nodes.count == 1 {
            isSortedInternal = true
            return
        }
        
        let width = currentIndex
        
        let n = nodes.count
        var z = [nodes , nodes]
        var d = 0
        
        var i = 0
        while i < n {
            var j = i
            var l = i
            var r = i+width
            
            let lMax = min (l + width  , n )
            let rMax = min (r + width , n)
            
            while (l < lMax && r < rMax) {
                if z[d][l].value <= z[d][r].value {
                    z[1-d][j] = z[d][l]
                    l+=1
                    j+=1
                }
                else {
                    z[1-d][j] = z[d][r]
                    r+=1
                    j+=1
                }
            }
            while l < lMax {
                z[1-d][j] = z[d][l]
                l+=1
                j+=1
            }
            while r < rMax {
                z[1-d][j] = z[d][r]
                r+=1
                j+=1
                
            }
            
            i += width*2
            
        }
        
        
        
        currentIndex *= 2
        d = 1 - d
        nodes = z[d]
        
        if currentIndex >= nodes.count {
            isSortedInternal = true
            return
        }
        
    }
    
    
}

extension SortingArray{
    
    
    func  buildMaxHeap(n: Int) {
        for i in 0..<n {
           
            if nodes[i] > nodes[Int((i - 1) / 2)]{
                var j = i
                
            
                while nodes[j] > nodes[Int((j - 1) / 2)]{
                    (nodes[j],
                    nodes[Int((j - 1) / 2)]) = (nodes[Int((j - 1) / 2)],nodes[j])
                    j = Int((j - 1) / 2)
                }
                    
            }
                  
        }
            
          
    }
      
    
    
    func performHeapSort() {
        if isSortedInternal {
            return
            
        }
        if nodes.count == 1{
            return
            
        }
        let i = currentIndex
        let temp = nodes[0]
        nodes[0] = nodes[i]
        nodes[i] = temp
        
            
              
        var j = 0
        var index = 0;
                
        while true{
            index = 2 * j + 1
                
              
              if (index < (i - 1) &&
                nodes[index] < nodes[index + 1]){
                index += 1
            }
                  
            
             
            if index < i && nodes[j] < nodes[index]{
                let temp = nodes[j]
                nodes[j] = nodes[index]
                nodes[index] = temp
                
            }
                  
            
              j = index
            if index >= i{
                break
            }
                  
        }
                
        currentIndex -= 1
        if currentIndex < 0 {
            isSortedInternal = true
            return
        }
    }
}
