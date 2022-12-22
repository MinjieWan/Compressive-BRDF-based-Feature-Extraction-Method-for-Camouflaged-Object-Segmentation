clear
close all
clc

%  This code is the algorithm of 'Compressive Bidirectional Reflection Distribution Function-Based Feature Extraction Method for Camouflaged Object Segmentation'

time = zeros(18,4); % record the running time
m = 250;n = 250; % (m,n) is the size of images
ON = ones(m,n);

images = zeros(m,n,41); % initialized original images
for group = 1:5
    for k = 2:40
        filename1 = ['.../original images/',num2str(group),'/',num2str(k*2+10),'.bmp'];
        I0  = imread(filename1);
        I = double(I0);
        images(:,:,k)=I;
    end
    
    for C = 3:2:11
        re=zeros(250,250,C-1);
        MM = ones(250,250,C);
        
        %% Calculate the first C coefficients of Chebyshev polynomial, at 41 x values in the interval [-1,1]
        tic
        X = zeros(41,1); %independent variable --> sin(j)
        X(1,1) = 1; % if j = 90 degrees, sin(j) = 1
        X(41,1) = -1; % if j = -90 degrees, sin(j) = -1
        for k = 2:40
            X(k,1) = sind(-k*2+80);
        end
        
        P = zeros(C,41);
        for k = 1:41
            % Calculate the first C coefficients of Chebyshev polynomial
            P(1,k) = 1;
            P(2,k) = X(k,1);
            for r = 3:C
                P(r,k) = 2*X(k,1)*P(r-1,k)-P(r-2,k);
            end
        end
        
        %% Compressive BRDF feature extraction
        m=250;n=250;
        A_all = zeros(m,n,C);
        for r = 1:C
            if r == 1
                A_all(:,:,r) =  (X(2,1)-X(1,1))*images(:,:,2)/sqrt(1-X(2,1)^2)/pi + (X(41,1)-X(40,1))*images(:,:,40)/sqrt(1-X(40,1)^2)/pi;
            else
                A_all(:,:,r) =  2*(X(2,1)-X(1,1))*images(:,:,1+1)*P(r,2)/sqrt(1-X(2,1)^2)/pi + 2*(X(41,1)-X(40,1))*images(:,:,40)*P(r,40)/sqrt(1-X(40,1)^2)/pi;
            end
            for k = 2:39
                if r == 1
                    A_all(:,:,r) =  A_all(:,:,r) + (X(k+1,1)-X(k,1))*(images(:,:,k)/sqrt(1-X(k,1)^2)+images(:,:,k+1)/sqrt(1-X(k+1,1)^2))/pi;
                else
                    A_all(:,:,r) =  A_all(:,:,r) + 2*(X(k+1,1)-X(k,1))*(images(:,:,k)*P(r,k)/sqrt(1-X(k,1)^2)+images(:,:,k+1)*P(r,k+1)/sqrt(1-X(k+1,1)^2))/pi;
                end
            end
        end
        
        %% normalization
        MAX = max(max(max(A_all)));
        MIN = min(min(min(A_all)));
        A_all = (A_all+(MAX-MIN)*MM)/(MAX-MIN);
        
        %% K-means cluster
        KKN = 0; % sign of cluster times
        N=2; % number of cluster center
        [m,n,p]=size(A_all);
        center=zeros(N,1,p);% number of cluster center
        re(:,:,1:p)=A_all(:,:,:);
        re(:,:,p+1)=ON;
        for x=1:N
            center(x,1,:)=A_all(randi(m,1),randi(n,1),:); % Clustering centers are randomly generated for the first time.
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
                    [~, temp]=min(distence); % get the max distance
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
        time(C-2,group)=toc;
        %% Save the segmentation results of clustering.
        K_result = 255*(re(:,:,p+1)-ON);
        filename2 = ['.../result images of method 1 (paper)/',num2str(group),'/',num2str(C),'W','.jpg'];
        imwrite(K_result,filename2,'jpg');
    end
end