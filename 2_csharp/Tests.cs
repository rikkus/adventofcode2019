using System;
using NUnit.Framework;

namespace aoc
{
    public class Tests
    {
        private static readonly int[] input =
        {
            1, 0, 0, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 13, 1, 19, 1, 19, 10, 23, 1, 23, 6, 27, 1, 6, 27, 31, 1,
            13, 31, 35, 1, 13, 35, 39, 1, 39, 13, 43, 2, 43, 9, 47, 2, 6, 47, 51, 1, 51, 9, 55, 1, 55, 9, 59, 1, 59, 6,
            63, 1, 9, 63, 67, 2, 67, 10, 71, 2, 71, 13, 75, 1, 10, 75, 79, 2, 10, 79, 83, 1, 83, 6, 87, 2, 87, 10, 91,
            1, 91, 6, 95, 1, 95, 13, 99, 1, 99, 13, 103, 2, 103, 9, 107, 2, 107, 10, 111, 1, 5, 111, 115, 2, 115, 9,
            119, 1, 5, 119, 123, 1, 123, 9, 127, 1, 127, 2, 131, 1, 5, 131, 0, 99, 2, 0, 14, 0
        };

        private static int[] Input
        {
            get
            {
                var i = new int[input.Length];
                Array.Copy(input, i, input.Length);
                return i;
            }
        }

        [Test]
        public void _1_1()
        {
            Assert.AreEqual(new[] {2, 0, 0, 0, 99}, Aoc.Run(new[] {1, 0, 0, 0, 99}));
        }

        [Test]
        public void _1_2()
        {
            Assert.AreEqual(new[] {2, 3, 0, 6, 99}, Aoc.Run(new[] {2, 3, 0, 3, 99}));
        }

        [Test]
        public void _1_3()
        {
            Assert.AreEqual(new[] {2, 4, 4, 5, 99, 9801}, Aoc.Run(new[] {2, 4, 4, 5, 99, 0}));
        }

        [Test]
        public void _1_4()
        {
            Assert.AreEqual(new[] {30, 1, 1, 4, 2, 5, 6, 0, 99}, Aoc.Run(new[] {1, 1, 1, 4, 99, 5, 6, 0, 99}));
        }

        [Test]
        public void PartOne()
        {
            Assert.AreEqual(5866714, Aoc.PartOne(Input));
        }

        [Test]
        public void PartTwo()
        {
            Assert.AreEqual(5208, Aoc.PartTwo(Input));
        }
    }
}