function classrate=clasvmbest(carac,dfol)
% Classification accuracy
% carac -> features
% dfol -> cross-valitadion partitions

X=load(dfol);
ge=X.ge;
gv=X.gv;
ve=X.ve;
vv=X.vv;
nc=max(ve);

clear X car

bestcv = 0;

for log2c = -5:2:15, % Grid search for SVM's parameters
    for log2g = 3:-2:-15, % Grid search for SVM's parameters
        nval = size(ge,1);
        ac=[];
        for nuv = 1:nval,
            carace=carac(:,ge(nuv,:));
            caracv=carac(:,gv(nuv,:));
            
            for k=1:nc,
                nmc(k)=sum(vv==k); %Number of validation samples per class
            end
            
            cmd = ['-q -b 0 -c ',num2str(2^log2c),' -g ',num2str(2^log2g)];
            model = svmtrain2(ve',carace',cmd); % function from LibSVM toolbox
            [ypredt, accuracy2, prob_est] = svmpredict(vv', caracv', model,'-b 0');
            
            % Confussion matrix
            for k=1:nc,
                for j=1:nc,
                    matcon(k,j)=sum(ypredt(vv==k)==j);
                end
                acuct(nuv,k)=matcon(k,k)/nmc(k);
            end
            accuracy(nuv,1) = trace(matcon)/length(vv);
            clear model matcon
        end
        
        acuc=mean(acuct); % Accuracy mean per class
        sacuc=std(acuct); % Accuracy deviation per class
        accuram=mean(accuracy); % Accuracy mean
        accurastd=std(accuracy); % Accuracy deviation
        cv=mean(accuram);
        
        if (cv > bestcv) || ((cv == bestcv) && (2^log2c < bestc) && (2^log2g == bestg))
            bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
        end
    end
end
classrate=bestcv;
