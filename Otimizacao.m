clear
%comecando com apenas 1 transmissor
nTx = 1;
Coord(1,:) = [51 218];
%dados gerais de transmissào
hTx = 30;
ERP = 10; %ERP em watts
hRx = 10;


%lendo o mapa da regiào de interesse
mapa = readhgt('S23W044.hgt');

%cortando o mapa
%======================================================================
TamanhoMapa = 500;
IniLat = 500;
IniLon = 500;

%inicializando as variáveis
lat = zeros(1,TamanhoMapa);
long = zeros(1,TamanhoMapa);
elevacao = zeros (TamanhoMapa);
RegiaoInteresse = zeros (TamanhoMapa);
dist = zeros(TamanhoMapa);

parfor i = 1:TamanhoMapa
    
    lat(i) = mapa.lat(IniLat + i-1);
    long(i) = mapa.lon(IniLon + i-1);
    
    for j = 1:TamanhoMapa
        elevacao(i,j) = mapa.z(IniLat + i, IniLon + j);
    end
end

[XUTM,YUTM,utm] = deg2utm(lat,long); %conversao das coordenadas para UTM

%região de cobertura (teste)
IniLat = 100;
IniLon = 200;
TamanhoRegiao = 200;

for i =1:TamanhoRegiao
    
    for j =1:TamanhoRegiao
        RegiaoInteresse(IniLat + i, IniLon + j) = 1;
    end
    
end

PCentral = [(IniLat + TamanhoRegiao/2),(IniLon + TamanhoRegiao/2) ];
% distancia = zeros(TamanhoRegiao);

%distancia de todos os pontos para o ponto central (referência)
tic
for i = 1:TamanhoMapa
   for j = 1:TamanhoMapa 
               
       distx = [XUTM(PCentral(1)),XUTM(i)];
       disty = [YUTM(PCentral(2)),YUTM(j)];
       dist(i,j) = sqrt(((abs(distx(1) - distx(2))^2)) + ((abs(disty(1) - disty(2)))^2));
                
   end
end
toc
%======================================================================

%inicializando as variáveis globais
hITU = zeros(TamanhoMapa,TamanhoMapa);
d = zeros(nTx,TamanhoMapa,TamanhoMapa);
Cor = zeros(TamanhoMapa,TamanhoMapa);
Ec = zeros(nTx,TamanhoMapa,TamanhoMapa);
raio = 100;
CondicaoCobertura = 0;
TIME = 1;
pctCobertura = ones(TamanhoMapa)*0.01;
MpctCobertura = ones(TamanhoMapa)*0.000000000001;
Maximos = imregionalmax(elevacao);
peso_elevacao = elevacao./max(max(elevacao));
peso_distancia = (max(max(dist))./dist);
peso_distancia(peso_distancia == inf) = (max(max(dist)))/30;
peso_distancia = peso_distancia./(max(max(peso_distancia)));
% peso_elevacao = 3*((max(max(dist))/max(max(elevacao))));
peso_elevacao = peso_elevacao.*((max(max(dist))/max(max(elevacao))));
PtoRepetido = 0;

tic
while CondicaoCobertura == 0   
    
%Rodando a cobertura ppara cada Tx
    for i = 1:nTx
        if MpctCobertura(Coord(i,:)) ~= 0.000000000001
            PtoRepetido = 1;
        else
            
        [d(i,:,:),Ec(i,:,:)] = CalculaManchaITU(ERP,hTx,Coord(i,:),elevacao,XUTM,YUTM);
        
        end
        
    end


    Cobertura = zeros(TamanhoMapa);

    for i = 1:nTx
        
%         if PtoRepetido ~= 1 
            IndiceCobertura = find(Ec(i,:,:)>= 58);
            Cobertura(IndiceCobertura) =  1;            
%         end

    end
    
    CoberturaRegiaoInteresse = RegiaoInteresse.*Cobertura;
    pctCoberturaOLD = pctCobertura;
    if PtoRepetido == 1
       pctCobertura = MpctCobertura(Coord(i,:));
    else
        
    pctCobertura = size(find(CoberturaRegiaoInteresse == 1),1)/(TamanhoRegiao^2)
    
    end
    
    PtoRepetido = 0;
    
    if pctCobertura == 0 
        pctCobertura = 0.01;
    end

    if pctCobertura >= 0.85
        CondicaoCobertura = 1;
        break
    else
    
    MpctCobertura(Coord(1,1),Coord(1,2)) = pctCobertura;
    HpctCoberto(TIME) = pctCobertura;
    %determinando o raio de movimentaçao da coordenada do Tx para a próxima
    %interação
    
    if pctCoberturaOLD >= pctCobertura 
        raio = (raio*5)*((max(max(MpctCobertura))/(pctCobertura)));
    else
        raio = raio/(15*((pctCobertura)/max(max(MpctCobertura))));
    end
    
    if raio > TamanhoMapa*30*sqrt(2)
        raio = TamanhoMapa*30*sqrt(2);
    end
    
    if raio < 100
        raio = 100;
    end
    
   
        MatrizRaio = zeros(TamanhoMapa,TamanhoMapa);
        ProxPtoX = [];
        Mproxpnt = zeros(TamanhoMapa);
        
        
        for i = 1:nTx
            while isempty(ProxPtoX) == 1 
                while max(max(Mproxpnt)) == 0
                    IndexRaio = find(d(i,:,:)<raio);
                    MatrizRaio(IndexRaio) = 1;
                    aleatorio = randn(TamanhoMapa);
                    Mproxpnt = MatrizRaio.*Maximos.*aleatorio.*peso_elevacao.*peso_distancia;

                    if max(max(Mproxpnt)) == 0
                       raio = raio * 2; 
                    end
                end
                
                [ProxPtoX, ProxPtoY]  = find(Mproxpnt == max(max(Mproxpnt)));
                
                if isempty(ProxPtoX) == 1
                   
                    raio = raio * 3; 
                    
                end
                
            end
        end
              
        
    end
     
     if raio > (TamanhoMapa*30)*sqrt(2)
         raio = TamanhoMapa*30*sqrt(2);
     end
    
    if raio < 30
        raio = 30;
    end
    
    Coord(i,:) = [ProxPtoX, ProxPtoY];
    
    TIME = TIME + 1;
    raio
    plot(HpctCoberto)
    
end
toc
