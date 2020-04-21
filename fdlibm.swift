let S1  = -1.66666666666666324348e-01 /* 0xBFC55555, 0x55555549 */
let S2  =  8.33333333332248946124e-03 /* 0x3F811111, 0x1110F8A6 */
let S3  = -1.98412698298579493134e-04 /* 0xBF2A01A0, 0x19C161D5 */
let S4  =  2.75573137070700676789e-06 /* 0x3EC71DE3, 0x57B1FE7D */
let S5  = -2.50507602534068634195e-08 /* 0xBE5AE5E6, 0x8A2B9CEB */
let S6  =  1.58969099521155010221e-10 /* 0x3DE5D93A, 0x5ACFD57C */

func fllibmSin(_ x: Double) -> Double {
    var x1 = x
    if x1 < 0 {
        x1 = -x1
    }
    if x1 > Double.pi/4 {
        x1 = x1.truncatingRemainder(dividingBy: Double.pi/4)
    }
    
    let z = x1*x1 // x^2
    let v = z*x1
    let r = S2+z*(S3+z*(S4+z*(S5+z*S6))) // polynomial
    
    if x < 0 {
        return -x1+v*(S1+z*r)
    } else {
        return x1+v*(S1+z*r)
    }
}
