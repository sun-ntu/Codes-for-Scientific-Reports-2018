function [arfa_all]=cac_coagulation(DT)


Ftr=fft(DT(:,1));    %FFT of referece waveform

arfa_all=ones(14,size(DT,2)-1);

d=0.14;         %liquid thickness,單位為mm 
c=3*10^11;     % 光速,單位為mm 
R=0.96;           % reference的transmitted amplitude, 因為用PE所以目前設定n=1.5, 

freq_s=(0.0681:0.0681:0.0681*15);
freq_s=freq_s';

for H=2:size(DT,2)
Fts=fft(DT(:,H));    %FFT of sample waveform
A=abs(Fts./Ftr);   % sample 的 FFT amplitude除掉 reference的FFT amplitude
%A=A;
phs=angle(Fts./Ftr);  % phase of sample - amplitude
amp=abs(A.*R);

phs=phs(2:16);
amp=amp(2:16);

for u=2:15   % 可用的頻率在100GHz到1THz
    if abs(phs(u)-phs(u-1))> 5
      phs(u)=phs(u)-2*pi;
    end
end          % 因為程式計算值只會落在0到2pi之間,所以要把多出的值加回去才會是正確的phase 
  
n=phs./(-2*pi.*freq_s.*10^12./c*d)+1;   % refractive index real part n calculation  

k=-log(amp)./(2*pi.*freq_s.*10^12./c*d);  % refractive index imaginary part kapa calculation

%(如果沒有去掉介面,到這裡程式就可以結束)
%==========================================================================


T1=9.*(4.*(n.^2+k.^2))./( ((n+1.5).^2+k.^2).^2 );   
T2=amp.^2./T1;
k1=-log(T2)./(4*pi.*freq_s.*10^12./c*d);    % calibrate 介面損失的 transmission power 

ph1=angle(1.5*2./(n-i*k+1.5));              
ph2=angle( (n-i*k).*2./(n-i*k+1.5) );
n1=(phs-ph1-ph2)./(-2*pi.*freq_s.*10^12./c*d)+1;   % calibrate 介面的 phase difference 



while (abs(n1(8)-n(8))>0.001 || abs(k1(8)-k(8))>0.001)    %iteration (重覆上面的calibration直到解出來的n和kapa收斂到定值)
    n=n1;
    k=k1;
    T1=9.*(4.*(n.^2+k.^2))./( ((n+1.5).^2+k.^2).^2 );
    T2=amp.^2./T1;
    k1=-log(T2)./(4*pi.*freq_s.*10^12./c*d);

    ph1=angle(1.5*2./(n-i*k+1.5));
    ph2=angle( (n-i*k).*2./(n-i*k+1.5) );
    n1=(phs-ph1-ph2)./(-2*pi.*freq_s.*10^12./c*d)+1;
   
end


%freq_s=freq_s(2:10);
%n=n(2:10);                 % final n    
%k=k(2:10);
%n1=n1(5:59);
%k1=k1(5:59);
arfa=4*pi.*freq_s.*10^12./c.*k*10;   % final arfa   
arfa_all(1:15,H-1)=arfa;
epsr=n.^2-k.^2;     % epsilon real part
epsi=-2.*n.*k;      % epsilon imginary part
end



