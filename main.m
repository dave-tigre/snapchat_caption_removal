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
Simple.bw = im2bw(Simple.pic, 0.5);
Simple.bw_edge = edge(Simple.bw,'canny');
[H,T,R] = hough(Simple.bw_edge);

% imshow(H,[],'XData',T,'YData',R,...
%             'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% 
% 
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
% plot(x,y,'s','color','white');


lines = houghlines(Simple.bw_edge,T,R,P,'FillGap',5,'MinLength',30);
figure; h1 = imshow(Simple.pic); hold on;
max_len = 0;
snaplines_y = [];

for k = 1:length(lines)
    
    if lines(k).theta ~= -90 % Added this to cancel out and non horizontal lines
       continue; 
    end
    
   xy = [lines(k).point1; lines(k).point2];
    xy(2,1)=750;
    xy(1,1) = 0;
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   snaplines_y(length(snaplines_y)+1) = lines(k).point2(2);

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

Simple.pic_adjusted = Simple.pic;
for t = snaplines_y(2):snaplines_y(1)
    Simple.pic_adjusted(t,:,:) = Simple.pic(t,:,:) + 15;
end
figure;
imshow(Simple.pic_adjusted);
% hold on 
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');