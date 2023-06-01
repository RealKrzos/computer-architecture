.data
RAM:    .space 4096    # zaloznie, ze tablica nie przekroczy 4096 bajtow
row:    .word 0
col:    .word 0

prompt1: .asciiz "Set array rows: "
prompt2: .asciiz "Set array columns: "

prompt3: .asciiz "\nChoose action. Read (0) / Write (1)"
prompt4: .asciiz "Row: "
prompt5: .asciiz "Column: "
prompt6: .asciiz "Err. Must be 0 or 1."

.text
main:
    ### Prosba o podanie liczby kolumn i wierszy

    li $v0, 4
    la $a0, prompt1
    syscall

    li $v0, 5
    syscall
    sw $v0, row     # Zapisz podana wartosc w row
    move $t0, $v0   # Przenies podana wartosc do $t0

    # Poproś o kolumny
    li $v0, 4
    la $a0, prompt2
    syscall

    li $v0, 5
    syscall
    sw $v0, col     # Zapisz podana wartosc w col
    move $t1, $v0   # Przenies podana wartosc do $t1

    ### Obliczenia dla tablicy adresow

    # Alokuj pamiec dla adresow
    sll $t2, $t0, 2      # 2 dla int, 2^2 = 4, sll ma mniejsza zlozonosc czasowa niz mnozenie
    la $t3, RAM
    addu $t3, $t3, $t2   # oblicz przesuniecie bajtowe w RAM, od tego przesuniecia mozna zaczac druga czesc tablicy

    jal fill_array

ask_for_action:
    # Poproś o wybor dzialania
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 5
    syscall
    move $t0, $v0  # Przenies podana wartosc do $t0 (lub $a0)

    beq $t0, 0, read    # Skocz, jesli podana wartosc to 0
    beq $t0, 1, write   # Skocz, jesli podana wartosc to 1

    li $v0, 4
    la $a0, prompt6
    syscall

    j ask_for_action   # Skocz z powrotem na poczatek, aby ponownie zapytac o dzialanie

read:
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 5
    syscall
    move $t4, $v0    # Przenies podana wartosc do $t4

    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 5
    syscall
    move $t5, $v0    # Przenies podana wartosc do $t5

    # Oblicz indeks w tablicy
    mul $t6, $t4, $t1   # Pomnoz wiersz przez kolumne, aby otrzymac indeks
    add $t6, $t6, $t5   # Dodaj kolumne do indeksu
    sll $t6, $t6, 2     # Pomnoz indeks przez 4, aby otrzymac przesuniecie bajtowe

    add $t6, $t6, $t3   # Dodaj przesuniecie bajtowe do adresu tablicy
    lw $t7, 0($t6)      # Wczytaj wartosc z obliczonego adresu

    # Wyswietl wartosc
    li $v0, 1
    move $a0, $t7
    syscall

    j ask_for_action   # Skocz z powrotem na poczatek, aby ponownie zapytac o dzialanie

write:
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 5
    syscall
    move $t4, $v0    # Przenies podana wartosc do $t4

    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 5
    syscall
    move $t5, $v0    # Przenies podana wartosc do $t5

    # Oblicz indeks w tablicy
    mul $t6, $t4, $t1   # Pomnoz wiersz przez kolumne, aby otrzymac indeks
    add $t6, $t6, $t5   # Dodaj kolumne do indeksu
    sll $t6, $t6, 2     # Pomnoz indeks przez 4, aby otrzymac przesuniecie bajtowe

    add $t6, $t6, $t3   # Dodaj przesuniecie bajtowe do adresu tablicy

    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 5
    syscall
    move $t7, $v0    # Przenies podana wartosc do $t7

    sw $t7, 0($t6)   # Zapisz wartosc pod obliczonym adresem

    j ask_for_action   # Skocz z powrotem na poczatek, aby ponownie zapytac o dzialanie

fill_array:
    # Zachowaj aktualny adres do pozniejszego uzycia
    move $t8, $ra

    # Inicjalizuj indeksy wiersza i kolumny
    li $t4, 0   # indeks i
    li $t5, 0   # indeks j

fill_loop:
    # Oblicz wartosc do zapisania w tablicy
    mul $t6, $t4, 100    # i * 100
    addi $t7, $t5, 1     # j + 1
    add $t6, $t6, $t7    # i * 100 + (j + 1)

    # Oblicz indeks w tablicy
    mul $t7, $t4, $t1    # i * col
    add $t7, $t7, $t5    # i * col + j
    sll $t7, $t7, 2      # (i * col + j) * 4

    add $t7, $t7, $t3    # Dodaj przesuniecie bajtowe do adresu tablicy

    # Zapisz wartosc do tablicy
    sw $t6, 0($t7)

    # Zwieksz indeks kolumny
    addi $t5, $t5, 1
    blt $t5, $t1, fill_loop   # Skocz do fill_loop, jesli j < col

    # Zwieksz indeks wiersza
    addi $t4, $t4, 1
    blt $t4, $t0, fill_loop   # Skocz do fill_loop, jesli i < row

    # Przywroc adres powrotu
    move $ra, $t8

    jr $ra   # Skocz do adresu powrotu
