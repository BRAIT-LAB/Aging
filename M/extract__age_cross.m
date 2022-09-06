List =dir('D:\.M\ShareRawData\all\*.mat');
n=length(List);
%读取数据
for i=1:n
    t = List(i).name;
    a{i,1}=t;
end
%提取年龄、交叉谱
for i=1:n
    data = load(['D:\.M\ShareRawData\all\',a{i,1}]);
    age_cross_all{i,1}=data.data_struct.age;
    age_cross_all{i,1}=round(age_cross_all{i,1});%年龄取整
    age_cross_all{i,2}=data.data_struct.CrossM;
end

save(['age_cross_all.mat'],'age_cross_all' ,'-v7.3');

