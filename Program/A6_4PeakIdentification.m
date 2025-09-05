%% Identify Peaks
i = 8;
cropborder= 0;
folder = 5;
nn=1;

Img0  = imread(['D:\test\' num2str(i) '_edited_' num2str(folder) '\' num2str(i) '_' num2str(401) '.bmp']);
[M,N] = size(Img0);
AllImage = zeros(M,N,601);
intensity = [];
for f = 401:1001
    Img0  = double(imread(['D:\test\' num2str(i) '_edited_' num2str(folder) '\' num2str(i) '_' num2str(f) '.bmp']));
    AllImage(:,:,f-400) = Img0;
    sliceintensity = sum(sum(Img0));
    intensity = [intensity;sliceintensity];
end
disp('maxspice')
maxspice = find(intensity==max(intensity(101:201)))+401;
maxspice = maxspice(1)
%Imgmax= imread(['D:\test\' num2str(i) '_edited_6\' num2str(i) '_' num2str(maxspice) '.bmp'],'bmp');
%Imgmax = double(Imgmax);
AllImage = zeros(M,N,601);

for f = maxspice-25:maxspice+25
    Img0  = double(imread(['D:\test\' num2str(i) '_edited_' num2str(folder) '\' num2str(i) '_' num2str(f) '.bmp']));
    AllImage(:,:,f-400) = Img0;
end
Imgmax = max(AllImage,[],3);
 [cooking, jet]  = imread(['D:\test\' num2str(i) '_edited_' num2str(folder) '\' num2str(i) '_' num2str(maxspice) '.bmp'],'bmp');
 %[cooking]  = imread(['D:\test\' num2str(i) '_edited_4\' num2str(i) '_' num2str(maxspice) '.tif'],'tif');
 %[TF1] = isoutlier(double(cooking),1);
 %[TF2] = isoutlier(double(cooking),2);
 % cooking = double(cooking).*double(TF1).*double(TF2);
 cooking = ind2rgb(cooking,jet);
figure(3)
    imshow(cooking)
    
   potato = imfreehand;
   wait(potato);
% create a mask and get coordinates
gravy = potato.createMask();
cellgravy = gravy;
Imgmax = Imgmax.*gravy;
surf(Imgmax)
%
[AllX, labels] = STAPeak(i,Imgmax,1);
AllPeak{i,1} = AllX;    
AllLabels{i,:} = labels;
figure(3)
gscatter(AllX(:,2),max(AllX(:,1))-AllX(:,1),labels);
axis equal
box off
%% Initial evaluation on if multiple peaks exist in one cluster
nump =[];
for selectpeak = 1:max(labels)
    select = (labels==selectpeak);
    select = [select select select];
    peakloc = AllX.*select;
    B = unique(peakloc,'rows');
    B( ~any(B,2), : ) = [];
    newImage = zeros(M,N);
    for p = 1:length(B(:,1))
        xi = B(p,1);
        xj = B(p,2);
        newImage(xi,xj)=1;
    end
    newImgmax = newImage.*Imgmax;
    [~, peaklabels] = STAPeak(i,newImgmax,2);
    nump = [nump; max(peaklabels)];
end
    peaknumloc = find(nump>1);
    maxnump = max(nump)
%% update label
newlabels = labels;
newAllX = AllX;
iteration = 0;
while maxnump>1
     for n = 1:length(peaknumloc)
        disp('n')
        disp(n)
        % Extract single peak for further analysis
        selectpeak = peaknumloc(n);
        select = (newlabels==selectpeak);
        select = [select select select];
        peakloc = newAllX.*select;
        B = unique(peakloc,'rows');
        B( ~any(B,2), : ) = [];
        newImage = zeros(M,N);
        for p = 1:length(B(:,1))
            xi = B(p,1);
            xj = B(p,2);
            newImage(xi,xj)=1;
        end
        newImgmax = newImage.*Imgmax;
        [peakX, peaklabels] = STAPeak(i,newImgmax,2);
        disp(max(peaklabels));
        % Getting rid of the original data
        nonselect= (newlabels~=selectpeak);
        newlabels = nonselect.*newlabels; 
        newAllX = nonselect.*newAllX;
        NEW = [newAllX newlabels];
        NEW( ~any(NEW,2), : ) = [];
        newlabels = NEW(:,4);
        newAllX = NEW(:,1:3);
        % Adding updated data
        newAllX = [newAllX;peakX];
        % fill in the original label with the first peak
        peak1 = find(peaklabels==1);
        newpeaklabels = peaklabels;
        newpeaklabels(peak1)= selectpeak;
        peakelse = find(peaklabels>1);
        if size(newlabels,1)== 0
            adjustment = 1;
        else
            adjustment = max(newlabels);
        end
        newpeaklabels(peakelse)= newpeaklabels(peakelse)+adjustment-1;
        newlabels = [newlabels;newpeaklabels];
     end
    nump =[];
    for selectpeak = 1:max(newlabels)
        select = (newlabels==selectpeak);
        select = [select select select];
        peakloc = newAllX.*select;
        B = unique(peakloc,'rows');
        B( ~any(B,2), : ) = [];
        newImage = zeros(M,N);
        for p = 1:length(B(:,1))
            xi = B(p,1);
            xj = B(p,2);
            newImage(xi,xj)=1;
        end
        newImgmax = newImage.*Imgmax;
        [~, peaklabels] = STAPeak(i,newImgmax,2);
        nump = [nump; max(peaklabels)];
    end
        peaknumloc = find(nump>1);
        maxnump = max(nump);
    disp('iteration')
    iteration = iteration+1
end


%%
figure(4)
newnew = [newAllX(newlabels>0,1),newAllX(newlabels>0,2),newlabels(newlabels>0)];
newnewnew = unique(newnew,'rows');
gscatter(newnewnew(:,2),newnewnew(:,1),newnewnew(:,3))
%%
newnewnewlabel = newnewnew(:,3);
numloc = [];
for peaknum = 1: max(newnewnewlabel)
    loc = find(newnewnewlabel(newnewnewlabel==peaknum));

    numloc = [numloc;length(loc)]
end
length(numloc(numloc<=12))
%%
noisepeak = find(numloc<=12);
for peaknum = 1:length(noisepeak)
    newnewnewlabel(newnewnewlabel==noisepeak(peaknum))=-1;
end
newnewnew1 = newnewnew(:,1); newnewnew1 = newnewnew1(newnewnewlabel>0);
newnewnew2 = newnewnew(:,2); newnewnew2 = newnewnew2(newnewnewlabel>0);
newnewnewlabel = newnewnewlabel(newnewnewlabel>0);
[~,~,newnewnewlabel] = unique(newnewnewlabel);
%%
finallabels = newlabels;
noisepeak = find(numloc<12);
for peaknum = 1:length(noisepeak)
   % if any(A(:) == 5);
    finallabels(finallabels==noisepeak(peaknum))=-1;
end
%%
figure(16)

img = imread(['D:\test\' num2str(i) '_edited_4\' num2str(i) '_' num2str(maxspice) '.tif']);
[M,N]=size(img);
img = img-min(min(img))*0.5;%imgaussfilt(img,50);%

imshow(uint16(img(1:M,1:N)*2^1))
%imshow(uint16(img(1+cropborder:M-cropborder,1+cropborder:N-cropborder)*2^4.5))

hold on
gscatter(newnewnew2,newnewnew1,newnewnewlabel,[],[],10);
%gscatter(newAllX(finallabels>0,2)-cropborder,newAllX(finallabels>0,1)-cropborder,finallabels(finallabels>0),[],[],10);
%gscatter(newAllX(:,1),newAllX(:,2),newlabels);
set(gca,'XColor', 'none','YColor','none')
axis equal
box off
axis off
hold off
%12+1+11 = 24

cellarea = sum(sum(double(cellgravy)))*0.1828*0.1828
density = max(newnewnewlabel)/cellarea*100
%%


newnewnewAllX = [newnewnew1,newnewnew2];

coordinate = [newnewnewAllX(1,:)];
coordinatelabel = [newnewnewlabel(1)];
for pixel = 2:length(newnewnewAllX)
    if sum(newnewnewAllX(pixel,:) ~= newnewnewAllX(pixel-1,:))>0
        coordinate = [coordinate; newnewnewAllX(pixel,:)];
        coordinatelabel = [coordinatelabel;newnewnewlabel(pixel)];
    end
end
%%
peakmax = [];
peakmaxlabel = [];
for peaki = 1:max(newnewnewlabel)
    coordinatei = coordinate(coordinatelabel == peaki,1:2);
    img0 = Imgmax.*0;
    for pixel = 1:length(coordinatei)
        img0(coordinatei(pixel,1), coordinatei(pixel,2)) = Imgmax(coordinatei(pixel,1), coordinatei(pixel,2));
    end
    [M,N]=find(img0 == max(max(img0)));
    peakmax = [peakmax;mean(M) mean(N)];
    peakmaxlabel = [peakmaxlabel;peaki];
end
%%
figure(17)

[img,jet] = imread(['D:\test\' num2str(i) '_edited_5\' num2str(i) '_' num2str(maxspice) '.bmp']);
imshow(ind2rgb(img,jet));
%imshow(uint16(img(1+cropborder:M-cropborder,1+cropborder:N-cropborder)*2^4.5))
    
hold on
%gscatter(newnewnew2,newnewnew1,newnewnewlabel,[],[],10);
%gscatter(newAllX(newlabels>0,2)-cropborder,newAllX(newlabels>0,1)-cropborder,newlabels(newlabels>0),[],[],10);

g = gscatter(peakmax(:,2),peakmax(:,1),peakmaxlabel,'w','*',10);
for gi = 1:max(peakmaxlabel);
    ggi = g(gi);
    ggi.LineWidth = 1;
end