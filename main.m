%% ECES 435 Snapchat Remove Caption Project
% Matt Giovannucci
% David Tigreros
clc; clear; close all;

%% Project Code 
% Simple.pic = imread('Simple.JPG');
Simple.pic = imread('desk.jpeg');

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


lines = houghlines(Simple.bw_edge,T,R,P,'FillGap',5,'MinLength',300);
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
% %    len = norm(lines(k).point1 - lines(k).point2);
% %    if ( len > max_len)
% %       max_len = len;
% %       xy_long = xy;
% %    end
end


Simple.pic_adjusted = Simple.pic;
R_adj = [];
G_adj = [];
B_adj = [];

% Take random pixels from above and below the snap bar and averages them to
% increase the intensity of part with the bar
col_num = ceil(rand(1,5)*size(Simple.pic,2)+1)-1;
row_num = ceil(rand(1,5)*5+1)-1 + snaplines_y(1);
row_num_bar = ceil(rand(1,5)*(abs(diff(snaplines_y)))+1)-1 + snaplines_y(2);


R_adj = Simple.pic(row_num,col_num,1) - Simple.pic(row_num_bar,col_num,1);
G_adj = Simple.pic(row_num,col_num,2) - Simple.pic(row_num_bar,col_num,2);
B_adj = Simple.pic(row_num,col_num,3) - Simple.pic(row_num_bar,col_num,3);

R_adj_scale = round(mean(R_adj));
R_adj_scale = round(mean(R_adj_scale)); % I Had to do all these twice for it
G_adj_scale = round(mean(G_adj));       % to actually take the mean idk why.
G_adj_scale = round(mean(G_adj_scale));
B_adj_scale = round(mean(B_adj));
B_adj_scale = round(mean(B_adj_scale));

        
for t = snaplines_y(2):snaplines_y(1)
    if t == snaplines_y(2) || t == snaplines_y(1) % The borders of the bar aren't faded as much
        Simple.pic_adjusted(t,:,1) = Simple.pic(t,:,1) + round(R_adj_scale/2);
        Simple.pic_adjusted(t,:,2) = Simple.pic(t,:,2) + round(G_adj_scale/2);
        Simple.pic_adjusted(t,:,3) = Simple.pic(t,:,3) + round(B_adj_scale/2);
        continue;
    end
    Simple.pic_adjusted(t,:,1) = Simple.pic(t,:,1) + R_adj_scale;
    Simple.pic_adjusted(t,:,2) = Simple.pic(t,:,2) + G_adj_scale;
    Simple.pic_adjusted(t,:,3) = Simple.pic(t,:,3) + B_adj_scale;
end

figure; % Plot adjusted picture
imshow(Simple.pic_adjusted);
title('Adjusted Picture to try and take care of the caption Bar');
