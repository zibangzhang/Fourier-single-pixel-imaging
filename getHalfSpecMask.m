function Mask = getHalfSpecMask (mRow, nCol)
    Mask = zeros(mRow, nCol);

    if mod(mRow, 2) == 0 && mod(nCol, 2) == 0                   % EVEN x EVEN
        smallerMask = getHalfSpecMask (mRow - 1, nCol - 1);
        Mask(2:end, 2:end) = smallerMask;

        Mask(2:mRow/2+1, 1)  = 1; 
        Mask(1,1) = 1; 
        Mask(1, 2:nCol/2+1)  = 1;  
    else                                                        % ODD x ODD
        if mod(mRow, 2) == 1 && mod(nCol, 2) == 1
            Mask(1:ceil(mRow/2), :) = 1;
            Mask(ceil(mRow/2), ceil(nCol/2)+1:end) = 0;
        else                                                    % ODD x EVEN
            if mod(mRow,2) == 1 && mod(nCol,2) == 0
                Mask(1:ceil(mRow/2), 2:end) = 1;
                Mask(ceil(mRow/2), ceil(nCol/2)+2:end) = 0;
                Mask(1:ceil(mRow/2), 1) = 1; 
            else                                                 % EVEN x ODD
                Mask(1:mRow/2+1, :) = 1;
                Mask(mRow/2+1, ceil(nCol/2)+1:end) = 0;
                Mask(1, ceil(nCol/2)+1:end) = 0; 
            end
        end
    end
end