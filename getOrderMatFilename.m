function [ orderMatFilename ] = getOrderMatFilename( mRow, nCol, PathStr )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    orderMatFilename = sprintf('%sOrderMat_%d_%d.mat', PathStr, mRow, nCol);
end

