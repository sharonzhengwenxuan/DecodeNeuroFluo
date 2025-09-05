function [AllBAdjusted] = STA3BaselineAdjust(a,AllDeconvolved)   
%%

Img = double(imread(['D:\test\' num2str(a) '_edited_1\' num2str(a) '_' num2str(401) '.tif'],'tif'));
[M, N] = size(Img);
tic
w = warning ('off','all');
for i = 1:M
    for j = 1:N
        pdata = [];
        for f = 1:601
            pdata = [pdata; double(AllDeconvolved{1,f}(i,j))];
        end
        time = [1:99, 500:601]';
        signal = [pdata(1:99);pdata(500:601)]';
        flist={@(c,x) exp(c(1)*x),@(c,x) exp(c(2)*x)};
        [c,ab]=fminspleas(flist,[0,0], time, signal);
        x = [1:601];
        newbase = ab(1)*exp(c(1)*x) + ab(2)*exp(c(2)*x);
        for k = 1:601
            AllFactor{1,k}(i,j) = newbase(1)/newbase(k);
        end
    end
end
toc
plot(newbase)
hold on
plot(pdata)
plot(smoothdata(pdata)) 
%
AllBAdjusted = cell(1,601);
maxi = 0;
for f = 1:601
    frame = AllDeconvolved{1,f};
    factor = AllFactor{1,f};
    AllBAdjusted{1,f} = frame.*factor;
    ifmaxi = max(max(AllBAdjusted{1,f}));
    if ifmaxi > maxi
        maxi = ifmaxi;
    end
end
%
time = 1; %2^16/maxi;
    mkdir (['D:\test\' num2str(a) '_edited_3']);
      
i = 0;
 for n=401:1001
     i = i+1;
    Img0 = AllBAdjusted{1,i};
    imwrite(uint16(Img0*time),['D:\test\' num2str(a) '_edited_3\' num2str(a) '_' num2str(n) '.tif'],'tif');
 end
end