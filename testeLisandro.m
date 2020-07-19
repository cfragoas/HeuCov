clear
nTx = 3;
Coord(1,:) = [51 218];
Coord(2,:) = [30 773];
Coord(3,:) = [987 599];

%iniciando os threads da otimização em paralelo
%parpool(3)

elevacao = zeros(3,1000,1000);
Ec = zeros(3,1000,1000);
tic
for i =1:nTx
    
    [elevacao(i,:,:),Ec(i,:,:)] = CalculaManchaITU(Coord(i,:));
    
end
toc

elevacaoTx = elevacao(1,:,:);
for i = 1:nTx
   
    elevacaoTx(1,Coord(i,1),Coord(i,2)) = elevacaoTx(1,Coord(i,1),Coord(i,2)) + 400;
    
end

for x=1:1000
      for y = 1:1000 
          if Ec(1,x,y) > 58
             CoberturaTx1(x,y) = 1;
          else
              
              CoberturaTx1(x,y) = 0;
          end
          
          if Ec(2,x,y) > 58
             CoberturaTx2(x,y) = 1;
          else
              
              CoberturaTx2(x,y) = 0;
          end
          
          if Ec(3,x,y) > 58
             CoberturaTx3(x,y) = 1;
          else
              
              CoberturaTx3(x,y) = 0;
          end
      end
end



%Cobertura e Best Server
   for x=1:1000
      for y = 1:1000 
          
          if Ec(1,x,y) > 58 || Ec(2,x,y) > 58 || Ec(3,x,y) > 58
          Cobertura(x,y) = 1;
          else
          Cobertura(x,y) = 0;    
          end
          
          if Cobertura(x,y) == 1
             if Ec(1,x,y) > Ec(2,x,y) && Ec(1,x,y) > Ec(3,x,y)
             BestServer(x,y) = 1;
             else if Ec(2,x,y) > Ec(1,x,y) && Ec(2,x,y) > Ec(3,x,y)
                     BestServer(x,y) = 2;
                 else
                     BestServer(x,y) = 3;
                 end
             end
          end
          
      end
   end
   figure
   s = surf(1:1000,1:1000,reshape(elevacaoTx(1,:,:),[1000 1000]),CoberturaTx1);
   s.LineStyle = ':';
   figure
   s = surf(1:1000,1:1000,reshape(elevacaoTx(1,:,:),[1000 1000]),CoberturaTx2);
   s.LineStyle = ':';
   figure
   s = surf(1:1000,1:1000,reshape(elevacaoTx(1,:,:),[1000 1000]),CoberturaTx3);
   s.LineStyle = ':';
   figure
   s = surf(1:1000,1:1000,reshape(elevacaoTx(1,:,:),[1000 1000]),BestServer);
   s.LineStyle = ':';
   figure
   s = surf(1:1000,1:1000,reshape(elevacaoTx(1,:,:),[1000 1000]),Cobertura);
   s.LineStyle = ':';
   
   %quantidade de Tx cobrindo o ponto e cobertura individual
   QtdTx = zeros(1000,1000);
   CoberturaTx1 = zeros(1000,1000);
   CoberturaTx2 = zeros(1000,1000);
   CoberturaTx3 = zeros(1000,1000);
   ElevacaoPtCobertTx1 = zeros(1000,1000);
   ElevacaoPtCobertTx2 = zeros(1000,1000);
   ElevacaoPtCobertTx3 = zeros(1000,1000);
   EcCobertoTx1 = zeros(1000,1000);
   EcCobertoTx2 = zeros(1000,1000);
   EcCobertoTx3 = zeros(1000,1000);
   
   for x=1:1000
      for y = 1:1000
          if Ec(1,x,y) > 58
               QtdTx(x,y) = QtdTx(x,y) + 1; 
               CoberturaTx1(x,y) = 1;
               ElevacaoPtCobertTx1(x,y) = elevacao(1,51,218) + 30 - elevacao(1,x,y);
               EcCobertoTx1(x,y) = Ec(1,x,y);
               distCobertoTx1(x,y) = sqrt(((51 - x)^2)+((218 - x)^2))*30;
          else
              ElevacaoPtCobertTx1(x,y) = NaN;
              distCobertoTx1(x,y) = NaN;
          end
          
          if Ec(2,x,y) > 58
               QtdTx(x,y) = QtdTx(x,y) + 1; 
               CoberturaTx2(x,y) = 1;
               ElevacaoPtCobertTx2(x,y) = elevacao(1,30,773) + 30 - elevacao(1,x,y);
               EcCobertoTx2(x,y) = Ec(2,x,y);
               distCobertoTx2(x,y) = sqrt(((30 - x)^2)+((773 - x)^2))*30;
          else
              ElevacaoPtCobertTx2(x,y) = NaN;
              distCobertoTx2(x,y) = NaN;
          end
          
          if Ec(3,x,y) > 58
               QtdTx(x,y) = QtdTx(x,y) + 1; 
               CoberturaTx3(x,y) = 1;
               ElevacaoPtCobertTx3(x,y) = elevacao(1,987,599) + 30 - elevacao(1,x,y);
               EcCobertoTx3(x,y) = Ec(3,x,y);
               distCobertoTx3(x,y) = sqrt(((987 - x)^2)+((599 - x)^2))*30;
          else
              ElevacaoPtCobertTx3(x,y) = NaN;
              distCobertoTx3(x,y) = NaN;
          end
      end
   end
   
   figure
   s = surf(1:1000,1:1000,reshape(elevacaoTx(1,:,:),[1000 1000]),QtdTx);
   s.LineStyle = ':';
   
   for x = 1:1000
       for y =1:1000
           maxEcpt(x,y) = max([Ec(1,x,y) Ec(2,x,y) Ec(3,x,y)]);
           minEcpt(x,y) = min([Ec(1,x,y) Ec(2,x,y) Ec(3,x,y)]);
           medEcpt(x,y) = mean(changem([Ec(1,x,y) Ec(2,x,y) Ec(3,x,y)],[0],[NaN]));
       end
   end
