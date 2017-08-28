addpath F:\ѧϰ����\���ѧϰ\R-CNN\data2\traindata\ѵ������
tic;
%testImage = imread('F:\ѧϰ����\���ѧϰ\R-CNN\data2\�ֶ�λ���ͼƬ\8.jpg');
load cifar10NetRCNN_bank.mat
[fn,pn,fi]=uigetfile('*.jpg','ѡ��ͼƬ');
testImage=imread([pn fn]);%����ԭʼͼ��

[bboxes, score, ~] = detect(cifar10NetRCNN_bank, testImage);
[score, idx] = max(score);
bbox = bboxes(idx, :);
annotation = sprintf('Confidence = %f', score);

outputImage = insertObjectAnnotation(testImage, 'rectangle', bbox, annotation);
disp(score)

figure
imshow(outputImage)
toc;