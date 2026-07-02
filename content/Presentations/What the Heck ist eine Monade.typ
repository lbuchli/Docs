#import "@preview/presentate:0.2.5": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(paper: "presentation-16-9")
#set text(size: 24pt, font: "Noto Sans Mono")

#set align(horizon)
#set raw(lang: "haskell")

#slide[
    = What the Heck ist eine Monade? \ \
    Lukas Buchli \
    03.07.2026
]

#slide[]

#slide[
    = Noch Fragen?
]

#slide[
    = (Endo-)Funktoren \ \
    #show: pause
    `List<T>` \
    #show: pause
    `Optional<T>` \
    #show: pause
    `State<S, T>`
    #show: pause
    #only(5)[$->$ #box(baseline: 2.3em)[```
    struct State<S, T> {
        run: S -> (S, T)
    }
    ```]]
    // get() -> State<S, S>
    // set(S) -> State<S, ()>
    \
    #show: pause
    $->$ Gemeinsamkeit? \
    #show: pause
    `map(F<T> , T -> U) -> F<U>`
]

// #slide[
//     #grid(columns: (1fr,)*2)[
//         = Monoid-Objekte \ \
//         Kombination $times.circle$ \
//         Operation $penta.stroked : M times.circle M -> M$ \
//         Ein spezielles $#emoji.cloud : M$ \ \
//         #show: pause
//         $A penta.stroked #emoji.cloud = A = #emoji.cloud penta.stroked A$ \
//         #show: pause
//         $A penta.stroked (B penta.stroked C) = (A penta.stroked B) penta.stroked C$
//     ][
//         #show: pause
//         #only(4,5)[
//             = Beispiel \#1 \ \
//             $times$ (tuple) \
//             $plus.double$ (concat) \
//             $\"\"$ (leerer Text) \ \
//             #show: pause
//             $\""hi"\" plus.double \"\" = \""hi"\" = \"\" plus.double \""hi"\"$ \
//             $\""i"\" plus.double (\""e"\" plus.double \""j"\") = (\""i"\" plus.double \""e"\") plus.double \""j"\"$ \
//         ]
//         #only(6,7,8)[
//             = Beispiel \#2 \ \
//             #show: pause
//             #show: pause
//             #show: pause
//             $times$ (tuple) \
//             $min(a, b)$ \
//             $infinity$ \ \
//             #show: pause
//             $min(12, infinity) = 12 = min(infinity, 12)$ \
//             #text(22pt)[$min(1, min(2, 3)) = min(min(1, 2), 3)$] \
//         ]
//         #only(9,10,11)[
//             = Beispiel \#3 \ \
//             #show: pause
//             #show: pause
//             #show: pause
//             #show: pause
//             #show: pause
//             #show: pause
//             $$ () \
//             $compose$ (compose) \
//             $id(x) = x$ \ \
//             #show: pause
//             $f(id(-)) = f(-) = id(f(-))$ \
//             $f(g(h(-))) = f(g(h(-)))$ \
//         ]
//         #only(12,13,14)[
//             = Beispiel \#4 \ \
//             #show: pause
//             #show: pause
//             #show: pause
//             #show: pause
//             #show: pause
//             #show: pause
//             #show: pause
//             #show: pause
//             #show: pause

//             $compose$ (compose) \
//             `join(List<List<T>>) -> List<T>` \
//             `one(T) -> List<T>` \ \
//             #show: pause
//             `join(one([1])) = [1] = join([[one(1))])` \
//             `join([join([[1, 2]])]) = join(join([[[1, 2]]]))` \
//         ]
//     ]
// ]

#slide[
        #grid(columns: (auto, auto), column-gutter: 1em)[
        = Monaden \ \
     ][
         #only(2)[= `List<T>`]
         #only(3)[= `Optional<T>`]
         #only(4)[= `State<S, T>`]
         \
     ][
        `join(F<F<T>>) -> F<T>` \
        `pure(T) -> F<T>`
     ][
         #only(2)[
            `flatten(List<List<T>>) -> List<T>` \
            `one(T) -> List<T>`
         ]
         #only(3)[
             #text(22pt)[`join(Optional<Optional<T>>) -> Optional<T>`] \
             `some(T) -> Optional<T>`
         ]
         #only(4)[
             #text(22pt)[`then(State<S, State<S, T>>) -> State<S, T>`] \
             `pure(T) -> State<S, T>`
         ]
     ]
]

#slide[
    ```
    fn then(outer: State<S, State<S, T>>) -> State<S, T> {
        return State {
            run = state => {
                let (new_state, inner) = outer.run(state)
                return inner.run(new_state)
            }
        }
    }
    ```
]

#slide[
    = Haskell \ \
    #stack(dir: ltr,
        ```
        main = do
          name <- getLine
          putStrLine ("Hi " ++ name)
        ```,
        [#h(1em)],
        text(22pt)[
        #show: pause
        ```
        let line1 = State<World, String> {
          run: w => (w, w.stdin.next_line)
        }
        let line2 = name => State<World, One> {
          run: w => (w.stdout.append(name), one)
        }
        then(map(line1, line2))
        ```],
    )
    #place(center + horizon, dx: -1cm, dy: -3cm, only(2, diagram(
        edge((0, 0), (2, 0), "-|>", stroke: 5pt + gray, mark-scale: 0.5, bend: 60deg)
    )))
]

#slide[]
