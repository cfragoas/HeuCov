%function LinhaPixel(x0,y0,x1,y1,dimx,dimy)
function [hITU,d,Cor] = NovoLinhaPixel(x0,y0,x1,y1,XUTM,YUTM,elev,hAnt,elevacaoTx,hITU,d,Cor)
%clear



% if x0 == x1 && y1 == y0
%    hITU = 30;
%    dist = 30;
%    Cor = 0;
%    return
% end



deltax = x1 - x0;
deltay = y1 - y0;
i = 1;
Octo = DecideOcto(deltax,deltay);

%matriz = zeros(dimx,dimy);

switch Octo
    
    case 1
%==========================================  

        deltaErro = abs(deltay/deltax);
        erro = 0;
        y = y0;

        indexX = zeros(1,abs(x1-x0));
        indexY = zeros(1,abs(x1-x0));
        
        for x  =x0:1:x1
            %matriz(y,x) = 1;
            indexX(i) = x;
            indexY(i) = y;
            i = i + 1;            
            erro = erro + deltaErro;
            if erro >= 0.5
               y = y + 1; 
               erro =  erro - 1; 
            end
        end

%=============================================

    case 2
%=============================================

        deltaErro = abs(deltax/deltay);
        erro = 0;
        x = x0;
        
        indexX = zeros(1,abs(y1-y0));
        indexY = zeros(1,abs(y1-y0));
        
        for y  =y0:1:y1
            %matriz(y,x) = 1;
            indexX(i) = x;
            indexY(i) = y;
            i = i + 1;             
            erro = erro + deltaErro;
            if erro >= 0.5
               x = x + 1; 
               erro =  erro - 1; 
            end
        end

%=============================================

    case 3
%=============================================

        deltaErro = abs(deltax/deltay);
        erro = 0;
        x = x0;
        
        indexX = zeros(1,abs(y1-y0));
        indexY = zeros(1,abs(y1-y0));
        
        for y  =y0:1:y1
            %matriz(y,x) = 1;
            indexX(i) = x;
            indexY(i) = y;
            i = i + 1;             
            erro = erro + deltaErro;
            if erro >= 0.5
               x = x - 1; 
               erro =  erro - 1; 
            end
        end
        
%=============================================

    case 4
%=============================================

        deltaErro = abs(deltay/deltax);
        erro = 0;
        y = y0;

        indexX = zeros(1,abs(x1-x0));
        indexY = zeros(1,abs(x1-x0));
        
        for x  =x0:-1:x1
            %matriz(y,x) = 1;
            indexX(i) = x;
            indexY(i) = y;
            i = i + 1; 
            erro = erro + deltaErro;
            if erro >= 0.5
               y = y + 1; 
               erro =  erro - 1; 
            end
        end
        
%=============================================        

    case 5
%============================================= 

        deltaErro = abs(deltay/deltax);
        erro = 0;
        y = y0;

        indexX = zeros(1,abs(x1-x0));
        indexY = zeros(1,abs(x1-x0));
        
        for x  =x0:-1:x1
            %matriz(y,x) = 1;
            indexX(i) = x;
            indexY(i) = y;
            i = i + 1; 
            erro = erro + deltaErro;
            if erro >= 0.5
               y = y - 1; 
               erro =  erro - 1; 
            end
        end        
        
%=============================================    

    case 6
%=============================================

        deltaErro = abs(deltax/deltay);
        erro = 0;
        x = x0;

        indexX = zeros(1,abs(y1-y0));
        indexY = zeros(1,abs(y1-y0));
        
        for y  =y0:-1:y1
            %matriz(y,x) = 1;
            indexX(i) = x;
            indexY(i) = y;
            i = i + 1; 
            erro = erro + deltaErro;
            if erro >= 0.5
               x = x - 1; 
               erro =  erro - 1; 
            end
        end
        
%============================================= 

    case 7
%============================================= 

        deltaErro = abs(deltax/deltay);
        erro = 0;
        x = x0;

        indexX = zeros(1,abs(y1-y0));
        indexY = zeros(1,abs(y1-y0));
        
        for y  =y0:-1:y1
            %matriz(y,x) = 1;
            indexX(i) = x;
            indexY(i) = y;
            i = i + 1; 
            erro = erro + deltaErro;
            if erro >= 0.5
               x = x + 1; 
               erro =  erro - 1; 
            end
        end
        
%============================================= 

    case 8
%============================================= 

        deltaErro = abs(deltay/deltax);
        erro = 0;
        y = y0;

        indexX = zeros(1,abs(x1-x0));
        indexY = zeros(1,abs(x1-x0));
        
        for x  =x0:1:x1
            %matriz(y,x) = 1;
            indexX(i) = x;
            indexY(i) = y;
            i = i + 1; 
            erro = erro + deltaErro;
            if erro >= 0.5
               y = y - 1; 
               erro =  erro - 1; 
            end
        end
        
%=============================================   

    case 9
 %=============================================        
        y = y0;
        
        indexX = zeros(1,abs(x1-x0));
        indexY = zeros(1,abs(x1-x0));
        
        for x  =x0:1:x1
           indexX(i) = x;
           indexY(i) = y;
           i = i + 1;            
           %matriz(y,x) = 1;
        
        end
%=============================================         
    case 10
%=============================================         
        
        indexX = zeros(1,abs(x1-x0));
        indexY = zeros(1,abs(x1-x0));
        
        y = y0;
        for x = x0:1:x1
           indexX(i) = x;
           indexY(i) = y;
           i = i + 1;
           y = y - 1;
         
        end
%=============================================         
    case 11
%=============================================         
        indexX = zeros(1,abs(y1-y0));
        indexY = zeros(1,abs(y1-y0));

        x = x0;
        for y  =y0:-1:y1
           indexX(i) = x;
           indexY(i) = y;
           i = i + 1;            
           %matriz(y,x) = 1;
        
        end  
%=============================================         
    case 12
        
        indexX = zeros(1,abs(x1-x0));
        indexY = zeros(1,abs(x1-x0));
        
        y = y0;
        for x = x0:-1:x1
           indexX(i) = x;
           indexY(i) = y;
           i = i + 1;
           y = y - 1;
         
        end        
%=============================================       
    case 13
%=============================================         
        indexX = zeros(1,abs(x1-x0));
        indexY = zeros(1,abs(x1-x0));

        y = y0;
        for x  =x0:-1:x1
           indexX(i) = x;
           indexY(i) = y;
           i = i + 1;            
           %matriz(y,x) = 1;
        
        end  
%=============================================         
    case 14
%=============================================         
        indexX = zeros(1,abs(y1-y0));
        indexY = zeros(1,abs(y1-y0));

        x = x0;
        for y = y0:1:y1
           indexX(i) = x;
           indexY(i) = y;
           i = i + 1;
           x = x - 1;
         
        end         
%=============================================         
    case 15
%=============================================         
        indexX = zeros(1,abs(y1-y0));
        indexY = zeros(1,abs(y1-y0));

        x = x0;
        for y  =y0:1:y1
           indexX(i) = x;
           indexY(i) = y;
           i = i + 1;            
           %matriz(y,x) = 1;
        
        end 
 %=============================================        
    case 16
%=============================================      
        indexX = zeros(1,abs(x1-x0));
        indexY = zeros(1,abs(x1-x0));

        y = y0;
        for x = x0:1:x1
           indexX(i) = x;
           indexY(i) = y;
           i = i + 1;
           y = y + 1;
         
        end  
%=============================================         
end
    


%prealocando as variáveis
elevacao = zeros(1,size(indexX,2));
dist = zeros(1,size(indexX,2));

for a = 1:1:size(indexX,2)

    elevacao(a) = elev(indexX(a),indexY(a));
    %[distx,disty] = deg2utm([lat(x0), lat(indexX(a))],[long(x0), long(indexX(a))]);
    distx = [XUTM(x0),XUTM(indexX(a))];
    disty = [YUTM(y0),YUTM(indexY(a))];
    dist(a) = sqrt(((abs(distx(1) - distx(2))^2)) + ((abs(disty(1) - disty(2)))^2));
    
end



Tamloop = ((size(indexX,2)));
%novo loop de média de relevo
%===========================================
for a = 2:1:Tamloop
   d(indexX(a),indexY(a)) = dist(a);
   if dist(a) > 15000
       for b = 1:1:a
          if dist(b) > 3000
              for c = Tamloop:-1:1
                  
                  if dist(c) < 15001
                      
                    if (elevacaoTx - mean(elevacao(a:b))) > 0
                        
                        hITU(indexX(a),indexY(a)) = elevacaoTx - mean(elevacao(b:c));
                        if dist(a) > 100 
                            Cor(indexX(a),indexY(a)) = ClearanceCorrection(dist(b:c),elevacao(b:c),elevacaoTx);
                        else
                            Cor(indexX(a),indexY(a)) = 0;
                        end
                    else
                        hITU(indexX(a),indexY(a)) = elevacaoTx - mean(elevacao(b:c));
                        Cor(indexX(a),indexY(a)) = ClearanceCorrection(dist(b:c),elevacao(b:c),elevacaoTx);
                        
                    end                  
                    %return
                  end
                  
              end
              
          end
       end
   else
       
   dLim = 0.2*dist(a);      
   
   for b = 1:1:Tamloop
        if dist(b) > dLim
            %for b = size(indexX,2):-1:1
                %if dist(b) < 15001 
                if ((elevacaoTx + hAnt) - mean(elevacao(b:size(indexX,2)))) > 0
                    hITU(indexX(a),indexY(a)) = (elevacaoTx + hAnt) - mean(elevacao(b:size(indexX,2)));
                    
                    if dist(a) > 100
                        Cor(indexX(a),indexY(a)) = ClearanceCorrection(dist(b:size(indexX,2)),elevacao(b:size(indexX,2)),elevacaoTx);
                    else
                        Cor(indexX(a),indexY(a)) = 0;
                    end
                    
                else
                    hITU(indexX(a),indexY(a)) = (elevacaoTx + hAnt) - mean(elevacao(b:size(indexX,2)));
                    Cor(indexX(a),indexY(a)) = ClearanceCorrection(dist(b:size(indexX,2)),elevacao(b:size(indexX,2)),elevacaoTx);
                    
                end
                %return
               
        end
    end
       
       
   end
end
%=========================================
%elevacaoRX = elevacao(x1,y1) + hRX;

% if dist(a) > 15 * 10 ^3
%     
%     for a = 1:1:size(indexX,2)
%         
%         if dist(a) > 3000
%             for b = size(indexX,2):-1:1
%                 if dist(b) < 15001
%                     if (elevacaoTx - mean(elevacao(a:b))) > 0
%                         
%                         hITU = elevacaoTx - mean(elevacao(a:b));
%                         if d > 100 
%                             Cor = ClearanceCorrection(dist(a:b),elevacao(a:b),elevacaoTx);
%                         else
%                             Cor = 0;
%                         end
%                     else
%                         hITU = elevacaoTx - mean(elevacao(a:b));
%                         Cor = ClearanceCorrection(dist(a:b),elevacao(a:b),elevacaoTx);
%                         
%                     end
%                     return 
%                 end
%             end
%         end
%     end
% else
%     dLim = 0.2*dist(a);
%     tam = a;
%     for a = 1:1:size(indexX,2)
%         if dist(a) > dLim
%             %for b = size(indexX,2):-1:1
%                 %if dist(b) < 15001 
%                 if ((elevacaoTx + hAnt) - mean(elevacao(a:size(indexX,2)))) > 0
%                     hITU = (elevacaoTx + hAnt) - mean(elevacao(a:size(indexX,2)));
%                     
%                     if d > 100
%                         Cor = ClearanceCorrection(dist(a:size(indexX,2)),elevacao(a:size(indexX,2)),elevacaoTx);
%                     else
%                         Cor = 0;
%                     end
%                     
%                 else
%                     hITU = (elevacaoTx + hAnt) - mean(elevacao(a:size(indexX,2)));
%                     Cor = ClearanceCorrection(dist(a:size(indexX,2)),elevacao(a:size(indexX,2)),elevacaoTx);
%                     
%                 end
%                 return
%                  
%         end
%     end
%     
% end


%plot(dist,elevacao)
%xlim([0 dist])
end