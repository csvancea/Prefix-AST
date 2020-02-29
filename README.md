# Tema 1 - Prefix AST


### Idee de rezolvare:
- Ideea principala pe care se bazeaza rezolvarea este parcurgerea recursiva
  postordine a arborelui returnat de `getAST()`, astfel ca pentru fiecare nod
  voi parcurge subarborii stang si drept (cat timp acestia exista), iar la
  intoarcerea din apelurile recursive voi aplica operatia specificata de nodul
  curent pe cele doua rezultate corespunzatoare celor doi subarbori.
- O implementare in pseudocod ar fi urmatoarea:

```cpp
int FUNC_PostOrder(Node *root) {
  if (isLeaf(root))
    return root->data;

  op = root->data;
  l = FUNC_PostOrder(root->left);
  r = FUNC_PostOrder(root->right);
  
  return FUNC_CalculateOperation(op, l, r);
}
```

### Helpers:
- In rezolvarea temei am definit structura `Node` pentru a lucra mai intuitiv
  cu offset-urile datelor cuprinse intr-un nod.
- Pentru a nu aglomera codul, am definit urmatoarele proceduri ajutatoare:
  - `FUNC_CalculateOperation(char op, int operand_1, int operand_2)`
    - procedura aplica operatia specificata de `op` celor doi operanzi
    - operatiile valide sunt: + - * /
    - rezultatul operatiilor trebuie sa poata fi stocat pe 32 biti (inmultire)
  - `FUNC_StringToInt(const char *string)`
    - procedura are ca rol transformarea unui intreg dat ca sir de caractere
      in integer
    - nu se fac verificari de corectitudine a sirului de intrare
    - un sir poate contine doar cifre si poate sa inceapa cu caracterul '-'
    - orice alt input duce la undefined behaviour
