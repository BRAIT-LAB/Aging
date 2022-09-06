function   Cc_real=clustering_coef_wu0(W)
%% 用加权矩阵计算聚类系数
Cc = clustering_coef_wu(W);  % 聚类系数，
Cc_real = mean(Cc);
