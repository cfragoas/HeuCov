function Cor = ClearanceCorrection(d,elevacao,elevacaoTx,hITU)
    f = 569.142857; 
    
%    [pks,locs] = findpeaks(elevacao);
    
    %teste com peakseek
    if hITU < 0 
        elevacaoRx = elevacaoTx;
    else
        elevacaoRx = elevacao(size(elevacao,2))+10;
        d = max(d) - d;
    end
    i = find(d < 16000);
    d = d(i);
    elevacao = elevacao(i);
    [locs, pks] = peakseek(elevacao);
     
     
    angulot = atand((elevacao(locs) - elevacaoRx)./(d(locs)));
%     MAngulo = max(max(max(angulo)));
%     if MAngulo > 40
%         MAngulo = 40;
%     end
%     if MAngulo < 0.55
%        MAngulo = 0.55; 
%     end

    MAngulo = 0;
   

    for i = locs 
        angulo = atand((elevacao(i) - elevacaoRx)/(d(i)));
        if angulo > 40

            MAngulo = 40;
            break

        else
            if angulo > MAngulo

                MAngulo = angulo;

            end
        end
    end
    
    if MAngulo < 0.55 
        MAngulo = 0.55;
    end
    
    V = 0.036 * sqrt(f);
    Vlinha = 0.065*MAngulo*sqrt(f);
    jV = (6.9 + 20*log10(sqrt(((V - 0.1).^2) + 1) + V - 0.1));
    jVlinha = (6.9 + 20*log10(sqrt(((Vlinha - 0.1).^2) + 1) + Vlinha - 0.1));
    Cor = -(jVlinha - jV);

end
