filename = "example.txt"

# open file for reading
txt_r = open(filename, 'r')

# reading file to string variable
string = txt_r.read()

# printing string
print string

# getting length of the string
length = len(string)
print length

filename_w = "in_test.txt"
# open file for writing
txt_w = open(filename_w, 'w')

# for loop for getting each symbol
for i in range(0, length - 1):
	symb = string[i]
	outp = format((ord(symb)-96), '07b')
	txt_w.write(outp + "\t")
