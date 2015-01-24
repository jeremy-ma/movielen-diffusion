
import sys

def ranklist_to_names():

	ranklist = sys.argv[1]
	ranklist = ranklist.split(',')
	rankSet = set()
	for rank in ranklist:
		rankSet.add(int(rank))

	fp = open('top500movies.txt')

	for line in fp:
		linesplit = line.split()
		rank = int(linesplit[1])
		if rank in rankSet:
			print line



if __name__ == "__main__":

	ranklist_to_names()






