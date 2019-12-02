import copy
from typing import *

RAM = List[int]


def part_one(ram: RAM) -> int:
    return run_with_mods(ram, 12, 2)[0]


def part_two(ram: RAM) -> int:
    return [100 * noun + verb
            for noun in range(0, 99)
            for verb in range(0, 99)
            if run_with_mods(copy.deepcopy(ram), noun, verb)[0] == 19690720][0]


def run(ram: RAM) -> RAM:
    return run_from(ram, 0)


def run_with_mods(ram: RAM, noun: int, verb: int) -> RAM:
    ram[1] = noun
    ram[2] = verb
    return run(ram)


def run_from(ram: RAM, ip: int) -> RAM:
    opcode = ram[ip]
    if opcode == 1:
        return run_from(operator(ram, ip, lambda x, y: x + y), ip + 4)
    elif opcode == 2:
        return run_from(operator(ram, ip, lambda x, y: x * y), ip + 4)
    elif opcode == 99:
        return ram


def operator(ram: RAM, ip: int, op: Callable[[int, int], int]) -> RAM:
    ram[ram[ip + 3]] = op(ram[ram[ip + 1]], ram[ram[ip + 2]])
    return ram
