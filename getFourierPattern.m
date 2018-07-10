function [ Pattern ] = getFourierPattern( amp, mRow, nCol, fx, fy, initPhase )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    PATTERN_GENERATION_MODE = 1;
    
    switch PATTERN_GENERATION_MODE
        case 1                                                             %选择1
            fxArr = fftshift([0:nCol-1] / nCol);                           %产生列频率对折变换后给fxArr
            fyArr = fftshift([0:mRow-1] / mRow);                           %产生行频率对折变换后给fyArr
            
            iRow = find(fyArr == fy);                                      %把（按逆时针螺旋型）采样位置fy给fyArr，找出非0元素给iRow (find为找出非0元素）
            jCol = find(fxArr == fx);                                      %把（按逆时针螺旋型）采样位置fx给fxArr，找出非0元素给jCol
            
            spec = zeros(mRow, nCol);                                      %产生一个mRow nCol的全零矩阵并给spec
            spec(iRow,jCol) = amp * mRow * nCol * exp(1i*initPhase);       %
            Pattern = (amp + amp * real(ifft2(ifftshift(spec)))) / 2;      %得到傅里叶基底图案的实部
        case 2
            [X,Y]=meshgrid(linspace(0,nCol-1,nCol), linspace(0,mRow-1,mRow));%循环产生等间距的x,y坐标
            Pattern = (amp*exp(1i*(2*pi*(fx*X+fy*Y)+initPhase))+1)/2;      %？
            Pattern = real(Pattern);                                       %得到傅里叶基底图案的实部
    end
    
end

