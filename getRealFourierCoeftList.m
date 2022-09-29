function RealFourierCoeftList = getRealFourierCoeftList(mRow, nCol)
    if mod(mRow, 2) == 1 && mod(nCol, 2) == 1
        RealFourierCoeftList = [ceil(mRow/2) ceil(nCol/2)];
    else
        if mod(mRow, 2) == 0 && mod(nCol, 2) == 0
             RealFourierCoeftList = [1        1;  ...
                                     1        nCol/2+1; ...
                                     mRow/2+1   1; ...
                                     mRow/2+1 nCol/2+1];
        else
            if mod(mRow, 2) == 1 && mod(nCol, 2) == 0
                 RealFourierCoeftList = [ceil(mRow/2)   nCol/2+1; ...
                                         ceil(mRow/2)   1];
            else
                 RealFourierCoeftList = [mRow/2+1       ceil(nCol/2); ...
                                         1              ceil(nCol/2)];
            end
        end
    end
end