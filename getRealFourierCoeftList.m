function RealFourierCoeftList = getRealFourierCoeftList(mRow, nCol)
    if mod(mRow, 2) == 1 && mod(nCol, 2) == 1                              %行数为奇数，列数也为奇数；mod为取余
        RealFourierCoeftList = [ceil(mRow/2) ceil(nCol/2)];                %实值傅里叶系数点坐标
    else
        if mod(mRow, 2) == 0 && mod(nCol, 2) == 0                          %行为偶数，列为偶数
             RealFourierCoeftList = [1        1;  ...                      %实值傅里叶系数点的坐标排成构造的矩阵第一列
                                     1        nCol/2+1; ...
                                     mRow/2+1   1; ...
                                     mRow/2+1 nCol/2+1];
        else
            if mod(mRow, 2) == 1 && mod(nCol, 2) == 0                      %行数为奇数，列数为偶数
                 RealFourierCoeftList = [ceil(mRow/2)   nCol/2+1; ...      %实值傅里叶系数点的坐标排成构造的矩阵第一列
                                         ceil(mRow/2)   1];
            else                                                           %行为偶数，列为奇数
                 RealFourierCoeftList = [mRow/2+1       ceil(nCol/2); ...  %实值傅里叶系数点的坐标排成构造矩阵的第一列
                                         1              ceil(nCol/2)];
            end
        end
    end
end