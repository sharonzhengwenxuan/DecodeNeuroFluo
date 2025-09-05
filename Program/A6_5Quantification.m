% Calculate peak decay
%function [jackolantern] = pumpkintest(a)
%check your cat
%clear if used after prefrcont
 close all
a = 232;
folder = 4;
spice =531;
thresh=1;
   Origauto =0 %1 for bg subtract,0 for no adjustment
   maxpeakframe = 301;
   
AllDenoised = cell(1,601);
    for f = 401:1001
        Img0 = double(imread(['D:\test\' num2str(a) '_edited_' num2str(folder) '\' num2str(a) '_' num2str(f) '.tif'],'tif'));
        AllDenoised{1,f-400} = Img0;
    end

       AllDenoised_c = cat(3,AllDenoised{1:601});
   Origmax = max(AllDenoised_c,[],3);
   %%   
  % histObject = histogram(Origmax) 
  %  grid on;
% Get the bin values into their own separate variable.
  %  counts = histObject.Values;
  %  width = histObject.BinWidth;
  %  loc = find(counts == max(counts))-1;
%loc*width+histObject.BinLimits(1);

[cooking7, jet]  = imread(['D:\test\' num2str(a) '_edited_7\' num2str(a) '_' num2str(spice) '.png'],'png');
        f = figure('WindowState','maximized');
      
    imshow(cooking7);
    title('circle cell')
         [M,N] = size(cooking7);

   potato = imfreehand;
   wait(potato);
% create a mask and get coordinates
cellgravy = potato.createMask();
cellarea = sum(sum(double(cellgravy)))*0.1828*0.1828
%cellgravy = ones(M,N);
%type logistics---
 [cooking, jet]  = imread(['D:\test\' num2str(a) '_edited_6\' num2str(a) '_' num2str(spice) '.bmp'],'bmp');
 %[TF1] = isoutlier(double(cooking),1);
 %[TF2] = isoutlier(double(cooking),2);
 % cooking = double(cooking).*double(TF1).*double(TF2);
 cooking = ind2rgb(cooking,jet);

  [cooking5, jet5]  = imread(['D:\test\' num2str(a) '_edited_5\' num2str(a) '_' num2str(spice) '.bmp'],'bmp');
  cooking5 = ind2rgb(cooking5,jet5);

  %figure(2)
%imshow(cooking5)
        f = figure('WindowState','maximized');

    imshow(cooking)
    title('circle cell')
  %imshowpair(cooking5/3,cooking,'blend','Scaling','joint')  
   potato = imfreehand;
   wait(potato);
% create a mask and get coordinates
gravy = potato.createMask();
[rows,columns] = find(gravy);

rows(rows > M) = M;
rows(rows <= 0) = 1;
columns(columns > M) = M;
columns(columns <= 0) = 1;
    %%

     [M,N] = size(Img0);

    Img0 = zeros(M,N);
    for f = 25:74
        Img0 = Img0 +AllDenoised{1,f};
    end
    Img0 = Img0/50;
    if Origauto == 1
        %imshow(cooking7);
        %title('circle background')
        %potato = imfreehand;
        %wait(potato);
% create a mask and get coordinates
        %cellbg = potato.createMask();
        %cellbg = Img0.*double(cellbg);
        cellbg = Img0;
        disp('bg')
        Origauto = min(min(cellbg(cellbg>0)))*0.91
    end
        [M,N] = size(Img0);
    AllCalc = cell(1,601);
    Img400 = zeros(M,N);  
    for f = 1:99
        Img400 = Img400 + AllDenoised{1,f}/99;
    end 
   for n=401:1001
        d = AllDenoised{1,n-400}- Img400;
        dImg = (d)./(Img0); 
        dImg_bg = d./(Img0-Origauto);
        dImg(isinf(dImg)|isnan(dImg)) = 0;
        AllCalc{1,n-400} =dImg;
        dImg_bg(isinf(dImg_bg)|isnan(dImg_bg)) = 0;
        AllCalc_bg{1,n-400} =dImg_bg;
   end
  
   AllDenoised_c = cat(3,AllDenoised{1:601});
   Origmax = max(AllDenoised_c,[],3);
   AllCalc_c = cat(3,AllCalc{101:maxpeakframe}); % 101:301
     Imgmax=max(AllCalc_c,[],3);
    
   AllCalc_c_bg = cat(3,AllCalc_bg{101:301}); % 101:301
     Imgmax_bg=max(AllCalc_c_bg,[],3);
   %surf(Imgmax)
   %shading interp
   
Imgk  = imread(['D:\test\' num2str(a) '_edited_5\' num2str(a) '_' num2str(401) '.bmp']);
[M,N] = size(Imgk);
Alld = zeros(M,N,601);
for f = 401:1001
    Imgk  = double(imread(['D:\test\' num2str(a) '_edited_5\' num2str(a) '_' num2str(f) '.bmp']));
    Alld(:,:,f-400) = Imgk;
end
Imgmaxvalid = max(Alld,[],3);
valid = double(Imgmaxvalid>1);

notImgmax=Imgmax_bg.*valid;
notImgmax(~gravy)=0;

Imax= max(notImgmax(:));
[mar, mac] = find(ismember(notImgmax, max(notImgmax(:))));

if rem(length(mar),2) == 0
    mar(end)=[];
    mar = mar(1)
else
    mar = median(mar)
end

if rem(length(mac),2) == 0
    mac(end)=[];
    mac = mac(1)
else
    mac = mac(1)
end
    %find ma aka center point
%heyyy case?
jackolantern = [];
ImgInitial = double(imread(['D:\test\' num2str(a) '_edited_' num2str(folder) '\' num2str(a) '_' num2str(401) '.tif'],'tif'));
corelation = [];
for r = 1:M
    for c = 1:N
        if and(gravy(r,c)==1, Imgmax(r,c)~=0)
    %1 pixel = 0.1828 um, 
    um =(sqrt( ((c-mac(1,1)).^2) + ((r-mar(1,1)).^2) )) *0.1828; %distance from mac, mar in um
    
            if cellgravy(r,c) == 1
                candle = Imgmax_bg(r,c);
                pumpkin = horzcat(um, candle);    
                jackolantern = vertcat(jackolantern(), pumpkin);
                Initial = ImgInitial(r,c)-Origauto;
                corr = [Initial,Imgmax_bg(r,c)];
                corelation = [corelation;corr];
            else
                candle = Imgmax(r,c);
                pumpkin = horzcat(um, candle);    
                jackolantern = vertcat(jackolantern(), pumpkin);
            end

        else
        end
    end
end
halloween = [];
for i = 0:1:( floor(max(jackolantern(:,2))))
   
    [jackfind, ~] = find(jackolantern(:,2) >= i & ...
        jackolantern(:,2) < i+1);
    [nan, ~] = size(jackfind);
    if nan == 0
    else
       lantern = jackolantern(jackfind, 2); %y
       hallow = jackolantern(jackfind, 1); %um
       
        scary = mean(lantern(:,1)); %avg y point
        sleepy = mean(hallow(:,1)); %avg um
       
    dracula = sqrt( sum(jackolantern(:,2) >= i & ...
        jackolantern(:,2) < i+1) );
    abstinence = std(hallow(:,1));
    nightmare = abstinence ./ dracula; %std
    
    hallowseve = horzcat(sleepy, scary, nightmare);
    halloween = vertcat(halloween(), hallowseve); 
    end
end
% halloween = halloween.';
% jackolantern = jackolantern.';
% putsp(halloween)

%
%jacklaternall1 = [];
%for f = 1:601
%    framelatern = 0;
%    n = 0;
%    for r = 1:M
%        for c = 1:N
%            if gravy(r,c)==1
%        %1 pixel = 0.1828 um, 
%                um =(sqrt( ((c-mac(1,1)).^2) + ((r-mar(1,1)).^2) )) *0.1828; %distance from mac, mar in um
%                if um < 1
%                    framelatern = framelatern + AllDenoised{f}(r,c);
%                    n = n+1;
%                end
%            end
%        end
%    end
%    %disp(n)
%    jacklaternall1 = [jacklaternall1;framelatern/n];
%end
%jacklaternall1(1:100) = mean(jacklaternall1(25:74));
%jacklaternall1_subtract = jacklaternall1 -Origauto;
%jacklaternall1_final = (jacklaternall1_subtract-mean(jacklaternall1_subtract(25:74)))/mean(jacklaternall1_subtract(25:74));
%plot(jacklaternall1_final)
%
j1 = jackolantern(:,1);
j2 = jackolantern(:,2);
%j2(and(j2 < 0.000001,j2>-0.000001))=NaN;
% j1(isnan(j2))=NaN;
% j1(isnan(j1))=[];
% j2(isnan(j2))=[];
% plot(j1,j2,'*')
 ajackolantern = [j1,j2];
 %
 %dImg = zeros(M,N);
 %       dImg(:,:) = double(Origmax)-Img400;
 %       current = dImg/Img0;
 %       adjusted = dImg/(Img0-Origauto);
        
%times = adjusted(mar,mac)/current(mar,mac)
dImg = Origmax(mar,mac)- Img400(mar,mac);
current = dImg/Img0(mar,mac)
adjusted = dImg/(Img0(mar,mac)-Origauto)
times = 1;%adjusted/current;
%
XX = [ajackolantern(:,1)];
YY = [ajackolantern(:,2)]*  times;
corelation(:,2) = corelation(:,2)*times;
locXX = find(XX<8);
XX = XX(locXX); 
YY = YY(locXX);
jacktotal = [XX,YY];
loc = find(YY==0);
weight = ones(numel(YY),1);
weight(loc) = 0;
myfittype = fittype('a*exp(-b*x)+c', 'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b','c'})
    %myfittype = fittype('a*exp(-b*x)', 'dependent',{'y'},'independent',{'x'},...
    %'coefficients',{'a','b'})
%myfit = fit(XX,YY,myfittype,'Weight',weight)
myfit = fit(XX,YY,myfittype)
figure(5)
plot(myfit,XX,YY)
%
box off
figure(4)
plot(jackolantern(locXX,1),jackolantern(locXX,2)*times,'o')
figure(6)
plot(corelation(:,1), corelation(:,2),'b.')

jacktotal = jacktotal(any(jacktotal,2),:);
jacktotalx = jacktotal(:,1);
jacktotaly = jacktotal(:,2);
    
limit = max(jacktotalx);
locXX = find(jacktotalx<limit);
jacktotalx = jacktotalx(locXX); 
jacktotaly = jacktotaly(locXX);

[x,I] = sort(jacktotalx);
y = jacktotaly(I);
%plot(jacktotalx,jacktotaly,'*')
figure(100)
hold on
plot(x,y,'o')
    %
bin = 32;
[binlist,E] = discretize(x,bin);
binlist(1) = 0;
%xy = x.*y;
xy = y;
jackbin = limit/bin;
jacktotalbin = [0,max(y)];
jacktotalbinx = 0 ;

for b = 1:bin 
    jacktotalbinx = jacktotalbinx + jackbin;
    inbin = (binlist==b);
    %jacktotalbiny = sum(inbin.*xy)/sum(inbin)/jacktotalbinx;
    %jacktotalbiny = sum(inbin.*xy./jacktotalbinx)/sum(inbin);
    jacktotalbiny = sum(inbin.*xy)/sum(inbin);
    jacktotalbin = [jacktotalbin; jacktotalbinx jacktotalbiny];
end
%%   
for b = 1:length(jacktotalbin(:,2));
    if isnan(jacktotalbin(b,2)) == 1
        jacktotalbin(b,2) = (jacktotalbin(b-1,2)+jacktotalbin(b+1,2))/2;
    end
end
plot(jacktotalbin(:,1),jacktotalbin(:,2))
myfittype = fittype('a*exp(-b*x)+c', 'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b','c'})
%weight = ones(bin+1,1);
%weight(1) = bin;
%myfit = fit(jacktotalbin(:,1),jacktotalbin(:,2),myfittype,'Weight',weight)
myfit = fit(jacktotalbin(:,1),jacktotalbin(:,2),myfittype)

plot(myfit,jacktotalbin(:,1),jacktotalbin(:,2))
box off
