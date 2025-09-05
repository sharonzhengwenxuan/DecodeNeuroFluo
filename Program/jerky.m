function Imgmax = jerky(a, varargin)
switch nargin
    case 1
        prepfr = 5;
        froyopics = 3;
thresh = 0.5;
    case 2
        prepfr = varargin{1};
froyopics = 3;
thresh = 0.5;
    case 4
        prepfr=varargin{1};
froyopics = varargin{2};
thresh = varargin{3};
end

%ext logistics---
extension2001 = exist(strcat(['D:\test\' num2str(a) '_edited_' num2str(prepfr) '\' num2str(a) '_2001.bmp']), 'file');
extension401 = exist(strcat(['D:\test\' num2str(a) '_edited_' num2str(prepfr) '\' num2str(a) '_401.bmp']), 'file');
if extension2001 == 2 || extension401 == 2
    extnsn=2;
else
    extnsn=0;
end
switch extnsn
    case 2
ext = 'bmp';
    case 0
        ext = 'tif';
end
divi = 1;
%---3 exception--
if prepfr == 3
    extnsn = 2;
    divi = (10.^2);
end
%---
%type logistics---
type = exist(strcat(['D:\test\' num2str(a) '_edited_' num2str(prepfr) '\' num2str(a) '_2001.' ext]), 'file');
switch type
    case 2
    typestart=2301;
    typeend=3311;
    case 0
        typestart=401;
    typeend=1001;
end
%--jerky--
tic
Img0  = imread(['D:\test\' num2str(a) '_edited_' num2str(prepfr) '\' num2str(a) '_' num2str(typestart) '.' ext],ext);
if extnsn==0
        Img0=rgb2ind(Img0,jet);
else
end
    [M, N] = size(Img0);
    for n = typestart:1:typeend
        Img = imread(['D:\test\' num2str(a) '_edited_' num2str(prepfr) '\' num2str(a) '_' num2str(n) '.' ext],ext);
        if extnsn==0
        Img=rgb2ind(Img,jet);
        else
        end
            Img(:,:) = Img-Img0;
            Img=double(Img);
    syrup{n} = Img;
    end
   
    if typestart<2001
allcandles = cat(3, syrup{501:801});
%allcandles = cat(3, syrup{951:1001});

    elseif typestart>=2001
allcandles = cat(3, syrup{2501:10:2991});
    end

%---make-some-mts-------------------
 Imgmax = zeros(M,N);
for r = 1:M
    for c = 1:N
        if froyo(allcandles(r,c,:), froyopics)< thresh .* max(allcandles(r,c,:))
        else
            Imgmax(r,c) = max(allcandles(r,c,:)./divi) ;
        end
    end
end
toc
for r = 1:M
    for c = 1:N
   Imgmaxerm(r,c) = max(allcandles(r,c,:) ./divi);     
    end
end

%edit mts---
figure('Name', 'Edit Mts?')
%Imgmax = imgaussfilt(Imgmax,1);
Imgmax = (Imgmax);
%Imgmax(Imgmax<0) = 0;
    imagesc(Imgmax)
    colormap(jet)
axis tight equal
set(gca,'xtick',[])
set(gca,'visible','off')
 axis off
opensesame = false([M,N]); %size
chia = imfreehand( gca );
% wait(chia);
sesame = createMask(chia);
while sum(sesame(:)) > 5
      opensesame = opensesame | sesame; % add mask to all mask
%delete(h)
      chia = imfreehand(gca);
%       wait(chia);
      sesame = createMask(chia);
end

for r = 1:M
    for c = 1:N
        if opensesame(r,c)==1
           Imgmax(r,c) = 0; 
        end
    end
end
%% Imgmax = imgaussfilt(Imgmax,1);
Imgmax = (Imgmax)/10;
Imgmax(Imgmax<0) = 0;
%show final mts---
figure('Name','Jerky')
hold on
colormap(jet)
%surf(Imgmax');
createfigure3(Imgmax');
shading interp
caxis([0 30]) 
axis tight equal
set(gca,'xtick',[])
set(gca,'visible','off')
% axis off
grid off
set(gcf, 'Position', get(0, 'Screensize'));
hold off
end
