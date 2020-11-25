def fuel_required(mass):
  return mass // 3 - 2

def parse(input):
  return (int(i) for i in input.split())

def part_one(input):
  return sum(fuel_required(i) for i in parse(input))

def total_fuel_required(mass, total):
  f = fuel_required(mass)
  if f <= 0:
    return total
  else:
    return total_fuel_required(f, total + f)

def part_two(input):
  return sum(total_fuel_required(i, 0) for i in parse(input))
