filename_r = "out_file.txt"
txt_r = open(filename_r, 'r')
string = txt_r.read()
print string

filename_w = "test_message.txt"
txt_w = open(filename_w, 'w')

list_r = string.split()
length = len(list_r)
print length

for i in range(0, length):
	numb = list_r[i]
	outp = chr(96 + int(numb, 2))
	
	txt_w.write(outp)		
