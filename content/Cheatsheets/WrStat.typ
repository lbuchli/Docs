#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": plot, chart
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(columns: 2, flipped: true)
#set text(font: "Noto Sans")
#set math.equation(block: true)

#let plot-style = cetz.draw.set-style(
    axes: (
        stroke: none,
        x: (mark: none, padding: 1),
        y: (mark: none),
        tick: (stroke: gray + .5pt),
    ),
    legend: (
        stroke: none,
    ),
)

#let plot-defaults = (
    size: (2, 1.2),
    x-tick-step: none,
    y-tick-step: 0.5,
    x-label: none,
    y-label: none,
)

= Ableitung

#table(
    stroke: none, inset: 5pt,
    columns: (auto, auto),
    $a$, $0$,
    $x$, $1$,
    $f^a$, $a f^(a-1) f'$,
    $f plus.minus g$, $f' plus.minus g'$,
    $f times g$, $(f' times g) + (f times g')$,
    $f / g$, $frac((f' times g) - (f times g'), g^2)$,
    $e^f$, $e^f times f'$,
    $ln(f)$, $f'/f$,
    $log_(a)(f)$, $f'/(f ln(a))$,
    $sin(f)$, $cos(f) times f'$,
    $cos(f)$, $-sin(f) times f'$,
    $f(g)$, $f'(g) times f(g')$,
)

= Integration

#table(
    stroke: none, inset: 5pt,
    columns: (auto, auto, auto),
    [Konstant], $integral f(a) dif x = x times f(a)$, [],
    [Partiell], $integral f g' = f g integral f' g$, []
)

Partiell brauchen, falls $f$ einfach abzuleiten und $g$ einfach zu integrieren

= Kombinatorik

== Produkt
_Bedingung_: Für jede der $n$ Möglichkeiten gibt es eine unabhängige/gleiche Anzahl $N$ Möglichkeiten für den Rest.

_Dann gilt_: Anzahl Möglichkeiten ist $n times N$.

===  Permutation
Folgt aus Produktregel.

_Bedingung_: $n$ verschiedene Elemente sind beliebig anordbar.

_Dann gilt_: Anzahl Möglichkeiten ist $n!$

== Kombination
_Bedingung_: Aus $n$ Elementen werden $k$ verschiedene Elemente ausgewählt.

_Dann gilt_: Anzahl Möglichkeiten ist $binom(n, k) = frac(n!, k! (n-k)!)$

= Wahrscheinlichkeit

$
    P(A backslash B) &= P(A) - P(A inter B) \
    P(A union B) &= P(A) + P(B) - P(A inter B) \
    P(A inter B) &= P(A|B) times P(B) = P(B|A) times P(A) \
    P(A|B) &= frac(P(B|A) times P(A), P(B)) \
$

== Totale Wahrscheinlichkeit

$ P(A) = sum^n_(i=0) P(A|B_i) times P(B_i) $


== Google-Matrix

Verlinkungsmatrix $H$, Spalten addieren zu $1$. Freier-Wille-Faktor $alpha$, $N$ Seiten. Matrix aus alles $1$: $A$. Startvektor $p_0$.

$G = alpha H + frac(1-alpha, N) A$

Fixpunkt $p = lim_(n->infinity) G^n p_0$ finden.


== Zufallsvariabeln

Zufallsvariabeln haben den Typ $Omega -> W$. Informell werten sie Ereignisse.
Diskrete Zufallsvariabeln nehmen nur diskrete Werte von $W$ an. Oft ist $W =
RR$.

== Unabhängigkeit
_Intuitiv_: Zwei Zufallsvariabeln $X$ und $Y$ sind unabhängig, wenn Wissen über den Wert von $X$ nichts über die Wahrscheinlichkeitsverteilung von $Y$ aussagt und umgekehrt.

$
    P((X <= x) and (Y <= y)) = P(X <= x) P(Y <= y) quad quad forall x, y in R
$

== Erwartungswert

$
    E(X + Y) &= E(X) + E(Y) \
    E(lambda X) &= lambda E(X) \
$

Für unabhängige Zufallsvariablen $X$ und $Y$ gilt zusätzlich:

$
    E(X Y) &= E(X) times E(Y) \
$

Bei einer diskreten Wahrscheinlichkeitsverteilung ist $ E(X) = sum^infinity_(i=0) X(omega_i) times P({omega_i}) $


Aus einer kontinuierlichen Dichtefunktion $phi$ kann der Erwartungswert berechnet werden: $ E(X) = integral phi(x) x dif x  $

== Varianz

Für unabhängige Zufallsvariablen $X$ und $Y$ gilt:

$
    "var(X)" &= E(X^2) - E(X)^2 \
    "var"(lambda X) &= lambda^2 "var"(X) \
    "var"(X + Y) &= "var"(X) + "var"(Y) \
    "var"(X Y) &= "var"(X) "var"(Y) + "var"(Y) E(X)^2 + "var"(X) E(Y)^2 \
    "cov"(X, Y) &= E(X Y) - E(X) E(Y) \
    "var"(M_n) &= "var"(X) / n
$

Aus einer kontinuierlichen Dichtefunktion kann die Varianz abgeleitet werden:

$
    "var"(X) = E(X^2) - E(X)^2 = (integral x^2 phi(x) dif x) - (integral phi(x) x dif x)
$


== Median

Gegeben eine Wahrscheinlichkeitsverteilung $F$:
$ F("med"(X)) = 1/2 $

== Tschebyscheff-Ungleichung

$ P(|X - mu| > epsilon) <= frac("var"(X), epsilon^2) $

Genauere Resultate, wenn man Anhand einer bekannten Wahrscheinlichkeitsverteilung rechnet.

== Satz von Bernoulli/Gesetz der grossen Zahlen

Der Mittelwert $M_n$ aus $n$ Werten nähert sich für grössere $n$ immer mehr dem Erwartungswert $mu$ an

$
    P(|M_n - mu| > epsilon) <= frac(sigma^2, epsilon^2 n)
$

sodass mit $n = infinity$ der Mittelwert dem Erwartungswert entspricht:

$
    lim_(n->infinity) P(|M_n - mu| > epsilon) = 0
$

Auch hier sind genauere Schranken möglich, wenn man die Wahrscheinlichkeitsverteilung kennt.

== Experimente

=== Laplace

Experimente mit gleichverteilter Wahrscheinlichkeit

$|Omega| = n$,
$ P({omega}) = 1/n quad quad forall omega in Omega $

=== Bernoulli

$|Omega| = 2$

= Wahrscheinlichkeitsverteilungen

(Siehe Übersicht am Ende)

== Faltung
(von Wahrscheinlichkeitsdichten)

$ phi_1 * phi_2(z) = integral_(-infinity)^infinity phi_1(x_1) phi_2(z - x_1) dif x_1  $


Es gilt:

$
    phi_1 * phi_2 &= phi_2 * phi_1 quad & "(Kommutativität)" \
    phi_1 * (phi_2 * phi_3) &= (phi_1 * phi_2) * phi_3 & "(Assoziativität)" \
    phi_1 * (phi_2 + phi_3) &= (phi_1 * phi_2) + (phi_1 * phi_3) & "(Distributivität)"

$

== Zentraler Grenzwertsatz

Wenn beliebige Wahrscheinlichkeitsdichten oft gefaltet werden, nähern sie sich
einer Normalverteilungsdichte an.


== Skaleninvarianz

$ phi(b x) = g(b) times phi(x) $ für eine passende Renormierungsfunktion $g$.

= Schätzen

=== Konsistenz

Wenn die grösse $n$ der Stichprobe gegen $infinity$ geht, nähert sich der Schätzer dem wahren Wert, also $ lim_(n->infinity) theta(X_1, ..., X_n) = theta $

=== Erwartungstreue

Ein Schätzer $theta(X_1, ..., X_n)$ ist erwartungstreu, wenn der Erwartungswert dem wahren Wert entspricht: $ lim_(n->infinity) E(theta(X_1, ..., X_n)) = theta $


=== Freiheitsgrade

Anzahl unabhängiger Parameter. Normalerweise Anzahl Versuchsausgänge - 1

=== Maximum Likelyhood-Prinzip

Gute Schätzer lassen sich oft ableiten, indem für gegebene Daten die Wahrscheinlichkeit eines Werts eines Parameters maximiert wird.

_Gegeben:_ Unbekannter Parameter $theta$ einer Wahrscheinlichkeitsdichte $phi$, Daten $x_1, ..., x_n$.

_Ziel_: $L(x_1, ... x_n; theta) := phi(x_1, theta) times ... times phi(x_n, theta)$ maximieren.

=== Konfidenzintervalle

Ein Intervall, in dem sich der Erwartungswert einer Zufallsvariable mit Wahrscheinlichkeit $1 - alpha$ befindet. Bei wenig Daten ($n <= 30$) wird normalerweise ein grösseres $alpha$, z.Bsp. $0.05$ verwendet. Bei medizinischen Tests wird oft $alpha <= 0.01$ verwendet.

Berechnung basierend auf einer Stichprobe $X_1, X_2, ...$ mit Grösse $n$:

_Mit bekannter Varianz (in Normalverteilung)_

1. Berechne Mittelwert der Stichprobe $overline(X)$
2. Finde $x_-$, s.t. $F(x_-) = alpha/2$ und $x_+$, s.t. $F(x_+) = 1 - alpha/2$
3. Konfidenzintervall für $mu$: $[overline(X) + sigma/sqrt(n) x_-, overline(X) + sigma/sqrt(n) x_+]$

_Mit geschätzer Varianz (mit $t$-Verteilung)_

1. Berechne Mittelwert der Stichprobe $overline(X)$,
2. Berechne Varianz der Stichprobe $S^2 = overline(X^2) - overline(X)^2 $
3. Nachschauen $t_-$ & $t_+$ basierend auf Tabelle der $t$-Verteilung mit $n-1$ Freiheitsgraden
4. Konfidenzintevall für $mu$: $[overline(X) + t_- S/sqrt(n), overline(X) + t_+ S/sqrt(n)]$


= Tests

== $t$-Test
_Anwendung:_ Test, ob Parameter zweier Datensätze gleich sind ($H_0$)

Gegeben sind zwei Stichproben $X_1, ..., X_n$ und $Y_1, ..., Y_m$.

Basierend auf der t-Verteilung (Parameter: $alpha$, Freiheitsgrade $k = m + n - 2$). Wenn $k$ gross, ist, Verteilung für $infinity$ Freiheitsgrade verwenden. Wenn $k$ nicht in Tabelle, nächstgrösseren Wert verwenden.

1. $t$-Wert $t_k^alpha$ in Tabelle nachschauen (Achtung normalerweise symmetrisch drum Wert $1-alpha/2$)
2. Stichprobenmittelwerte $overline(X)$ und $overline(Y)$ und Stichprobenvarianzen $S^2_X$ und $S^2_Y$ berechnen.
3. $ T = frac(overline(X) - overline(Y), sqrt((n-1) S^2_X + (m-1) S^2_Y)) sqrt(frac(n m k, n + m)) $

== $F$-Test
_Anwendung:_ Test, ob Varianzen der Stichproben $S_X^2$ (Grösse $n$) und $S_Y^2$ (Grösse $m$) gleich sind.

1. Berechnung $accent(y, "^") = S_X^2 / S_Y^2$
2. Nachschauen $F^alpha_(n-1,m-1)$ (zur Sicherheit höherer Wert, falls exakter Wert nicht vorhanden)
3. Falls $accent(y, "^") > F^alpha_(n-1,m-1)$, sind Varianzen nicht gleich.

== $chi^2$-Test
_Anwendung:_ Diskrete Verteilungen, mind. 5 gemessene Werte pro Kategorie.

1. Bestimme $x$, die nötige Diskrepanz, um $H_0$ zu verwerfen anhand Tabelle ($d$ Freiheitsgrade):
   $ F_(chi^2_d)(x) = 1 - alpha $
2. Berechne Diskrepanz (einzelne Summanden in Tabelle)
   $ D = sum^d_(i=0) frac((n_i - n p_i)^2, n p_i ) $
3. Verwerfe Hypothese $H_0$, dass $i$ mit Wahrscheinlichkeit $p_i$ eintritt, falls $D > x$

== Kolmogoroff-Smirnov-Test
_Anwendung:_ Test, ob Stichprobe nach einer bestimmten Verteilungsfunktion $F$ verteilt ist.

1. Die Stichprobe wird auf Gleichverteilung im Intervall $[0, 1]$ reduziert. Dazu wird $F$ auf die Werte angewendet.
2. $K_"krit"$ nach Tabelle mit Parametern $n$, $alpha$ festlegen
3. Plot, bei jedem Wert $x$: $y "+=" 1/n$. $K_"krit"$ als Offset $f(x) := x plus.minus K_"krit"$ einzeichnen.
4. Falls $K_"krit"$ überschritten: $H_0$ verwerfen. Nötigenfalls an einzelnen Stellen $i$ genaue Werte ausrechnen: \
   $K_n^+ := sqrt(n) (i/n - F(x_i))$ (Überschreitung nach oben) \
   $K_n^- := sqrt(n) (F(x_i) - frac(i-1, n))$ (Überschreitung nach unten)

= Filter
_Grundidee_: Minimieren der Varianz beim Kombinieren mehrerer Zufallsvariabeln.

== Optimale Mittelung

Gegeben zwei Zufallsvariabeln $X$ und $Y$, lässt sich ein Mittelwert mit minimaler Varianz folgendermassen bestimmen:

$
    t = frac(sigma_2^2, sigma^2_1 + sigma^2_2) \
    X = t X_1 + (1 - t)X_2
$

Die Varianz ist dann bestimmt durch:

$
    1 / sigma^2 = 1 / sigma^2_1 + 1 / sigma^2_2
$

== Wiener-Filter

Gegeben eine Zufallsvariable $X$, ein Dämpfungsfaktor $a$ und ein Störsignal $N$:

#diagram(
    node-stroke: 1pt,
    node((-1,0)),
    edge("->", $X$),
    node((0,0), [$times$], name: <a>),
    edge("->", $a X$),
    node((1,0), [$+$], name: <N>),
    edge("->", $a X + N$),
    node((3,0), [$times$], name: <b>),
    edge("->", $b(a X + N)$),
    node((5,0)),
    edge((rel: (0, -1), to: <a>), <a>, "->", $a$),
    edge((rel: (0, -1), to: <N>), <N>, "->", $N$),
    edge((rel: (0, -1), to: <b>), <b>, "->", $b$),
)

_Ziel_: $b$ bestimmen, so dass $"var"(b(a X + N) - X)$ möglichst klein ist.

$ b = frac(a sigma_X^2, a^2 sigma_X^2 + sigma_N^2) $


== Kalman-Filter

1. $P_k = (I - K_k H_k) x_(k|k-1) + K_k z_k$
2. $P_(k+1|k) = phi_k P_k phi^t_k + Q_k$
3. $K_k = P_(k|k-1) H_k^t (H_k P_(k|k-1) H_k^t + R_k)^(-1)$
4. You are doomed.


#page(flipped: true, columns: 1, "a4", margin: 0.5cm)[

    #let boxeddistr(a, title, content, dx: 0pt, subtitle: []) = box(rect(stroke: none)[
        #set text(9pt)
        #align(center, pad(6pt)[
            === #title
            #subtitle
        ])
        #set par(spacing: 0pt)
        #set table(stroke: none, inset: 5pt)
        #align(center, content)
    ])

#boxeddistr(180deg, "Gleichverteilung")[
#table(
    columns: (auto, auto),
    cetz.canvas({
        plot-style
        plot.plot(
            ..plot-defaults,
            legend: none,
            {
                plot.add(domain: (-2, 2), x =>
                    if x < -1 { 0 }
                    else if x < 0.6 { (x+1)/1.6 }
                    else { 1 }
                )
                plot.add-vline(-1, label: "a")
                plot.add-vline(0.6, label: "b")
                plot.add-vline((-1+0.6)/2, label: "E(X)")
            }
        )
    }),
    cetz.canvas({
        plot-style
        plot.plot(
            ..plot-defaults,
            fill-below: true,
            {
                plot.add(domain: (-2, 2), x =>
                    if x < -1 { 0 }
                    else if x < 0.6 { 1/1.6 }
                    else { 0 }
                )
                plot.add-vline(-1, label: "a")
                plot.add-vline(0.6, label: "b")
                plot.add-vline((-1+0.6)/2, label: "E(X)")
            }
        )
    }),
    $
    F(x) := cases(
      0 & x < a,
      frac(x - a, b - a) quad & x in [a, b],
      1 & x > b
    )
    $,
    $
    phi(x) := cases(
      0 & x < a,
      frac(1, b - a) quad & x in [a, b],
      0 & x > b
    )
    $,
)
#table(
    columns: (auto, auto, auto),
    $
        E(X) = frac(a+b, 2)
    $,
    $
        "var"(X) = frac((b-a)^2, 12)
    $,
    $
        "Median" = frac(a + b, 2)
    $
)
]
#boxeddistr(225deg, "Exponentialverteilung", subtitle: [Gedächtnislos, Zerfall])[
#table(
    columns: (auto, auto),
    cetz.canvas({
        plot-style
        plot.plot(
            ..plot-defaults,
            legend: none,
            {
                plot.add(domain: (-2, 5), x =>
                    if x < 0 { 0 }
                    else {
                        let a = 0.4
                        1-calc.exp(-a*x)
                    }
                )
                plot.add-vline(1/0.4, label: "E(X)")
            }
        )
    }),
    cetz.canvas({
        plot-style
        plot.plot(
            ..plot-defaults,
            y-tick-step: 0.2,
            fill-below: true,
            {
                plot.add(domain: (-2, 5), x =>
                    if x < 0 { 0 }
                    else {
                        let a = 0.4
                        a*calc.exp(-a*x)
                    }
                )
                plot.add-vline(1/0.4, label: "E(X)")
            }
        )
    }),
    $
    F(x) := cases(
      0 & x < 0,
      1-e^(-a x) quad & x in x >= 0,
      )
    $,
    $
    phi(x) := cases(
      0 & x < 0,
      a  e^(-a x) quad & x >= 0,
      )
    $,
)

#table(
    columns: (auto, auto, auto),
    $
        E(X) = frac(1, a)
    $,
    $
        "var"(X) = 1/a^2
    $,
    $
        "Median" = t_(1/2) = "ln"(2) / a
    $
)
]
#boxeddistr(270deg, "(Standard-)Normalverteilung", subtitle: [Summe vieler Einflüsse])[
#table(
    columns: (auto, auto),
    cetz.canvas({
        plot-style
        plot.plot(
            ..plot-defaults,
            x-tick-step: 2,
            y-tick-step: 0.5,
            legend: none,
            {
                plot.add(((-3.0, 1-0.9987),(-2.9, 1-0.9981),(-2.8, 1-0.9974),(-2.7, 1-0.9965),(-2.6, 1-0.9953),(-2.5, 1-0.9938),(-2.4, 1-0.9918),(-2.3, 1-0.9893),(-2.2, 1-0.9861),(-2.1, 1-0.9821),(-2.0, 1-0.9772),(-1.9, 1-0.9713),(-1.8, 1-0.9641),(-1.7, 1-0.9554),(-1.6, 1-0.9452),(-1.5, 1-0.9332),(-1.4, 1-0.9192),(-1.3, 1-0.9032),(-1.2, 1-0.8849),(-1.1, 1-0.8643),(-1.0, 1-0.8413),(-0.9, 1-0.8159),(-0.8, 1-0.7881),(-0.7, 1-0.7580),(-0.6, 1-0.7257),(-0.5, 1-0.6915),(-0.4, 1-0.6554),(-0.3, 1-0.6179),(-0.2, 1-0.5793),(-0.1, 1-0.5398), /**/ (0.0, 0.5000), (0.1, 0.5398), (0.2, 0.5793),(0.3, 0.6179),(0.4, 0.6554),(0.5, 0.6915),(0.6, 0.7257),(0.7, 0.7580),(0.8, 0.7881),(0.9, 0.8159),(1.0, 0.8413),(1.1, 0.8643),(1.2, 0.8849),(1.3, 0.9032),(1.4, 0.9192),(1.5, 0.9332),(1.6, 0.9452),(1.7, 0.9554),(1.8, 0.9641),(1.9, 0.9713),(2.0, 0.9772),(2.1, 0.9821),(2.2, 0.9861),(2.3, 0.9893),(2.4, 0.9918),(2.5, 0.9938),(2.6, 0.9953),(2.7, 0.9965),(2.8, 0.9974),(2.9, 0.9981),(3.0, 0.9987)))
                plot.add-vline(0, label: $mu$)
            }
        )
    }),
    cetz.canvas({
        plot-style
        plot.plot(
            ..plot-defaults,
            x-tick-step: 2,
            y-tick-step: 0.1,
            fill-below: true,
            {
                plot.add(domain: (-3, 3), x =>
                1 / (calc.sqrt(2*calc.pi)) * calc.exp(- (x*x) / 2)
                )
                plot.add-vline(0, label: $mu$)
            }
        )
    }),
    $
        F(x) "nicht berechenbar"
    $,
    $
        phi(x) := frac(1, sqrt(2 pi) sigma) e^(-frac((x-mu)^2, 2 sigma^2))
    $,
)

#table(
    columns: (auto, auto, auto),
    $E(X) = mu$,
    $"var"(X) = sigma^2$,
    $"Median" = mu$
)

$mu plus.minus 1 sigma ~> 68%$, $mu plus.minus 2 sigma ~> 95%$, $mu plus.minus 3 sigma ~> 99.7%$
\
Für Standardverteilung: $mu = 0$, $sigma = 1$
]
#boxeddistr(315deg, "Potenzverteilung", subtitle: [Skalenunabhängig])[
#table(
    columns: (auto, auto),
    cetz.canvas({
        plot-style
        plot.plot(
            ..plot-defaults,
            x-tick-step: 1,
            y-tick-step: 0.5,
            legend: none,
            {
                plot.add(domain: (0, 4), x =>
                if x < 1 { 0 }
                else { 1.5 * (1 / -1.5) * calc.pow(x, -1.5) + (1.5 / 1.5) }
                )
                plot.add-vline(1, label: $x_min$)
                plot.add-vline(1.5/0.5, label: $E(x)$)
            }
        )
    }),
    cetz.canvas({
        plot-style
        plot.plot(
            ..plot-defaults,
            x-tick-step: 1,
            y-tick-step: 1,
            fill-below: true,
            {
                plot.add(domain: (0, 4), x =>
                if x < 1 { 0 }
                else { 1.5 * calc.pow(x, -2.5) }
                )
                plot.add-vline(1, label: $x_min$)
                plot.add-vline(1.5/0.5, label: $E(x)$)
            }
        )
    }),
    $
    F(x)_(|a>1) := cases(
    frac(alpha - 1, x_min^(1 - alpha)) frac(1, 1-alpha) x^(-alpha) quad & x > x_min,
        0 & x <= x_min
        )
    $,
    $
    phi(x)_(|a>1) := cases(
        frac(alpha - 1, x_min^(1 - alpha)) x^(-alpha) quad & x > x_min,
        0 & x <= x_min
        )
    $,
)

#table(
    columns: (auto, auto),
    $E(X)_(|a>2) = frac(alpha - 1, alpha - 2) x_min$,
    $"var"(X)_(|a>3) = (frac(alpha - 1, alpha - 3) - (frac(alpha - 1, alpha - 2))^2) x_min^2$,
    $"Median" = 1 - (frac(x_(1/2), x_min))^(1-alpha)$,
    $x_(1/2) = 2^frac(1, alpha - 1) x_min$
)
]
#boxeddistr(0deg, "Binomialverteilung", subtitle: [Genau 2 mögliche Versuchsausgänge])[
#table(
    columns: (auto),
    cetz.canvas({
        plot-style
        chart.columnchart(
            ..plot-defaults,
            y-tick-step: 0.1,
            legend: none,
            (..range(0, 6).map(k => (k, calc.binom(10, k)*calc.pow(0.25, k)*calc.pow(0.75, 10-k))))
        )
    }),
    $
    F(k) := sum_(i=0)^k binom(n, i) p^i (1-p)^(n-i)
    $,
)

#table(
    columns: (auto, auto),
    $E(X) = n p$,
    $"var"(X) = n p (1 - p)$,
    $sigma = sqrt("var"(X))$
)
Normalapproximation mit Korrektur: \
$P(X <= a) = Phi(frac(a + 1/2 - mu, sigma))$ \
$P(a <= X <= b) = Phi(frac(b + 1/2 - mu, sigma)) - Phi(frac(a - 1/2 - mu, sigma))$

]
#boxeddistr(45deg, "Hypergeometrische Verteilung", subtitle: [Stichprobe nach Eigenschaft])[
#table(
    columns: (auto),
    cetz.canvas({
        plot-style
        chart.columnchart(
            ..plot-defaults,
            y-tick-step: 0.1,
            legend: none,
            (..range(0, 6).map(k => (k, (calc.binom(7, k) * calc.binom(15-7, 6-k)) / calc.binom(15, 6))))
        )
    }),
    $
    h(k|N;M;n) := frac(binom(M, k) binom(N-M, n-k), binom(N, n))
    $,
    align(left)[$N$: Gesamte Grösse \
    $n$: Grösse der Stichprobe \
    $M$: Anteil mit Eigenschaft in Gesamtgrösse \
    $k$: Gesuchte Anzahl]
)

#table(
    columns: (auto, auto),
    $E(X) = n frac(M, N)$,
    $"var"(X) = n frac(M (N - M) (N - n), N^2 (N - 1))$,
)
]
#boxeddistr(135deg, "Poisson-Verteilung", subtitle: [Anzahl Ereignisse über fixe Zeit, bekannter Erwartungswert, *selten*])[
#table(
    columns: (auto, auto),
    cetz.canvas({
        plot-style
        let lambda = 2
        chart.columnchart(
            ..plot-defaults,
            y-tick-step: 0.5,
            legend: none,
            (..range(0, 6).map(k => (k, 1-(range(0, k+1).map(i => (calc.pow(lambda, i) / calc.fact(i)) * calc.exp(-lambda))).sum())))
        )
    }),
    cetz.canvas({
        plot-style
        let lambda = 2
        chart.columnchart(
            ..plot-defaults,
            y-tick-step: 0.1,
            legend: none,
            (..range(0, 6).map(k => (k, (calc.pow(lambda, k) / calc.fact(k)) * calc.exp(-lambda))))
        )
    }),
    $
        P(X > k) := 1 - sum_(i=0)^k frac(lambda^i, i!) e^(-lambda)
    $,
    $
        P_lambda (k) := frac(lambda^k, k!) e^(-lambda)
    $,
)

#table(
    columns: (auto, auto, auto),
    $lambda = n p$,
    $E(X) = lambda$,
    $"var"(X) = lambda$,
)
]
#boxeddistr(90deg, "Erlang-Verteilung", dx: -10em, subtitle: [Telefonzentrale, Queues])[
#table(
    columns: (auto, auto),
    cetz.canvas({
        plot-style
        let k = 7
        let a = 2
        chart.columnchart(
            ..plot-defaults,
            y-tick-step: 0.5,
            legend: none,
            (..range(1, 7).map(x => (x, 1-calc.exp(-a*x) * range(0, k - 1).map(i => calc.pow(a*x, i) / calc.fact(i)).sum())))
        )
    }),
    cetz.canvas({
        plot-style
        let k = 7
        let a = 2
        chart.columnchart(
            ..plot-defaults,
            y-tick-step: 0.2,
            legend: none,
            (..range(1, 7).map(x => (x, calc.pow(a, k) * (calc.pow(x, k - 1) / calc.fact(k - 1)) * calc.exp(-a * x))))
        )
    }),
    $
    F_(X_1+...+X_k)(x) := cases(
    1-e^(-a x) sum^(k-1)_(i=0) frac((a x)^i, i!) quad & x >= 0,
    0 & x < 0
    )
    $,
    $
    phi_(X_1+...+X_k)(x) := cases(
    a^k frac(x^(k-1), (k-1)!) e^(- a x) quad & x >= 0,
    0 & x < 0
    )
    $,
)
]

#place(center + horizon,
    dx: 3.5cm,
    dy: -4cm,
    cetz.canvas({
        import cetz.draw: *
        line((0,0), (2, 2), name: "line", mark: (end: ">"))
        set-style(content: (frame: "rect", stroke: none, fill: white, padding: .1))
        content((name: "line", anchor: 50%), [$n$ gross])
    })
)

#place(center + horizon,
    dx: -4.5cm,
    dy: 4cm,
    cetz.canvas({
        import cetz.draw: *
        line((0,0), (-1.5, -1.5), name: "line", mark: (end: ">"))
        set-style(content: (frame: "rect", stroke: none, fill: white, padding: .1))
        content((name: "line", anchor: 50%), [$p$ klein])
    })
)

]
