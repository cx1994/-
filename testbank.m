addpath F:\学习资料\深度学习\R-CNN\data2\traindata\训练网络
tic;
%testImage = imread('F:\学习资料\深度学习\R-CNN\data2\粗定位后的图片\8.jpg');
load cifar10NetRCNN_bank.mat
[fn,pn,fi]=uigetfile('*.jpg','选择图片');
testImage=imread([pn fn]);%输入原始图像

[bboxes, score, ~] = detect(cifar10NetRCNN_bank, testImage);
[score, idx] = max(score);
bbox = bboxes(idx, :);
annotation = sprintf('Confidence = %f', score);

outputImage = insertObjectAnnotation(testImage, 'rectangle', bbox, annotation);
disp(score)

figure
imshow(outputImage)
toc;