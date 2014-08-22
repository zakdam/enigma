# getting the file name
filename = raw_input("Enter the file name > ")

# open file for reading
txt_r = open(filename, 'r')

# reading file to string variable
string = txt_r.read()

# printing string
print string

# getting length of the string
length = len(string)
print length

filename_w = "in_file.txt"
# open file for writing
txt_w = open(filename_w, 'w')

# for loop for getting each symbol
for i in range(0, length):
	symb = string[i]

	if symb == "a":
		outp = "0000001"
	elif symb == "b":
		outp = "0000010"
	elif symb == "c":
		outp = "0000011"
	elif symb == "d":
		outp = "0000100"
	elif symb == "e":
		outp = "0000101"
	elif symb == "f":
		outp = "0000110"
	elif symb == "g":
		outp = "0000111"
	elif symb == "h":
		outp = "0001000"
	elif symb == "i":
		outp = "0001001"
	elif symb == "j":
		outp = "0001010"
	elif symb == "k":
		outp = "0001011"
	elif symb == "l":
		outp = "0001100"
	elif symb == "m":
		outp = "0001101"
	elif symb == "n":
		outp = "0001110"
	elif symb == "o":
		outp = "0001111"
	elif symb == "p":
		outp = "0010000"
	elif symb == "q":
		outp = "0010001"
	elif symb == "r":
		outp = "0010010"
	elif symb == "s":
		outp = "0010011"
	elif symb == "t":
		outp = "0010100"
	elif symb == "u":
		outp = "0010101"
	elif symb == "v":
		outp = "0010110"
	elif symb == "w":
		outp = "0010111"
	elif symb == "x":
		outp = "0011000"
	elif symb == "y":
		outp = "0011001"
	elif symb == "z":
		outp = "0011010"

	txt_w.write(outp + "\t")
