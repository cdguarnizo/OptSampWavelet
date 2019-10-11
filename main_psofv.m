clear; close all; clc; warning off;

d = 3; % Number of paramters
% [ResamplingDelta DecompositionLevel WaveType]
li = [1 1 1]; %Lower limit per parameter
ls = [100 10 24]; %Upper limit per parameter


np = 25; % Number of particles
ni = 50; % Number of iterations

%crear memoria
memo=zeros(1, d);
memov=0;
% PSO algorithm
c1 = 2;
c2 = 2;

% Initial poblation generation
S=zeros(np,d);
for k=1:d,
    S(:,k)=(ls(k)-li(k))*rand(np,1)+li(k);
end
S=round(S);
v=zeros(np,d);
wb=[1.2,0.5,0.4];
wdec=(wb(1)-wb(3))/(ni*wb(2));
w=wb(1);
i{1}=[];

% Poblation evaluation y calculation of gbest and pbest
for p=1:np,
    ind=find(ismember(memo,S(p,:),'rows'));    
    if isempty(ind),
        fit(p)=psomcaracfv(S(p,:));
        %display('Porcentaje:')
        %display(fit(p))
        memo(end+1,:)=S(p,:);
        memov(end+1)=fit(p);
    else
        fit(p)=memov(ind);
    end
end

[a b]=max(fit);
gbest=S(b,:);
pbest=S;

for n = 1:ni,
    % Uptade particles velocities
    for p = 1:np,
        v(p,:) = w*v(p,:)+c1*rand(1)*(pbest(p,:)-S(p,:))+c2*rand(1)*(gbest-S(p,:));
        S(p,:) = round(S(p,:)+v(p,:));
        for k = 1:d,
            S(p,k) = min(S(p,k),ls(k));
            S(p,k) = max(S(p,k),li(k));
        end
        ind = find(ismember(memo,S(p,:),'rows'));   
        if isempty(ind),
            fit2(p) = psomcaracfv(S(p,:));
            memo(end+1,:) = S(p,:);
            memov(end+1) = fit2(p);
        else
            fit2(p) = memov(ind);
        end
        %fit2(p) = psomcaracfv(S(p,:),1);
        if fit2(p)>fit(p),
            pbest(p,:) = S(p,:);
        end
    end
    [a2 b]=max(fit2);
    if (a2>a) | (a2==a & S(b,2)<gbest(2)),
        gbest=S(b,:);
        a=a2;
    end
    clear fit;
    fit=fit2;
    if n<ni*wb(2),
        w=w-wdec;
    end
    bestpo(n,:)=a;
    besti(n,:)=gbest;
    display(a)
end
%freq=gbest;
%miv=a;