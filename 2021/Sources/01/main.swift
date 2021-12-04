import Foundation

/**
 --- Day 1: Sonar Sweep ---

 You're minding your own business on a ship at sea when the overboard alarm goes off! You rush to see if you can help. Apparently, one of the Elves tripped and accidentally sent the sleigh keys flying into the ocean!

 Before you know it, you're inside a submarine the Elves keep ready for situations like this. It's covered in Christmas lights (because of course it is), and it even has an experimental antenna that should be able to track the keys if you can boost its signal strength high enough; there's a little meter that indicates the antenna's signal strength by displaying 0-50 stars.

 Your instincts tell you that in order to save Christmas, you'll need to get all fifty stars by December 25th.

 Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

 As the submarine drops below the surface of the ocean, it automatically performs a sonar sweep of the nearby sea floor. On a small screen, the sonar sweep report (your puzzle input) appears: each line is a measurement of the sea floor depth as the sweep looks further and further away from the submarine.

 For example, suppose you had the following report:

 199
 200
 208
 210
 200
 207
 240
 269
 260
 263
 This report indicates that, scanning outward from the submarine, the sonar sweep found depths of 199, 200, 208, 210, and so on.

 The first order of business is to figure out how quickly the depth increases, just so you know what you're dealing with - you never know if the keys will get carried into deeper water by an ocean current or a fish or something.

 To do this, count the number of times a depth measurement increases from the previous measurement. (There is no measurement before the first measurement.) In the example above, the changes are as follows:

 199 (N/A - no previous measurement)
 200 (increased)
 208 (increased)
 210 (increased)
 200 (decreased)
 207 (increased)
 240 (increased)
 269 (increased)
 260 (decreased)
 263 (increased)
 In this example, there are 7 measurements that are larger than the previous measurement.

 How many measurements are larger than the previous measurement?

 Your puzzle answer was 1655.

 --- Part Two ---

 Considering every single measurement isn't as useful as you expected: there's just too much noise in the data.

 Instead, consider sums of a three-measurement sliding window. Again considering the above example:

 199  A
 200  A B
 208  A B C
 210    B C D
 200  E   C D
 207  E F   D
 240  E F G
 269    F G H
 260      G H
 263        H
 Start by comparing the first and second three-measurement windows. The measurements in the first window are marked A (199, 200, 208); their sum is 199 + 200 + 208 = 607. The second window is marked B (200, 208, 210); its sum is 618. The sum of measurements in the second window is larger than the sum of the first, so this first comparison increased.

 Your goal now is to count the number of times the sum of measurements in this sliding window increases from the previous sum. So, compare A with B, then compare B with C, then C with D, and so on. Stop when there aren't enough measurements left to create a new three-measurement sum.

 In the above example, the sum of each three-measurement window is as follows:

 A: 607 (N/A - no previous sum)
 B: 618 (increased)
 C: 618 (no change)
 D: 617 (decreased)
 E: 647 (increased)
 F: 716 (increased)
 G: 769 (increased)
 H: 792 (increased)
 In this example, there are 5 sums that are larger than the previous sum.

 Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?
 */

func countLargerThanPrevious(measurements: [Int]) -> Int {
  var previous: Int?
  var largerCnt = 0
  measurements.forEach {
    if let prev = previous, prev < $0 {
      largerCnt += 1
    }
    previous = $0
  }
  
  return largerCnt
}

func countSlidingWindowLargerThanPrevious(measurements: [Int], slidingWindowSize: Int = 3) -> Int {
  var largerCnt = 0
  measurements.enumerated().forEach { (i, measurement) in
    guard i > 0, i + 2 < measurements.count else { return }
    
    let a = measurements[i - 1] + measurement + measurements[i + 1]
    let b = measurement + measurements[i + 1] + measurements[i + 2]
    
    if a < b {
      largerCnt += 1
    }
  }
  
  return largerCnt
}


let input: [Int] = [
  188, 192, 196, 198, 199, 202, 208, 225, 231, 219, 226, 232, 265, 267, 268, 287, 288, 296, 297, 303, 321, 325, 327,
  332, 334, 343, 348, 351, 354, 355, 357, 358, 359, 361, 389, 397, 395, 367, 368, 370, 372, 356, 366, 370, 373, 376,
  390, 389, 391, 402, 413, 419, 426, 427, 450, 452, 456, 457, 463, 462, 457, 463, 450, 452, 456, 455, 464, 460, 461,
  476, 477, 486, 492, 495, 512, 513, 534, 535, 545, 549, 555, 559, 564, 539, 548, 555, 556, 558, 560, 567, 566, 565,
  566, 567, 569, 572, 581, 582, 583, 575, 591, 602, 606, 607, 608, 610, 614, 616, 620, 630, 635, 634, 633, 665, 666,
  680, 685, 678, 694, 697, 698, 702, 704, 705, 711, 721, 719, 720, 731, 730, 731, 733, 742, 747, 767, 764, 761, 763,
  757, 763, 766, 767, 773, 790, 791, 793, 780, 788, 808, 837, 842, 853, 855, 857, 858, 859, 861, 870, 872, 875, 868,
  870, 866, 867, 872, 873, 869, 846, 865, 868, 869, 870, 872, 875, 878, 881, 888, 903, 907, 908, 914, 918, 919, 922,
  918, 921, 918, 924, 927, 921, 927, 928, 929, 930, 936, 945, 954, 980, 982, 993, 994, 1008, 1010, 1014, 1016, 1017,
  1022, 1020, 1023, 1025, 1021, 1019, 1027, 1028, 1031, 1013, 1014, 1023, 1024, 1027, 1028, 1042, 1051, 1030, 1035,
  1038, 1020, 1024, 1019, 983, 988, 1002, 1003, 1004, 1001, 1009, 1016, 1017, 1024, 1025, 1034, 1054, 1057, 1063, 1064,
  1066, 1087, 1088, 1091, 1094, 1095, 1096, 1105, 1122, 1124, 1125, 1123, 1140, 1130, 1131, 1138, 1141, 1143, 1159,
  1163, 1164, 1193, 1218, 1220, 1201, 1200, 1217, 1218, 1231, 1230, 1233, 1241, 1243, 1245, 1260, 1262, 1260, 1286,
  1297, 1298, 1307, 1313, 1314, 1313, 1323, 1324, 1332, 1333, 1339, 1357, 1389, 1390, 1394, 1396, 1399, 1392, 1393,
  1394, 1407, 1408, 1410, 1422, 1423, 1424, 1434, 1435, 1442, 1462, 1466, 1467, 1469, 1470, 1471, 1485, 1473, 1474,
  1476, 1486, 1491, 1496, 1508, 1538, 1547, 1554, 1563, 1574, 1588, 1594, 1591, 1594, 1602, 1606, 1619, 1625, 1626,
  1636, 1638, 1641, 1640, 1646, 1642, 1655, 1656, 1650, 1651, 1657, 1659, 1657, 1660, 1675, 1652, 1638, 1641, 1644,
  1645, 1647, 1651, 1653, 1660, 1662, 1667, 1668, 1667, 1668, 1669, 1673, 1697, 1701, 1721, 1726, 1727, 1723, 1725,
  1732, 1734, 1733, 1736, 1757, 1761, 1772, 1771, 1789, 1790, 1794, 1804, 1806, 1807, 1811, 1822, 1812, 1810, 1812,
  1814, 1791, 1789, 1781, 1776, 1781, 1798, 1802, 1817, 1820, 1809, 1807, 1820, 1825, 1823, 1835, 1834, 1835, 1839,
  1843, 1844, 1824, 1839, 1844, 1851, 1853, 1887, 1895, 1899, 1904, 1903, 1901, 1896, 1903, 1904, 1909, 1910, 1915,
  1920, 1932, 1942, 1944, 1926, 1951, 1961, 1962, 1972, 1975, 1977, 1984, 1987, 1993, 2001, 2003, 2006, 2013, 2034,
  2046, 2050, 2058, 2063, 2060, 2044, 2050, 2051, 2045, 2049, 2078, 2060, 2063, 2064, 2065, 2081, 2082, 2092, 2098,
  2099, 2107, 2108, 2134, 2135, 2157, 2159, 2158, 2168, 2167, 2173, 2179, 2204, 2208, 2218, 2221, 2238, 2234, 2235,
  2236, 2239, 2243, 2247, 2248, 2249, 2264, 2265, 2266, 2261, 2262, 2248, 2256, 2258, 2270, 2280, 2284, 2292, 2293,
  2298, 2299, 2309, 2332, 2340, 2341, 2342, 2343, 2350, 2353, 2358, 2359, 2363, 2365, 2357, 2359, 2363, 2370, 2375,
  2374, 2390, 2384, 2402, 2405, 2409, 2412, 2422, 2428, 2429, 2432, 2417, 2410, 2401, 2418, 2419, 2420, 2421, 2417,
  2418, 2422, 2424, 2436, 2462, 2471, 2480, 2478, 2481, 2505, 2510, 2518, 2545, 2546, 2549, 2564, 2569, 2577, 2609,
  2605, 2604, 2614, 2596, 2613, 2629, 2631, 2632, 2635, 2634, 2663, 2664, 2678, 2712, 2689, 2688, 2697, 2706, 2708,
  2714, 2715, 2718, 2739, 2743, 2745, 2754, 2752, 2754, 2794, 2796, 2797, 2798, 2801, 2804, 2807, 2819, 2838, 2839,
  2840, 2841, 2842, 2843, 2848, 2853, 2883, 2889, 2905, 2906, 2912, 2935, 2925, 2924, 2957, 2958, 2980, 2972, 2973,
  2959, 2964, 2965, 2976, 2977, 2978, 2981, 3000, 3002, 3009, 2996, 3000, 2999, 3001, 3002, 3008, 3009, 3011, 3014,
  3015, 3019, 3037, 3046, 3048, 3049, 3050, 3049, 3050, 3060, 3056, 3053, 3065, 3067, 3068, 3067, 3073, 3075, 3076,
  3079, 3086, 3072, 3076, 3079, 3103, 3104, 3117, 3120, 3111, 3127, 3128, 3130, 3129, 3134, 3137, 3138, 3140, 3143,
  3159, 3162, 3188, 3201, 3204, 3206, 3216, 3217, 3196, 3208, 3210, 3215, 3216, 3220, 3236, 3237, 3227, 3231, 3249,
  3251, 3255, 3258, 3261, 3262, 3271, 3274, 3270, 3272, 3281, 3282, 3303, 3300, 3317, 3323, 3358, 3359, 3360, 3361,
  3364, 3366, 3370, 3376, 3377, 3379, 3380, 3384, 3385, 3394, 3401, 3391, 3392, 3425, 3414, 3423, 3428, 3448, 3454,
  3464, 3465, 3466, 3469, 3474, 3476, 3478, 3488, 3482, 3483, 3484, 3486, 3485, 3498, 3504, 3505, 3506, 3514, 3520,
  3523, 3529, 3534, 3535, 3537, 3538, 3545, 3513, 3515, 3522, 3527, 3528, 3537, 3541, 3542, 3543, 3548, 3535, 3537,
  3553, 3590, 3588, 3596, 3591, 3598, 3602, 3606, 3607, 3608, 3614, 3612, 3616, 3618, 3623, 3624, 3644, 3645, 3650,
  3651, 3652, 3654, 3656, 3660, 3678, 3680, 3684, 3685, 3703, 3709, 3710, 3717, 3754, 3755, 3756, 3727, 3755, 3761,
  3759, 3765, 3774, 3775, 3779, 3786, 3788, 3800, 3801, 3802, 3813, 3841, 3847, 3856, 3859, 3866, 3872, 3869, 3870,
  3890, 3905, 3906, 3907, 3908, 3920, 3921, 3928, 3939, 3956, 3967, 3968, 3974, 3989, 3995, 3996, 4000, 4007, 4015,
  4022, 4019, 4029, 4030, 4031, 4040, 4043, 4044, 4045, 4054, 4056, 4075, 4084, 4085, 4086, 4088, 4086, 4093, 4101,
  4111, 4110, 4111, 4102, 4103, 4101, 4102, 4103, 4110, 4111, 4121, 4122, 4142, 4143, 4142, 4152, 4155, 4157, 4132,
  4137, 4141, 4136, 4138, 4141, 4143, 4167, 4169, 4170, 4171, 4179, 4180, 4191, 4194, 4193, 4181, 4180, 4181, 4185,
  4191, 4192, 4194, 4196, 4200, 4204, 4208, 4219, 4223, 4216, 4219, 4222, 4228, 4218, 4224, 4226, 4248, 4246, 4249,
  4238, 4237, 4247, 4263, 4264, 4268, 4271, 4277, 4282, 4283, 4290, 4291, 4292, 4300, 4299, 4300, 4301, 4302, 4304,
  4305, 4306, 4310, 4325, 4327, 4325, 4338, 4341, 4343, 4342, 4343, 4345, 4346, 4348, 4362, 4364, 4365, 4362, 4370,
  4374, 4377, 4379, 4385, 4389, 4407, 4418, 4422, 4426, 4429, 4428, 4450, 4452, 4445, 4446, 4454, 4458, 4476, 4479,
  4486, 4500, 4498, 4499, 4498, 4505, 4508, 4509, 4518, 4520, 4523, 4522, 4530, 4544, 4545, 4568, 4572, 4565, 4582,
  4585, 4586, 4601, 4587, 4596, 4612, 4628, 4629, 4633, 4634, 4635, 4640, 4642, 4641, 4637, 4638, 4641, 4637, 4640,
  4641, 4653, 4658, 4635, 4644, 4653, 4654, 4655, 4681, 4682, 4681, 4696, 4689, 4691, 4697, 4698, 4708, 4711, 4713,
  4714, 4725, 4728, 4731, 4723, 4725, 4715, 4724, 4759, 4762, 4763, 4764, 4774, 4777, 4779, 4780, 4788, 4787, 4807,
  4828, 4829, 4830, 4832, 4833, 4836, 4830, 4846, 4827, 4828, 4831, 4832, 4837, 4839, 4842, 4844, 4845, 4857, 4835,
  4839, 4840, 4843, 4841, 4855, 4856, 4882, 4891, 4897, 4890, 4904, 4912, 4931, 4932, 4933, 4946, 4952, 4953, 4970,
  4974, 4975, 4969, 4971, 4972, 4971, 4972, 4968, 4983, 4999, 5001, 5010, 5012, 5027, 5025, 5033, 5036, 5051, 5032,
  5023, 5024, 5029, 5043, 5045, 5049, 5055, 5071, 5070, 5072, 5084, 5085, 5086, 5092, 5100, 5099, 5101, 5113, 5120,
  5111, 5139, 5146, 5152, 5149, 5151, 5128, 5145, 5132, 5153, 5181, 5193, 5197, 5203, 5236, 5237, 5235, 5240, 5241,
  5275, 5270, 5271, 5287, 5309, 5313, 5316, 5317, 5318, 5319, 5322, 5323, 5319, 5322, 5323, 5326, 5331, 5323, 5331,
  5326, 5328, 5329, 5330, 5331, 5333, 5334, 5335, 5329, 5330, 5332, 5333, 5334, 5337, 5338, 5337, 5338, 5341, 5340,
  5338, 5339, 5346, 5347, 5348, 5334, 5330, 5331, 5334, 5342, 5373, 5374, 5366, 5367, 5377, 5381, 5387, 5414, 5390,
  5394, 5395, 5378, 5382, 5385, 5378, 5387, 5386, 5387, 5388, 5389, 5373, 5374, 5377, 5386, 5408, 5411, 5412, 5414,
  5408, 5426, 5425, 5458, 5478, 5479, 5481, 5482, 5492, 5496, 5497, 5502, 5480, 5481, 5488, 5503, 5504, 5470, 5475,
  5476, 5479, 5480, 5487, 5491, 5492, 5491, 5494, 5496, 5497, 5495, 5506, 5508, 5510, 5509, 5507, 5515, 5509, 5510,
  5512, 5528, 5522, 5530, 5531, 5544, 5547, 5548, 5563, 5571, 5595, 5597, 5613, 5634, 5639, 5648, 5653, 5656, 5663,
  5675, 5676, 5671, 5678, 5681, 5690, 5711, 5714, 5721, 5732, 5737, 5738, 5760, 5759, 5769, 5770, 5771, 5781, 5783,
  5786, 5784, 5785, 5787, 5800, 5802, 5799, 5800, 5803, 5808, 5842, 5838, 5843, 5844, 5846, 5855, 5862, 5865, 5881,
  5904, 5909, 5910, 5911, 5914, 5915, 5920, 5930, 5956, 5973, 5981, 5991, 5993, 6002, 6024, 6028, 6031, 6037, 6031,
  6032, 6035, 6038, 6065, 6074, 6076, 6078, 6079, 6084, 6086, 6087, 6076, 6080, 6068, 6070, 6081, 6086, 6097, 6119,
  6125, 6127, 6125, 6117, 6124, 6121, 6124, 6127, 6134, 6129, 6131, 6145, 6147, 6143, 6144, 6151, 6150, 6155, 6156,
  6158, 6159, 6160, 6172, 6190, 6191, 6193, 6192, 6208, 6225, 6228, 6234, 6235, 6236, 6237, 6242, 6247, 6248, 6250,
  6241, 6255, 6257, 6260, 6261, 6264, 6263, 6286, 6265, 6290, 6295, 6297, 6322, 6344, 6359, 6362, 6371, 6385, 6388,
  6394, 6395, 6413, 6425, 6422, 6423, 6448, 6450, 6441, 6444, 6443, 6446, 6450, 6468, 6470, 6473, 6474, 6480, 6473,
  6474, 6485, 6484, 6486, 6498, 6506, 6518, 6517, 6535, 6533, 6559, 6564, 6565, 6544, 6554, 6566, 6567, 6561, 6574,
  6575, 6609, 6610, 6633, 6635, 6639, 6643, 6645, 6648, 6652, 6649, 6615, 6620, 6633, 6640, 6641, 6642, 6645, 6644,
  6648, 6654, 6656, 6654, 6664, 6665, 6668, 6687, 6692, 6712, 6713, 6721, 6710, 6707, 6706, 6714, 6718, 6731, 6742,
  6748, 6749, 6759, 6726, 6733, 6736, 6748, 6749, 6746, 6743, 6749, 6752, 6781, 6777, 6764, 6763, 6778, 6781, 6782,
  6807, 6829, 6831, 6842, 6850, 6866, 6867, 6884, 6891, 6881, 6883, 6892, 6905, 6867, 6859, 6862, 6863, 6847, 6848,
  6844, 6845, 6874, 6894, 6901, 6894, 6911, 6935, 6941, 6948, 6956, 6955, 6964, 6969, 6968, 6969, 6972, 6974, 6975,
  6983, 6989, 7009, 7014, 7016, 7028, 7024, 7028, 7029, 7024, 7042, 7055, 7059, 7092, 7095, 7100, 7109, 7112, 7110,
  7111, 7110, 7128, 7129, 7131, 7133, 7135, 7163, 7165, 7175, 7176, 7177, 7178, 7188, 7199, 7181, 7195, 7200, 7201,
  7203, 7212, 7224, 7225, 7234, 7251, 7252, 7245, 7246, 7254, 7256, 7251, 7252, 7253, 7254, 7257, 7256, 7246, 7245,
  7248, 7261, 7247, 7246, 7247, 7254, 7248, 7256, 7258, 7259, 7260, 7261, 7262, 7277, 7297, 7300, 7299, 7301, 7306,
  7314, 7309, 7313, 7316, 7318, 7328, 7329, 7335, 7323, 7324, 7331, 7333, 7334, 7348, 7330, 7334, 7335, 7346, 7348,
  7351, 7356, 7352, 7356, 7364, 7372, 7377, 7378, 7380, 7387, 7390, 7388, 7401, 7403, 7408, 7427, 7425, 7429, 7433,
  7457, 7463, 7474, 7492, 7493, 7496, 7495, 7496, 7502, 7524, 7532, 7529, 7535, 7536, 7544, 7548, 7549, 7571, 7585,
  7586, 7589, 7590, 7595, 7610, 7611, 7616, 7621, 7624, 7659, 7662, 7635, 7653, 7639, 7642, 7643, 7645, 7658, 7656,
  7665, 7669, 7668, 7658, 7686, 7668, 7667, 7672, 7675, 7699, 7703, 7699, 7710, 7712, 7738, 7760, 7759, 7760, 7762,
  7763, 7770, 7789, 7791, 7782, 7779, 7782, 7779, 7802, 7795, 7791, 7808, 7809, 7821, 7822, 7829, 7830, 7853, 7859,
  7860, 7861, 7864, 7868, 7852, 7864, 7865, 7866, 7863, 7866, 7862, 7853, 7863, 7862, 7864, 7866, 7868, 7872, 7874,
  7875, 7895, 7894, 7896, 7887, 7891, 7890, 7891, 7888, 7889, 7904, 7905, 7901, 7922, 7912, 7911, 7912, 7911, 7914,
  7915, 7918, 7923, 7933, 7924, 7927, 7930, 7946, 7948, 7964, 7966, 7968, 7972, 7969, 7968, 7960, 7968, 7974, 7975,
  7974, 7953, 7950, 7944, 7949, 7955, 7953, 7954, 7956, 7959, 7961, 7962, 7964, 7968, 7969, 7985, 7991, 8006, 8007,
  8008, 8009, 8029, 8005, 8006, 8008, 8015, 8019, 8012, 8020, 8021, 8022, 8028, 8038, 8037, 8055, 8065, 8067, 8061,
  8088, 8095, 8099, 8100, 8102, 8105, 8092, 8093, 8097, 8102, 8111, 8112, 8130, 8141, 8137, 8140, 8156, 8157, 8165,
  8168, 8175, 8189, 8202, 8205, 8203, 8208, 8211, 8223, 8228, 8229, 8226, 8242, 8245, 8246, 8254, 8257, 8258, 8259,
  8264, 8269, 8270, 8271, 8272, 8259, 8264, 8267, 8284, 8285, 8297, 8299, 8300, 8301, 8305, 8306, 8307, 8308, 8310,
  8311, 8308, 8312, 8297, 8302, 8300, 8303, 8304, 8309, 8307, 8316, 8317, 8310, 8312, 8317, 8319, 8327, 8329, 8340,
  8329, 8339, 8338, 8339, 8345, 8335, 8332, 8348, 8349, 8350, 8349, 8351, 8364, 8365, 8368, 8371, 8372, 8384, 8386,
  8383, 8397, 8428, 8433, 8449, 8469, 8472, 8483, 8491, 8481, 8483, 8482, 8483, 8484, 8486, 8487, 8497, 8498, 8499,
  8501, 8509, 8514, 8517, 8516, 8518, 8526, 8528, 8505, 8509, 8523, 8524, 8525, 8526, 8531, 8518, 8517, 8520, 8521,
  8542, 8514, 8517, 8518, 8528, 8559, 8562, 8592, 8617, 8622, 8632, 8639, 8640, 8659, 8660, 8655, 8665, 8666, 8661,
  8679, 8687, 8688, 8676, 8704, 8711, 8710]

print("part 1: \(countLargerThanPrevious(measurements: input))")
print("part 2: \(countSlidingWindowLargerThanPrevious(measurements: input))")
