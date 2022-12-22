clear
close all
clc

% This code is used to calculate the probability and false alarm rate of target segmentation

Pd_M1 = zeros(6,4);
Pf_M1 = zeros(6,4);
Pd_M2 = zeros(39,4);
Pf_M2 = zeros(39,4);
Pd_M3 = zeros(1,4);
Pf_M3 = zeros(1,4);

m = 250;n = 250; % (m,n) is the size of images

for group = 1:5
    filename5 = ['.../ground truth images/',num2str(group),'.jpg'];
    ST0 = imread(filename5);
    ST = double(ST0); % ground truth images
    
    %% Compressive BRDF-based feature extraction method
    for C = 3:2:13
        filename2 = ['.../result images of method 1 (paper)/',num2str(group),'/',num2str(C),'W','.jpg'];
        I0 = imread(filename2);
        I = double(I0);
        
        N1 = length(find(ST==255)); % pixels of ground truth target
        A1 = ST+I;
        N2 =length(find(A1==510)); % pixels which are both ground truth target and the detected target
        A2 = ST./I;
        N3 =length(find(A2==0)); % pixels which are not ground truth target but are detected as target
        Pd_M1((C-1)/2,group) = N2/N1; % probability
        Pf_M1((C-1)/2,group) = N3/m/n; % false alarm rate
    end
    
    %% One-dimensional grey level feature-based segmentation method
    for kk = 2:40
        filename3 = ['.../result images of method 2 (comparision)/',num2str(group),'/',num2str(group),'_',num2str(kk-1),'Z','.jpg'];
        I0 = imread(filename3);
        I = double(I0);
        
        N1 = length(find(ST==255));
        A1 = ST+I;
        N2 =length(find(A1==510));
        A2 = ST./I;
        N3 =length(find(A2==0));
        Pd_M2(kk-1,group) = N2/N1;
        Pf_M2(kk-1,group) = N3/62500;
    end
    
   %% Multi-dimensional grey level feature-based segmentation method
    filename4 = ['.../result images of method 3 (comparision)/',num2str(group),'.jpg'];
    I0 = imread(filename4);
    I = double(I0);
    
    N1 = length(find(ST==255));
    A1 = ST+I;
    N2 =length(find(A1==510));
    A2 = ST./I;
    N3 =length(find(A2==0));
    Pd_M3(1,group) = N2/N1;
    Pf_M3(1,group) = N3/m/n;
end
