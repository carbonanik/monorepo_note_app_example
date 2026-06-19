// class Solution {
//   double findMedianSortedArrays(List<int> nums1, List<int> nums2) {
//     List<int> marge = [];

//     while (nums1.isNotEmpty || nums2.isNotEmpty) {
//       if (nums1.isEmpty) {
//         marge.addAll(nums2);
//         break;
//       }
//       if (nums2.isEmpty) {
//         marge.addAll(nums1);
//         break;
//       }

//       if (nums1.first < nums2.first) {
//         var temp = nums1.first;
//         nums1.removeAt(0);
//         marge.add(temp);
//       } else {
//         var temp = nums2.first;
//         nums2.removeAt(0);
//         marge.add(temp);
//       }
//     }

//     print(marge);

//     if (marge.length.isOdd) {
//       int mi = (marge.length) ~/ 2;
//       return marge[mi].toDouble();
//     } else {
//       int ri = marge.length ~/ 2;
//       int li = ri - 1;
//       double rv = marge[ri].toDouble();
//       double lv = marge[li].toDouble();

//       return (rv - lv) / 2 + lv;
//     }
//   }
// }

// [1,0,0]
// [1,1,1,0]
// class Solution {
//   bool isOneBitCharacter(List<int> bits) {
//     var _2bitStart = false;
//     var _1bitChar = false;
//     for (var i = 0; i < bits.length; i++) {
//       var bit = bits[i];

//       if (bit == 1 && !_2bitStart) {
//         // 2 bit character start
//         _2bitStart = true;
//         _1bitChar = false;
//       } else {
//         if (_2bitStart) {
//           // 2 bit character end
//           _1bitChar = false;
//         } else {
//           // 1 bit character
//           _1bitChar = true;
//         }
//         _2bitStart = false;
//       }
//     }
//     return _1bitChar;
//   }
// }

// class Solution {
//   List<String> invalidTransactions(List<String> transactions) {
//     List<String> invalid = [];
//     List<Tx> byName = [];

//     for (var t in transactions) {
//       var parts = t.split(',');
//       var tx = Tx(
//         parts[0],
//         int.parse(parts[1]),
//         int.parse(parts[2]),
//         parts[3],
//         t,
//       );
//       byName.add(tx);
//     }

//     for (var name in byName.keys) {
//       var txs = byName[name]!;
//       for (var i = 0; i < txs.length; i++) {
//         var tx = txs[i];

//         for (var j = i + 1; j < txs.length; j++) {
//           var other = txs[j];
//           if (tx.city != other.city && (other.time - tx.time).abs() <= 60) {
//             invalid.add(tx.raw);
//             invalid.add(other.raw);
//           }
//         }

//         if (tx.amount > 1000 && invalid.contains(tx.raw) == false) {
//           invalid.add(tx.raw);
//         }
//       }
//     }

//     return invalid.toList();
//   }
// }

// class Tx {
//   String name;
//   int time;
//   int amount;
//   String city;
//   String raw;

//   Tx(this.name, this.time, this.amount, this.city, this.raw);
// }

// class Solution {
//   int triangleNumber(List<int> nums) {
//     nums.sort();
//     int count = 0;
//     int n = nums.length;

//     for (int k = n - 1; k >= 2; k--) {
//       int i = 0;
//       int j = k - 1;

//       while (i < j) {
//         if (nums[i] + nums[j] > nums[k]) {
//           // all numbers between i and j with nums[j] will also work
//           count += (j - i);
//           j--;
//         } else {
//           i++;
//         }
//       }
//     }

//     return count;
//   }
// }

main() {
  // var sol = Solution();
  // print(sol.triangleNumber([2, 2, 3, 4]));
}
