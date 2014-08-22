filename_r = "out_file.txt"
txt_r = open(filename_r, 'r')
string = txt_r.read()
print string

filename_w = "message.txt"
txt_w = open(filename_w, 'w')

list_r = string.split()
length = len(list_r)
print length

for i in range(0, length):
	numb = list_r[i]
	
	if numb == "0000001":
		outp = "a"
	elif numb == "0000010":
		outp = "b"
	elif numb == "0000011":
		outp = "c"
	elif numb == "0000100":
		outp = "d"
	elif numb == "0000101":
		outp = "e"
	elif numb == "0000110":
		outp = "f"
	elif numb == "0000111":
		outp = "g"
	elif numb == "0001000":
		outp = "h"
	elif numb == "0001001":
		outp = "i"
	elif numb == "0001010":
		outp = "j"
	elif numb == "0001011":
		outp = "k"
	elif numb == "0001100":
		outp = "l"
	elif numb == "0001101":
		outp = "m"
	elif numb == "0001110":
		outp = "n"
	elif numb == "0001111":
		outp = "o"
	elif numb == "0010000":
		outp = "p"
	elif numb == "0010001":
		outp = "q"
	elif numb == "0010010":
		outp = "r"
	elif numb == "0010011":
		outp = "s"
	elif numb == "0010100":
		outp = "t"
	elif numb == "0010101":
		outp = "u"
	elif numb == "0010110":
		outp = "v"
	elif numb == "0010111":
		outp = "w"
	elif numb == "0011000":
		outp = "x"
	elif numb == "0011001":
		outp = "y"
	elif numb == "0011010":
		outp = "z"

	txt_w.write(outp)		
