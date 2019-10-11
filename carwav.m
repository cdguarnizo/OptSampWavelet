function car=carwav(S,wname,levels)

car=[];
ss=S(:)';
for n=1:levels,
    [CA CD]=dwt(ss,wname);
    ce(n)=sum(CD.^2); %energia
    clear ss;
    ss=CA;
    %cmax(1,n)=max(CD);
    cstd(1,n)=std(CD);
    %cmean(1,n)=mean(CD);
    %cmin(1,n)=min(CD);
    clear CA CD;
end
%cmax(1,n+1)=max(ss);
cstd(1,n+1)=std(ss);
%ce(1,n+1)=sum(ss.^2);
%cre=ce/sum(ce);
%cmean(1,n+1)=mean(ss);
%cmin(1,n+1)=min(ss);
%car=[cmax cstd cmean cmin];
%car=[cstd cre ce];
car=cstd;