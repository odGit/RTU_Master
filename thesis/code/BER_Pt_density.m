close all;
clear all;
N=51;     %mezglu skaits tiiklaa
Rb=2e6;    %datu parraides aatrums
fc=915*1e6; %carrier freq.
To=300;  % temperatura[K]
K=1.38*1e-23; %Boltsmana konst.
lambda=1; %[pck/s]
L=512; %[bit/pck]
F=0  ; %[dB] noise figure
Pt=1e-3; %[W] raiditajjauda
c=3*1e8; % speed of light, [m/s]
Gt=1;
Gr=1;
rlink=[1:5:700];

%videjais mezglu skaits daudzposmu marshrutaa
n=floor(((2+N)*sqrt(N)+3*N)/(2*(N-1))); 
fun = @(x) (1/sqrt(2*pi))*exp((-x.^2)./2);
var_ini=1-exp(-lambda*L/Rb); 
Ptherm=10^(F/10)*K*To*Rb;
a=Gt*Gr*c^2/(4*pi*fc)^2;
b=3*n*lambda*L/(4*Rb);

for i=1:length(rlink)
    rho(1,i)=1/rlink(1,i)^2;
    S1(1,i)=(2*rlink(1,i))^2;
    S2(1,i)=(2*2*rlink(1,i))^2;
    S3(1,i)=(2*3*rlink(1,i))^2;

    S2p(1,i)=S2(1,i)-S1(1,i);
    S3p(1,i)=S3(1,i)-S2(1,i);

    n2p(1,i)=S2p(1,i)*rho(1,i)/2;
    n3p(1,i)=S3p(1,i)*rho(1,i)/2;
 
    Pr(1,i)=a*Pt/(rlink(1,i)^4);
   
    Pini(1,i)=var_ini*((n2p(1,i)*a*Pt/(2*rlink(1,i))^4)...
        +(n3p(1,i)*a*Pt/(3*rlink(1,i))^4));
    %Pini(1,i)=0;
    SNR(1,i)=Pr(1,i)/(Ptherm+Pini(1,i));
    SNR_dB(1,i)=10*log10(SNR(1,i))
    Kp(1,i)=erfc(sqrt(2*SNR(1,i)));

    BER(1,i)=integral(fun, sqrt(2*SNR(1,i)), Inf);
    BERroute(1,i)=1-(1-BER(1,i))^n;
    BERroute1(1,i)=1-(1-Kp(1,i))^n;
    BERroute17(1,i)=max(BERroute1(1,i), b)
end

loglog(rho, BERroute1, '-r'), hold on
loglog(rho, BERroute17, '-b')
legend('BER Gauss','BER');
	xlabel('Blivums, [1/m2]')
	ylabel('BER')
axis([1e-6 1e-3 1e-6 2]);