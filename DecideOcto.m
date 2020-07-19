%Quadrantes principais e seus octantes
function Octo = DecideOcto(deltax,deltay)

    if deltay == 0 
        
        if deltax > 0
            Octo = 9;
            return
        else
            Octo = 13;
            return
        end
        
    elseif deltax == 0
        
        if deltay > 0
            Octo = 15;
            return
        else
            Octo = 11;
            return
        end
        
    end
    
    if abs(deltax) ==  abs(deltay)
       
        if deltay < 0 && deltax > 0
            Octo = 10;
            return
        elseif deltax < 0 && deltay < 0
            Octo = 12;
            return            
        elseif deltay > 0 && deltax < 0
            Octo = 14;
            return            
        elseif deltay > 0 && deltax > 0
            Octo = 16;
            return            
        end
        
    end
        
        
    

    if deltax > 0 && deltay > 0
    %I   
        if abs(deltax)>abs(deltay)
        %1    
            Octo = 1;
            return

        else
        %2   

            Octo = 2;
            return
        end

    elseif deltax < 0 && deltay > 0
    %II    
         if abs(deltay)>abs(deltax)
        %3    
            Octo = 3;
            return
        else
        %4   
            Octo = 4;
            return
        end

    elseif deltax < 0 && deltay < 0
    %III    

        if abs(deltax)>abs(deltay)
        %5    
            Octo = 5;
            return
        else
        %6   
            Octo = 6;
            return
        end

    elseif deltax > 0 && deltay < 0
    %IV

         if abs(deltay)>abs(deltax)
        %7    
            Octo = 7;
            return
        else
        %8   
            Octo = 8;
            return
        end

    end
end
