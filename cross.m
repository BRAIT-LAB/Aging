%set文件
setFileName = 's001_EC.set';
filePath = 'D:\.桌面文件\Multinational EEG\Chongqing\s001_EC';
eeg = pop_loadset(setFileName, filePath);
data = eeg.data;
Fs= eeg.srate; %采样频率
Fm=eeg.xmax;
deltaf=2;
Nw=4;

%function [Svv,F,Ns,PSD] = xspectrum(data,Fs,Fm,deltaf,Nw)
% xspectrum estimates the Cross Spectrum of the input M/EEG data 构建交叉频谱
% Inputs:
%    data     = M/EEG data matrix, in which every row is a channel 原数据矩阵
%    Fs       = sampling frequency (in Hz)采样频率
%    Fm       = maximun frequency (in Hz) in the estimated spectrum 频谱最大频率
%    deltaf   = frequency resolution   频率分辨率
% Outputs:
%    PSD      = estimated power spectral density of input EEG data功率谱密度
%    Svv      = estimated cross spectrum of input EEG data交叉谱
%    Ns       = number of segments in which the EEG signal is wrapped脑电信号段数
%
%

%% Initialization oF variables...
Nf     = round(Fs/deltaf);                            % 各窗口时间点数百分比
F        = deltaf:deltaf:Fm;                                 % 频率矢量
%% Estimation of the Cross Spectrum...
e       = dpss(Nf,Nw);                                % discrete prolate spheroidal (Slepian) sequences
e       = reshape(e,[1,Nf,2*Nw]);
[Nc,Ns] = size(data);                                   % number of channels (rows) and samples (columns)
Ns      = fix(Ns/Nf);                                 % number of segments in which the EEG signal is wrapped
Ns      = max(1,Ns);
if Nf > Ns
    data = [data zeros(Nc,Nf-Ns)];                    % zero padding
end
data(:,Ns*Nf+1:end) = [];                             % discards samples after Ns*NFFT
data = reshape(data,Nc,Nf,Ns);                        % 'resized' EEG data
lf = length(F);                                         % length of F vector
Svv = zeros(Nc,Nc,lf);                                  % allocated matrix for the cross spectrum
for k = 1:Ns
    w = data(:,:,k);                                    % k-th window
    W = repmat(w,[1,1,2*Nw]).*repmat(e,[Nc,1,1]);       % multiplied by Slepian seq
    W = fft(W,[],2);                                    % FFT
    W = W(:,1:lf,:);                                    % pruning values of the FFT
    for i=1:lf
        Svv(:,:,i) = Svv(:,:,i)+cov(squeeze(W(:,i,:)).',1);
    end
end
Svv = Svv/Ns;                                           % normalizing 交叉谱
%% Estimation of Power Spectral Density (PSD)...跨频谱密度
PSD = zeros(Nc,lf);
for freq = 1:lf
    PSD(:,freq) = diag(squeeze(abs(Svv(:,:,freq))));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function [coh,cohy] = cs2coh(data)
% CS2COH transform cross spectra tensor to cross cohernece/coherency tensor
% Input
%          data --- Nc*Nc*Nf
% Output
%          coh  --- real tensor Nc*Nc*Nf实张量
%          cohy --- complex tensor Nc*Nc*Nf复数张量
%
% Andy, Apr. 2019
% See more in the meth toolbox (Guido Nolte)
        %%%function diagm = tdiag(data)
% TDIAG tensor diagnal operator to get the diagnal vectors for each slice
% (p*p*n) into a matrix (diagm) p*n
% Input
%         data p*p*n
% Output
%         diagm p*n
% Andy Hu, Sept. 17, 2019

[p, ~, n] = size(Svv);

idx = bsxfun(@plus,(1:p+1:p*p)',(0:n-1)*p*p);

diagm = data(idx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psd = diagm;
[Nc, Nf] = size(psd);
psdt = reshape(psd,[Nc 1 Nf]).*reshape(psd,[1 Nc Nf]);

coh= abs(Svv).^2./psdt;

cohy = Svv./sqrt(psdt());
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
%function C = xspt2coh (spt)
% XSPT2COH convert the crossspectra to coherence matrix交叉光谱转为相干矩阵
% Input
%         spt --- [nc*nc*nf*nind..] crossspectra tensor 交叉光谱张量 
%           c  --- [nc*nc*nf*nind...] coherence tensor相干张量

% Andy, 29/Apr/2019

if isreal (Svv)
    Svv = real2hmt(Svv);
end
[sz1,sz2,nslice] = size(Svv);
sz3 = size(Svv,3);
Svv = reshape(Svv,[sz1 sz2 nslice]);
C = zeros(size(Svv));

% magnitude squared coherence  波普相干
for i=1:nslice
    power = diag(Svv(:,:,i));
    C(:,:,i) = abs(Svv(:,:,i)).^2 ./ (power*power');
end

C = sqrt(C);
C = reshape(C,[sz1 sz2 sz3 nslice/sz3]);

%%%%%%波普相干 平均

sumM=zeros(19,19,1);
for i=1:lf
    %name=['m',num2str(i,'%d')]; %
   % eval([name,'=C(:,:,i)'])
    sumM=sumM+C(:,:,i);   
end
averageM=sumM/lf;

%%%二值化
for a=1:19
    for b=1:19
        if   averageM(a,b)<0.1;
            averageM(a,b)=0;
        else
            averageM(a,b)=1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 把功能连接矩阵变为加权矩阵，normalize归一化
W = weight_conversion(averageM, 'normalize'); %   W 加权矩阵
%% 用加权矩阵计算聚类系数
Cc = clustering_coef_wu(W);  % 聚类系数，
Cc_real = mean(Cc);

%%%%%%%%%%%%%%%%%%路径长度

D=distance_wei(averageM);  % 距离矩阵
 
[lambda,efficiency,ecc,radius,diameter] = charpath(D,0,1);  % 特征路径长度
 
L_real = lambda; % 特征路径长度就是lambda...其他四个结果参数先不看

