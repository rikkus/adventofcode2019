import unittest

from aoc import *

input = """
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
  """

class AocTest(unittest.TestCase):
    def test_1_1(self):
        self.assertEqual(fuel_required(12), 2)
    def test_1_2(self):
        self.assertEqual(fuel_required(14), 2)
    def test_1_3(self):
        self.assertEqual(fuel_required(1969), 654)
    def test_1_4(self):
        self.assertEqual(fuel_required(100_756), 33583)

    def test_part_one(self):
        self.assertEqual(part_one(input), 3_331_523)

    def test_2_1(self):
        self.assertEqual(total_fuel_required(12, 0), 2)
    def test_2_2(self):
        self.assertEqual(total_fuel_required(1969, 0), 966)
    def test_2_3(self):
        self.assertEqual(total_fuel_required(100_756, 0), 50346)

    def test_part_two(self):
        self.assertEqual(part_two(input), 4_994_396)


if __name__ == "__main__":
    unittest.main()
