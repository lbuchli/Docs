#import "@preview/cetz:0.3.4"

#cetz.canvas(length: 1.5cm, {
    import cetz.draw: *
    import calc: *

    let r = 1.0
    let angle = 33deg
    let tangent_len_up = 1.8
    let tangent_len_down = 0.8

    let O = (0, 0)
    let P = (cos(angle), sin(angle))
    let N = (cos(angle), 0)
    let N_prime = (0, sin(angle))
    let T = (1 / cos(angle), 0)
    let T_prime = (0, 1 / sin(angle))

    let tangent_start = (P.at(0)-sin(angle)*tangent_len_up, P.at(1)+cos(angle)*tangent_len_up)
    let tangent_end = (P.at(0)+sin(angle)*tangent_len_down, P.at(1)-cos(angle)*tangent_len_down)

    let A = (r, 0)
    let A_prime = (-r, 0)
    let B = (0, r)
    let B_prime = (0, -r)

    line((0, 0), (2, 0), stroke: 0.6pt, name: "x-axis")
    line((0, 0), (0, 2), stroke: 0.6pt, name: "y-axis")

    arc-through((r, 0), P, (0, r), stroke: (paint: black, thickness: 0.6pt))
    line(O, P, stroke: 0.6pt)

    line(tangent_start, P, stroke: 0.8pt, name: "tangent-up")
    line(P, tangent_end, stroke: 0.8pt, name: "tangent-down")
    content(("tangent-up.start", 50%, "tangent-up.end"), angle: "tangent-up.end", anchor: "south", padding: .05, $cot$)
    content(("tangent-down.start", 50%, "tangent-down.end"), angle: "tangent-down.end", anchor: "south", padding: .05, $tan$)

    line(P, N, stroke: 0.8pt, name: "sin")
    content(("sin.start", 50%, "sin.end"), angle: "sin.end", anchor: "north", padding: .05, $sin$)
    line(P, N_prime, stroke: 0.8pt, name: "cos")
    content(("cos.start", 50%, "cos.end"), angle: "cos.start", anchor: "south", padding: .05, $cos$)

    content(("y-axis.start", 50%, "y-axis.end"), angle: "y-axis.end", anchor: "south", padding: .05, $csc$)
    content(("x-axis.start", 35%, "x-axis.end"), angle: "x-axis.end", anchor: "north", padding: .05, $sec$)

    arc((0.5, 0), start: 0deg, delta: angle, radius: 0.5, stroke: 0.6pt)
    content((0.33, 0.10), $theta$)
})
