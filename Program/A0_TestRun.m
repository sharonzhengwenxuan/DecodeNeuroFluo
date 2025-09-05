%% Image Processing:0. Direct
for i = [1]
    AllOriginal = cell(1,601);
    for f = 401:1001
        Img0 = double(imread(['D:\test\' num2str(i) '\' num2str(i) '_' num2str(f) '.tif'],'tif'));
        AllOriginal{1,(f-400)} = Img0;
    end
    [M,N] = size(Img0);
    Imgbase = zeros(M,N);
    for f = 1:99
        Imgbase = Imgbase + AllOriginal{1,f}/99;
    end 
    %[AllCalc] = STA5Calc(i,AllOriginal,Imgbase,'5',12,0.00);
     [AllCalc] = STA5Calc(i,AllOriginal,Imgbase,'5',9,0.00);
    AllImage_0(i,:)= AllCalc;

%
%im2avi(['D:\test\',num2str(i),'_edited_5'],[num2str(i) '_*.bmp'],...
%       ['D:\test\' num2str(i) '_colormovie.avi'],100)
end
