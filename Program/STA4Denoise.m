function [AllDenoised] = STA4Denoise(a,AllData,createf)   
%%

typestart = 401;
typeend = 1001;
Img = AllData{1,typestart};
[M, N] = size(Img);
% AllDenoised
tic
   AllDenoised = cell(1,601);
   %
   tic
findr = zeros(M,N);
for i = 1:M
    for j = 1:N
        pdata0 = [];
        for f = 1:601
            pdata0 = [pdata0; double(AllData{1,f}(i,j))];
        end
        %
        %
        idx =isnan(pdata0);
        pdata0(idx) = 0;
        pden = pdata0;
        
        for f = 3:601-2
            pden(f) = (pdata0(f-2)+2*(pdata0(f-1))+3*pdata0(f)+pdata0(f+1)+2*(pdata0(f+2)))/9;
        end
        s1x = [1:100]'; s1y = pden(1:100);
        num = (pden == max(pden(100:450)));
        [mac] = find(num);
        mac = mac(1);
        s2x = [101:mac]'; 
        s3x = [mac+1:601]'; s3y = pden(mac+1:601);
        fitresult1 = polyfit(s1x,s1y,1);
        s1y = fitresult1(1)*s1x+fitresult1(2);
        s1y = ones(length(s1x),1)*mean(s1y);
        B = maxk(pden,15);
        allloc = [];
        loci=1;
        while length(allloc)<15
            loc= find(pden == B(loci));
            allloc = [allloc;loc];
            loci = loci+1;
        end
        allloc=allloc(1:15);
        distance = abs(allloc-allloc(1));
        
        if mean(mink(distance,10))+ std(mink(distance,10)) < 100
            findr(i,j) = 1;
            [s3xd,x3yd] = prepareCurveData(s3x,s3y);
            fitresult3 = fit(s3xd,x3yd,'exp2','Normalize','on');
            k2 = (fitresult3(mac)- (fitresult1(1)*100+fitresult1(2)))/(mac-100);
            s2y = s1y(1)+k2*(s2x-100);
            s3y = fitresult3(s3x);
            for f = 2: length(s3y)
                    if s3y(f) > s3y(f-1)
                        s3y(f) = s3y(f-1);
                    end
            end
            for f = 1: length(s3y)
                    if s3y(f) < mean(s1y)
                        s3y(f) = mean(s1y);
                    end
            end
            %for f = 2: length(s3y)-mac+1
            %    if s3y(f) > s3y(f-1)
            %        s3y(f:length(s3y)) = s3y(f-1);
            %    end
            %end
            X = [s1x;s2x;s3x];
            Y = [s1y;s2y;s3y];
        else
            X = [1:601]';
            Y = ones(601,1)*mean(s1y);
        end
        %
        for k = 1:601
           AllDenoised{1,k}(i,j) = Y(k);
        end
    end
    plot(X,Y,'k*')
    hold on
    plot(pdata0)
    plot(allloc,B,'ro')
    disp(i)
    toc
    mean(mink(distance,10))
    std(mink(distance,10))
end
    %%
    dirname = num2str(createf);

    mkdir (['D:\test\' num2str(a) '_edited_' dirname '\']);
    %
for frame = 1:601
    fimg = double(AllDenoised{1,frame});
    gimg = imgaussfilt(fimg,1);
    
    fimg(findr==0) = gimg(findr==0);
    fimg1 = medfilt2(fimg,[3 3]);
    df = ((fimg - fimg1)./fimg).^2;
    fimg2 = fimg;
    fimg2(3:M-3,3:N-3)= fimg1(3:M-3,3:N-3);
    fimg(df>0.02*0.02) = fimg2(df>0.02*0.02);
%imwrite(uint16(imgaussfilt(fimg,1)),['D:\test\' num2str(a) '_edited_' dirname '\' num2str(a) '_' num2str(frame+400) '.tif'],'tif');
imwrite(uint16(fimg),['D:\test\' num2str(a) '_edited_' dirname '\' num2str(a) '_' num2str(frame+400) '.tif'],'tif');

end
end