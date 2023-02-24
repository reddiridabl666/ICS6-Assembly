line = input().split()

res = 0
a_count = 0

for word in line:
    for char in word:
        if char == 'A':
            a_count += 1
    if a_count > 3:
        res += 1
    a_count = 0

print(res)
    