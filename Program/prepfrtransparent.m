% makes figure to transparent png:

%1) expand to fit axis in export on the figure
%2) run this program on figure 1 or 2
%3) copy transparent.png (in test) into a ppt 
%4) save as tif file
%5) into canvas.


fig = figure(3);
line;
set(gca,'Color',[0 1 0]);%green[0 1 0]
%original background
background = get(gcf, 'color'); 
%specify transparent background
 set(gcf,'color',[0.8 0.8 0.8]);% grey [0.8 0.8 0.8]
%create output file
set(gcf,'InvertHardCopy','off'); 
set(gca,'visible','off')
print('-dpng', 'D:\test\notTransparent.png');
%read image back in
cdata = imread('D:\test\notTransparent.png');
%write back out with setting transparency info
imwrite(cdata,'D:\test\transparent.png', 'png', 'BitDepth', 16, 'transparency', [0.8 0.8 0.8])%background)