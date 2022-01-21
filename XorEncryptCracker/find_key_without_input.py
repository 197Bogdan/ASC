f_input = open("text_criptat", 'rb')
f_text = f_input.read()

contor = 0
cheie = []


def find_key(text, length):
    if length == 0:
        print("Lungimea cheii nu a fost identificata corect.(cheia nu are lungime 10-15)")
    for pas in range(length):
        caractere = []
        ok = False
        for i in range(len(text)):
            if i % length == pas:
                caractere.append(text[i])
        for i in range(97, 123):
            cod_xor = []
            for cod in caractere:
                cod_xor.append(cod ^ i)
            frecventa = {}
            for cod_decriptat in cod_xor:
                try:
                    frecventa[cod_decriptat] += 1
                except KeyError:
                    frecventa[cod_decriptat] = 1
            try:
                suma = frecventa[97] + frecventa[105] + frecventa[101] + frecventa[114]
            except KeyError:
                continue
            proportie = suma / len(caractere) * 100
            if 30 <= proportie <= 45:
                cheie.append(i)
                ok = True
                break
        if ok:
            continue

        for i in range(65, 91):
            cod_xor = []
            for cod in caractere:
                cod_xor.append(cod ^ i)
            frecventa = {}
            for cod_decriptat in cod_xor:
                try:
                    frecventa[cod_decriptat] += 1
                except KeyError:
                    frecventa[cod_decriptat] = 1
            try:
                suma = frecventa[97] + frecventa[105] + frecventa[101] + frecventa[114]
            except KeyError:
                continue

            proportie = suma / len(caractere) * 100
            if 30 <= proportie <= 45:
                cheie.append(i)
                ok = True
                break

        if ok:
            continue

        for i in range(48, 58):
            cod_xor = []
            for cod in caractere:
                cod_xor.append(cod ^ i)
            frecventa = {}
            for cod_decriptat in cod_xor:
                try:
                    frecventa[cod_decriptat] += 1
                except KeyError:
                    frecventa[cod_decriptat] = 1
            try:
                suma = frecventa[97] + frecventa[105] + frecventa[101] + frecventa[114]
            except KeyError:
                continue

            proportie = suma / len(caractere) * 100
            if 30 <= proportie <= 45:
                cheie.append(i)


def check_key_length(text, length):
    frecventa = {}
    for char in range(len(text)):
        if char % length == 0:
            try:
                frecventa[text[char]] += 1
            except KeyError:
                frecventa[text[char]] = 1
    valori = sorted(frecventa.values(), reverse=True)
    proportie = sum(valori[:4]) / (len(text) / length) * 100
    #print(proportie)
    if 40 <= proportie <= 56:
        return True
    return False


lungime_cheie = 0
for x in range(10, 16):      # intervalul [10, 15] poate fi schimbat cu orice interval pentru lungimea posibila a cheii
    if check_key_length(f_text, x):
        lungime_cheie = x

find_key(f_text, lungime_cheie)
cheie_text = []
for cod_ascii in cheie:
    cheie_text.append(chr(cod_ascii))
print("".join(cheie_text))
