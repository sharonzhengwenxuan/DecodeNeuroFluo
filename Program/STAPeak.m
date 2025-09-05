function [X, labels] = STAPeak(a,Imgmax,mode)
%%
rng('default')
Img0  = imread(['D:\test\' num2str(a) '_edited_6\' num2str(a) '_' num2str(401) '.bmp']);
[M,N] = size(Img0);
%%
if mode == 1
    Imgmax = Imgmax-min(min(Imgmax>0));

else
    aaImgmax = imgaussfilt(Imgmax,5);
    Imgmax = Imgmax-aaImgmax;
end
    Imgmax(Imgmax<0) = 0;
    times = 8/mean(Imgmax(Imgmax>0));
    Imgmax = round(Imgmax*times);
Xi = [];
Xj = [];
for i = 1:M
    for j = 1:N
            numone = round(Imgmax(i,j));
            for t = 1:numone
                Xi = [Xi;i];
                Xj = [Xj;j];
            end
        
    end
end
%%
X = [Xi,Xj,ones(length(Xi),1)];
if mode == 1
    minpts =  50; %115 for 15 when resolution is 8   50/1.4
    epsilon = 1.4; %(Controls the size of the group) 2
else
    minpts = 50; %115 for 15 when resolution is 8   50/1.4
    epsilon = 1.4; %(Controls the size of the group) 2
end
labels = dbscan(X,epsilon,minpts);
min(labels)
max(labels)
%%
figure(2)
colormap(jet)
surf(Imgmax')
shading interp
%set(gca,'xtick',[])
%set(gca,'visible','off')

hold on

end