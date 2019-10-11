function valu=psomcaracfv(vin)
% This function evaluates the classification of
% a wavelet decomposition 

delta=vin(1);
level=vin(2);

scase = 'foldEEG2c.mat';
%2clase Z,S (A,E) -> foldEEG2c.mat
%2clase2 (Z,N,F),S ((A,C,D),E) -> foldEEG2c2.mat
%2clase3 (Z,O,N,F),S ((A,B,C,D),E) -> foldEEG2c3.mat
%3clase Z,F,S (A,D,E) -> foldEEG3c.mat
%3clase2 ZO,NF,S (AB,CD,E) -> foldEEG3c2.mat

direc1='A/';
direc2='B/';
direc3='C/';
direc4='D/';
direc5='E/';

direc = {direc1 direc2 direc3 direc4 direc5};
clase={'A' 'B' 'C' 'D' 'E'};

base={'db1' 'db2' 'db3' 'db4' 'db5' 'db6' 'db7' 'db8' 'db9' 'db10' 'coif1' 'coif2' 'coif3' 'coif4' 'coif5' ...
    'sym2' 'sym3' 'sym4' 'sym5' 'sym6' 'sym7' 'sym8' 'sym9' 'sym10'};

wname=char(base{vin(3)});

for m=1:length(clase),  % Numero de clases
    Dr=dir(strcat(direc{m},'*.*'));
    [p,q]=size(Dr);
    for num=1:p-2
        y=load(strcat(direc{m},Dr(num+2).name));
        y=resample(y,delta,100);
        y=y-mean(y);
        ly=length(y);
        car=carwav(y,wname,level);
        eval([clase{m} '(num,:)=car; ']);
        clear s car;
    end
end
carac = [A;B;C;D;E]';
valcla = clasvmbest(carac,scase); 
clear A B C D E carac
valu = valcla(1);
