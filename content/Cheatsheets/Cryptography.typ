#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(flipped: true, columns: 3, margin: 0.6cm)
#set text(9pt)

#set table(stroke: none)

#set enum(tight: true, spacing: 4pt, numbering: n => box(height: 1em, circle(radius: 0.4em, align(center + horizon, text(8pt)[#n]))))

/ Kerckhoff's Principle: A cryptosystem should be secure if everything about it is known except its key.
/ Semantically secure: IND-CPA is not winnable. Ciphertext does not leak information about plaintext.
/ $(t, epsilon)$-secure: $P("Attacker computing at most t steps succeeds") < epsilon$
/ n-bit security: $(2^n, epsilon)$-secure for a small epsilon

= Randomness

/ Event Surprisal: $I(p) = - log_2(p) quad I(1) = 0$
/ Shannon Entropy: $H(X) = - sum_(x in Omega) p(x) log p(x)$
/ Pseudo-Random Number Generator (PRNG): output looks random if key is not known. Ops: `init()`, `refresh(r)`, `next(n)`
/ Pseudo-Random Function (PRF): given input, looks like random output if key is not known. Used for key derivation (*KDF*).
/ Pseudo-Random Permutation (PRP): given input, looks like a random permutation if key is not known. Bijective, since permutation. Example (indistinguishable): AES.
/ Prediction Resistance: cannot predict future output of PRNG
/ Backtracking Resistance: given output, cannot predict predecessing output of PRNG
/ Entropy Pool: collects events (e.g. mouse movements), should be asked for new entropy once in a while.

=== Examples

/ Fortuna: State: (Key, Counter). Uses AES to compute $(K', C')$ from $(K, C)$, giving one or more blocks of output. Reseeding: $K' = "SHA-256"(K||"seed"), C' = C+1$, where seed more often from lower pools (allowing higher pools to collect more entropy).

= Channels

/ Insecure Channel: no guarantees.
/ Authentic Channel: Attacker read and stop message.
/ Secure Channel: Attacker can stop message.

= Symmetric Encryption

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

=== Examples

/ AES: Operates on $4 times 4$ state matrix. SubBytes: substitute matrix elems using S-Box. ShiftRows: Shift row $i$ by $i$ to the left. MixColums: Matrix multiplication over $"GF"(2^8)$ (linear transform). AddRoundKey: Add key matrix for current round. 10-14 rounds depending on key length. Optimized in hardware and software.

== Stream Cipher

/ Linear Feedback Shift Register (LFSR): Given initial state, taps, generates cycle of states. Goal: long cycles/periods. Limit: $2^n-1$. If taps are known, $n$ consecutive bits determine state. Berlekamp-Massey Algorithm can be used to recover taps.
/ Filtered LFSR: LFSR where output is a non-linear function of the state bits, e.g. AND.
/ Nonlinear Feedback Shift Register (NFSR): Nonlinear feedback function. Problem: hard to compute period.

=== Examples

/ Grain-128a: Lightweight, combines LFSR for long period with NFSR for nonlinearity.
/ Salsa20: Counter-Based. Quarter-Round function consisting of Addition, Rotation, XOR (ARX). Done for 20 rounds.
/ ChaCha20: Modern version of Salsa20, more diffusion and larger nonce

= Hash Functions

/ Preimage Resistance: Given the output of a function, it is difficult to determine a possible input that results in that output.
/ Second Preimage Resistance: Given the input and output of a function, it is difficult to determine a possible second input that results in the same output.
/ Collision Resistance: It is hard to find two inputs of a function that result in the same output.

Collision probability: $P = frac(N!, (N-n)!) quad 2^(n/2) "evaluations on average"$

/ Merkle-Damgård Construction: Compression function $F$. Output should look random, e.g. using encryption. F is then applied from left to right, compacting whole input. Finding a collision in $F$ $<=>$ finding collision in hash. Vulnerable to length extension attacks.
/ Sponge Construction: Uses PRP $f$. Absorb by adding input to repeated PRP. Squeeze output by taking output, then PRP repeatedly.
/ Length Extension Attack: Given $h = H(M)$, build $h' = H(M||...||M')$ by starting with $h$ as IV.

= Message Authentication Codes

/ Unforgeability: The attacker can ask for the authentication code of any message. They should not be able to construct an authentication code for a not-yet-asked message.
/ Universal Hashing (UH): Family of hash functions where key selects actual hash function. Used to build a dedicated MAC (one not built from other primitives).
/ Authenticated Encryption with Associated Data (AEAD): Encrypt plaintext, authenticate plaintext + associated data.

== Examples

/ HMAC: $H((K' plus.o "opad") || H((K' plus.o "ipad") || m))$, $K' "derived from private key"$, opad: one block of 0x5c, ipad: one block of 0x36. No length extension attacks.
/ CMAC: Uses block cipher. Encrypt, $plus.o$ output with next input before encrypting. Last output is tag.
/ Poly1305: UH used as one-time MAC (new key for every authentication, would leak key otherwise)
/ Poly1305-AES: (Wegman-Carter MAC): $"MAC"(K_1,K_2, N, M) = "UH"(K_1, M) + "AES"(K_2, N)$ where $N$ is nonce and AES used as PRF.
/ AES-GCM: Block-based AEAD, AES for encryption, GHASH for authentication. Do not use short tags (> 128 bit) and use unique IVs. $H = "AES"(K, 0)$ should not be in small mult. subgroup of galois field. Used in TLS, SSH
/ ChaCha20-Poly1305: Stream-based AEAD, ChaCha20 for encryption, Poly1305 for authentication.

= Hard Problems

/ Discrete Logarithm Problem (DLP): Given group elements $x = g^k$ and $g$, find $k$. Only hard for specific subgroups, thus generator to be chosen wisely.
/ Elliptic Curve Discrete Logarithm Problem (ECDLP): Given points $P = k G$ and $G$, find $k$ ($G$ is group generator). Hard for specific curves only.

= Asymmetric Encryption

/ Asymmetric IND-CPA: Attacker knows pk. Selects $M$ and $M'$. Gets one back encrypted. Guesses which one.
/ RSA: Choose $p$, $q$ prime. Modulus is $n = p q$. Group $ZZ_n^*$ size $phi(n) = (p-1)(q-1)$. Choose $e$, $d$ in exponent group $ZZ_phi(n)^*$ s.t. $e d equiv^phi(n) 1$. Choose $x in ZZ_n^*$, define $y = x^e mod n$. Computing $x$ from $y$ is hard unless $d$ is known. Public: $n$, $e$. Secret: $p$, $q$, $d$. *RSA needs OAEP padding to be secure.*
/ ElGamal: Use any group $G$ (order $q$, prime, generator $g$) where DLP is hard. $"sk"$ random group element, $"pk" = g^"sk"$. Encrypt group elem $M$ by $(g^r, M dot.op "pk"^r)$ where $r$ is random group elem. DDH holds over $G$ $=>$ ElGamal IND-CPA (proof by assuming IND-CPA attacker, reducing to solve DDH). Homomorphic ($E(M, "pk") dot.op E(M', "pk") = E(M dot.op M', "pk")$).

= Key Exchange

/ Key Encapsulation Mechanism (KEM): One party generates key. It is then wrapped and sent.
/ Key Exchange Protocol (KEX): Both parties contribute to key, often same protocol (e.g. DH KEX)
/ Diffie-Hellman-KEX:
/ ECDH-KEX: ECG with generator $G$. Shared secret is $a b G$, with $a$ and $b$ randomly generated and then shared by $A = a G$ and $B = b G$. Shared secret is not fully random and should thus be hashed or key derived from it.

== Assumptions

/ Decisional Diffie-Hellman (DDH): for random $a, b in ZZ_q$, $a b G$ looks like a random element. Security Game: attacker has to distinguish $a b G$ from $c G$. Provides full semantic security.
/ Computational Diffie-Hellman (CDH): for random $a, b in ZZ_q$, computing $a b G$ from $a G$ and $b G$ is infeasable. Security Game: attacker guesses $a b G$. Learning part of the key is still possible.

Solving DLP implies solving DDH and CDH.

== Examples

/ RSA-KEM: Encrypt and decrypt generated symmetric key using RSA
/ Curve25519: Fast in software, used in TLS and Whatsapp

= Surprise Math

== Groups

$compose$ associative, $e$ identity element, $a^(-1) slash hat(a)$ inverse elements \
Abelian/commutative group: $compose$ commutative

$ZZ_m = {0,1,...,m}$ (under $+$, order 1$m$) \
$ZZ_m^* = { x in ZZ_m | x "co-prime" m }$ (under $dot$, order $phi(m)$)

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

== Fields

$FF = (S, +, -, *, div)$, where operations behave like defined on $RR$.

=== Finite fields

Two options:
$"GF"(p) = ZZ_p = FF_p$ ($p$ prime) or
$"GF"(p^k) = (p prime, k "integer")$

=== Field extensions

Extend field $FF$. E.g. $CC$ is extension of $RR$.

$FF[x]$ of all polynomials over $FF$ is a field. E.g. $x^4 + x + 1 in ZZ_2[x] = 10011_2$

$FF[x]\/m(x)$ of all polynomials over $FF$ modulo $"deg"(m)$. E.g. $ZZ_2[x]\/(x^3+1)$: $(x^3 + x + 1) dot.op (x^2 + 1) = x^5 + x^2 + x + 1 mod x^3 + 1 = x + 1$ ($x^3 equiv 1 (mod x^3 + 1)$). Is only a field for special $m$ called 'irreducible'.

== Elliptic Curves

Form a group (ECG) using $+$ (opposite of intersection point of line between input points and curve). $𝒪$ is the point at infinity and the neutral element.

/ Weierstrass Curve: ${ (x, y) | x, y in FF, y^2 = x^3 + a x + b }$ for some field $FF$ and some params $a, b in FF$.
