function [elevacao,Ec] = NovoCalculaManchaITU(Coord)
%clear
%clc
%tic


%parâmetros ITU otimizados por Gauss Newton
A = [0.0926, 0.7503, -35.075, 91.2638];
B = [51.1222, 10.8779, 2.1819, 0.5451, -0.314, 1.5422, 49.0288, 96.2994];
C = [6.3549, 2.9537, 1.7512, 1.7385, 196.3467, -0.3879, 2.3631];     
D = [4.9617, 1.2175];

mapa = readhgt('S23W044.hgt');
%altura da antena de TX e RX
hAnt = 30;
hRX = 10;

%tamanho do mapa e ponto inicial de corte
TamanhoMapa = 300;
IniLat = 500;
IniLon = 500;

%prealocando variaveis
lat = zeros(1,TamanhoMapa);
long = zeros(1,TamanhoMapa);
elevacao = zeros(TamanhoMapa,TamanhoMapa);
hITU = zeros(TamanhoMapa,TamanhoMapa);
d = zeros(TamanhoMapa,TamanhoMapa);
Cor = zeros(TamanhoMapa,TamanhoMapa);
Ec = zeros(TamanhoMapa,TamanhoMapa);

for i = 1:TamanhoMapa
    
    lat(i) = mapa.lat(IniLat + i-1);
    long(i) = mapa.lon(IniLon + i-1);
    
    for j = 1:TamanhoMapa
        elevacao(i,j) = mapa.z(IniLat + i, IniLon + j);
    end
end

%coordenada de Estudo
%Coord = [258 11];
elevacaoTx = elevacao(Coord(1), Coord(2));
[distx, disty] = size(elevacao);

%lat = mapa.lat;
%long = mapa.lon;
%elevacao = mapa.z;

[XUTM,YUTM,utm] = deg2utm(lat,long);

%======================loop de teste===============

CorERP = 0;
x = 1;
for y = 1:disty
    [hITU,d,Cor] = NovoLinhaPixel(Coord(1), Coord(2), x,y,XUTM,YUTM, elevacao,hAnt,elevacaoTx,hITU,d,Cor);  
end

y = 1;
for x = 1:distx
    [hITU,d,Cor] = NovoLinhaPixel(Coord(1), Coord(2), x,y,XUTM,YUTM, elevacao,hAnt,elevacaoTx,hITU,d,Cor);
end

x = distx;
for y = disty:-1:1
    [hITU,d,Cor] = NovoLinhaPixel(Coord(1), Coord(2), x,y,XUTM,YUTM, elevacao,hAnt,elevacaoTx,hITU,d,Cor);
end

y = disty;
for x = distx:-1:1
    [hITU,d,Cor] = NovoLinhaPixel(Coord(1), Coord(2), x,y,XUTM,YUTM, elevacao,hAnt,elevacaoTx,hITU,d,Cor);
end

%valores para o pixel do Tx (não calculável)
hITU(Coord(1),Coord(2)) = elevacaoTx;
d(Coord(1),Coord(2)) = 30;
Cor(Coord(1),Coord(2)) = 0;

%calculando Ec
for x = 1:distx
    for y = 1:disty
        CITU = Cor(x,y) + CorERP;
        Ec(x,y) = Aplica_ITU(A,B,C,D,d(x,y)/1000,hITU(x,y),CITU);
    end
end

%================================================

end