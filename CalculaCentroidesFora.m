function PesoCentroidesFora = CalculaCentroidesFora(RegiaoInteresse,MaximosFora,XUTM,YUTM)
    
    TamanhoX = size(RegiaoInteresse,1);
    TamanhoY = size(RegiaoInteresse,2);

    %calculando o centroide da Regiao de Interesse
    buracos = zeros(size(RegiaoInteresse,1), size(RegiaoInteresse,2));
    buracos((RegiaoInteresse) == 1) = 1;
    buracos = bwlabel(buracos);%não sei ao certo, mas só funciona com essa conversão (bwlabel OU LOGICAL?)
    buracos = bwareaopen(buracos,50);  %remove pequenos buracos que acabam gerando centroides
    s = regionprops(buracos,'centroid'); %localizando os centroides de cada buraco na cobertura
    centroids = round(cat(1, s.Centroid));
    
    
    %calculando a distancia do centroide dos demais pontos
    dist = zeros(TamanhoX,TamanhoY);
    for i = 1:TamanhoX
        for j=1:TamanhoY
            distx = [XUTM(centroids(1)),XUTM(i)];
            disty = [YUTM(centroids(2)),YUTM(j)];
            dist(i,j) = sqrt(((abs(distx(1) - distx(2))^2)) + ((abs(disty(1) - disty(2)))^2));         
        end
    end
    dist(dist<=300) = 300;
    PesoCentro = max(max(dist))./dist;
    PesoCentro = PesoCentro./max(max(PesoCentro));
    
    [X,Y] =  find(MaximosFora == 1);

    %NCentroides = size(find(MaximosFora.*1),1);
    dist = zeros(TamanhoX,TamanhoY);
    PesoCentroidesFora = zeros(TamanhoX,TamanhoY);
    
    
    for k = 1:size(X,1)
        PesoDUMMY = zeros(TamanhoX,TamanhoY);
        parfor i = 1:TamanhoX
            for j = 1:TamanhoY
                
                
                distx = [XUTM(X(k)),XUTM(i)];
                disty = [YUTM(Y(k)),YUTM(j)];
                dist(i,j) = sqrt(((abs(distx(1) - distx(2))^2)) + ((abs(disty(1) - disty(2)))^2));
                
            end
        end
        
        dist(dist<=300) = 300;
        PesoDUMMY = max(max(dist))./dist;
        %PesoDUMMY(PesoDUMMY == inf) = 0;
        PesoCentroidesFora = PesoCentroidesFora + PesoDUMMY;
    end
    PesoCentroidesFora = log10(PesoCentroidesFora);
    PesoCentroidesFora = PesoCentroidesFora+PesoCentro;
    PesoCentroidesFora = PesoCentroidesFora./max(max(PesoCentroidesFora));
    
end