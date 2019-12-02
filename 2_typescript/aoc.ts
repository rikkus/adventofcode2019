type RAM = number[];
type IP = number;
type Operator = (x: number, y: number) => number;

export default class Aoc {

    partOne = (ram: RAM) : number => this.runWithMods(ram, 12, 2)[0];

    partTwo(ram: RAM) : number {
        for (let noun = 0; noun <= 99; noun++)
            for (let verb = 0; verb <= 99; verb++)
                if (this.runWithMods(Array.from(ram), noun, verb)[0] == 19690720)
                    return 100 * noun + verb;

        return -1;
    }

    run(ram: RAM): RAM {
        return this.runFrom(ram, 0);
    }

    runFrom(ram: RAM, ip: IP) : RAM {
        switch (ram[ip]) {
            case 1: return this.runFrom(this.operator(ram, ip, (x, y) => x + y), ip + 4);
            case 2: return this.runFrom(this.operator(ram, ip, (x, y) => x * y), ip + 4);
            case 99: return ram;
        }
        throw `Unknown opcode ${ram[ip]} at ${ip}`
    }

    runWithMods(ram: RAM, noun: number, verb: number): RAM {
        ram[1] = noun;
        ram[2] = verb;
        return this.run(ram);
    }

    operator(ram: RAM, ip: IP, op: Operator) : RAM {
        ram[ram[ip + 3]] = op(ram[ram[ip + 1]], ram[ram[ip + 2]]);
        return ram
    }
}