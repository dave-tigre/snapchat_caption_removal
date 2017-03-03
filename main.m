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

%% Houghline Transform
bin = im2bw(Simple.pic, 0.5);
%rotI = imrotate(bin,33,'crop');
BW = edge(bin,'canny');
%BW = im2bw(Simple.pic, 0.5);
[H,T,R] = hough(BW);

% imshow(H,[],'XData',T,'YData',R,...
%             'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% 
% 
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
% plot(x,y,'s','color','white');


lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',30);
figure, imshow(Simple.pic), hold on
max_len = 0;

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
    xy(2,1)=750;
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% hold on 
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');