 % Overlay color image on one frame
a = 1;
slice = 516;
img = imread(['D:\test\' num2str(a) '_edited_4\' num2str(a) '_401.tif']);
[M,N]=size(img);
bg = imgaussfilt(img,100);
img = img-bg;%min(min(img));
figure(18)
imshow(uint16(img*2^1))

hold on
[img,cmap] = imread(['D:\test\' num2str(a) '_edited_6\' num2str(a) '_' num2str(slice) '.bmp']);
img = ind2rgb(img,cmap);


r = img(:,:,1);
%bw = r>0;
bw = or(sum(img,3) > 0.8,r>0);        % a binary image to overlay
mask = cast(bw, class(img)); 
% ensure the types are compatible
img_masked = (img) .* repmat(mask, [1 1 3]);  % apply the mask
%imshow(img_masked);
imwrite(img_masked, '10_515bmp_transparant.png', 'Transparency', [0 0 0]);
   mask = double( any(img_masked, 3) );
   image(img_masked, 'AlphaData', mask )
   %
   axis tight equal
%set(gca,'xtick',[])
%set(gca,'visible','off')
%axis off
%grid off
%set(gcf, 'Position', get(0, 'Screensize'));
hold on
%% Two images
%a = 10;
%slice = 505;
%img = imread(['D:\test\' num2str(a) '_edited_4\' num2str(a) '_401.tif']);
%img = img-min(min(img));
%imshow(uint16(img*2^3.5))

%hold on
%[img,cmap] = imread(['D:\test\' num2str(a) '_edited_6\' num2str(a) '_' num2str(slice) '.bmp']);
%%img = ind2rgb(img,cmap);
%[img2,cmap2] = imread(['D:\test\' num2str(a) '_edited_6\' num2str(a) '_' num2str(502) '.bmp']);
%%img2 = ind2rgb(img2,cmap2);
%img = double(img>img2).*double(img) + double(img<img2).*double(img2);
%img = ind2rgb(img,cmap);

%r = img(:,:,1);
%%bw = r>0;
%bw = or(sum(img,3) > 1 ,r>0);        % a binary image to overlay
%mask = cast(bw, class(img)); 
% ensure the types are compatible
%%img_masked = (img) .* repmat(mask, [1 1 3]);  % apply the mask
%%imshow(img_masked);
%imwrite(img_masked, '10_515bmp_transparant.png', 'Transparency', [0 0 0]);
%   mask = double( any(img_masked, 3) );
%   image(img_masked, 'AlphaData', mask )
%   %
%   axis tight equal
%%set(gca,'xtick',[])
%%set(gca,'visible','off')
%%axis off
%%grid off
%set(gcf, 'Position', get(0, 'Screensize'));
hold on
