clear
clc


%==============variáveis da regiao estudada===========
load('QueimadosTratado.mat','Elev');
elevacao = Elev;
elevacao = double(elevacao);
clear Elev
TamanhoMapaX = size(elevacao,1);
TamanhoMapaY = size(elevacao,2);
XUTM = ((1:1:TamanhoMapaX).*30)-30;
YUTM = ((1:1:TamanhoMapaY).*30)-30;

load('QueimadosTratado.mat','RI2');
RegiaoInteresse = RI2;
RegiaoInteresse( RegiaoInteresse > 1) = 1;
clear RI2

TamanhoRegiao = sum(sum(RegiaoInteresse));

load('QueimadosTratado.mat','centroide');
PCentral = centroide;
clear centroide
%=====================================================
TIMEMAX = 0;
PCTCoberturaCombinadaTotal =  zeros(1000,50);
MpctCobertura = zeros(TamanhoMapaX,TamanhoMapaY);

TIMETOTAL = 1; % contador de iterações
nTx = 1;

 Coord(1,:) = [1,1];
% Coord(2,:) = [500,500];
% Coord(3,:) = [500,1];
% Coord(4,:) = [1,500];
% Coord(5,:) = [1,250];
% Coord(6,:) = [500,250];
% Coord(7,:) = [100,250];
% Coord(8,:) = [100,100];
% Coord(9,:) = [50,250];
% Coord(10,:) = [500,300];

for perc = 0.2:0.2:1
%comecando com apenas 1 transmissor
     
    TIMEMAX = TIMEMAX+300;
    %dados gerais de transmissào
    hTx = 30;
    %ERP = 0.5; %ERP em watts
    ERP = 1;
    hRx = 10;


    %lendo o mapa da regiào de interesse
    
    %mapa = readhgt('S23W044.hgt');

    %cortando o mapa
    %======================================================================
    %TamanhoMapa = 500;
    %IniLat = 2500;
    %IniLon = 1500;

    %inicializando as variáveis
    %lat = zeros(1,TamanhoMapa);
    %long = zeros(1,TamanhoMapa);
    %elevacao = zeros (TamanhoMapa);
    %RegiaoInteresse = zeros (TamanhoMapa);
    dist = zeros(TamanhoMapaX,TamanhoMapaY);

    %parfor i = 1:TamanhoMapa

        %lat(i) = mapa.lat(IniLat + i-1);
        %long(i) = mapa.lon(IniLon + i-1);

        %for j = 1:TamanhoMapa
            %elevacao(i,j) = mapa.z(IniLat + i, IniLon + j);
        %end
    %end


    %elevacao(elevacao == 0) = 1;
    

    %[XUTM,YUTM,utm] = deg2utm(lat,long); %conversao das coordenadas para UTM

    %região de cobertura (Queimados)


    
    %VERIFICAR A UTILIZAÇÃO DA VARIÁVEL TAMANHOREGIAO (SE VAI DAR RUIM)
    %for i =1:TamanhoRegiao

        %for j =1:TamanhoRegiao
            %RegiaoInteresse(IniLat + i, IniLon + j) = 1;
        %end

    %end
    

    
    %PCentral = [(IniLat + TamanhoRegiao/2),(IniLon + TamanhoRegiao/2) ];
    % distancia = zeros(TamanhoRegiao);

    %distancia de todos os pontos para o ponto central (referência)
    for i = 1:TamanhoMapaX
       for j = 1:TamanhoMapaY

           distx = [XUTM(PCentral(1)),XUTM(i)];
           disty = [YUTM(PCentral(2)),YUTM(j)];
           dist(i,j) = sqrt(((abs(distx(1) - distx(2))^2)) + ((abs(disty(1) - disty(2)))^2));

       end
    end
    %======================================================================

    %inicializando as variáveis globais
    TIME = 2;
    hITU = zeros(TamanhoMapaX,TamanhoMapaY);
    d = zeros(nTx,TamanhoMapaX,TamanhoMapaY);
    Cor = zeros(TamanhoMapaX,TamanhoMapaY);
    Ec = zeros(nTx,TamanhoMapaX,TamanhoMapaY);
    raio = ones(1,nTx)*100; %raio inicial
    CondicaoCobertura = 0;
    CoberturaConjunta(1,:,:) = zeros(TamanhoMapaX,TamanhoMapaY);
    pctCobertura = zeros(1,nTx);
    %MpctCobertura = ones(TamanhoMapa)*0.000000000001;
    elevacao(elevacao <= 0) = 1;
    %Maximos = imregionalmax(smooth2a(elevacao,4,4));
    %Maximos = imregionalmax(elevacao);
    Maximos = NMaiores(imregionalmax(elevacao).*elevacao.*RegiaoInteresse,perc);
    Centroides = Maximos;
    RegiaoFora = zeros(TamanhoMapaX,TamanhoMapaY);
    RegiaoFora(RegiaoInteresse == 0) = 1;
    CentroidesFora = NMaiores(imregionalmax(elevacao).*elevacao.*RegiaoFora,0.3);
    Maximos = Maximos + CentroidesFora;
    %CentroidesFora = imregionalmax(smooth2a(elevacao,4,4));
    %Centroides = imregionalmax(smooth2a(elevacao,1,1));
    elevacaoN = log10(elevacao);
    peso_elevacao = elevacaoN./max(max(elevacaoN));
    PesoCentroidesFora = CalculaCentroidesFora(RegiaoInteresse,CentroidesFora,XUTM,YUTM);
    
    %===============================================
%      elevacao = ones(500,500);
%      peso_elevacao = zeros(500,500);
    %===============================================
    distN = log10(dist);
    peso_distancia = (max(max(distN))./distN);
    peso_distancia(peso_distancia == inf) = (max(max(dist)))/30;
    peso_distancia = peso_distancia./(max(max(peso_distancia)));
    % peso_elevacao = peso_elevacao.*((max(max(dist))/max(max(elevacao))));
    %peso_pontoBom = ones(TamanhoMapa);
    PtoRepetido = zeros(nTx); %marcador para evitar o cálculo de um mesmo ponto 2x
    pctCoberturaCombinada = ones(1000,1+(nTx*2));
    pctCoberturaCombinadaOLD = 0;
    ProxPtoX = zeros(1,nTx);
    ProxPtoY = zeros(1,nTx);
    ProxCoord = zeros(1,nTx*2);

    %determinando as posicoes iniciais dos pontos
%     for i = 1:nTx
%         aleatorio = randn(size(elevacao,1),size(elevacao,2));
%         maximo = aleatorio.*((peso_elevacao) + (3*peso_distancia));
%         [coordx,coordy] = find(max(max(maximo)) == maximo);
%         Coord(i,1) = coordx;
%         Coord(i,2) = coordy;
%     end




    CoordOld =Coord;

    while CondicaoCobertura == 0   

    %Rodando a cobertura ppara cada Tx
        for i = 1:nTx


            [d(i,:,:),Ec(i,:,:)] = CalculaManchaITU(ERP,hTx,Coord(i,:),elevacao,XUTM,YUTM); %calculo do campo eletromagnético por ponto

    %         end

        end

        CoberturaConjunta(TIME,:,:) = zeros(TamanhoMapaX,TamanhoMapaY);
        Cobertura = zeros(TamanhoMapaX,TamanhoMapaY,i);
        %verificando a condição de cobertura por ponto
        for i = 1:nTx
            CoberturaDUMMY = zeros(TamanhoMapaX,TamanhoMapaY);
            CoberturaRegiaoInteresse(i,:,:) = zeros(TamanhoMapaX,TamanhoMapaY);

                CoberturaDUMMY(Ec(i,:,:)>= 58) =  1;  
                CoberturaRegiaoInteresse(i,:,:) = RegiaoInteresse.*CoberturaDUMMY;
                CoberturaConjunta(TIME,:,:) = reshape(CoberturaConjunta(TIME,:,:), [TamanhoMapaX, TamanhoMapaY]) + reshape(CoberturaRegiaoInteresse(i,:,:), [TamanhoMapaX, TamanhoMapaY]);
                pctCoberturaOLD(i) = pctCobertura(i);
                pctCobertura(i) = size(find(CoberturaRegiaoInteresse(i,:,:) == 1),1)/(TamanhoRegiao);
                CoordOld(i,:) = Coord(i,:);

                if pctCobertura(i) == 0 
                    pctCobertura(i) = 0.1;
                end

                MpctCobertura(Coord(i,1),Coord(i,2)) = pctCobertura(i);
                %peso_pontoBom(Coord(i,1),Coord(i,2)) = pctCobertura(i);



        end

        pctCoberturaCombinadaOLD =  pctCoberturaCombinada(TIME - 1,1);
        pctCoberturaCombinada(TIME,1) = size(find(reshape(CoberturaConjunta(TIME,:,:), [TamanhoMapaX, TamanhoMapaY]) >= 1),1)/(TamanhoRegiao);
       
        for j = 1:nTx
            pctCoberturaCombinada(TIME,(j*2):((j*2)+1)) = CoordOld(j,:);
        end
        PCTCoberturaCombinadaTotal(TIMETOTAL,1:size(pctCoberturaCombinada,2)) = pctCoberturaCombinada(TIME,:);
        TIME = TIME + 1;
        PtoRepetido(1:nTx) = 0;

        %determinando o raio de movimentaçao da coordenada do Tx para a próxima
        %interação

        parfor i=1:nTx
%             if pctCoberturaCombinadaOLD > pctCoberturaCombinada(TIME - 1,1)
              if pctCoberturaOLD(i) >= pctCobertura(i)
                if pctCobertura(i) == 0.01
                    raio(i) = raio(i) + 300;
                    alfa(i) = 2;
                else
    %             raio(i) = (raio(i)*5)*((max(max(MpctCobertura))/(pctCobertura(i))));
    %              raio(i) = (raio(i)*4)*((max(max(pctCoberturaCombinada(:,1)))/(pctCoberturaCombinadaOLD)));  
                    %raio(i) = raio(i) + 30;
                    raio(i) = raio(i)*1.5;
                    alfa(i) = 0.5;
                end
            else
                if pctCobertura(i) ~= 0.01
                    alfa(i) = 0.5;

    %             raio(i) = raio(i)/(10*((pctCobertura(i))/max(max(MpctCobertura))));
    %              raio(i) = raio(i)/(8*(( pctCoberturaCombinadaOLD)/max(max(pctCoberturaCombinada(:,1)))));
                    %raio(i) = raio(i)/3;
                    raio(i) = raio(i)/2;
                else
                    alfa(i) = 2;
                end
            end

            if raio(i) >= min(TamanhoMapaX,TamanhoMapaY)*30*sqrt(2)
                raio(i) = min(TamanhoMapaX,TamanhoMapaY)*30*sqrt(2);
            end

            if raio(i) < 300
                raio(i) = 300;
            end
        end 


            Mproxpnt = zeros(nTx,TamanhoMapaX,TamanhoMapaY);
            repetido = 1;
            %RegiaoBusca = intersecaoTx(nTx,CoberturaRegiaoInteresse,RegiaoInteresse,Coord,elevacao); %verificando os interferentes e direcionando a busca a partir deles
            RegiaoBusca = ones(nTx,TamanhoMapaX,TamanhoMapaY);
            PesoPtoBom = MpctCobertura./max(max(MpctCobertura));
            PesoPtoBom(PesoPtoBom == 0) = 1;
            
            while repetido == 1 
                PesoCentroide = PesoCentroides(reshape(CoberturaConjunta(TIME-1,:,:),[size(elevacao,1), size(elevacao,2)]),RegiaoInteresse,d,nTx,XUTM,YUTM,raio,Maximos,Coord,Centroides);
                
                for i = 1:nTx
                    ProxPtoXDUMMY = [];
                    ProxPtoYDUMMY = [];

                    while isempty(ProxPtoXDUMMY) == 1 
                        while max(max(Mproxpnt(i,:,:))) == 0
                            MatrizRaio = zeros(TamanhoMapaX,TamanhoMapaY);
                            aleatorio = zeros(TamanhoMapaX,TamanhoMapaY);
                            DUMMY = [];
                            IndexRaio = find(d(i,:,:)<raio(i));
                            MatrizRaio(IndexRaio) = 1;
                            MatrizRaio(pctCoberturaCombinada(TIME-1,i*2),pctCoberturaCombinada(TIME-1,(i*2)+1)) = 0; %impossibilidando o ponto anterior ser escolhido na próxima iteração
                            DUMMY = find(reshape(RegiaoBusca(i,:,:),[size(elevacao,1), size(elevacao,2)]).*MatrizRaio.*Maximos == 1);
                            aleatorio(DUMMY) = randn(1,size(DUMMY,1));
                            %Mproxpnt(i,:,:) = aleatorio.*((3*peso_elevacao) + (alfa(i)*4*peso_distancia) + (2.*(reshape(PesoCentroide(i,:,:),[size(elevacao,1), size(elevacao,2)]))));
                            %Mproxpnt(i,:,:) = PesoPtoBom.*aleatorio.*((((alfa(i)*4*PesoCentroidesFora) +(2*peso_elevacao) ) + (5.*(reshape(PesoCentroide(i,:,:),[size(elevacao,1), size(elevacao,2)])))));
                            %guardando as variáveis para estudo
                            HPesoCentroide(i,TIMETOTAL,:,:) = PesoCentroide(i,:,:);
                            
                            %======================================================
                            Mproxpnt(i,:,:) = PesoPtoBom.*(aleatorio+((((alfa(i)*4*PesoCentroidesFora) +(2*peso_elevacao) ) + (5.*(reshape(PesoCentroide(i,:,:),[size(elevacao,1), size(elevacao,2)]))))));

                            if max(max(Mproxpnt(i,:,:))) == 0 
                               raio(i) = raio(i) + 20; 
                            end

                            if raio(i) > (min(TamanhoMapaX,TamanhoMapaY)*30)*sqrt(2)
                                RegiaoBusca(i,:,:) = (ones(size(elevacao,1),size(elevacao,2)));
                                raio(i) = 200;
                            end


                        end
                        %==================
                        %Mproxpnt(i,:,:) = Mproxpnt(i,:,:) + PesoCentroides(CoberturaConjunta(TIME,:,:),RegiaoInteresse,d,nTx,XUTM,YUTM,Mproxpnt);
                        [ProxPtoXDUMMY, ProxPtoYDUMMY]  = find(reshape(Mproxpnt(i,:,:),[TamanhoMapaX,TamanhoMapaY]) == max(max(reshape(Mproxpnt(i,:,:),[TamanhoMapaX,TamanhoMapaY]))));



    %                     if isempty(ProxPtoXDUMMY) == 1 || ((ProxPtoXDUMMY == ProxPtoX(i) && ProxPtoYDUMMY == ProxPtoY(i)))

                        if isempty(ProxPtoXDUMMY) == 1 || (((ismember(ProxPtoXDUMMY, ProxPtoX) && ismember(ProxPtoYDUMMY, ProxPtoY))) == 1)

                            raio(i) = raio(i)+30; 
                            ProxPtoXDUMMY = [];
                            ProxPtoYDUMMY = [];
                            Mproxpnt(1:nTx,:,:) = zeros(nTx,TamanhoMapaX,TamanhoMapaY);

                        else

                            ProxPtoX(i) = ProxPtoXDUMMY;
                            ProxPtoY(i) = ProxPtoYDUMMY;
                        end

                    end

                    ProxPtoXDUMMY = [];
                    ProxPtoYDUMMY = [];

                end

                for i=1:nTx

                    ProxCoord((i*2)-1:((i*2))) = [ProxPtoX(i),ProxPtoY(i)];

                end

                %identificando todas as permutações do conjunto de pontos
                %escolhidos
                perm = perms(1:nTx);

                for i=1:size(perm,1)
                    for j = 1:size(perm,2)
                        permutacoes(i,((2*j)-1):(2*j)) = ProxCoord(1,((2*perm(i,j))-1):(2*perm(i,j)));
                    end
                end

                %verificando se o ponto e as suas permutações já foram
                %estudadas
                repetido = 0;
                for i=1:size(permutacoes,1)
                    if ismember(permutacoes(i,:),pctCoberturaCombinada(:,2:((2*nTx)+1)),'ROWS') ~= 0

                        repetido = 1;
                        raio(1:nTx) = raio(1:nTx) + 100;
                        Mproxpnt(1:nTx,:,:) = zeros(nTx,TamanhoMapaX,TamanhoMapaY);
                        break

                    end
                end
            end

        parfor i = 1:nTx
             if raio(i) > (min(TamanhoMapaX,TamanhoMapaY)*30)*sqrt(2)
                 raio(i) = min(TamanhoMapaX,TamanhoMapaY)*30*sqrt(2);
             end

            if raio(i) < 300
                raio(i) = 300;
            end

            Coord(i,:) = [ProxPtoX(i), ProxPtoY(i)];
        end


    TIMETOTAL = TIMETOTAL + 1;   
    if TIMETOTAL > TIMEMAX
        break
    end
    
     end
end
