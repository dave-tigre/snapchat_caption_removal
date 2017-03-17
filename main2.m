%% ECES 435 Snapchat Remove Caption Project
% Matt Giovannucci
% David Tigreros
clc; clear; close all;

%% Project Code 
% testImage.pic = imread('Simple.JPG');
testImage = imread('desk.jpeg');

imshow(testImage)
title('Original Image');




%% Houghline Transform to isolate caption box

testImage_bw = im2bw(testImage, 0.5);
testImage_bw_edge = edge(testImage_bw,'canny');
[H,T,R] = hough(testImage_bw_edge);

% imshow(H,[],'XData',T,'YData',R,...
%             'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% 
% 
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
% plot(x,y,'s','color','white');


lines = houghlines(testImage_bw_edge,T,R,P,'FillGap',5,'MinLength',300);
figure; h1 = imshow(testImage); hold on;
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

hold on

%% Contrast Adjustment to differentiate text
snap_box_bw = ~im2bw(testImage, 0.9);


blob_region = regionprops(snap_box_bw,'Area');
bw_label = bwlabel(snap_box_bw);


Rows = 74;
Col = 750;

for k = 1:Rows
    for j = 1:Col
        if(bw_label(k,j) ~= 1)
            bw_label(k,j) = 0;
        end
    end
        
end

max_reg = bw_label;
[B,L] = bwboundaries(max_reg);

hold on
max_y = snaplines_y(2);
min_y = snaplines_y(1);
max_x = 0;
min_x = 750;


for k = 1:size(B)
   boundary = B{k};
   
   if(and(boundary(:,1) > snaplines_y(2), boundary(:,1) < snaplines_y(1)) )
        plot(boundary(:,2), boundary(:,1), 'm', 'LineWidth', 1.5)
        % find highest and lowest y values
        if( max(boundary(:,1)) > max_y)
           max_y = max(boundary(:,1));
        end
        if(max(boundary(:,1)) < min_y)
           min_y = max(boundary(:,1));
        end

        % find highest and lowest x and y values
        if( max(boundary(:,2)) > max_x)
           max_x = max(boundary(:,2));
        end
        if(max(boundary(:,2)) < min_x)
           min_x = max(boundary(:,2));
        end
   end
   
end
title('Image with isolated text and caption box')

%% Inpaint the text with found values

% create polygon region to fill
fact = 10;
max_y = max_y+fact;
min_y = min_y-fact;
max_x = max_x+fact; 
min_x = min_x-fact;
diff_x = (max_x - min_x);
left_x = min_x - diff_x;
right_x = max_x + diff_x;

diff_y = (max_y - min_y);
mid_y = min_y + diff_y;

ro_x = [min_x max_x right_x max_x min_x left_x]
ro_y = [min_y min_y mid_y max_y max_y mid_y]

testImage_gray = rgb2gray(testImage);
J = regionfill(testImage_gray,ro_x,ro_y);
figure
imshow(J)

rgbTest = gray2rgb(J);

rgbTest = im2uint8(rgbTest);

% change the rgb values of the gray image image to be same as original
% except for what was in the caption bar
[ROW COL RGB] = size(testImage)
for i = 1:ROW
    for j = 1:COL
        
        if (not(and(i > snaplines_y(2), i < snaplines_y(1))))
            for c = 1:RGB
            rgbTest(i,j,c) = testImage(i,j,c);
            end
        end
        
    end
end

figure()
imshow(rgbTest)
title('Image with text removed')



