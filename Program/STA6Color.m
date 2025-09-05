% Calculate F6 (background adjusted color image) based on F5
function STA6Color(a,AllCalc,AllDenoised,amp,cutoff5,cutoff6,p,createf)
%AllDenoised = cell(1,601);
%    for f = 401:1001
%        Img0 = double(imread(['D:\test\' num2str(a) '_edited_4\' num2str(a) '_' num2str(f) '.tif'],'tif'));
%        AllDenoised{1,f-400} = Img0;
%    end
%    [M,N] = size(Img0);
%    Img0 = zeros(M,N);
%    for f = 25:74
%        Img0 = Img0 +AllDenoised{1,f};
%    end
%    Img0 = Img0/50;
%    [AllCalc] = STA5Calc(a,AllDenoised,Img0,'7',amp,0);    
    
Img0  = AllDenoised{1,1};
[M,N] = size(Img0)
Alld = zeros(M,N,601);
for f = 401:1001
    %Img0  = double(imread(['D:\test\' num2str(a) '_edited_5\' num2str(a) '_' num2str(f) '.bmp']));
    Img0 = AllCalc{1,f-400};
    Alld(:,:,f-400) = Img0;
end
Imgmax = max(Alld,[],3);
valid = double(Imgmax>cutoff5);
%valid(1:10,:) = 0;
%valid(:,1:10) = 0;
%valid(M-10:M,:) = 0;
%valid(:,N-10:N) = 0;
%% background calc
All = zeros(M,N,601);
for f = 401:1001
        Img0 = AllDenoised{1,f-400};
        
        All(:,:,f-400) = Img0;
end
bg = min(All(All>0),[],'all')*p % change to a more accurate background estimation
%%
    for f = 401:1001
        Img0 = AllDenoised{1,f-400};
        AllDenoised{1,f-400} = (Img0-bg).*valid;
    end
    [M,N] = size(Img0);
    Img0 = zeros(M,N);
    for f = 25:74
        Img0 = Img0 +AllDenoised{1,f};
    end
    Img0 = Img0/50;
    [AllCalc] = STA5Calc(a,AllDenoised,Img0,createf,amp,cutoff6);
end   
    
    
    