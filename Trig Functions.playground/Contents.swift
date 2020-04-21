import Foundation
//
////C's Implementation
//let S1  = -1.66666666666666324348e-01 /* 0xBFC55555, 0x55555549 */
//let S2  =  8.33333333332248946124e-03 /* 0x3F811111, 0x1110F8A6 */
//let S3  = -1.98412698298579493134e-04 /* 0xBF2A01A0, 0x19C161D5 */
//let S4  =  2.75573137070700676789e-06 /* 0x3EC71DE3, 0x57B1FE7D */
//let S5  = -2.50507602534068634195e-08 /* 0xBE5AE5E6, 0x8A2B9CEB */
//let S6  =  1.58969099521155010221e-10 /* 0x3DE5D93A, 0x5ACFD57C */
//
///* __kernel_sin( x, y, iy)
//* kernel sin function on [-pi/4, pi/4], pi/4 ~ 0.7854
//* Input x is assumed to be bounded by ~pi/4 in magnitude.
//* Input y is the tail of x.
//* Input iy indicates whether y is 0. (if iy=0, y assume to be 0).
//*
//* Algorithm
//*    1. Since sin(-x) = -sin(x), we need only to consider positive x.
//*    2. if x < 2^-27 (hx<0x3e400000 0), return x with inexact if x!=0.
//*    3. sin(x) is approximated by a polynomial of degree 13 on
//*       [0,pi/4]
//*                            3            13
//*           sin(x) ~ x + S1*x + ... + S6*x
//*       where
//*
//*     |sin(x)         2     4     6     8     10     12  |     -58
//*     |----- - (1+S1*x +S2*x +S3*x +S4*x +S5*x  +S6*x   )| <= 2
//*     |  x                                |
//*
//*    4. sin(x+y) = sin(x) + sin'(x')*y
//*            ~ sin(x) + (1-x*x/2)*y
//*       For better accuracy, let
//*             3      2      2      2      2
//*        r = x *(S2+x *(S3+x *(S4+x *(S5+x *S6))))
//*       then                    3   2
//*        sin(x) = x + (S1*x + (x *(r-y/2)+y))
//*/
//var steps: [CFAbsoluteTime] = []
//
//func mySin(_ x: Double) -> Double {
//    var x1 = x
//    if x1 < 0 {
//        x1 = -x1
//    }
//    if x1 > Double.pi/4 {
//        x1 = x1.truncatingRemainder(dividingBy: Double.pi/4)
//    }
//
//    let z = x1*x1 // x^2
//    let v = z*x1
//    let r = S2+z*(S3+z*(S4+z*(S5+z*S6))) // polynomial
//
//    if x < 0 {
//        return -x1+v*(S1+z*r)
//    } else {
//        return x1+v*(S1+z*r)
//    }
//}
extension Double {
    static func ^(left: Double, right: Double) -> Double {
        return pow(left, right)
    }
}

func mySin(_ originalX: Double) -> Double {
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


var start = CFAbsoluteTimeGetCurrent()

let one = mySin(1)
let two = mySin(Double.pi/4)

let myDiff = CFAbsoluteTimeGetCurrent() - start
start = CFAbsoluteTimeGetCurrent()

let three = sin(1.0)
let four = sin(Double.pi/4)

let cDiff = CFAbsoluteTimeGetCurrent() - start

print("My implementation:")
print(one, two)
print("Time: \(myDiff) s\n")
print("C implementation:")
print(three, four)
print("Time: \(cDiff) s")
//  0.00004994869

//generate csv string
var numbers: [Double] = [Double.pi, Double.pi/2, Double.pi/4, Double.pi/5, (Double.pi*2)/3, (Double.pi*2)/5, (Double.pi*2)/3, -Double.pi, Double.pi*2, Double.pi/3, 3/4, 4, 3, 1, 2, 0, 0.5, 365, 150, 120, 125, 300, 1000000, 123456789]

for _ in 0...100 {
    numbers.append(Double.random(in: -32...32))
}

var str = "Number,My Implementation,My Timestamp,Swift Implementation,Swift Timestamp\n"
for number in numbers {
    var s = CFAbsoluteTimeGetCurrent()
    mySin(number)
    let dif1 = CFAbsoluteTimeGetCurrent() - s
    s = CFAbsoluteTimeGetCurrent()
    sin(number)
    let dif2 = CFAbsoluteTimeGetCurrent() - s
    str.append("\(number),\(mySin(number)),\(dif1),\(sin(number)),\(dif2)\n")
}
print(str)

