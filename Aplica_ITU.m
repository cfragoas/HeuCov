function Ec = Aplica_ITU(A,B,C,D,d,h1,Cor)
    if h1 < 10
        if h1 < 0
           h1 = 0; 
        end
        
        E10 = Aplica_ITU(A,B,C,D,d,10,0);
        E20 = Aplica_ITU(A,B,C,D,d,20,0);
        v = 3.31*deg2rad(atan(10/9000));
        J = (6.9 + 20*log10(sqrt(((v-0.1)^2)+1)+v-0.1));
        Ch1neg10 = 6.03 - J;
        Ezero = E10 + 0.5*(E10 - E20 + Ch1neg10);
        Eb = Ezero + 0.1*h1*(E10 - Ezero);
        Ec = Eb + Cor;
        
    else
        
        ld = log10(d);
        k = (log10(h1/9.375))/(log10(2));
        E1 = ((A(1)*(k.^2) + A(2)*k + A(3)).*ld) + (0.1995*(k.^2) + 1.8671*k + A(4));
        Eref1 = B(1)*(exp(-B(5)*10.^(ld.^B(6))) - 1) + B(2)*exp(-(((ld - B(3))/B(4)).^2));
        Eref2 = -B(7)*ld + B(8);
        Eref = Eref1 + Eref2;
        Eoff = (C(6)*k.^C(7)) + (C(1)/2)*k.*(1 -tanh(C(2)*(ld-(C(3)+((C(4).^k)/C(5))))));
        E2 = Eref + Eoff;
        pb = D(1) + D(2)*sqrt(k);
        Eu = min([E1,E2],[],2) - pb.*log10(1 + 10.^(-(abs(E1-E2)./pb)));
        Efs = 106.9 - 20*ld; 
        Eb = min([Eu,Efs],[],2) - 8*log10(1 + 10.^(-(abs(Eu-Efs)/8)));
        %Cor = Cerp + Ch2 + Curban + Ctca + Ch1;    %fator de correção definido pela itu1546
        Ec = Eb + Cor;
        
    end
end