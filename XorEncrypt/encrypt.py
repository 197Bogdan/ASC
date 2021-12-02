import sys

# sys.argv[1]  == cheie de criptare
# sys.argv[2]  == input file
# sys.argv[3]  == output file

f_input = open(sys.argv[2], 'r')
text = f_input.read()                       # salvam inputul
f_input.close()

cheie_text = sys.argv[1]
cheie_b10 = [ord(x) for x in cheie_text]            # transformam cheia in baza 10
text_b10 = [ord(x) for x in text]                   # transformam textul in baza 10
l_cheie = len(cheie_b10)
l_text = len(text_b10)

text_binar = []
for i in range(l_text):         # xor pe tot textul caracter cu caracter, apoi transformam in string binar si umplem
    text_binar.append(bin(int(text_b10[i]) ^ int(cheie_b10[i % l_cheie]))[2:].zfill(8))  # eventualele goluri cu 0
output = ''.join(text_binar)    # transfomam lista cu text criptat intr un string

f_output = open(sys.argv[3], 'w')
f_output.write(output)
f_output.close()
