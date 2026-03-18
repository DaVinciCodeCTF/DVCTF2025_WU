# Chunk Norris

## Infos

Objective: Chunk Norris never lies, it's the truth that's wrong.

Difficulty: Hard

Category: Steganography

Flag : DVCTF{cHUnK_N0Rr15!}

# SOLUTION

ok en gros il faut juste run stegseek avec rockyou on sort un png on remet les chunks dans le bon ordre pour avoir un png correct (ça c facile pcque y'a un seul chunk IDAT donc meme pas de guess) puis ensuite on voit une image avec une ligne de pixels blancs et noirs on récupère et on met 0 pour noir et espace pour blanc on décode ce truc (c'est du chuck norris) et hop le flag

## FLAG: DVCTF{cHUnK_N0Rr15!}

C'était une très bonne idée de checker en ligne si y'avait pas un WU ;)