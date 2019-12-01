export default class Aoc {

  fuel_required(mass : number) : number {
    return Math.floor(mass / 3) - 2;
  }

  total_fuel_required(mass : number, total: number) : number {
    let f : number = this.fuel_required(mass)
    if (f <= 0)
      return total;
    else
      return this.total_fuel_required(f, total + f);
  }

  part_one(input : string) : number {
    return this.sum(this.parse(input).map(this.fuel_required));
  }

  part_two(input : string) : number {
    return this.sum(this.parse(input).map(mass => this.total_fuel_required(mass, 0)))
  }

  parse(input : string) : number[] {
    return input.split("\n").map(n => parseInt(n));
  }

  sum(a : number[]) : number {
    return a.reduce((sum, n) => sum + n);
  }
}