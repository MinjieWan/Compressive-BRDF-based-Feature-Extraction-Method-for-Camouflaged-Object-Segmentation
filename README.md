# Compressive-BRDF-based-Feature-Extraction-Method-for-Camouflaged-Object-Segmentation

This repository contains the codes for paper Compressive Bidirectional Reflection Distribution Function-Based Feature Extraction Method for Camouflaged Object Segmentation by Xueqi Chen, Yunkai Xu, Ajun Shao, Xiaofang Kong, Qian Chen,2, Guohua Gu* and Minjie Wan*. (*Corresponding author). More details are available at https://www.mdpi.com/2304-6732/9/12/915.

Provided in the 'images' folder are multi-angles photos taken by black-and-white camera. The ground truth images are also in this folder.

Provided in the 'procedure' folder is the camouflaged object segmentation algorithm program proposed in this paper. The programs of comparison algorithms are also in this folder. The programs should be run using Matlab.

Provided in the 'results' folder are result images of the proposed method and comparison methods. We provide a program to calculate the performance (probability and false alarm rate) of the result images in the 'procedure' folder.

## Requirements
 - Matlab 2012b

## Usage
 - Download and release Segmentation.zip.
 - Set the path of the 'procedure ' folder as the working directory of Matlab.
 - Modify the filenames in the program based on where the images is actually stored.
 - run main_M1.m for training or testing.
