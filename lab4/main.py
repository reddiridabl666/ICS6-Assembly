def max_upper(matrix):
    max_elem = float('-inf')
    for i, row in enumerate(matrix):
        for j, elem in enumerate(row):
            if j > i and elem > max_elem:
                max_elem = elem
    return max_elem

print("Enter 5*5 matrix:")

matrix = []

for i in range(5):
    line = list(map(int, input().split()))
    matrix.append(line)

print(max_upper(matrix))
