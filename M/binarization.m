%%%二值化 
function  averageM=binarization(averageM)
for a=1:19
    for b=1:19
        if   averageM(a,b)<0.4;
            averageM(a,b)=0;
        else
            averageM(a,b)=1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 把功能连接矩阵变为加权矩阵，normalize归一化
%W = weight_conversion(averageM, 'normalize'); %   W 加权矩阵