#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(flipped: true, columns: 2, margin: 1cm)
#set text(9pt)

#set table(stroke: none)

#set enum(tight: true, spacing: 4pt, numbering: n => box(height: 1em, circle(radius: 0.4em, stroke: 0.5pt, align(center + horizon, text(8pt)[#n]))))

// TODO ugly
#place(top + left, dx: 24cm, dy: 2cm, include "/_components/unit_circle.typ")

#table(
    columns: (20%, auto),
    [Differentiation],
    [
        #columns(2)[
            #table(
                columns: (auto, auto),
                $a$, $0$,
                $x$, $1$,
                $f^a$, $a f^(a-1) f'$,
                $a^f$, $a^f dot.op ln(a) dot.op f'$,
                $f plus.minus g$, $f' plus.minus g'$,
                $f dot.op g$, $f' dot.op g + f dot.op g'$,
                $f / g$, $frac(f' dot.op g - f dot.op g', g^2)$,
                $f(g)$, $f'(g) dot.op g'$,
            )
            #colbreak()
            #table(
                columns: (auto, auto),
                $e^f$, $e^f dot.op f'$,
                $ln(f)$, $f' / f$,
                $log_a(f)$, $frac(f', f dot.op ln(a))$,
                $sin(f)$, $cos(f) dot.op f'$,
                $cos(f)$, $-sin(f) dot.op f'$,
                $tan(f)$, $ &(1 + tan^2(f)) dot.op f' \ &= frac(f', cos^2(f)) $,
            )
        ]
        Given $f(x, y) = 3x^2+2y$, $frac(partial f, partial x) = 6x$ while $frac(d f, d x) = 6x + 2 frac(d y, d x)$ because total derivative does not assume independence of vars.
    ],
    [Integration],
    [
        $integral_a^b u(x) v'(x) dif x = [u(x) v(x)]_a^b - integral_a^b u'(x) v(x) dif x$

        $integral_a^b f(g(x)) dot.op g'(x) dif x = integral_g(a)^g(b) f(u) dif u$
    ],
    [Matrix addition],
    table(
        columns: (auto, auto),
        $(A + B) + C = A + (B + C)$,
        [Associativity of addition],
        $A + B = B + A$,
        [Commutativity of addition],
    ),
    [Matrix multiplication],
    [
        columns = domain, rows = codomain of transformation
        #block($
            (a_(i j)) = A in RR^(r times n),
            (b_(i j)) = B in RR^(n times c),
            (c_(i j)) = C in RR^(r times c)
        $)
        #stack(dir: ltr,
            diagram(spacing: (4mm, 4mm), {
                let (c, n, r) = ((0, 0), (1, 0), (2, 0))
                node(c, $RR^c$)
                node(n, $RR^n$)
                node(r, $RR^r$)
                edge(c, n, "->", $B$)
                edge(n, r, "->", $A$)
                edge(c, r, "->", $C = A B$, bend: -15deg, shift: -5pt)
            }),
            h(0.6cm),
            stack(dir: ttb,
                $ C = A B <=> c_(i j) = sum^n_(k=1) a_(i k) b_(k j) = sum_k a_(i k) b_(k j) $,
                table(
                    columns: (auto, auto),
                    $(A B) C = A (B C)$,
                    [Associativity],
                    $A (B + C) = A B + A C$,
                    [Distributivity]
                )
            )

        )
    ],
    [Matrix transposition],
    stack(dir: ltr,
        block($
            dot^T : cases(
            RR^(n times m) -> RR^(m times n),
            a_(i j) |-> a_(j i)
            )
        $),
        block([$
            (A^T)^T &= A &quad    (lambda A)^T &= lambda A^T \
            (A + B)^T &= A^T + B^T &quad (A B)^T &= B^T A^T \
        $ $M M^T = bold(1) <=> M in RR^(n times n) "is orthogonal"$])
    ),
    [Determinant],
    block($
        det mat(a, b; c, d;) = a d - b c quad
        det mat(a, b, c; d, e, f; g, h, i;) = #block($a e i + b f g + c d h \ - c e g - b d i - a f h$)
    $),
    [Matrix Inverse],
    [
        defined if $det A eq.not 0$ and $A$ is square. \
        if $A in RR^(2 times 2)$: $A^(-1) = frac(1, det A) mat(d, -b; -c, a;)$ \
        else: use Gauss-Jordan to go from $mat(augment: #1, A, I;)$ to $mat(augment: #1, I, A^(-1);)$.
    ],
    [Image],
    block($ im A = { A x | x in RR^n } quad A in RR^(m times n)$),
    [Kernel],
    block($ ker A = { x | x in RR^n, A x = bold(0) } quad A in RR^(m times n)$),
    [Dimension],
    block([
        $ dim A = n quad A in RR^(m times n) $
        $ underbrace(dim im A, "rank (= number of " \ " independent columns)") + underbrace(dim ker A, "nullity") = n $
    ]),
    [Kroenecker $delta$],
    block($ delta_(i j) = cases(
        0 quad "if" i != j,
        1 quad "if" i = j
    ) $),
    [Indicator Function],
    block($ 1_A (x) = cases(
        1 quad "if" x in A,
        0 quad "if" x in.not A
    ) $),
    [Graph],
    block($
        "graph" : cases(
        (RR^n -> RR^m) -> (RR^n -> RR^(n + m)),
        f |-> (x |-> vec(x, f(x)))
        )
    $),
    [Taylor Series],
    stack(dir: ltr,
        block($ sum_(n=0)^infinity frac(f^(n"th")(a), n!) (x - a)^n $),
        h(1cm),
        block[where $f^(n"th")(a)$ is the \ $n$th derivative of $f$]
    ),
    [Linearization],
    $f(bold(x)) approx f(bold(x)_0) + f'(bold(x)_0) dot.op (bold(x) - bold(x)_0)$,
    [Gradient],
    [
        #block($gradient f(x_1, x_2, ...) = (partial / (partial x_1) f, partial / (partial x_2) f, ...)$)
        #block($
            gradient |bold(v)| = frac(bold(v)^T, |bold(v)|) quad gradient (f + g) = gradient f + gradient g quad gradient (f - g) = gradient f - gradient g \
            gradient (f dot g) = g dot gradient f + f dot gradient g quad gradient f/g = frac(g dot gradient f - f dot gradient g, g^2)
        $)
    ],
    [Gradient Descent],
    table(
        columns: (auto, auto),
        $x_(i+1) = x_i - gamma gradient f(x_i)$, $"("gamma": step size)"$,
        $|x_(i+1) - x_i| < epsilon$, [Stop condition],
    ),
    [Newton's Method],
    table(
        columns: (auto, auto),
        $x_0$, [initial guess],
        $x_(i+1) = x_i - frac(f(x_i), f'(x_i))$, [step],
    ),
    [Jacobian Matrix],
    stack(dir: ltr,
        $
            f : RR^n -> RR^m quad x_0 in RR^n \
            J_f (x_0) : RR^(m times n) \
            J_f (bold(x_0))_(i j) = frac(partial, partial x_j) f_i (x_0) \
            #[Rows: $i$, Columns: $j$]
        $,
        h(2em),
        diagram(spacing: (5mm, 5mm), {
            let (ern, erm, erk, mrn, mrm, mrk) = ((0,0), (0,1), (0,2), (4,0), (4,1), (4,2))
            node(ern, $(RR^n, bold(x)_0)$)
            node(erm, $(RR^m, g(bold(x)_0))$)
            node(erk, $(RR^k, f(g(bold(x)_0)))$)
            node(mrn, $RR^n$)
            node(mrm, $RR^m$)
            node(mrk, $RR^k$)
            edge(ern, erm, "->", $g$, label-side: right)
            edge(erm, erk, "->", $f$, label-side: right)
            edge(ern, erk, "->", $f compose g$, bend: +40deg, shift: 10pt, label-angle: left)
            edge(mrn, mrm, "->", $J_g (bold(x)_0)$, label-side: left)
            edge(mrm, mrk, "->", $J_f (g(bold(x)_0))$, label-side: left)
            edge(mrn, mrk, "->", $J_f (g(bold(x)_0)) J_g (bold(x)_0)$, bend: -40deg, shift: -5pt, label-angle: left)
            edge((1, 1), (1.5, 1), "=>")
        })
    ),
    [Hessian Matrix],
    block($
        f : RR^n -> RR quad bold(x) in RR^n quad H(bold(x)) : RR^(n times n) \
        H(bold(x))_(i j) = partial / (partial bold(x)_i) partial / (partial bold(x)_j) f(bold(x)) = partial / (partial bold(x)_j) partial / (partial bold(x)_i) f(bold(x))
    $),
    [Quadratic Form],
    block($
        M in RR^(n times n) quad q_M (bold(v)) = bold(v)^T M bold(v) = sum_(i j) a_(i j) x_i x_j \
        H = 1/2 (M + M^T) "upholds" forall bold(v) in RR^n .  q_M (bold(v)) = q_H (bold(v)) \
        H "is symmetric"
    $),
    [Affine Transformation],
    [
        #block($
            M in RR^(m times n) quad A_(b, M) : cases(
                RR^m -> RR^n,
                x |-> b + M dot.op x
            ) quad
            J_A (x) = M
        $)
        Without $b$ this is a _Linear Transformation_.
    ],
    [Sigmoid],
    [$sigma(x) = frac(1, 1+e^(-x))$, parametize by $p_(a, b) = sigma(a x - b)$, giving threshold $b/a$],
    [Softmax],
    stack(dir: ltr,
        $ bold(sigma)(x) = cases(
            RR^n &-> [0; 1]^n,
            x_i &|-> frac(1, sum^n_(j=1) e^(x_j)) e^(x_i)
        ) $,
        h(2em),
        [if all other $x_i$ are much smaller \ than $x_k$ then $bold(sigma)_i (x) approx delta_(i k)$]),
    [CDF from PDF],
    block($
        F_X (alpha) = integral_(-infinity)^alpha f_X (t) dif t quad F_X, f_X : RR -> [0, 1] quad
        F_X (alpha) = P(X(omega) <= alpha)

    $),
    [Relating Random Variables],
    [
        #stack(dir: ltr,
            diagram(
                spacing: 1em,
                node((0, 0), $Omega$),
                node((1, 0), $RR$),
                node((2, 0), $[0; 1]$),
                node((1, 1), $RR$),

                edge((0, 0), (1, 0), $X$, "->"),
                edge((0, 0), (1, 1), $Y$, "->", label-side: right),
                edge((1, 0), (2, 0), $F_X$, "->"),
                edge((1, 1), (1, 0), $g$, "->", label-side: right),
                edge((1, 1), (2, 0), $F_Y$, "->", label-side: right),
            ),
            h(1em),
            text(8pt)[$
                & g(Y(omega)) = X(omega) \
                =>& F_X (g(y)) = P(X(omega) <= g(y))) = P(g(Y(omega)) <= g(y))) \
                =>& cases(
                F_X (g(y)) = P(Y(omega) <= y) = F_Y (y) quad &g "strictly increasing",
                F_X (g(y)) = P(Y(omega) >= y) = 1 - F_Y (y) quad &g "strictly decreasing"
                )
            $],
        )
        $F_X (g(y)) = F_Y (y) => f_X (g(y)) dot.op g'(y) = f_Y (y)$ (by differentiation)
    ],
    [Likelihood],
    block($
        ell(bold(x)_0\; p) = f_X (x_1\; p) dot.op f_X (x_2 \; p) dot.op ...

    $),
    [Log Likelihood], [Used because easier to maximize. E.g. $ln ell (a, b) = ln ( (product_(bold(x) in S_"Yes") p_(a, b)(f(bold(x))))) (product_(bold(x) in S_"No") 1 - p_(a, b)(f(bold(x)))) = sum_(bold(x) in S_"Yes") ln(p_(a, b)(f(bold(x)))) + sum_(bold(x) in S_"No") ln(1 - p_(a, b)(f(bold(x))))$],
    [Univariate Uniform Distribution],
    block($
        x ~ "unif"(a, b) quad
        f(x) = cases(
            1/(b-a) quad &x in [a, b],
            0 &x < a or x > b,
        )
    $),
    [Multivariate Normal Distribution],
    block($
        bold(V) : Omega -> RR^n quad mu in RR^n quad bold(Sigma) in RR^(n times n) quad bold(V) ~ 𝓝(mu, Sigma) \
        f_bold(V)(bold(v)) = frac(1, sqrt((2 pi)^n det bold(Sigma))) e^(-1/2 (bold(v)-mu)^T bold(Sigma)^(-1)(bold(v)-mu)) \
        mu approx overline(bold(x)) = 1/N sum_(i=1)^N bold(x)_i quad
        Sigma approx frac(1, N-1) sum_(i=1)^N (bold(v)_i - overline(bold(v))) (bold(v)_i - overline(bold(v)))^T
    $),
    [Statistical Independence],
    [$X : Omega -> RR "and" Y : Omega -> RR$ are statistically independent if there is no correlation between them, that is $bold(V) : cases(Omega -> RR^2, omega |-> vec(X(omega), Y(omega)))$ satisfies \ $f_bold(V)(x, y) = f_X (x) dot.op f_Y (y)$ ],
    table.hline(stroke: 0.5pt),
    [Gauss-Jordan Algorithm],
    [
        Goal:
        - The first non-zero number is 1 (pivot)
        - Each pivot is strictly to the right of the one above it.
        - Any column containing a pivot has zeros everywhere else.
        - Rows of all zeros are at the bottom.

        Moves:
        - Swap rows
        - Multiply row by non-zero constant
        - Add or subtract a multiple of one row to another

        + From top to bottom, make pivot, make all numbers below pivot 0 by adding/subtracting current row.
        + From bottom to top, make all numbers above pivot 0.
        + Read result: if identity matrix, solution is unique. If some row looks like $0 0 0 | c$, no solution. If some row looks like $0 0 0 | 0$, the corresponding variable is 'free'.
    ],
    [Stationary Points],
    [
        + Solve for $bold(x)_0$ in $gradient f (bold(x)_0) = bold(0)$
    ],
    [Completing Squares],
    [
        Goal: convert $a x^2 + b x + c$ into $a(x+frac(b,2a))^2 + k$.
        #table(
            inset: 0pt,
            columns: (auto, auto, auto),
            row-gutter: 4pt,
            enum.item(1)[], [factor out $a$], $a(x^2 + b/a x) + c$,
            enum.item(2)[], [Add and subtract $h = (frac(b, 2a))^2$ #h(1em)], $a(x^2 + b/a x + h - h) + c$,
            enum.item(3)[], [Move $- h$ outside parens], $a(x^2 + b/a x + h) - a h + c$,
            enum.item(4)[], [Factor], $a(x + frac(b, 2a))^2 - a h + c$
        )
    ],
    [Finding extrema],
    [
        + Find stationary points. Those are the candidates.
        + Calculate the Hessian matrix at those points.
        + Calculate the polynomial quadratic form of the Hessian matrix.
        + Use completing squares one variable at a time.
        + Substitue to get a polynomial of the form $c_1a^2 + c_2b^2 + ...$. The sign of the constants defines the definiteness.
        $
        & forall v in RR^n without \{0\} . q_H(v) > 0 quad &&->&& "local minimum (positive definite)" \
        & forall v in RR^n without \{0\} . q_H(v) < 0 &&->&& "local maximum (negative definite)" \
        & "both, depending on" v &&->&& "saddle point (indefinite)" \
        & forall v in RR^n without \{0\} . q_H(v) >= 0 &&->&& "unknown (positive semi-definite, rare)" \
        & forall v in RR^n without \{0\} . q_H(v) <= 0 &&->&& "unknown (negative semi-definite, rare)"
        $
    ],
    [Maximum Likelihood Principle],
    [
        + Calculate the likelihood function $ell(bold(x)_0, p)$ for some samples $bold(x)_0$ and some parameter $p$.
        + Calculate the maximum of $ln(ell(bold(x)_0, p))$ / minimum of $-ln(ell(bold(x)_0, p))$ via stationary points.
    ],
)
