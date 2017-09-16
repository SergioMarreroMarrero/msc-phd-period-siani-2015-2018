my_file = open("/Users/lukas/Desktop/Medical Imaging/Medical Imaging All in One.txt", "r")

lines = my_file.readlines()

my_file.close()

new_file = open("/Users/lukas/Desktop/Medical Imaging/Pruned/Medical Imaging All in One.txt", "w")

for line in lines:
    if line.startswith("URL"):
        pass
    elif line.startswith("doi"):
        pass
    elif line.startswith("keywords"):
        new_file.write(line+'\n')
    elif line.startswith("Abstract"):
        new_file.write(line)
    else:
        title = line.split('"')
        if len(title) > 1:
            new_file.write(title[1]+'\n')

new_file.close()
