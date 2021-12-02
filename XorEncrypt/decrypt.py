import sys

# sys.argv[1]  == input file
# sys.argv[2]  == cheie decriptare
# sys.argv[3]  == output file

f_input = open(sys.argv[1], 'r')
text = f_input.read()
f_input.close()

cheie_text = sys.argv[2]
cheie_b10 = [ord(char) for char in cheie_text]                      # transformam cheia in baza 10
text_sep = [text[8*i:8*i+8] for i in range(len(text)//8)]           # separam textul binar in string uri de cate 8
text_b10 = [int(nr_binar, 2) for nr_binar in text_sep]              # transformam in baza 10 8 cate 8 biti
l_cheie = len(cheie_b10)
l_text = len(text_b10)

text_decriptat = []
for i in range(l_text):
    text_decriptat.append(chr(text_b10[i] ^ cheie_b10[i % l_cheie]))   # xor apoi din baza 10 in string decriptat
output = ''.join(text_decriptat)

f_output = open(sys.argv[3], 'w')
f_output.write(output)
f_output.close()
