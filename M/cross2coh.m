function C = cross2coh(Svv)
% XSPT2COH convert the crossspectra to coherence matrix交叉光谱转为相干矩阵
% Input
%         Svv --- [nc*nc*nf*nind..] crossspectra tensor 交叉光谱张量 
%           C  --- [nc*nc*nf*nind...] coherence tensor相干张量

% Andy, 29/Apr/2019
%load(['D:\matlab\Aging\M\age_cross.mat']);
%Svv=age_cross{1,2}
if isreal (Svv)
    Svv = real2hmt(Svv);
end
[sz1,sz2,nslice] = size(Svv);
sz3 = size(Svv,3);
Svv = reshape(Svv,[sz1 sz2 nslice]);
C = zeros(size(Svv));

% magnitude squared coherence  波普相干
for i=1:sz3
    power = diag(Svv(:,:,i));
    C(:,:,i) = abs(Svv(:,:,i)).^2 ./ (power*power');
end

C = sqrt(C);
C = reshape(C,[sz1 sz2 sz3 nslice/sz3]);


