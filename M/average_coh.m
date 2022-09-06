%%%%%%波普相干 平均
function averageM = average_coh(C)
sz3 = size(C,3);
sumM=zeros(19,19,1);
for i=1:sz3
    %name=['m',num2str(i,'%d')]; %
   % eval([name,'=C(:,:,i)'])
   sumM=sumM+C(:,:,i);   
end
averageM=sumM/sz3;
averageM=real(averageM);