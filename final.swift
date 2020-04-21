extension Double {
    static func ^(left: Double, right: Double) -> Double {
        return pow(left, right)
    }
}

func realSin(_ originalX: Double) -> Double {
    var x = originalX
    
    //reduce to pi/2
    if originalX > Double.pi/2 {
        x = x.truncatingRemainder(dividingBy: Double.pi/2)
    }
    
    //get x^(2n+1) for the first 6 iterations
    let x3 = (x^3.0)/6
    let x5 = (x^5.0)/120
    let x7 = (x^7.0)/5040
    let x9 = (x^9.0)/362880
    let x11 = (x^11.0)/39916800
    let x13 = (x^13.0)/6227020800
    let x15 = (x^15)/1307674368000
    let x17 = (x^17)/355687428096000
    
    let result = x - x3 + x5 - x7 + x9 - x11 + x13 - x15 + x17
    
    if originalX < 0 {
        return -result
    } else {
        return result
    }
}
