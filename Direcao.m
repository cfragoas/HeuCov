function RegiaoBusca =  Direcao(MaioresInter,Coord,elevacao,RegiaoBusca)
    nTx = size(Coord,1);
    [dimx,dimy] = size(elevacao);
    ang = zeros(dimx,dimy);
    angPTx = zeros(dimx,dimy);
    
    
    for n = 1:nTx
        
        if reshape(RegiaoBusca(n,:,:), [dimx dimy]) == ones(dimx,dimy)
            
            continue
            
        else        
            
            Coord0 = Coord(MaioresInter(n,1),1:2);
            x0 = Coord0(1);
            y0 = Coord0(2);
            Coord1 = Coord(MaioresInter(n,2),1:2);
            x1 = Coord1(1);
            y1 = Coord1(2);
            
            deltax = x1 - x0;
            deltay = y1 - y0;
            Octo = DecideOcto(deltax,deltay);

            i = 1;

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

            %calculo dos pesos
            peso1 = MaioresInter(n,3);
            peso2 = MaioresInter(n,4);
    %         if peso1 > peso2
                DeltaN = peso1/(peso1 + peso2);
    %         else
    %             DeltaN = peso2/peso1;
    %         end

            Npontos = size(indexX,2);
            Passo = DeltaN*Npontos;
            
            if Passo < 1
                Passo = 1;
            end
            
            PtMed = [indexX(round(Passo)),indexY(round(Passo))];

            %calculo dos angulos
            %===============================================================
            for k = 1:dimx
                for j=1:dimy

                    deltaX = PtMed(1) - k;
                    deltaY = PtMed(2) - j;
                    %determinacao do quadrante dos pontos para o calculo de azimute

                    %primeiramente vemos se os pontos estão nos limites dos
                    %quadrantes
                    if deltaX == 0 
                        if deltaY > 0
                           ang(k,j) = 270; 
                        else
                           ang(k,j) = 90; 
                        end

                    else

                        if deltaY == 0
                            if deltaX > 0
                                ang(k,j) = 0; 
                            else
                                ang(k,j) = 180; 
                            end
                        end

                    end


                    %agora os angulos dados os quadrantes em si
                    if deltaX > 0 && deltaY > 0 %quadrante 4

                        ang(k,j) = atand(abs(deltaX/deltaY)) + 270;

                    else if deltaX > 0 && deltaY < 0 %quadrante 1

                            ang(k,j) = atand(abs(deltaY/deltaX));

                        else if deltaX < 0 && deltaY > 0 %quadrante 3

                                ang(k,j) = atand(abs(deltaY/deltaX)) + 180;

                            else if deltaX < 0 && deltaY < 0 %quadrante 2

                                    ang(k,j) = atand(abs(deltaX/deltaY)) + 90;


                                end
                            end
                        end
                    end



                end
            end
           % =====================================================================================

           %=================================================================================
           %novamente para o ponto que irá ser movido

           for k = 1:dimx
                for j=1:dimy

                    deltaX = Coord(n,1) - k;
                    deltaY = Coord(n,2) - j;
                    %determinacao do quadrante dos pontos para o calculo de azimute

                    %primeiramente vemos se os pontos estão nos limites dos
                    %quadrantes
                    if deltaX == 0 
                        if deltaY > 0
                           angPTx(k,j) = 270; 
                        else
                           angPTx(k,j) = 90; 
                        end

                    else

                        if deltaY == 0
                            if deltaX > 0
                                angPTx(k,j) = 0; 
                            else
                                angPTx(k,j) = 180; 
                            end
                        end

                    end


                    %agora os angulos dados os quadrantes em si
                    if deltaX > 0 && deltaY > 0 %quadrante 4

                        angPTx(k,j) = atand(abs(deltaX/deltaY)) + 270;

                    else if deltaX > 0 && deltaY < 0 %quadrante 1

                            angPTx(k,j) = atand(abs(deltaY/deltaX));

                        else if deltaX < 0 && deltaY > 0 %quadrante 3

                                angPTx(k,j) = atand(abs(deltaY/deltaX)) + 180;

                            else if deltaX < 0 && deltaY < 0 %quadrante 2

                                    angPTx(k,j) = atand(abs(deltaX/deltaY)) + 90;


                                end
                            end
                        end
                    end



                end
            end
            %===================================================================
            %marcando a região no quadrante formado pelos pesos dos pontos de
            %sobreposição

            angRef1 = ang(x1,y1);
            angRef2 = ang(x0,y0);
            angPtoRef = ang(Coord(n,1),Coord(n,2));

            if peso1 > peso2

               angIni = angRef2;
               angFim2 = angRef1;
            else

               angIni = angRef1;
               angFim2 = angRef2;
            end

            %determinando os ãnguilos da região de movimentação
            if (angIni >= 270) && (angPtoRef <= 90 || (angPtoRef >= 270 && angPtoRef <= angIni) || (angPtoRef >= 180 && angPtoRef <= angFim2))
    %             angFim = angIni - 270;
                RegiaoBusca(n,(angPTx >= angIni) | (angPTx <= (angIni - 270))) = 1;
%                  s = surf(1:500,1:500,elevacao,reshape(RegiaoBusca(n,:,:), [500 500]));
%                  s.LineStyle = ':';
            else
                if (angIni <= 90) && (((angPtoRef <= 360) && (angPtoRef >= angFim2)) || ((angPtoRef <= 90 )&& (angPtoRef<= angIni)))
    %                 angFim = angIni + 270;
                    RegiaoBusca(n,(angPTx <= angIni) | (angPTx >= (angIni + 270))) = 1;
%                      s = surf(1:500,1:500,elevacao,reshape(RegiaoBusca(n,:,:), [500 500]));
%                      s.LineStyle = ':';
                else
                    if angIni > angPtoRef
    %                     angFim = angIni - 90;
                        RegiaoBusca(n,(angPTx >= angIni - 90) & (angPTx <= angIni)) = 1;
%                          s = surf(1:500,1:500,elevacao,reshape(RegiaoBusca(n,:,:), [500 500]));
%                          s.LineStyle = ':';
                    else
    %                     angFim = angIni + 90;
                        RegiaoBusca(n,(angPTx >= angIni) & (angPTx <= (angIni + 90))) = 1;
%                          s = surf(1:500,1:500,elevacao,reshape(RegiaoBusca(n,:,:), [500 500]));
%                          s.LineStyle = ':';
                    end
                end
            end



        end

    end
end