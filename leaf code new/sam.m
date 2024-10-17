clc;
close all;
clear all;

I=imread('car.jpg');
imshow(I)
imp=imnoise(I,'salt & pepper',0.02);
imshow(imp);
inp22=im2bw(imp);
figure;
imshow(inp22);
title('Segmentation Image');