with open("benesdis_distribution.txt") as f_in:
    for binary in f_in:
        # print(len(binary))
        for i in range(len(binary)):
            if((i+1)%5 == 0):
                print binary[i],
                print "_",
            else:
                print binary[i],
    print

