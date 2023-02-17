def func(a, b, y):
    return (a * a - b) // (y + a) + (a - 1)**2

print("Enter numbers a, b, y:")

a, b, y = map(int, input().split())

print(func(a, b, y))
