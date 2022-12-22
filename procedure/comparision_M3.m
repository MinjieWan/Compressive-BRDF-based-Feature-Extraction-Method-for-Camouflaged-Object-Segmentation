clear
close all
clc

%  This code is the algorithm of multi-dimensional grey level feature-based segmentation method

time = zeros(1,4); % record the running time
m = 250;n = 250; % (m,n) is the size of images
ON = ones(m,n);
images = zeros(m,n,41); % initialized original images
for group = 1:1
    for k = 2:40
        filename1 = ['.../original images/',num2str(group),'/',num2str(k*2+10),'.bmp'];
        I0  = imread(filename1);
        I = double(I0);
        images(:,:,k)=I;
    end
    A_all = images(:,:,2:40);
    
    %% normalization
    tic
    MAX = max(max(max(A_all)));
    MIN = min(min(min(A_all)));
    MM = ones(m,n,39);
    A_all = (A_all+(MAX-MIN)*MM)/(MAX-MIN);
    
    %% K-means cluster
    N=2; % number of cluster center
    [m,n,p]=size(A_all);
    re=zeros(m,n,p+1);
    center=zeros(N,1,p);% number of cluster center
    re(:,:,1:p)=A_all(:,:,:);
    for x=1:N
        center(x,1,:)=A_all(randi(m,1),randi(n,1),:);% Clustering centers are randomly generated for the first time.
    end
    while 1
        distence=zeros(1,N);
        num=zeros(1,N);
        new_center=zeros(N,1,p);
        
        for x=1:m
            for y=1:n
                for z=1:N
                    distence(z)=sqrt(sum(sum(sum(((A_all(x,y,:)-center(z,1,:)).^2)))));% Calculate the distance from the point to each cluster center.
                end
                [~, temp]=min(distence);% get the max distance
                re(x,y,p+1)=temp;
            end
        end
        k=0;
        for z=1:N
            for x=1:m
                for y=1:n
                    if re(x,y,p+1)==z
                        new_center(z,1,:)=new_center(z,1,:)+re(x,y,1:p);
                        num(z)=num(z)+1;
                    end
                end
            end
            new_center(z,1,:)=new_center(z,1,:)/num(z);
            if sqrt(sum(sum(sum((new_center(z,1,:)-center(z,1,:)).^2))))<0.01
                k=k+1;
            end
        end
        if k==N
            break;
        else
            center=new_center;
        end
    end
    toc
    time(1,group)=toc;
    %% Save the segmentation results of clustering.
    K_result = 255*(re(:,:,p+1)-ON);
    filename4 = ['.../result images of method 3 (comparision)/',num2str(group),'.jpg'];
    imwrite(K_result,filename4,'jpg');
end