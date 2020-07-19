function RegiaoBusca = intersecaoTx(nTx,CoberturaRegiaoInteresse,RegiaoInteresse,Coord,elevacao)

%determinando os maiores interferentes a fim de determinar a direcao de
%movimentacao
    RegiaoBusca = zeros(nTx,size(CoberturaRegiaoInteresse(1,:,:),2),size(CoberturaRegiaoInteresse(1,:,:),3));
    
    if nTx <= 2
        RegiaoBusca = ones(nTx,size(CoberturaRegiaoInteresse(1,:,:),2),size(CoberturaRegiaoInteresse(1,:,:),3));
        return
    end
    
    combinacoes = nchoosek(1:nTx,2); %todas as combinacoes possiveis 2 a 2 entre Txs
    combinacoes(:,3) = 0;
    MaioresInter = zeros(nTx,2);
    MatrizIntersecao = zeros(size(combinacoes,1),size(CoberturaRegiaoInteresse(1,:,:),2),size(CoberturaRegiaoInteresse(1,:,:),3));
    
    %verifica a intereferência entre Txs e conta a sua quantidade    
    for i = 1:size(combinacoes,1)
        
        MatrizIntersecao(i,:,:)= reshape(CoberturaRegiaoInteresse(combinacoes(i,1),:,:),[size(RegiaoInteresse,1),size(RegiaoInteresse,2)]).*reshape(CoberturaRegiaoInteresse(combinacoes(i,2),:,:),[size(RegiaoInteresse,1) size(RegiaoInteresse,2)]).*RegiaoInteresse;
        ContInter =  size(find(MatrizIntersecao(i,:,:) == 1),1);
        while ismember(ContInter,combinacoes(:,3)) == 1    
            ContInter = ContInter + 0.00001;
        end
        
        combinacoes(i,3) = ContInter;
        
    end
    
    
    for i=1:nTx
       
        [linha, ~] = find(combinacoes(:,1:2) == i);
        sortedValues = sort(combinacoes(linha,3),'descend');
        maxValues = unique(sortedValues(1:2));
        maximos = combinacoes(linha,:);
%         [~, maxIndex] = ismember(maxValues,combinacoes(linha,3));
        [~, maxIndex] = ismember(maxValues,maximos(:,3));
        Nmaiores = maximos(maxIndex,1:2);
        MaxInter = maximos(maxIndex,3);
%         [linha,~] = find(combinacoes(maxIndex,1:2) == i); 
        [index] =  find(Nmaiores ~= i);
%         [linha, ~] = find(combinacoes(:,3) == maxValues);
%         index = find(combinacoes(maxIndex,1:2) ~= i);
%         MaioresInter(i,1:2) = combinacoes(index)';
        MaioresInter(i,1:2) = Nmaiores(index);
%         MaioresInter(i,3:4) = fliplr(combinacoes(linha,3)');
        MaioresInter(i,3:4) = (MaxInter);
        if max(MaioresInter(i,3:4)) < 10^(-4) || min(MaioresInter(i,3:4)) < 10^(-4) 
           
            RegiaoBusca(i,:,:) = ones(size(elevacao,1),size(elevacao,2));
            
        end
                
    end 
    
    RegiaoBusca =  Direcao(MaioresInter,Coord,elevacao,RegiaoBusca);
    
end