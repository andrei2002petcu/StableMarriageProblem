Solved the problem of stable marriages using the Gale Shapley algorithm and functions for manipulating lists and streams

In the Stable Marriage Problem (SMP), an equal number of men and women are given, and for each of them, a "ranking" of all individuals of the opposite sex is provided. The task is for each man to marry a woman in such a way that there are no pairs consisting of a man and a woman in different marriages who would prefer each other over their spouses. If such a pair exists, they would be motivated to leave their partners to be together, thus their marriages would not be stable (hence the name of the problem).

An SMP instance in Racket is seen as two lists (of equal length) of male and female preferences, respectively.Thus, the male/female preference list is a list of lists, with each inner list having a male/female in the first position, and the following positions people of the opposite sex in the order of preferences of this man/woman
