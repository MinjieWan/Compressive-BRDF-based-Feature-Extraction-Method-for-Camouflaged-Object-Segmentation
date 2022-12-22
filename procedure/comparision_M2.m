clear
close all
clc

%  This code is the algorithm of one-dimensional grey level feature-based segmentation method

time = zeros(39,4); % record the running time
m = 250;n = 250; % (m,n) is the size of images
ON = ones(m,n);
re=zeros(m,n,2);
ZE=zeros(m,n);

images = zeros(m,n,41); % initialized original images
for group = 1:5
    for kk = 2:40
        filename1 = ['.../original images/',num2str(group),'/',num2str(k*2+10),'.bmp'];
        I0  = imread(filename1);
        A_all = double(I0);
        
        %% normalization
        tic
        MAX = max(max(max(A_all)));
        MIN = min(min(min(A_all)));
        A_all = (A_all+(MAX-MIN)*ON)/(MAX-MIN);
        
        %% K-means cluster
        N=2; % number of cluster center
        [m,n]=size(A_all);
        center=zeros(N,1);% number of cluster center
        re(:,:,1)=A_all;
        re(:,:,2)=ZE;
        for x=1:N
            center(x,1)=A_all(randi(m,1),randi(n,1));% Clustering centers are randomly generated for the first time.
        end
        while 1
            distence=zeros(1,N);
            num=zeros(1,N);
            new_center=zeros(N,1);
            
            for x=1:m
                for y=1:n
                    for z=1:N
                        distence(z)=sqrt((A_all(x,y)-center(z,1))^2); % Calculate the distance from the point to each cluster center.
                    end
                    [~, temp]=min(distence); % get the max distance
                    re(x,y,2)=temp;
                end
            end
            k=0;
            for z=1:N
                for x=1:m
                    for y=1:n
                        if re(x,y,2)==z
                            new_center(z,1)=new_center(z,1)+re(x,y);
                            num(z)=num(z)+1;
                        end
                    end
                end
                new_center(z,1)=new_center(z,1)/num(z);
                if sqrt((new_center(z,1)-center(z,1))^2)<0.1
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
        time(kk-1,group)=toc;
        %% Save the segmentation results of clustering.
        K_result = 255*(re(:,:,2)-ON);
        % imshow(K_result);
        filename3 = ['.../result images of method 2 (comparision)/',num2str(group),'/',num2str(group),'_',num2str(kk-1),'Z','.jpg'];
        imwrite(K_result,filename3,'jpg');
    end
end