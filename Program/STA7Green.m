function STA7Green(a,AllCalc,amp,bg)
%%
%varargin{1} = percent baseline cut e.g. 0.75
%varargin{2} = intensity upscale after cut e.g. 1.75
%must have both or none!
        typestart=401;
    typeend=1001; %1001   
    Img =  AllCalc{1,typestart}
    [M, N] = size(Img);
Imgmax = zeros(M,N);       
allcandles = cat(3, AllCalc{1,101:401});   
for r = 1:M
    for c = 1:N
        Imgmax(r,c) = max(allcandles(r,c,:));
    end
end
maxinum = max(max(Imgmax))
if bg > 0
    times = (2^amp)/5000%maxinum
else
    times = amp/15000
end
    Img1 = zeros(M,N,3);
    

        mkdir (['D:\test\' num2str(a) '_edited_7']);
        Img0=imgaussfilt(Img,100);
            for n=typestart:1:typeend
        Img = AllCalc{1,n-400};%imread(['D:\test\' num2str(a) '_edited_4\' num2str(a) '_' num2str(n) '.tif'],'tif');
        if bg > 0
            Img=Img-Img0*bg;
        end
        Img1(:,:,2) = Img;
        imwrite(imgaussfilt(Img1*times,1),['D:\test\' num2str(a) '_edited_7\' num2str(a) '_' num2str(n) '.png'],'png');
            
            end
        
end