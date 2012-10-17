close all; clear all;
Pt=1e-3; %[W] raiditajjauda
Prmin=-94;  %[dB]
c=3*1e8; % speed of light, [m/s]
Gt=1;
Gr=1;
fc=915*1e6; %carrier freq.
a=Gt*Gr*c^2/(4*pi*fc)^2;
r=sqrt(sqrt(a*Pt/10^(Prmin/10)))
v=[5,10,15,20];
Rb1=[2e4 4e4 2.5e5 4e5 2e6];
for z=1:length(v)
    t(1,z)=r/v(1,z);
  for m=1:length(Rb1)
    bits(m,z)=t(1,z)*Rb1(1,m);
  end
end

semilogy(t, bits(1,:)/512, t, bits(2,:)/512, t, bits(3,:)/512,...
    t, bits(4,:)/512, t, bits(5,:)/512),grid on;
vleg = legend('20 Kbit/s','40 Kbit/s', '250 Kbit/s', '400 Kbit/s',...
    '2 Mbit/s','Location','NorthEastOutside');
	xlabel('Laiks, [s]')
	ylabel('Pakesu skaits, [pck]')
