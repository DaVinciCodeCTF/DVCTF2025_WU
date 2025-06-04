from Crypto.Util.number import getRandomInteger, long_to_bytes
import sympy

output=open("../files/output.txt","r").read().strip().split("\n")
ct,n=[int(output[-i].split("=")[1]) for i in [1,2]]

allLogs=output[:-2]
allLogs=[0 if "Oh" in i else int(i.split(" ")[-1]) for i in allLogs]

def getPrimeFromLog(logs):
    R=list(sympy.sieve.primerange(1000))

    m=len(logs)
    residues=[]
    modulus=[]
    for j, log in enumerate(logs):
        if(log>0):
            ri=log
            residues.append((2*(m-j))%ri)
            modulus.append(ri)

    s=lcm(modulus)
    return CRT(residues, modulus),s

cp,cq,s=0,0,0
for SPLITER in range(len(allLogs)):
    logsP=allLogs[:SPLITER]
    logsQ=allLogs[SPLITER:]
    
    try:
        ap,sp=getPrimeFromLog(logsP)
        aq=int(n*Mod(ap,sp)^-1)

        bq,sq=getPrimeFromLog(logsQ)
        bp=int(n*Mod(bq,sq)^-1)

        s=lcm(sp,sq)

        cp=CRT([ap,bp],[sp,sq])
        cq=CRT([aq,bq],[sp,sq])
    except: pass

def coron(pol, X, Y, k=2):
    P.<x,y> = ZZ[]
    pol = pol(x,y)

    p00 = pol(0,0)
    delta = 1 # maximum degree of any variable

    W = max(i for i in pol(x*X,y*Y).coefficients())
    u = W + ((1-W) % abs(p00))
    N = u*(X*Y)^k # modulus for polynomials
    
    # Construct polynomials
    p00inv = inverse_mod(p00,N)
    polq = P(sum((i*p00inv % N)*j for i,j in zip(pol.coefficients(), pol.monomials())))
    polynomials = [ polq * x^i * y^j * X^(k-i) * Y^(k-j) if (i < 3 and j < 3) else x^i * y^j * N for i in range(delta+3) for j in range(delta+3) ]

    monomials = list( set( sum( (i.monomials() for i in polynomials), [] ) ) ) # Make list of monomials for matrix indices

    L = matrix(ZZ, len(monomials), lambda i,j: polynomials[i](X*x,Y*y).monomial_coefficient(monomials[j]) ).LLL() # Construct lattice spanned by polynomials with xX and yY
    roots = []

    pol2 = P(sum(map(mul, zip(L[0],monomials)))(x/X,y/Y))
    r = pol.resultant(pol2, y)

    x0, _ = r.univariate_polynomial().roots()[0]
    y0, _ = pol(x0,y).univariate_polynomial().roots()[0]
    return x0, y0

t=(n - cp*cq)//s

P.<x,y> = ZZ[]
pol =s*x*y + cp*y + cq*x - t
bound=(2^512)//s

x0,y0 = coron(pol, bound,bound)
recoveredP=s*x0+cp

recoveredQ=n//recoveredP
d=pow(65537,-1,(recoveredP-1)*(recoveredQ-1))
print(long_to_bytes(pow(ct,d,n)))