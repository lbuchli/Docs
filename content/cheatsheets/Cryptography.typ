#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(flipped: true, columns: 2, margin: 1cm)
#set text(10pt)

#set table(stroke: none)

#set enum(tight: true, spacing: 4pt, numbering: n => box(height: 1em, circle(radius: 0.4em, align(center + horizon, text(8pt)[#n]))))

/ Kerckhoff's Principle: A cryptosystem should be secure if everything about it is known except its key.
/ Semantically secure: IND-CPA is not winnable. Ciphertext does not leak information about plaintext.
/ $(t, epsilon)$-secure: $P("Attacker computing at most t steps succeeds") < epsilon$
/ n-bit security: $(2^n, epsilon)$-secure for a small epsilon
/ Pseudo-Random Permutation (PRP): looks like a random permutation if key is not known.
/ Pseudo-Random Number Generator (PRNG): output looks like a random number if key is not known.

= Channels

/ Insecure Channel: no guarantees.
/ Authentic Channel: Attacker read and stop message.
/ Secure Channel: Attacker can stop message.

= Encryption

/ Indistinguishability (IND): Given two plaintexts and two corresponding ciphertexts, the attacker should not be able to correlate.
/ Nonmalleability (NM): Attacker should not be able to modify the ciphertext in a way that correlates predictably with a modification of the corresponding plaintext.
/ Chosen-Plaintext Attack (CPA): Attacker can obtain ciphertexts for arbitrary plaintexts (encryption oracle).
/ Chosen-Ciphertext Attack (CCA): Attacker has access to an encryption and a decryption oracle (until challenge: CCA1, during challenge, but not on response: CCA2).

#diagram(spacing: (4mm, 4mm),{
    node((0,0), "IND-CCA2", name: <IND-CCA2>)
    node((1,0), "IND-CPA", name: <IND-CPA>)
    node((0,1), "NM-CCA2", name: <NM-CCA2>)
    node((1,1), "NM-CPA", name: <NM-CPA>)
    edge(<IND-CCA2>, <IND-CPA>, "=>")
    edge(<NM-CCA2>, <IND-CCA2>, "<=>")
    edge(<NM-CCA2>, <NM-CPA>, "=>")
    edge(<NM-CPA>, <IND-CPA>, "=>")
})

== Block Cipher

/ Confusion: Relation between input and output is complex (non-linear).
/ Diffusion: Changing one bit of input should change many (\~ half) output bits.
/ S-Box: Substitution box, non-linear.
/ F-Function: $plus.o$ key part, substitute, permutate.
/ SP-Network: $plus.o$ key part, substitute, permutate. Repeat for $n$ rounds.
/ Feistel Network: Operates on $L$ and $R$ part of input. Apply F-Function to $R$, $plus.o$ output with $L$. Switch $L$ and $R$. Repeat for $n$ rounds.

=== Modes

/ Electronic Codebook (ECB): Apply cipher block by block. Bad.
/ Cipher Block Chaining (CBC): $plus.o$ IV on plaintext, then $plus.o$ last blocks cipher output.
/ Output Feedback (OFB): Used by AES. Encrypts IV, $plus.o$ plaintext. Then encrypt last ciphertext (before plaintext $plus.o$) on next block.
/ Counter (CTR): Encrypt Nonce||$n$, where $n$ is the msg index. $plus.o$ plaintext onto cipher output (one-time-pad like).

== Stream Cipher

/ Linear Feedback Shift Register (LFSR): Given initial state, taps, generates cycle of states. Goal: long cycles/periods. Limit: $2^n-1$. If taps are known, $n$ consecutive bits determine state. Berlekamp-Massey Algorithm can be used to recover taps.
/ Filtered LFSR: LFSR where output is a non-linear function of the state bits, e.g. AND.
/ Nonlinear Feedback Shift Register (NFSR): Nonlinear feedback function. Problem: hard to compute period.


= Hash Functions

/ pre-image resistance: Given the output of a function, it is difficult to determine a possible input that results in that output.
/ second pre-image resistance: Given the input and output of a function, it is difficult to determine a possible second input that results in the same output.
/ collision resistance: It is hard to find two inputs of a function that result in the same output.

Collision probability: $P = frac(N!, (N-n)!) quad 2^(n/2) "evaluations on average"$

= Authentication

= Surprise Math

== Groups

$compose$ associative, $e$ identity element, $a^(-1) "/" hat(a)$ inverse elements \
Abelian/commutative group: $compose$ commutative

$ZZ_m = {0,1,...,m}$ (group under $+$) \
$ZZ_m^* = { x in ZZ_m | x "co-prime" m }$ (group under $dot$)

$"ord"(G) = |G| $ \
$"ord"(a in G) = k quad "s.t." a^k = e $

$"ord"(ZZ_m^*) = phi(m) quad phi : cases(
    p &|-> p-1 quad &p "prime",
    p^k &|-> p^(k-1) (p-1) quad &p "prime",
    a b &|-> phi(a) phi(b) quad &a\, b "coprime"

)$

$g in G$ is a generator iff $"ord"(g) = "ord"(G)$

== Rings

$(S, +, *)$, where:
- $(R, +)$ is an abelian group
- $(R, *)$ is a monoid (group, but no inverses required)
- Distributivity: $a * (b + c) = a * b + a * c$
