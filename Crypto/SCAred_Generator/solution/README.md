# Solution  

This challenge is based on a **side-channel attack** exploiting the behavior of a flawed prime generation algorithm.  

## Vulnerability Overview  
The generator starts with a random odd number `v₀` and increments by `2` until it finds a prime:  

```python
def getPrime(b=512):
    v = 2 * getRandomInteger(b) + 1  # Random odd number
    while 1:
        v += 2
        R = sympy.sieve.primerange(1000)
        for r in R:
            if v % r == 0:  # Trial division
                print("Ahh ! My test failed on", r)
                break
        else:
            if isPrime(v): return v
            print("Oh nooo ! isPrime test failed")
```

### Key Observations  
- The prime number `vₘ` generated follows:  
```math
  vₘ = v₀ + 2m
```
- If a candidate `vⱼ` fails on a prime divisor `r`, then:  
```math
  vⱼ \equiv 0 \pmod{r} \Rightarrow vₘ \equiv 2(m - j) \pmod{r}
```

Using the **Chinese Remainder Theorem (CRT)**, we can determine `p` and `q` modulo the product of vj prime divisors r.  
```math
a_p \equiv p \pmod{s_p}
```
```math
a_q \equiv q \pmod{s_q}
```

Since:
```math
n = p \cdot q
```

we derive:  
```math
b_p \equiv p \equiv n \cdot q^{-1} \pmod{s_p}
```
```math
b_q \equiv q \equiv n \cdot p^{-1} \pmod{s_q}
```

## Reconstruction of `p` and `q`  
Using the **Chinese Remainder Theorem (CRT)**, we reconstruct `p` and `q` modulo a large value:
```math
s=lcm(s_p,s_q)
```  

```math
c_p = p \mod s
```
```math	
c_q = q \mod s
```

We can write `p` and `q` as:

```math
p = s \cdot x_0 + c_p
```
```math
q = s \cdot y_0 + c_q
```

Expanding the equation:

```math	
0 = p \cdot q - n = (s x_0 + c_p)(s y_0 + c_q) - n
```

```math
0 = s^2 x_0 y_0 + s x_0 c_q + s y_0 c_p + c_p c_q - n
```

Since
```math
c_p c_q - n \equiv 0 \pmod{s}
```

```math
t = \frac{c_p c_q - n}{s}
```

And t is an integer.

This leads to a **bivariate polynomial**:

```math
f(x, y) = A x y + B x + C y + D
```

Where x and y are unknown and A, B, C, D are known.

Also we have `(x₀, y₀)` a solution to the equation:

```math
f(x, y) = 0
```

## Extracting `p` and `q`  
To solve for `(x₀, y₀)`, we use the **LLL algorithm** to find small roots of the polynomial:  

📌 **References:**  
- [Finding Roots of Bivariate Integer Polynomials (Paper)](https://iacr.org/archive/eurocrypt2004/30270487/bivariate.pdf)  
- [Coppersmith’s Algorithm (Code)](https://github.com/ubuntor/coppersmith-algorithm)  
- [Challenge inspired by this paper](https://www.iacr.org/archive/ches2009/57470141/57470141.pdf)

Once `p` and `q` are known, compute `d` (the private key) and decrypt the flag.
## Flag: `DVCTF{S1d3_Ch4nn3l_4tt4ck_0n_Pr1me_G3n3r4t0r}`  
