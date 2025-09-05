
%%

i1 = 4;
spice = 510;
[cooking, jet]  = imread(['D:\test\' num2str(i1) '_edited_4\' num2str(i1) '_' num2str(spice) '.tif'],'tif');
       
cooking = cooking - min(min(cooking));
figure(3)
    imshow(cooking*2^4)
    
   potato = imfreehand;
   wait(potato);
% create a mask and get coordinates
gravy = potato.createMask();


%%
total1 = [];
All1 = cell(1);

for f = 401:1001
    Img1 = double(imread(['D:\test\' num2str(i1) '_edited_3\' num2str(i1) '_' num2str(f) '.tif'],'tif')).*double(gravy);
    All1{1,f-400} = Img1;
    %total1 = [total1;sum(sum(Img1))/sum(sum(double(Img1>0)))];
        total1 = [total1;sum(sum(Img1))/sum(sum(double(gravy>0)))];

end
%
figure(6)
        plot(total1,'r-')
        %xline(100:100:1600)
        %hold on     
        %%
        plot(total4/mean(total4(25:74)),'g-.')
        xaxis = [1:601]';
        yaxis = ones(601,1);
        %plot(xaxis,yaxis,'--k','LineWidth',1)
        box off
        ylabel('Fluorescence')
        xlabel('Frame')
       % legend('W/o Fluorescence Adjustment', 'W/ Fluorescence Ajustment')
%%



%%
i1 = 9;
All1 = cell(1);
for f = 401:1001
    Img1 = double(imread(['D:\test\' num2str(i1) '_edited_3\' num2str(i1) '_' num2str(f) '.tif'],'tif'));
    All1{1,f-400} = Img1;
end
[M,N] = size(Img1);
%%
for i = 33%346
    for j = 44%472
        %pdata1 = []; 
        for f = 1:601
            pdata1 = [pdata1; double(All1{1,f}(i,j))];
        end
        pden = pdata1;
        for f = 3:601-2
            pden(f) = (pdata1(f-2)+2*(pdata1(f-1))+3*pdata1(f)+pdata1(f+1)+2*(pdata1(f+2)))/9;
        end
         s1x = [1:100]'; s1y = pden(1:100);
        num = (pden == max(pden(100:150)));
        [mac] = find(num);
        mac = mac(1);
        s2x = [101:mac-1]'; 
        s3x = [mac:601]'; s3y = pden(mac:601);
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
        
        if mean(mink(distance,10))+ std(mink(distance,10)) < 30
            [s3xd,x3yd] = prepareCurveData(s3x,s3y);
            weight = ones(length(s3x),1);
            weight(1) = length(s3x)^2;
            %weight = flip(1:length(s3x))';
            %weight = weight.^2;
            fitresult3 = fit(s3xd,x3yd,'exp2','Normalize','on','Weight',weight);
         
            k2 = (fitresult3(mac)- (fitresult1(1)*100+fitresult1(2)))/(mac-100);
            s2y = s1y(1)+k2*(s2x-100);
            s3y = fitresult3(s3x);
        
            for f = 2: length(s3y)-mac+1
                if s3y(f) > s3y(f-1)
                    s3y(f:length(s3y)) = s3y(f-1);
                end
            end
            for f = 1: length(s3y)
                    if s3y(f) < mean(s1y)
                        s3y(f) = mean(s1y);
                    end
            end
            X = [s1x;s2x;s3x];
            Y = [s1y;s2y;s3y];
        else
            X = [1:601]';
            Y = ones(601,1)*mean(s1y);
        end
        %
        
    end
end
figure(3)
plot(pdata1,'green')
hold on
plot(X,Y)
%%
tic
for i = 105%346
    for j = 186%472
        pdata1 = []; 
        pdata2 = [];
        pdata3 = [];
        for f = 1:601
            pdata1 = [pdata1; double(All1{1,f}(i,j))];
            pdata2 = [pdata2; double(All2{1,f}(i,j))];
            pdata3 = [pdata3; double(All3{1,f}(i,j))];
        end
        pden1 = pdata1;
        for f = 3:601-2
            pden1(f) = (pdata1(f-2)+2*(pdata1(f-1))+3*pdata1(f)+pdata1(f+1)+2*(pdata1(f+2)))/9;
        end
        
        
    end
end

plot(pdata1,'.-green')
hold on
plot(pdata2,'.-magenta')
plot(pdata3,'.-blue')
%plot(pdata1/(mean(pdata1(25:75))))
%plot(pdata4)
legend('[148,207]','[148,207]','[148,207]','[105,186]','[105,186]','[105,186]')
box off
%%
mpdata = mean(pdata);
vpdata = pdata(pdata<10*mpdata);

%%
pdata4_b = pdata4 - mean(pdata1)
plot(pdata4_b)
%%
X = [1:99, 500:601]';
Y = [pdata(1:99); pdata(500:601)];
fitresult1=fit(X,Y,'exp2','Normalize','on')

plot(pdata,'*')
hold on
dY = fitresult(1)*[1:601]+fitresult(2);
plot([1:601],dY)
%%
time = X;
signal = Y;
tic
w = warning ('off','all');

for i = 1:1000

    flist={@(c,x) exp(c(1).*x(:)),@(c,x) exp(c(2).*x(:))};
    [c,ab]=fminspleas(flist,[0,0], time, signal);
end
toc
%ezplot(@(x) ab(1)*exp(c(1)*x) + ab(2)*exp(c(2)*x),[1,601])
x = [1:601];
newbase = ab(1)*exp(c(1)*x) + ab(2)*exp(c(2)*x);
hold on
plot(x,newbase,'r+')
plot(pdata,'*')

%%
X = [1:99, 500:601]';
Y = [pdata(1:99); pdata(500:601)];

X1 = [104:601]';
Y1 = [pdata(104:601)];
YY1 = pden(104:601);
tic
for i = 1:1000
    fitresult1=fit(X,Y,'exp2','Normalize','on');
end
toc
    dY1 = fitresult1(X1);
plot(pdata)
hold on
fitresult=polyfit(X,Y,1);
%dY = fitresult([1:601]);
dY = fitresult(1)*[1:601]+fitresult(2);
plot(X1,dY1)
plot([1:601],dY)
%%
for i = 129
    for j = 4
        pdata2 = [];  
        pdata4 = [];
        for f = 1:601
            pdata2 = [pdata2; double(All1{1,f}(i,j))];
            pdata4 = [pdata4; double(All4{1,f}(i,j))];
        end
        
        
    end
end
plot(pdata2)
hold on
%%
x = [511:1001];
logx = log(x);
original3 = pdata1(111:601);
logy3 = log(original3);
%%
tryy = 100*exp(x);
logtryy = log(tryy);
%%
second3 = original3-1122*exp(-0.0599);
%%
preparepdata0 = smoothdata(pdata1,'movmedian');
pdata0new = smoothdata(preparepdata0,'gaussian',20)
%plot(pdata1)
hold on
plot(pdata0new)
%%
preparepdata0 = smoothdata(pdata1(1:100),'movmedian');
preparepdata1 = smoothdata(pdata1(101:601),'movmedian');
pdata0new = smoothdata(preparepdata0,'gaussian',100)
pdata1new = smoothdata(preparepdata1,'gaussian',100)


plot(pdata1)
hold on
plot(pdata0new)
plot([101:601]',pdata1new)

%%

for f = 401:1001
    Img1 = double(imread(['D:\test\' num2str(i) '_edited_2\' num2str(i) '_' num2str(f) '.tif'],'tif'));
    AllOriginal0{1,(f-400)} = Img1;
    Img20 = double(imread(['D:\test\' num2str(i) '_edited_3\' num2str(i) '_' num2str(f) '.tif'],'tif'));
    AllOriginal20{1,(f-400)} = Img20;
    Img1 = double(imread(['D:\test\' num2str(i) '_edited_4\' num2str(i) '_' num2str(f) '.tif'],'tif'));
    AllOriginal1{1,(f-400)} = Img1;
    Img4 = double(imread(['D:\test\' num2str(i) '_edited_5\' num2str(i) '_' num2str(f) '.tif'],'tif'));
    AllOriginal4{1,(f-400)} = Img4;
end

for i = 193%:M
    for j = 231%:N
        pdata1 = [];
        pdata20 = [];
        pdata1 = [];
        pdata4 = [];
        for f = 1:601
            pdata1 = [pdata1; double(AllOriginal0{1,f}(i,j))];
            pdata1 = [pdata1; double(AllOriginal1{1,f}(i,j))];
            pdata4 = [pdata4; double(AllOriginal4{1,f}(i,j))];
            pdata20 = [pdata20; double(AllOriginal20{1,f}(i,j))];
        end
    end
end
%%
figure(1)
plot(pdata1)
hold on
plot(pdata1)
figure(2)
plot(pdata4)
hold on
plot(pdata20)
%%
plot(pdata1.*sum(sum(pdata1))/sum(sum(pdata1)))
hold on
plot(pdata20)
plot(pdata4)
plot(pdata1,'k')
legend('pdata0','pdata20','pdata4','pden1')
%% 290 33
Allfmaxi = zeros(M,N);
for i = 1:M
    for j = 1:N
        pdata = [];
        for f = 1:601
            pdata = [pdata; double(AllCalc{1,f}(i,j))];
        end
        y = pdata;
        L = 601;
        Fs = 1;
        NFFT = 2^nextpow2(L); % Next power of 2 from length of y
        Y = fft(y,NFFT)/L;
        f = Fs/2*linspace(0,1,NFFT/2+1);
        absY = 2*abs(Y(1:NFFT/2+1));
            % Plot single-sided amplitude spectrum.
        [pks,locs] = findpeaks(absY,'SortStr','descend');
        if length(locs)>0
            fmaxi = f(locs(2));
                Allfmaxi(i,j) = fmaxi;
        end
        
    end
end
%%
plot(pdata)
y = pdata;
L = 601;
Fs = 1
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
absY = 2*abs(Y(1:NFFT/2+1));
% Plot single-sided amplitude spectrum.
[pks,locs] = findpeaks(absY,'SortStr','descend');
plot(f,absY) 
hold on
%plot(f(locs(1)),absY(locs(1)),'r*')
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
fmaxi = f(locs(1))