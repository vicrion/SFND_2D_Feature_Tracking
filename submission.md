## Write-up

### MP.1 Data Buffer Optimization

The usage of `std::vector` could be left as-is and instead we can iterate on the index and keep track of `current` vs. `previous` using `imgIndex % bufferSize` formula. The vector is pre-allocated beforehand. Alternatively, `std::array` could be used in the same manner. 

Reference: [github](https://github.com/vicrion/SFND_2D_Feature_Tracking/blob/master/src/MidTermProject_Camera_Student.cpp#L40), or refer to L40 within `MidTermProject_Camera_Student.cpp`.

### MP.2 Keypoint Detection

OpenCV provides implementation for each of the detectors.

Reference: [github](https://github.com/vicrion/SFND_2D_Feature_Tracking/blob/master/src/matching2D_Student.cpp#L222) or refer to L222 of `matching2D_Student.cpp`.

### MP.3 Keypoint Removal

`cv::Rect::contains()` was used for ROI selection for a list of detections.

Reference: [github](https://github.com/vicrion/SFND_2D_Feature_Tracking/blob/master/src/MidTermProject_Camera_Student.cpp#L106) or refer to L106 of `MidTermProject_Camera_Student.cpp`.

### MP.4 Keypoint Descriptors

OpenCV provides implementation for each of the descriptors.

Reference: [github](https://github.com/vicrion/SFND_2D_Feature_Tracking/blob/master/src/matching2D_Student.cpp#L56) or refer to L56 of `matching2D_Student.cpp`.

### MP.5 Descriptor Matching

OpenCV provides implementation using type `cv::DescriptorMatcher::FLANNBASED`, as well as `knnMatch()`.

Reference: [github](https://github.com/vicrion/SFND_2D_Feature_Tracking/blob/master/src/matching2D_Student.cpp#L19) or refer to L19 of `matching2D_Student.cpp`.

### MP.6 Descriptor Distance Ratio

The `ratioThreshold` can be used for K-nn based matched points using the formula: `distance_best < ratio * distance_secondbest`.

Reference: [github](https://github.com/vicrion/SFND_2D_Feature_Tracking/blob/master/src/matching2D_Student.cpp#L47) or refer to L47 of `matching2D_Student.cpp`.

### MP.7 Performance Evaluation 1

The distribution of the neighborhood size of all the detectors:

* Not all of the detectors are scale invariant. For some the scale is fixed (HARRIS, FAST). 
* For dynamic environment it is best to have scale invariance as inherent design into feature detection.

After this step, it makes sense to narrow down to: BRISK, ORB, AKAZE, SIFT.

### MP.8 Performance Evaluation 2

Number of matched keypoints using all combinations of detectors and descriptors (BF matching with the descriptor distance ratio of 0.8):

* Average points per all iterations is presented.

* BRISK-BRIEF: 145
* BRISK-ORB: 110
* BRISK-FREAK: 122
* BRISK-AKAZE: -
* BRISK-SIFT: 181 (flann)

* ORB-BRIEF: 51
* ORB-ORB: 86
* ORB-FREAK: 42
* ORB-AKAZE: -
* ORB-SIFTR: 89

* AKAZE-BRIEF: 137
* AKAZE-ORB: 129
* AKAZE-FREAK: 130
* AKAZE-AKAZE: 139
* AKAZE-SIFT: 138

* SIFT-BRIEF: 76
* SIFT-ORB: -
* SIFT-FREAK: 65
* SIFT-AKAZE: -
* SIFT-SIFT: 88

Most of the combinations are viable options at this step, the AKAZE descriptor implementation requires the same type of the detector. All of the combinations presented a good number of matches, otherwise.

### MP.9 Performance Evaluation 3

Time for keypoint detection - descriptor extraction.

* Rough average is presented using local system for tests.
* The above table is copied and expanded

Pair combination - number of points - time, msec.
---
* BRISK-BRIEF: 145 - 0.75
* BRISK-ORB: 110 - 3.4
* BRISK-FREAK: 122 - 25
* BRISK-AKAZE: -
* BRISK-SIFT: 181 (flann) - 21.5

* ORB-BRIEF: 51 - 0.7
* ORB-ORB: 86 - 5.9
* ORB-FREAK: 42 - 28
* ORB-AKAZE: -
* ORB-SIFT: 89 - 31

* AKAZE-BRIEF: 137 - 0.67
* AKAZE-ORB: 129 - 2.29
* AKAZE-FREAK: 130 - 25
* AKAZE-AKAZE: 139 - 40
* AKAZE-SIFT: 138 - 17

* SIFT-BRIEF: 76 - 0.75
* SIFT-ORB: -
* SIFT-FREAK: 65 - 31
* SIFT-AKAZE: -
* SIFT-SIFT: 88 - 57

### Suggestions

* Number of points: it is probable best to pick a value in the middle as too many points can indicate increased computational time for further processing; or we could even choose from lower numbers. 
* Computation time: we want to minimize as much as possible.
* Combination: it is likely the same type of detector-descriptor to perform better in practice as they were originally designed as a whole (unless they are re-implemented to work together). There could be some OpenCV implementation details that favor such combination and makes it more robust.
* License: SIFT might be difficult to use for its licence restrictions.

**Suggestions for performance**: ORB-BRIEF, AKAZE-BRIEF, BRISK-ORB.

**Suggestions for robustness**: ORB-ORB, AKAZE-AKAZE.

**Overall top**: ORB-BRIEF or ORB-ORB.
