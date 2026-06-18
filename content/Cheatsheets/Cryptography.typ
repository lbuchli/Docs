#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(flipped: true, columns: 4, margin: 0.6cm)
#set text(8pt)

#set table(stroke: none)

#set enum(tight: true, spacing: 4pt, numbering: n => box(height: 1em, circle(radius: 0.4em, align(center + horizon, text(8pt)[#n]))))

= Security

/ Kerckhoff's Principle: A cryptosystem should be secure if everything about it is known except its key.
/ Semantically secure: IND-CPA is not winnable. Ciphertext does not leak information about plaintext.
/ $(t, epsilon)$-Secure: $P($Attacker computing at most t steps succeeds$) < epsilon$
/ n-Bit Security: $(2^n, epsilon)$-secure for a small epsilon
/ Attacker Advantage: $delta = |P("Attacker wins") - 1/2|$. Scheme is secure if advantage is 'negligible'.
/ Keylength: Choose by: 1. How long does the scheme need to be secure? 2. Do regulations apply?
\
/ Indistinguishability (IND): Given two plaintexts and one of the two corresponding ciphertexts, the attacker should not be able to tell which it is.
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

/ Proof by Contradiction: $A => B$ iff $not B => not A$. E.g. proof "PRG Game not winnable ($A$) $=>$ Encryption Game not winnable ($B$)" by showing "Encryption Game attack with advantage ($not B$) $=>$ PRG Attack with advantage ($not A$)"
/ Security Reduction Strategy: Provide functions of $B$ Game by playing $A$ Game.

== Channels

/ Insecure Channel: no guarantees.
/ Authentic Channel: Attacker can read and stop message.
/ Secure Channel: Attacker can stop message.

= Randomness

/ Event Surprisal: $I(p) = - log_2(p) quad I(1) = 0$
/ Shannon Entropy: $H(X) = - sum_(x in Omega) p(x) log p(x)$
/ Pseudo-Random Generator (PRG): output looks random if key is not known. Ops: `init()`, `refresh(r)`, `next(n)`
/ Pseudo-Random Function (PRF): given input, looks like random output if key is not known. Used for key derivation (*KDF*).
/ Pseudo-Random Permutation (PRP): given input, looks like a random permutation (message space, not bits) if key is not known. Bijective, since permutation. Example (indistinguishable): AES.
/ Prediction Resistance: cannot predict future output of PRNG
/ Backtracking Resistance: given output, cannot predict predecessing output of PRNG
/ Entropy Pool: collects events (e.g. mouse movements), should be asked for new entropy once in a while.

=== Examples

/ Fortuna: State: (Key, Counter). Uses AES (CTR mode) to compute $(K', C')$ from $(K, C)$, giving one or more blocks of output (then two blocks for $K'$). Reseeding: $K' = "SHA-256"(K||"seed"), C' = C+1$, where seed more often from lower pools (allowing higher pools to collect more entropy).

= Symmetric Encryption

Should look like a PRP if key is not known.

== Block Cipher

/ Confusion: Relation between input and output is complex (non-linear).
/ Diffusion: Changing one bit of input should change many (\~ half) output bits.
/ S-Box: Substitution box, non-linear.
/ F-Function: $plus.o$ key part, substitute, permutate.
/ SP-Network: $plus.o$ key part, substitute, permutate. Repeat for $n$ rounds. S-Box needs to be reversible in order to decrypt.
/ Feistel Network: Operates on $L$ and $R$ part of input. Apply F-Function to $R$, $plus.o$ output with $L$. Switch $L$ and $R$. Repeat for $n$ rounds. Decryption by switching inputs and applying key in reverse.
/ PKCS\#7 Padding: Needed in ECB and CBC. Padding by repeated byte containing padding length. If message is exactly block size, a whole block of padding needs to be added.

=== Modes

/ Electronic Codebook (ECB): Apply cipher block by block. Bad.
/ Cipher Block Chaining (CBC): Encryption: $plus.o$ IV before encrypt on first block, $plus.o$ last blocks cipher output before encrypt on next blocks. Decryption: Decrypt, then $plus.o$ IV on first block. On next blocks, decrypt, then $plus.o$ last block ciphertext.
/ Output Feedback (OFB): Encrypts IV, $plus.o$ plaintext. Then encrypt last ciphertext (before plaintext $plus.o$) on next block.
/ Counter (CTR): Encrypt Nonce||$n$, where $n$ is the msg index. $plus.o$ plaintext onto cipher output (one-time-pad like).

=== Examples

/ AES: Operates on $4 times 4$ byte state matrix. SubBytes: substitute matrix elems using S-Box. ShiftRows: Shift row $i$ by $i$ to the left. MixColums: Matrix multiplication over $"GF"(2^8)$ (linear transform). AddRoundKey: Add key matrix for current round. 10-14 rounds depending on key length. Optimized in hardware and software.

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

Probability of at least one collision: $P = 1 - frac(N!, N^n dot.op (N-n)!) approx 1 - e^(-frac(n^2, 2N))$, where: $N$ is the number of possible hash values, $n$ is the number of tried hash values, $frac(N!, (N-n)!)$ is the number of ways in which $n$ hashes can be distinct and $N^n$ is the number of ways that $n$ hashes can be chosen from $N$ possible hashes.

Average evaluations to find a collision of a collision resistant hash function: $2^(b/2)$ where $b$ is the bit length of the hash.

/ Merkle-Damgård Construction: Compression function $F$. Output should look random, e.g. using encryption. F is then applied from left to right, compacting whole input. Finding a collision in $F$ $<=>$ finding collision in hash. Vulnerable to length extension attacks.
/ Sponge Construction: Uses PRP $f$. Absorb by adding input to repeated PRP. Squeeze output by taking output, then PRP repeatedly.
/ Length Extension Attack: Given $h = H(M)$, build $h' = H(M||...||M')$ by starting with $h$ as IV.

= Message Authentication Codes

/ Unforgeability: The attacker can ask for the authentication code of any message. They should not be able to construct an authentication code for a not-yet-asked message.
/ Universal Hashing (UH): Family of hash functions where key selects actual hash function. Used to build a dedicated MAC (one not built from other primitives).
/ Authenticated Encryption with Associated Data (AEAD): Encrypt plaintext, authenticate plaintext + associated data.

MACs do not prevent replay attacks! Need counters in messages for that.

== Examples

/ HMAC: $H((K' plus.o "opad") || H((K' plus.o "ipad") || m))$, $K' "derived from private key"$, opad: one block of 0x5c, ipad: one block of 0x36. No length extension attacks.
/ CMAC: Uses block cipher. Encrypt, $plus.o$ output with next input before encrypting. Last output is tag.
/ Poly1305: UH used as one-time MAC (new key for every authentication, would leak key otherwise)
/ Poly1305-AES: (Wegman-Carter MAC): $"MAC"(K_1,K_2, N, M) = "UH"(K_1, M) + "AES"(K_2, N)$ where $N$ is nonce and AES used as PRF.
/ AES-GCM: Block-based AEAD, AES for encryption, GHASH for authentication. Do not use short tags (> 128 bit) and use unique IVs. $H = "AES"(K, 0)$ should not be in small mult. subgroup of galois field. Used in TLS, SSH
/ ChaCha20-Poly1305: Stream-based AEAD, ChaCha20 for encryption, Poly1305 for authentication.

= Hard Problems

/ Task Feasibility: feasible if computable in P time.
/ Discrete Logarithm Problem (DLP): Given group elements $x = g^k$ and $g$, find $k$. Only hard for specific subgroups, thus generator to be chosen wisely.
/ Elliptic Curve Discrete Logarithm Problem (ECDLP): Given points $P = k G$ and $G$, find $k$ ($G$ is group generator). Hard for specific curves only, harder than DLP or factoring and thus more security.

If P = NP, both of those and factoring fail.

= Asymmetric Encryption

/ Asymmetric IND-CPA: Attacker knows pk. Selects $M$ and $M'$. Gets one back encrypted. Guesses which one.

== Examples

/ RSA: Choose $p$, $q$ prime. Modulus is $n = p q$. Group $ZZ_n^*$ size $phi(n) = (p-1)(q-1)$. Choose $e$, $d$ in exponent group $ZZ_phi(n)^*$ s.t. $e d equiv^phi(n) 1$. Choose $x in ZZ_n^*$, define $y = x^e mod n$. Computing $x$ from $y$ is hard unless $d$ is known. Public: $n$, $e$. Secret: $p$, $q$, $d$. If you know $phi(n)$, you can retrieve $p+q$ and use the quadratic formula on that and $n$ to find $p$ and $q$. *RSA needs OAEP padding to be secure.*
/ ElGamal: Use any group $G$ (order $q$, prime, generator $g$) where DLP is hard. $"sk"$ random group element, $"pk" = g^"sk"$. Encrypt group elem $M$ by $(g^r, M dot.op "pk"^r)$ where $r$ is random group elem. DDH holds over $G$ $=>$ ElGamal IND-CPA (proof by assuming IND-CPA attacker, reducing to solve DDH). Homomorphic ($E(M, "pk") dot.op E(M', "pk") = E(M dot.op M', "pk")$).

= Key Exchange

/ Key Encapsulation Mechanism (KEM): One party generates key. It is then wrapped and sent.
/ Key Exchange Protocol (KEX): Both parties contribute to key, often same protocol (e.g. DH KEX)

KEX can be anonymous or authenticated. If anonymous, it is vulnerable to MITM.

== Assumptions

/ Decisional Diffie-Hellman (DDH): for random $a, b in ZZ_q$, $a b G$ looks like a random element. Security Game: attacker has to distinguish $a b G$ from $c G$ (where $c$ is chosen randomly). Provides full semantic security.
/ Computational Diffie-Hellman (CDH): for random $a, b in ZZ_q$, computing $a b G$ from $a G$ and $b G$ is infeasable. Security Game: attacker guesses $a b G$. Learning part of the key is still possible.

Solving DLP implies solving DDH and CDH.

== Examples

/ RSA-KEM: Encrypt and decrypt generated symmetric key using RSA
/ ECDH-KEX: ECG with generator $G$. Shared secret is $a b G$, with $a$ and $b$ randomly generated and then shared by $A = a G$ and $B = b G$. Shared secret is not fully random and should thus be hashed or key derived from it.

= Signatures

Goal: Authentic channel from insecure channel without shared key. Needs PKI to establish.

/ Hash-then-Sign: Often done because signing message directly is computationally expensive.

== Properties

/ Correctness: Valid signatures always pass verification.
/ Integrity: Alteration invalidates the signature.
/ Unforgeability: Computationally infeasible to fake.
/ Authenticity: Confirms the identity of the sender.
/ Non-repudiation: Signers cannot deny signing the message.
\
/ Existential Unforgeability under Chosen Message Attack (EUF-CMA): Hard to forge signatures even if seen many. Game: Attacker knows pk, has signature oracle, needs to provide valid (M, sig) of new M to win.
/ SUF-CMA: Strong EUF-CMA. Game: Attacker needs to provide valid  (M, sig) of new (M, sig)

== Examples

/ RSA: weak by default, use RSA-Probabilistic Signature Scheme or RSA-Full Domain Hash
/ ECDSA: Nonce Reuse = Key Leak. Public params: (Elliptic Curve $C(FF)$, Base point $G$, Prime and order of subgroup generated by $G$: $n$). Assumption: DLP hard in this group. Private key: random $d in ZZ_n without {0}$. Public key: $P = d G$. \ *Sign* $m in ZZ_n without {0}$: random $k in ZZ_n without {0}$, $(x, y) = k G$, $r = x mod n$, $s = (m + r d) dot.op k^(-1) mod n$. Return (r, s) \ *Verify* $m$: $(hat(x), hat(y)) = (m s^(-1) mod n)G + (r s^(-1) mod n)P$. Accept if $hat(x) = r$.
/ EdDSA: E.g. using Ed25519. No random nonce needed and faster to compute than ECDSA. Previously patent problems. Public params: (Elliptic Curve $C(FF)$, Base point $G$, Prime and order of subgroup generated by $G$: $n$). Assumption: DLP hard in this group.

= Post-Quantum Cryptography

TLDR; Breaking schemes like ECC signatures or RSA encryption requires quantum computers more complex than what exists today. NIST recommends migration until 2035. Other experts are more pessimistic (2029 deadline)

/ Quantum Gates: Always reversible. All can be built from Hadamard and Toffoli.
/ Grover's Algorithm: Solves search in unsorted data in $O(sqrt(n))$. E.g. find AES key in keyspace.
/ Shor's Algorithm: Exponential speedup in factoring and DLP. But: Factoring RSA 2048-bit modulos requires ca. 2000-4000 logical qbits, so not yet possible.
/ Q-Day: The day at which crypto is broken by quantum computation.

*Hardware Challenges*: Cannot clone qbits, need error correction scheme for reliability ('logical qbit' from many physical qbits).

*Migration*: Create inventory, Assess risks & prios, migrate

#table(
    columns: (auto, auto),
    [*Safe*], [*Broken*],
    [AES, ChaCha20, SHA-256, SHA-3, HMAC, CMAC, Fortuna (with AES)],
    [RSA encryption, RSA signatures, ElGamal, ECDSA, EdDSA, DH-KEX],
)

== Quantum-Secure Hard Problems

/ Lattices: SVP, LWE. Kyber KEX, Dilithium (ML-DSA) and Falcon (FN-DSA) Signatures, NTRUEncrypt.
/ Code-Based: Based on error correcting codes, e.g. McEliece encryption, HQC KEM.
/ Isogenies: Graph of mappings between ECs.
/ Multi-Variate: Polynomial equations
/ Hash-Based: E.g. assuming 2nd preimage resistance.

= Surprise Math

== Groups

$compose$ associative, $e$ identity element, $a^(-1) slash hat(a)$ inverse elements \
Abelian/commutative group: $compose$ commutative

$ZZ_m = {0,1,...,m-1}$ (under $+$, order $m$) \
$ZZ_m^* = { x in ZZ_m | x "co-prime" m }$ (under $dot$, order $phi(m)$)

$"ord"(G) = |G| $ \
$"ord"(a in G) = k quad "s.t." a^k = e $

The order of any group element divides the group order. \
$g in G$ is a generator iff $"ord"(g) = "ord"(G)$

$"ord"(ZZ_m^*) = phi(m) quad phi : cases(
    p &|-> p-1 quad &p "prime",
    p^k &|-> p^(k-1) (p-1) quad &p "prime",
    a b &|-> phi(a) phi(b) quad &a\, b "coprime"

)$

== Rings

$(S, +, *)$, where:
- $(R, +)$ is an abelian group
- $(R, *)$ is a monoid (group, but no inverses required)
- Distributivity: $a * (b + c) = a * b + a * c$

== Fields

$FF = (S, +, -, *, div)$, where operations behave like defined on $RR$.

=== Field extensions

Extend field $FF$. E.g. $CC$ is extension of $RR$.

$FF[x]$ of all polynomials over $FF$ is a field. E.g. $x^4 + x + 1 in ZZ_2[x] = 10011_2$

$FF[x]\/m(x)$ of all polynomials over $FF$ modulo $"deg"(m)$. E.g. $ZZ_2[x]\/(x^3+1)$: $(x^3 + x + 1) dot.op (x^2 + 1) = x^5 + x^2 + x + 1 mod x^3 + 1 = x + 1$ ($x^3 equiv 1 (mod x^3 + 1)$). Is only a field for special $m$ called 'irreducible'.

=== Finite fields

Two options:
- $"GF"(p) = ZZ_p = FF_p$ ($p$ prime) or
- $"GF"(p^k) = ZZ_p [x] \/ m(x)$ ($p$ prime, $k$ integer $> 1$, $m(x)$ irreducible polynomial of degree $k$, all possible choices are isomorphic)

== Elliptic Curves

Form a group (ECG) using $+$ (opposite of intersection point of line between input points and curve). $𝒪$ is the point at infinity and the neutral element ($P + (-P) = 𝒪$).



/ Weierstrass Curve: ${ (x, y) | x, y in FF, y^2 = x^3 + a x + b }$ for some field $FF$ and some params $a, b in FF$.
/ Curve25519: Specific Montgomery curve. Fast in software, used in TLS and Whatsapp. Not suspicious.
/ Ed25519: Specific Edwards curve.
