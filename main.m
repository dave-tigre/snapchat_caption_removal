%% ECES 435 Snapchat Remove Caption Project
% Matt Giovannucci
% David Tigreros
clc; clear; close all;

%% Project Code 
Simple.pic = imread('Simple.JPG');

figure;
subplot(1,2,1);
imshow(Simple.pic);

logfilter = fspecial('log');
Simple.pic_edge = imfilter(Simple.pic,logfilter);

subplot(1,2,2);
Simple.pic_edge_gray = rgb2gray(Simple.pic_edge);
Simple.pic_edge_bw = im2bw(Simple.pic_edge_gray,0.4);

% Simple.pic_edge_bw = im2bw(Simple.pic_edge,.2);
imshow(Simple.pic_edge_bw);


% labels = regionprops(Simple_pic_edge,'Area');
% labels_bw = bwlabel(Simple_pic_edge);
