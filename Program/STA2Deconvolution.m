function AllDeconvolved = STA2Deconvolution(a)
%%
dirname = '2';

    mkdir (['D:\test\' num2str(a) '_edited_' dirname]);
%%
    javaaddpath([matlabroot filesep 'java' filesep 'DeconvolutionLab_2.jar'])
    % 40x
    psf = zeros(121,121);
           a1 = 0.8512;
           c1 = 3.1871;
           a2 = 0.1412;
           c2 = 8.8578;
    for i = 1:121
        for j = 1:121
            x = sqrt((i-61)^2+(j-61)^2);
             psf(i,j) =  a1*exp(-((x)/c1)^2)+a2*exp(-((x)/c2)^2) ;
        end
    end
    %%
    for f = 1:601
        Img0 = double(imread(['D:\test\' num2str(a) '_edited_1\' num2str(a) '_' num2str(f+400) '.tif'],'tif'));
        %Deconvolved = DL2.LW(Img0, psf,50,1,'-monitor no');
        Deconvolved = DL2.LW(Img0, psf,200,1,'-monitor no');
        AllDeconvolved{1,f} = Deconvolved;
        imwrite(uint16(AllDeconvolved{1,f}),['D:\test\' num2str(a) '_edited_2\' num2str(a) '_' num2str(f+400) '.tif'],'tif');
    end
end