import copy
from typing import *
from itertools import *

def trace_lines(input : string):
    return tuple(map(split(input, "\n"), parse_line))

def parse_line(input):
    commands = map(split(input, ","))
    return map(execute_commands(map(split(input, ","), parse_command)))

def closest_intersection(input : string) -> int:
    (line1, line2) = trace_lines(input)
    common = set(line1).intersection(set(line2))
    return manhattan_distance(min(common, key=manhattan_distance))

## WIP...

def manhattan_distance((x : int, y : int)) -> int:
    return x + y

