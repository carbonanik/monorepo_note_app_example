
// class Solution {
//   int numSub(String s) {
//     const mod = 1000000007;
//     var continuesOne = 0;
//     // var continuesSubstring = 0;
//     var totalSubstring = 0;
//     for (int i = 0; i < s.length; i++) {
//       if (s[i] == '1') {
//         continuesOne = continuesOne + 1;
//         // continuesSubstring = continuesSubstring + continuesOne;
//         totalSubstring = (totalSubstring + continuesOne) % mod;
//       } else if (s[i] == '0') {
//         // reset
//         continuesOne = 0;
//         // continuesSubstring = 0;
//       }
//       print('->$continuesOne : $totalSubstring');
//     }
//     return totalSubstring;
//   }
// }

// class Solution {
//   bool isPalindrome(String s) {
//     var start = 0;
//     var end = s.length - 1;
//     while (start < end) {
//       if (s[start] != s[end]) {
//         return false;
//       }
//       start++;
//       end--;
//     }
//     return true;
//   }

//   String removeNonAlphanumeric(String input) {
//     return input.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
//   }
// }

// class Solution {
//   int wateringPlants(List<int> plants, int capacity) {
//     var steps = 0;
//     var bucket = capacity;
//     var i = 0;

//     while (i < plants.length) {
//       if (i == 0) {
//         // 0 index
//         steps = steps + 1;
//         bucket = bucket - plants[i];
//         print(steps);
//       } else {
//         // Other index
//         // if bucket has the amount of water that the plant needs
//         if (bucket >= plants[i]) {
//           bucket = bucket - plants[i];
//           steps = steps + 1;
//         } else {
//           // if bucket does not have the water

//           // refill the bucket
//           bucket = capacity;

//           // the steps i need to travel
//           // 2 * i + 1;
//           steps = 2 * i + 1;

//           // reduce the water from the bucket
//           bucket = bucket - plants[i];
//         }
//       }

//       i++;
//     }

//     return steps;
//   }
// }

// Input: nums = [1,0,0,0,1,0,0,1], k = 2
// Output: true
// Explanation: Each of the 1s are at least 2 places away from each other.

class Solution {
  bool kLengthApart(List<int> nums, int k) {
    var currentDistance = k;
    for (var i = 0; nums.length > i; i++) {
      var num = nums[i];
      if (num == 0) {
        currentDistance += 1;
      } else {
        if (currentDistance < k) {
          return false;
        }
        currentDistance = 0;
      }
    }
    return true;
  }
}

void main() {
  var so = Solution();
  var s1 = [1, 0, 0, 0, 1, 0, 0, 1];
  var s2 = [1, 0, 0, 1, 0, 1];
  print(so.kLengthApart(s1, 2));
  print(so.kLengthApart(s2, 2));
}
