function  L_real=distance_wei0(averageM)
%%%路径长度

D=distance_wei(averageM);  % 距离矩阵
 
[lambda,efficiency,ecc,radius,diameter] = charpath(D,0,1);  % 特征路径长度
 
L_real = lambda; % 特征路径长度就是lambda...其他四个结果参数先不看

