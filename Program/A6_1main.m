%% Image Processing:6. align_dec_denoise_morph_baseline_calc
% Run jerky(a) for 3D image
typestart=401;
typeend=1001;
%
for i = [2]
tic
% 1. Alignment: _edited_1
    %STA1Align(i,typestart,typeend)

%% 2. Deconvolution: _edited_2
    STA2Deconvolution(i);
    AllDeconvolved = cell(1,601);
    for f = 401:1001
        Img0 = double(imread(['D:\test\' num2str(i) '_edited_2\' num2str(i) '_' num2str(f) '.tif'],'tif'));
        AllDeconvolved{1,f-400} = Img0;
        
    end
    STA3BaselineAdjust(i,AllDeconvolved)
%% 4. Denoise: edited_4 
    AllBAdjusted = cell(1,601);
    for f = 401:1001
        Img0 = double(imread(['D:\test\' num2str(i) '_edited_3\' num2str(i) '_' num2str(f) '.tif'],'tif'));
        AllBAdjusted{1,f-400} = Img0;
    end  
    STA4Denoise(i,AllBAdjusted,4);
%% 5. dF Color Image: edited_5
 i = 14;
    AllDenoised = cell(1,601);
    for f = 401:1001
        Img0 = double(imread(['D:\test\' num2str(i) '_edited_4\' num2str(i) '_' num2str(f) '.tif'],'tif'));
        AllDenoised{1,f-400} = Img0;
    end
    [M,N] = size(Img0);
    Img0 = zeros(M,N);
    for f = 25:74
        Img0 = Img0 +AllDenoised{1,f};
    end
    Img0 = Img0/50;
    [AllCalc] = STA5Calc(i,AllDenoised,Img0,'5',9,0.03);%
    AllImage_5(i,:)= AllCalc;
%

% 6. Make Color Image
    amp = 10;
    cutoff5 = 0.03;
    cutoff6 = 0.00;
    STA6Color(i,AllCalc,AllDenoised,amp,cutoff5,cutoff6,0.91,'6') 

%%
% 7. Make Green Image
%
        AllDenoised = cell(1,601);
    for f = 401:1001
        Img0 = double(imread(['D:\test\' num2str(i) '_edited_4\' num2str(i) '_' num2str(f) '.tif'],'tif'));
        AllDenoised{1,f-400} = Img0;
    end
    STA7Green(i,AllDenoised,2.9,0.91)

%
      im2avi(['D:\test\',num2str(i),'_edited_7'],[num2str(i) '_*.png'],...
           ['D:\test\' num2str(i) '_greenmovie.avi'],50)
% Time series
    im2avi(['D:\test\',num2str(i),'_edited_6'],[num2str(i) '_*.bmp'],...
       ['D:\test\' num2str(i) '_colormovie.avi'],50)
disp(i)
toc
end