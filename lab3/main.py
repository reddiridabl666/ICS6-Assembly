def func(a, c):
    if a / c > 2:
        return (a - c)**2 + c
    return a + 2 * c

print("Input two numbers, each on its own line")

a = int(input())
c = int(input())

print(func(a, c))
