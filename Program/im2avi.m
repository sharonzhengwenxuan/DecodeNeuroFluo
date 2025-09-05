function im2avi(path,fmt,out,framerate) 
%im2avi('P:\test\1_edited_4','1_*.bmp','P:\test\1_colormovie.avi',10)

%watch tif vs bmp?

% Syntax: im2avi(path,fmt,out,framerate)
%     path - folder containing the image sequences
%     fmt - format of the images
%     out - name of the output video file
%     framerate - The framerate of the output video

%for a = 1:4
%im2avi(['P:\test\' num2str(a) '_edited_4'],[num2str(a) '_*.bmp'],['P:\test\' num2str(a) '_colormovie.avi'],10)
%disp(a)
%end

fils = dir([path '/' fmt]);
fmt2 = strrep(fmt, '*', '%d');
number = zeros(1, length(fils) );

for i = 1:length(fils)
    number(i) = sscanf(fils(i).name, fmt2);
end

[~,neworder] = sort(number);

outVideo = VideoWriter(out);
outVideo.FrameRate = framerate;

open(outVideo);
pattern = ".bmp";
extension = endsWith(fmt,pattern);
if extension == 1
    for i = neworder 
    %    colormap(jet)
       [X, jet] =  imread([path '/' fils(i).name]);
       img = ind2rgb(X,jet);
       writeVideo(outVideo,img); 
    end

else
    for i = neworder 
       img =  imread([path '/' fils(i).name]);
       writeVideo(outVideo,img); 
    end
end

close(outVideo);
end