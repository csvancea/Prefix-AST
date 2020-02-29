%include "includes/io.inc"

extern getAST
extern freeAST

struc Node
    .data:  resd 1
    .left:  resd 1
    .right: resd 1
endstruc

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text
global main
main:
    ; NU MODIFICATI
    push ebp
    mov ebp, esp

    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax

    ; Implementati rezolvarea aici:

    push eax
    call FUNC_PostOrder
    add esp, 4

    PRINT_DEC 4, eax

    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST

    xor eax, eax
    leave
    ret


; int FUNC_PostOrder(struct Node *root)
; @return rezultatul operatiei specificate de nodul curent aplicata elementelor (left_subtree, right_subtree)
FUNC_PostOrder:
    push  ebp
    mov   ebp, esp
    push  ebx

    mov   ebx, [ebp + 8] ; root
    mov   eax, [ebx + Node.right] ; root->right
    test  eax, eax
; daca un nod nu are ambii copii, inseamna ca acel nod este frunza (numar)
    jz    node_is_leaf

    push  eax
    call  FUNC_PostOrder ; FUNC_PostOrder(root->right)
    mov   [esp], eax ; pun valoarea returnata pe stack ca parametru pentru FUNC_CalculateOperation

    push  dword [ebx + Node.left]
    call  FUNC_PostOrder ; FUNC_PostOrder(root->left)
    mov   [esp], eax ; pun valoarea returnata pe stack ca parametru pentru FUNC_CalculateOperation

    mov   ecx, [ebx + Node.data] ; root->data
    movzx ecx, byte [ecx] ; *(root->data)

; FUNC_CalculateOperation(FUNC_PostOrder(root->left), FUNC_PostOrder(root->right), *root->data)
    push  ecx
    call  FUNC_CalculateOperation
    add   esp, 12

    jmp   end_calc

node_is_leaf:
    mov   ecx, [ebx + Node.data]
    push  ecx
    call  FUNC_StringToInt
    add   esp, 4

end_calc:
    pop   ebx
    leave
    ret


; int FUNC_CalculateOperation(char op, int operand_1, int operand_2)
; @return 32bit integer
FUNC_CalculateOperation:
    push  ebp
    mov   ebp, esp

    mov   edx, [ebp + 8]  ; op
    mov   eax, [ebp + 12] ; operand_1
    mov   ecx, [ebp + 16] ; operand_2

    cmp   dl, '+'
    jz    op_add
    cmp   dl, '-'
    jz    op_sub
    cmp   dl, '*'
    jz    op_mul

; fallthrough case: op_div
op_div:
    cdq
    idiv  ecx
    jmp   op_end

op_mul:
    imul  eax, ecx
    jmp   op_end

op_sub:
    sub   eax, ecx
    jmp   op_end

op_add:
    add   eax, ecx

op_end:
    leave
    ret


; int FUNC_StringToInt(const char *string)
; consider ca input-ul este valid (contine doar cifre; poate sa inceapa cu '-')
; @return 32bit integer
FUNC_StringToInt:
    push  ebp
    mov   ebp, esp

    mov   ecx, [ebp + 8] ; string
    xor   eax, eax ; ret

loop_elements:
    movzx edx, byte [ecx]

    test  dl, dl
    jz    end_of_string

    cmp   dl, '-'
    jz    next_element

; eax = eax*10 + string[i] - '0'
    imul  eax, 10
    add   eax, edx
    sub   eax, '0'

next_element:
    inc   ecx
    jmp   loop_elements

end_of_string:
; verific daca numarul este negativ (incepe cu '-')
    mov   ecx, [ebp + 8] ; string
    cmp   byte [ecx], '-'
    jnz   is_positive
    neg   eax

is_positive:
    leave
    ret
