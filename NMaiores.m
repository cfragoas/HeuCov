function NM = NMaiores(Maximos,perc)
    NMaximos = size(find(Maximos ~= 0),1); 
    Maiores = sort(Maximos(:),'descend');
    Maiores = Maiores(1:(round(NMaximos*perc)));
    
    NM = zeros(size(Maximos,1),size(Maximos,2));
    for i=1:size(Maiores);
       index = find(Maiores(i) == Maximos);
       NM(index)  = 1;
    end
end