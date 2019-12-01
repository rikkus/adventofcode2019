using NUnit.Framework;

namespace aoc
{
    public class Tests
    {
        [Test]
        public void _1_1() =>
            Assert.That(Aoc.FuelRequired(12).Equals(2));
        [Test]
        public void _1_2() =>
            Assert.That(Aoc.FuelRequired(14).Equals(2));
        [Test]
        public void _1_3() =>
            Assert.That(Aoc.FuelRequired(1969).Equals(654));
        [Test]
        public void _1_4() =>
            Assert.That(Aoc.FuelRequired(100_756).Equals(33583));

        [Test]
        public void PartOne() =>
            Assert.That(Aoc.PartOne(Input).Equals(3_331_523));

        [Test]
        public void _2_1() =>
            Assert.That(Aoc.TotalFuelRequired(14, 0).Equals(2));
        [Test]
        public void _2_2() =>
            Assert.That(Aoc.TotalFuelRequired(1969, 0).Equals(966));
        [Test]
        public void _2_3() =>
            Assert.That(Aoc.TotalFuelRequired(100_756, 0).Equals(50346));

        [Test]
        public void PartTwo() =>
            Assert.That(Aoc.PartTwo(Input).Equals(4_994_396));

        private const string Input = @"
    95249
    126697
    77237
    80994
    91186
    53823
    115101
    130919
    88127
    141736
    53882
    67432
    94292
    73223
    139947
    66450
    55710
    128647
    73874
    57163
    139502
    140285
    119987
    125308
    77561
    74573
    85364
    92991
    102935
    71259
    99622
    118876
    124482
    148442
    77664
    90453
    111933
    110449
    74172
    148641
    58574
    135365
    84703
    81077
    65290
    136749
    127256
    94872
    143534
    81702
    59493
    72365
    69497
    149082
    79552
    78509
    73759
    147439
    97535
    118952
    114301
    104401
    95080
    100907
    132914
    136096
    52451
    70544
    120717
    107010
    76840
    51324
    135258
    73985
    118067
    86602
    95127
    51182
    84838
    60430
    86347
    140487
    147777
    85143
    114215
    100410
    126504
    69630
    123656
    108886
    144192
    123620
    147217
    146090
    101966
    80577
    62193
    143331
    79947
    93518
  ";
   }
}