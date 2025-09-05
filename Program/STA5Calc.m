function [AllCalc] = STA5Calc(a,All,Img0,dirname,amp,cutoff)
%%
    [M,N] = size(Img0);
AllCalc = cell(1,601);
Img400 = zeros(M,N);  
for f = 1:99
    Img400 = Img400 + All{1,f}/99;
end 
   for n=401:701
        d = All{1,n-400}- Img400;
        dImg = d./Img0; 
        dImg(isinf(dImg)|isnan(dImg)) = 0;
        AllCalc{1,n-400} =dImg;
   end
   %%
Imgmax = zeros(M,N);       
allcandles = cat(3, AllCalc{1,101:401});   
for r = 1:M
    for c = 1:N
        Imgmax(r,c) = max(allcandles(r,c,:));
    end
end
maxinum = max(max(Imgmax));

    mkdir (['D:\test\' num2str(a) '_edited_' dirname]);
    %
Imgdmax = zeros(M,N);
times =  round((2^amp)/maxinum)
    for n= 401:1001
        d = All{1,n-400}- Img400;
        %
        %
        dImg = d./Img0;
        dImg(isinf(dImg)|isnan(dImg)) = 0;
        AllCalc{1,n-400} =dImg;
        Img =  AllCalc{1,n-400};
        Img1=double(Img);
        Img1(Img1<0)=0;
        TF1 = isoutlier(Img1,'movmean',10,1);
        TF1 = double(TF1);
        TF2 = isoutlier(Img1,'movmean',10,2);
        TF2 = double(TF2);
        TF = TF1.*TF2;
        TF = 1-TF;
        Img1 = Img1.*TF-cutoff;
            imwrite(imgaussfilt(Img1*times,1),jet,['D:\test\' num2str(a) '_edited_' dirname '\' num2str(a) '_' num2str(n) '.bmp'],'bmp');
        
            %imwrite(Img1*times,jet,['D:\test\' num2str(a) '_edited_' dirname '\' num2str(a) '_' num2str(n) '.bmp'],'bmp');
    end
end

