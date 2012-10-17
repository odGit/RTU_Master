clear all; 
close all; 
F=6; %noise figure in dB
K=1.38*1e-23;  %Boltzman constant
T=300; %room temperature in K
Pt=1e-3;  %mW
B=20*1e6;
N=300;

Rb=128*1024; % [b/s], data rate = 128kbps
L=1e4; %b/pck
lamda=1; %pck/s
rho=1e-3;    %the node spatial density, [nodes/kv.m]
rlink=1/sqrt(rho);

n_max=ceil(2*sqrt(N/pi));  %maxim number of hops in a route
n=floor(((2+N)*sqrt(N)+3*N)/(2*(N-1)));%aver.number of hops in a route

Pr=Pt/rlink^2;
Ptherm=10^(F/10)*K*T*B;
nTier1 = randi(7,1,1);%1.Tierre transmit. neighbors
nTier2 = randi(5,1,1);%2st Tierre transmitting neighbors
Pini=nTier1*Pt/(2*rlink)^2+nTier2*Pt/((3*rlink)^2)
SNRlink_ini=Pr/(Ptherm+Pini);
BERlink_ini=0.5*erfc(sqrt(SNRlink_ini));
BERroute=1-(1-BERlink_ini).^n;
BERroutem=1-(1-BERlink_ini)^n_max;
     
route_SP=zeros(50,2);
route_BER=zeros(50,2);
route=zeros(50,2);
k=1;

while(k<51)
    
 %Random values of routes
  %BER_rand_link=randi([90 103],1,5)*1e-3;
  BER_rand_link=(BERlink_ini+(BERlink_ini/12)*rand(1,7));
   %n_rand=randi([n-5 n+5],1,7);
  for o=1:7
   a=[n_max:-1:1]
    n_rand(1,o)=a(1,randi([1 n_max], 1,1));
  end
    for m=1:length(n_rand)
        BERrand_route(1,m)=1-(1-BER_rand_link(1,m)).^n_rand(1,m);
    end
  %List of routes to destination X, where first row BER and 2nd is nh
    for i =1:length(BERrand_route)
        Tn(i,:)=cat(2,BERrand_route(1,i),n_rand(1,i));
    end

%Short Path (SP) route selection algorith
    Tn1=sortrows(Tn,2); %Tn sorted by number of hops(ascending)
    route_SP(k,1)=Tn1(1,1);
    route_SP(k,2)=Tn1(1,2);

 %BER-based route selection algorith
    Tn2=sortrows(Tn,1); %Tn sorted by  by BER number(ascending)
    route_BER(k,1)=Tn2(1,1);
    route_BER(k,2)=Tn2(1,2);

%SP&&BER-based route selection algorith
%First from Tn sorted by length of route, starting from shortest route
% for each pair (BER, nh) compare routes BER < avg.BER. If all BER 
%are > avg.BER then selected route with smallest available BER.
    for i=1:length(Tn) 
        if Tn1(i,1)<BERroute&(route(k,2)==0)  
            route(k,1)=Tn1(i,1);
            route(k,2)=Tn1(i,2);
        else
            if i==5&(route(k,2)==0)   
                route(k,1)=Tn2(1,1);
                route(k,2)=Tn2(1,2);
            end
           
        end
    end
    k=k+1;
end

x=1:50;

figure(1) 
	plot(x, route_SP(:,2), 'g'), grid on, hold on
    plot(x, route_BER(:,2), 'r'), hold on
	plot(x, route(:,2), 'y'), hold on;
    plot(x, ones(size(x))*n, 'b') 
	vleg = legend('SP','BER-based','BER-based&SP','Location',...
		'NorthEastOutside');
	xlabel('Number of Simulations')
	ylabel('Number of hops')
	title('BER&SP-based performance: number of hops')
	%axis([0 51 8 22]);

figure(2)
	semilogy(x, route_SP(:,1), 'g'), grid on, hold on
	semilogy(x, route_BER(:,1), 'r'), hold on
	semilogy(x, route(:,1), 'o-'), hold on;
    semilogy(x, ones(size(x))*BERroute, 'm') 
	vleg = legend('SP','BER-based','BER-based&SP','Location',...
		'NorthEastOutside');
	xlabel('Number of Simulations')
	ylabel('BER')
	title('BER&SP-based performance: BER level')
    
 figure(3)
	semilogy(route(:,2),route(:,1), 'k*'),grid on, hold on
    semilogy(route_SP(:,2),route_SP(:,1), 'r+'),grid on, hold on
	semilogy(route_BER(:,2),route_BER(:,1), 'bo'),grid on, hold on
    %plot(x, ones(size(x))*n, 'b') 