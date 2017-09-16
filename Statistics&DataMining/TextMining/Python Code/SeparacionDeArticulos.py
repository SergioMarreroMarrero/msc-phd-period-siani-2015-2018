my_file = open("/Users/lukas/Desktop/Medical Imaging/Medical Imaging All in One.txt", "r")

lines = my_file.readlines()

my_file.close()

article_number = 1

for index, line in enumerate(lines):

    f = open("Article {}.txt".format(article_number), "a")

    f.write(line+'\n')

    f.close()

    if index%4 == 3:
        article_number += 1
