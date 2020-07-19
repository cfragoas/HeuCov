function [d,Ec] = CalculaManchaITU(ERP,hTx,Coord,elevacao,XUTM,YUTM)
%clear
%clc
%tic


%parâmetros ITU otimizados
A = [0.0926, 0.7503, -35.075, 91.2638];
B = [51.1222, 10.8779, 2.1819, 0.5451, -0.314, 1.5422, 49.0288, 96.2994];
C = [6.3549, 2.9537, 1.7512, 1.7385, 196.3467, -0.3879, 2.3631];     
D = [4.9617, 1.2175];

elevacaoTx = elevacao(Coord(1), Coord(2));
[distx, disty] = size(elevacao);

% mapa = readhgt('S23W044.hgt');
%altura da antena de TX e RX
% hAhTxnt = 30;
% hRX = 10;
% ERP = 1000;

%tamanho do mapa e ponto inicial de corte
% TamanhoMapa = 1000;
% IniLat = 500;
% IniLon = 500;

%prealocando variaveis
% lat = zeros(1,TamanhoMapa);
% long = zeros(1,TamanhoMapa);
% elevacao = zeros(TamanhoMapa,TamanhoMapa);
hITU = zeros(distx,disty);
d = zeros(distx,disty);
Cor = zeros(distx,disty);
Ec = zeros(distx,disty);
%Pot = zeros(TamanhoMapa,TamanhoMapa);

% parfor i = 1:TamanhoMapa
%     
%     lat(i) = mapa.lat(IniLat + i-1);
%     long(i) = mapa.lon(IniLon + i-1);
%     
%     for j = 1:TamanhoMapa
%         elevacao(i,j) = mapa.z(IniLat + i, IniLon + j);
%     end
% end

%coordenada de Estudo
%Coord = [258 11];


%lat = mapa.lat;
%long = mapa.lon;
%elevacao = mapa.z;

% [XUTM,YUTM,utm] = deg2utm(lat,long);

parfor x = 1:distx
    
    for y =1:disty
        
        %calculando h1
        %elevacaoRX = elevacao(x,y) + hRX;
        [hITU(x,y),d(x,y),Cor(x,y)] = LinhaPixel(Coord(1), Coord(2), x,y,XUTM,YUTM, elevacao,hTx,elevacaoTx);
        
        %calculando Ec
        CorERP = 10*log10(ERP/1000);
        CITU = Cor(x,y) + CorERP;
        Ec(x,y) = Aplica_ITU(A,B,C,D,d(x,y)/1000,hITU(x,y),CITU);
        %convertendo campo elétrico em potência
        %Pot(x,y) = converte_pot_campo(Ec(x,y),1,'H',0);
    end
    
end

%elevacao(Coord(1),Coord(2)) = elevacao(Coord(1),Coord(2)) + 1000;
%s = surf(lat,long,elevacao,Ec);
%s.EdgeColor = 'none';

%caxis([-50, 0])
%toc

end