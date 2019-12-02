using System;
using System.Collections.Generic;

namespace aoc
{
    internal class Aoc
    {
        public static int PartOne(int[] input) => Run(input, 12, 2)[0];

        public static int PartTwo(int[] input)
        {
            for (var noun = 0; noun <= 99; noun++)
            for (var verb = 0; verb <= 99; verb++)
            {
                var inputCopy = new int[input.Length];
                Array.Copy(input, inputCopy, input.Length);

                if (Run(inputCopy, noun, verb)[0] == 19690720)
                    return 100 * noun + verb;
            }

            throw new ArgumentException("Couldn't find what we're looking for in input");
        }

        private static int[] Run(int[] input, int noun, int verb)
        {
            input[1] = noun;
            input[2] = verb;

            return Run(input);
        }

        public static int[] Run(int[] input)
        {
            var ip = 0;

            while (true)
                switch (input[ip])
                {
                    case 1:
                        ip = Operator(input, ip, (x, y) => x + y);
                        break;
                    case 2:
                        ip = Operator(input, ip, (x, y) => x * y);
                        break;
                    case 99:
                        return input;
                }
        }

        private static int Operator(IList<int> input, int ip, Func<int, int, int> op)
        {
            input[input[ip + 3]] = op(input[input[ip + 1]], input[input[ip + 2]]);
            return ip + 4;
        }
    }
}