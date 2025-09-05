function STA1Align(a,typestart,typeend)
dirname = '1';

    mkdir (['D:\test\' num2str(a) '_edited_' dirname]);

    
     
fixed = imread(['D:\test\' num2str(a) '\' num2str(a) '_' num2str(typestart) '.tif'],'tif');   
    [M, N] = size(fixed);
Img = ones(M,N);
[optimizer, ~] = imregconfig('monomodal');
metric = registration.metric.MattesMutualInformation;
 optimizer.MaximumIterations = 200;


 for n=typestart:1:typeend
        moving = imread(['D:\test\' num2str(a) '\' num2str(a) '_' num2str(n) '.tif'],'tif');
        moving_reg = imregister(moving,fixed,'translation',optimizer,metric);
        imwrite(moving_reg(20:M-20,20:N-20),['D:\test\' num2str(a) '_edited_' dirname '\' num2str(a) '_' num2str(n) '.tif'],'tif');

 end
 
end