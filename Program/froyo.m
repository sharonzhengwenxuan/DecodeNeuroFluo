function [D]=froyo(A,percent)

B=sort(A,'descend');
%C=B(1:(ceil(length(B).*percent)));
C=B(1:percent);
D=mean(C);

end