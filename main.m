%% Initialied on 2013/10/28
% Rev 1: 2015/1/22 by Charles Cheung
% Rev 2: 2016/6/23 by Charles Cheung
% Rev 3: 2016/12/25 by Charles Cheung
% Rev 4: 2021/09/25 by Charles Cheung
% Rev 5: 2022/02/14 by Charle Cheung.
% Optimized the generation of circular path

%% simulating single-pixel imaging with phase-shifting sinusoid illumination
close all
clear
clc
TimeStamp = datestr(now, 'YYmmDD_HHMMSS');

NOISE_POWER = 0;   % Additional noise to single-pixel measurements

%% Parameters
nStepPS = 4;                % N-step phase shifts (N is a integer not less than 3)
Phaseshift = 360/nStepPS;    % Unit: degree
SamplingRatio = 1;          % formerly, spectral coverage

% Get input image
[FileName, FolderName] = uigetfile({'*.bmp;*.jpg;*.tif;*.png;*.gif'','...
    'All Image Files';'*.*','All Files'});
InputImgFilePath = fullfile(FolderName, FileName);
if ~exist(InputImgFilePath, 'file')
	error('Input image not exists.');
end
SamplingPath = 'circular';  % circular, spiral

InputImg = im2double(imread(InputImgFilePath));
[mRow, nCol, nBand] = size(InputImg);
if nBand == 3
	InputImg = rgb2gray(InputImg);
end
figure,imshow(InputImg);title('Input image'); axis image;

[fxGrid, fyGrid] = meshgrid((0:1:nCol-1)/nCol, (0:1:mRow-1)/mRow);
fxGrid = fftshift(fxGrid); 
fyGrid = fftshift(fyGrid);

% Sampling strategy (aka sampling path)
OrderMat = getOrderMat(mRow, nCol, 'circular'); 
nCoeft = round(size(OrderMat, 1) * SamplingRatio);

InitPhaseArr = getPhaseShiftingInitPhaseArr (nStepPS);
MeasurementMat = zeros(mRow, nCol, nStepPS);
NoisyMeasurementMat = zeros(size(MeasurementMat));
MeasuredSpecMask = zeros(mRow,nCol);
RealFourierCoeftList = getRealFourierCoeftList(mRow, nCol);

PreGeneratedRandNoiseMat = rand(size(MeasurementMat)) * NOISE_POWER;

iMeasurement = 1;
tic;
for iCoeft = 1:nCoeft
    iRow = OrderMat(iCoeft,1);
    jCol = OrderMat(iCoeft,2);
    MeasuredSpecMask(iRow, jCol) = 1;
    
    fx = fxGrid(iRow,jCol);
    fy = fyGrid(iRow,jCol);
    
    IsRealCoeft = isVectorInMat( [iRow jCol], RealFourierCoeftList );
    
    for iStep = 1:nStepPS
        if IsRealCoeft == 1 && iStep > floor(nStepPS/2)+1
            DuplicatedStepNumber = nStepPS + 2 - iStep;
            MeasurementMat(iRow,jCol,iStep) = MeasurementMat(iRow,jCol,DuplicatedStepNumber);
        else
            [ Pattern ] = getFourierPattern(mRow, nCol, fx, fy, InitPhaseArr(iStep) );
            MeasurementMat(iRow,jCol,iStep) = sum(sum( Pattern .* InputImg ));
        end
    end
end

NoisyMeasurementMat = MeasurementMat + PreGeneratedRandNoiseMat .* repmat(MeasuredSpecMask, [1 1 nStepPS]);     % add noise to measurements

toc;

[img, spec] = getFSPIReconstruction( MeasurementMat, nStepPS );
figure, imagesc(img); caxis([0 1]); axis image; colormap gray; title('Reconstructed Img');
figure, specshow(spec);

PSNR = psnr(img, InputImg);
SSIM = ssim(img, InputImg);
RMSE = rmse(InputImg, img);

fprintf('PSNR = %f\nSSIM = %f\nRMSE = %f\n', PSNR, SSIM, RMSE);

%% Saving results
ErrorImg = InputImg - img;
figure, imagesc(ErrorImg); axis image; colormap jet; colorbar; title('error image');

TrueSpec = fftshift(fft2(InputImg));

SpecAbsDiff = abs(spec) - abs(TrueSpec);
SpecRealDiff = real(spec) - real(TrueSpec);
SpecImagDiff = imag(spec) - imag(TrueSpec);

figure, imagesc(SpecAbsDiff); axis image; colormap jet; title('spec abs diff'); colorbar;
figure, imagesc(SpecRealDiff); axis image; colormap jet; title('spec real diff'); colorbar;
figure, imagesc(SpecImagDiff); axis image; colormap jet; title('spec imag diff'); colorbar;

ResultFolderName = sprintf('[%s]FSI_Simulation_mRow=%d_nCol=%d_nStep=%d_PS=%d', TimeStamp, mRow, nCol, nStepPS, Phaseshift);

mkdir(ResultFolderName);
ResultFileName = 'results.mat';
ResultFilePath = fullfile(ResultFolderName, ResultFileName);
save(ResultFilePath);