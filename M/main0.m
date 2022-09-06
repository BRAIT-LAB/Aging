load(['D:\matlab\Aging\M\age_cross_Cuba90.mat']);
k=length(age_cross_Cuba90);

for i=1:k
    age_cross_Cuba90{i,1}=round(age_cross_Cuba90{i,1});%年龄取整
    age_cross_Cuba90{i,3}=cross2coh(age_cross_Cuba90{i,2});  
    %age_cross{i,3}波谱相干矩阵
    age_cross_Cuba90{i,4}=average_coh(age_cross_Cuba90{i,3});
    %age_cross{i,4}平均波谱相干
    age_cross_Cuba90{i,5}=binarization(age_cross_Cuba90{i,4});
    %age_cross{i,5}二值化
    
end
 
for  i=1:k
    age_cross_Cuba90{i,6}=clustering_coef_wu0(age_cross_Cuba90{i,5});
    % age_cross{i,6}聚类系数
end

for  i=1:k
   
    age_cross_Cuba90{i,7}=distance_wei0(age_cross_Cuba90{i,5});
    %age_cross{i,7}特征路径长度
end


plot_scalp_net_graph(age_cross_Cuba90{1,5},chanlocs);

myLabel={'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','T7','T8','P7','P8','Fz','Cz','Pz'};

A6=age_cross_Cuba90{119,5};
A10=age_cross_Cuba90{111,5};
A15=age_cross_Cuba90{33,5};
A30=age_cross_Cuba90{128,5};
A40=age_cross_Cuba90{147,5};
A50=age_cross_Cuba90{150,5};
A60=age_cross_Cuba90{162,5};
A70=age_cross_Cuba90{167,5};
A80=age_cross_Cuba90{179,5};

subplot(3,3, 1),circularGraph(A6,'Label',myLabel);
subplot(3,3, 2),circularGraph(A10,'Label',myLabel);
subplot(3,3, 3),circularGraph(A15,'Label',myLabel);

subplot(3,3, 4),circularGraph(A30,'Label',myLabel);
subplot(3,3, 5),circularGraph(A40,'Label',myLabel);
subplot(3,3, 6),circularGraph(A50,'Label',myLabel);

subplot(1,3, 1),circularGraph(A60,'Label',myLabel);
subplot(1,3, 2),circularGraph(A70,'Label',myLabel);
subplot(1,3, 3),circularGraph(A80,'Label',myLabel);