function Pr = converte_pot_campo (E,Ant,pol,Papt)
Pc = 1.2; %perda nos cabos
    %antena yagi
    GHY = 9.2;
    GVY = 10.3;
    
    %antena painel
    GHP = 7.5;
    GVP = 6.3;
    for i = 1:size(E)
        if Ant(i) == 1 %antena yagi
           if pol == 'H'
               Gr(i) = GHY;
           else
               Gr(i) = GVY;
           end
           
        else %antena painel
            
            if pol == 'H'
               Gr(i) = GHP;
           else
               Gr(i) = GVP;
           end
        end
    end
    
    %Gr = 10.3;
    %E = 77.2 - Gr' + 20*log10(569.142857) + Pr + Pc - Papt;
    %E = 77.2 - Gr' + 20*log10(569.142857) + Pr + Pc;
    Pr = E -Pc - 77.2 - Gr' - 20*log10(569.142857);
    
end