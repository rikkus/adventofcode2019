import Aoc from './aoc'

const ram: number[] = [
    1, 0, 0, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 13, 1, 19, 1, 19, 10, 23, 1, 23, 6, 27, 1, 6, 27, 31, 1, 13,
    31, 35, 1, 13, 35, 39, 1, 39, 13, 43, 2, 43, 9, 47, 2, 6, 47, 51, 1, 51, 9, 55, 1, 55, 9, 59, 1, 59, 6, 63, 1,
    9, 63, 67, 2, 67, 10, 71, 2, 71, 13, 75, 1, 10, 75, 79, 2, 10, 79, 83, 1, 83, 6, 87, 2, 87, 10, 91, 1, 91, 6,
    95, 1, 95, 13, 99, 1, 99, 13, 103, 2, 103, 9, 107, 2, 107, 10, 111, 1, 5, 111, 115, 2, 115, 9, 119, 1, 5, 119,
    123, 1, 123, 9, 127, 1, 127, 2, 131, 1, 5, 131, 0, 99, 2, 0, 14, 0
];

describe('Aoc()', () => {
    it('1_1', () => {
        expect(new Aoc().run([1, 0, 0, 0, 99])).toStrictEqual([2, 0, 0, 0, 99])
    });

    it('1_2', () => {
        expect(new Aoc().run([2, 3, 0, 3, 99])).toStrictEqual([2, 3, 0, 6, 99])
    });

    it('1_3', () => {
        expect(new Aoc().run([2, 4, 4, 5, 99, 0])).toStrictEqual([2, 4, 4, 5, 99, 9801])
    });

    it('1_4', () => {
        expect(new Aoc().run([1, 1, 1, 4, 99, 5, 6, 0, 99])).toStrictEqual([30, 1, 1, 4, 2, 5, 6, 0, 99])
    });

    it('part_one', () => {
        expect(new Aoc().partOne(Array.from(ram))).toStrictEqual(5866714)
    });

    it('part_two', () => {
        expect(new Aoc().partTwo(Array.from(ram))).toStrictEqual(5208)
    });
});
